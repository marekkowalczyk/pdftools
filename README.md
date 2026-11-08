# pdftools

A **versioned suite** of Unix CLI tools for PDF document production. Each tool lives in its own repository and ships its own releases. This repository is the **bundle**: installer, conventions, and a bill of materials (BOM) that pins which tool versions belong together.

**Current suite release:** [v1.0.0](https://github.com/marekkowalczyk/pdftools/releases/tag/v1.0.0)  
**Site:** [marekkowalczyk.github.io/pdftools](https://marekkowalczyk.github.io/pdftools/)

## Tools

| Tool | What it does | Suite pin |
|------|--------------|-----------|
| [pdfclean](https://github.com/marekkowalczyk/pdfclean) | Compress PDFs in-place via cpdfsqueeze | — (queued) |
| [mdtopdf](https://github.com/marekkowalczyk/mdtopdf) | Convert Markdown to PDF via Pandoc | — (queued) |
| [pdfocr](https://github.com/marekkowalczyk/pdfocr) | OCR a PDF and embed the text layer | v1.3.0 |
| [pdflogo](https://github.com/marekkowalczyk/pdflogo) | Stamp a logo onto a PDF | — (queued) |
| [pdfstamp](https://github.com/marekkowalczyk/pdfstamp) | Add filename watermark to a PDF | — (queued) |
| [pdfrem](https://github.com/marekkowalczyk/pdfrem) | Remove stamped-on text (e.g. from pdfstamp) from a PDF | — (queued) |
| [pdfbates](https://github.com/marekkowalczyk/pdfbates) | Add Bates numbers to a PDF | — (queued) |
| [pdfsecret](https://github.com/marekkowalczyk/pdfsecret) | Add "Tajemnica przedsiębiorstwa" overlay | — (queued) |
| [pdfa4](https://github.com/marekkowalczyk/pdfa4) | Normalize pages to A4 (fit, white pad) | v1.1.0 |

Pins live in [`VERSIONS`](VERSIONS). The installer only installs **pinned** tools. Remaining tools join the BOM as they complete the [release queue](RELEASE-QUEUE.md).

## How the suite is versioned

- **Tools** release independently (semver tags + GitHub Releases).
- **`pdftools`** releases are BOM snapshots: each suite release records the tool tags in `VERSIONS`, usually in the same sitting as a tool release.
- See [CHANGELOG.md](CHANGELOG.md) for suite history.

## Install

```bash
git clone https://github.com/marekkowalczyk/pdftools.git
cd pdftools
bash install.sh
```

For each pin in `VERSIONS`, clones the tool repo (if missing) into the parent directory, checks out that tag, and symlinks the script to `/usr/local/bin` (may need `sudo`).

## Conventions

All tools follow shared [CLI and Unix citizenship conventions](CONVENTIONS.md) — error format, output verbosity, standard flags, in-place file handling, and testing requirements.

## Dependencies

- `cpdf` — pdflogo, pdfstamp, pdfrem, pdfbates, pdfsecret, pdfa4
- `cpdfsqueeze` — pdfclean
- `pandoc`, `exiftool`, `yq` — mdtopdf
- See each tool's repo for its full dependency list

## License

[MIT](LICENSE)
