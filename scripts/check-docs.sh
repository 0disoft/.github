#!/usr/bin/env bash
# Keep the default community health files consistent across languages:
# heading shape parity, a language bar on every document, and no broken
# relative links.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
languages=(ko es fr hi zh-CN)
documents=(CODE_OF_CONDUCT.md CONTRIBUTING.md GOVERNANCE.md SECURITY.md SUPPORT.md)
failures=0

fail() {
  printf 'FAIL %s\n' "$1" >&2
  failures=$((failures + 1))
}

# Compare heading levels only: translated heading text differs by design, the
# document structure must not.
heading_shape() {
  grep -E '^#{1,6} ' "$1" | sed -E 's/^(#{1,6}) .*/\1/' || true
}

for document in "${documents[@]}"; do
  source_doc="$root/$document"
  if [ ! -f "$source_doc" ]; then
    fail "missing $document"
    continue
  fi
  if ! sed -n '3p' "$source_doc" | grep -q '](.\/docs/i18n/'; then
    fail "missing language bar on line 3: $document"
  fi

  expected="$(heading_shape "$source_doc")"
  for language in "${languages[@]}"; do
    translated="$root/docs/i18n/$language/$document"
    if [ ! -f "$translated" ]; then
      fail "missing docs/i18n/$language/$document"
      continue
    fi
    if [ "$(heading_shape "$translated")" != "$expected" ]; then
      fail "heading structure differs from $document: docs/i18n/$language/$document"
    fi
    if ! sed -n '3p' "$translated" | grep -q '](.\{1,2\}/'; then
      fail "missing language bar on line 3: docs/i18n/$language/$document"
    fi
  done
done

# Every relative link target has to exist.
while IFS= read -r -d '' file; do
  directory="$(dirname "$file")"
  while IFS= read -r link; do
    [ -n "$link" ] || continue
    target="$directory/${link%%#*}"
    if [ ! -e "$target" ]; then
      fail "broken link in ${file#"$root"/}: $link"
    fi
  done < <(grep -oE '\]\(\.{1,2}/[^)[:space:]]+\)' "$file" | sed -E 's/^\]\(//; s/\)$//' || true)
done < <(find "$root" -name '*.md' -not -path "$root/.git/*" -print0)

if [ "$failures" -ne 0 ]; then
  printf '\n%s problem(s) found.\n' "$failures" >&2
  exit 1
fi

printf 'Docs checks passed: %s documents x %s languages.\n' "${#documents[@]}" "${#languages[@]}"
