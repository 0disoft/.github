#!/usr/bin/env bash
# Keep the default community health files consistent across languages:
# heading shape parity, one language bar in the same order on every document,
# no broken relative links, and the GitHub-required funding file location.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
languages=(ko es fr hi zh-CN)
failures=0

fail() {
  printf 'FAIL %s\n' "$1" >&2
  failures=$((failures + 1))
}

if [ ! -f "$root/.github/FUNDING.yml" ]; then
  fail "missing .github/FUNDING.yml"
fi
for misplaced in "$root/FUNDING.yml" "$root/docs/FUNDING.yml"; do
  if [ -e "$misplaced" ]; then
    fail "FUNDING.yml must be stored in .github/: ${misplaced#"$root"/}"
  fi
done

# Compare heading levels only: translated heading text differs by design, the
# document structure must not.
heading_shape() {
  grep -E '^#{1,6} ' "$1" | sed -E 's/^(#{1,6}) .*/\1/' || true
}

# Print the language codes of the line 3 language bar, in the order they appear.
bar_order() {
  sed -n '3p' "$1" \
    | grep -oE 'docs/i18n/[A-Za-z-]+/|\.\./[A-Za-z-]+/' \
    | sed -e 's|^docs/i18n/||' -e 's|^\.\./||' -e 's|/$||' \
    | paste -sd, - || true
}

expected_order="$(IFS=,; printf %s "${languages[*]}")"

# Every root markdown file except README.md is a policy document that must be
# translated; README.md describes this repository and stays English-only.
documents=()
for candidate in "$root"/*.md; do
  [ -e "$candidate" ] || continue
  name="$(basename "$candidate")"
  [ "$name" = "README.md" ] && continue
  documents+=("$name")
done

if [ "${#documents[@]}" -eq 0 ]; then
  fail "no policy document found in the repository root"
fi

for document in "${documents[@]}"; do
  source_doc="$root/$document"
  if [ "$(bar_order "$source_doc")" != "$expected_order" ]; then
    fail "language bar on line 3 is missing or out of order: $document"
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
    # The current language is plain text in its own bar, so it has no link and
    # must be dropped from the order this document is expected to show.
    expected_translated="$(printf '%s\n' "${languages[@]}" | grep -vx "$language" | paste -sd, -)"
    if [ "$(bar_order "$translated")" != "$expected_translated" ]; then
      fail "language bar on line 3 is missing or out of order: docs/i18n/$language/$document"
    fi
  done
done

# Every relative link target has to exist. Absolute URLs, anchors, and
# mailto links are not filesystem paths.
while IFS= read -r -d '' file; do
  directory="$(dirname "$file")"
  while IFS= read -r link; do
    [ -n "$link" ] || continue
    case "$link" in
      http://* | https://* | mailto:* | //* | '#'* ) continue ;;
    esac
    target="$directory/${link%%#*}"
    if [ ! -e "$target" ]; then
      fail "broken link in ${file#"$root"/}: $link"
    fi
  done < <(grep -oE '\]\([^)[:space:]]+\)' "$file" | sed -E 's/^\]\(//; s/\)$//' || true)
done < <(find "$root" -name '*.md' -not -path "$root/.git/*" -print0)

if [ "$failures" -ne 0 ]; then
  printf '\n%s problem(s) found.\n' "$failures" >&2
  exit 1
fi

printf 'Docs checks passed: %s documents x %s languages.\n' "${#documents[@]}" "${#languages[@]}"
