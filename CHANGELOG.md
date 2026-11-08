# Changelog

All notable changes to the **pdftools** suite (installer + bill of materials) are recorded here. Individual tools keep their own changelogs and semver tags.

## [1.0.0] — 2026-11-08

### Added

- Suite treated as a versioned bill of materials: `VERSIONS` pins tool → git tag
- `install.sh` checks out pinned tags (membership-only tools are skipped until pinned)
- MIT `LICENSE`
- GitHub Pages site under `docs/` (https://marekkowalczyk.github.io/pdftools/)
- `RELEASE-QUEUE.md` for staggered first releases of remaining tools

### Pins

| Tool | Tag |
|------|-----|
| pdfa4 | v1.1.0 |
| pdfocr | v1.3.0 |

Other suite members (`pdfclean`, `pdflogo`, `pdfstamp`, `pdfrem`, `pdfbates`, `pdfsecret`, `mdtopdf`) are listed in the README but not pinned until their release sittings.
