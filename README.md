# 0disoft default community files

This repository holds the default community health files that GitHub applies to
every 0disoft repository which does not define its own copy:

- `CODE_OF_CONDUCT.md` - community expectations and enforcement.
- `CONTRIBUTING.md` - contribution and review expectations.
- `SECURITY.md` - security requirements and the private vulnerability reporting channel.
- `SUPPORT.md` - where to ask questions.
- `.github/FUNDING.yml` - GitHub Sponsors configuration.
- `.github/ISSUE_TEMPLATE/` and `.github/PULL_REQUEST_TEMPLATE.md` - issue and pull request templates.

A repository-specific file always wins over a default file.

This repository also hosts the shared [governance policy](./GOVERNANCE.md) and
translations under `docs/i18n/`. GitHub does not automatically inherit
`GOVERNANCE.md`; the contribution guides link to it explicitly.

## Translations

Each policy document exists in English at the repository root and in Korean,
Spanish, French, Hindi, and Simplified Chinese under `docs/i18n/`. Every document
starts with a language bar on line 3, and every translated document keeps the
heading structure of the English original.

## Maintenance

```bash
bash scripts/check-docs.sh
```

The check fails when a translated document drifts from the English heading
structure, loses its language bar, when any relative link points at a file
that does not exist, or when `FUNDING.yml` is missing from `.github/` or misplaced
in the root or `docs/` directory. CI runs the same script on pushes to `main`
and on pull requests.

Private vulnerability reporting has to be enabled per repository. The helper
below lists eligible public repositories and only changes them when `--apply`
is passed:

```bash
bash scripts/enable-private-vulnerability-reporting.sh           # dry run
bash scripts/enable-private-vulnerability-reporting.sh --apply   # enable
```
