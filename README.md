# pdftools

A suite of PDF tools for document production workflows. Each tool lives in its own repo; this repo is the installer.

## Tools

| Tool | What it does |
|------|--------------|
| [pdfclean](https://github.com/marekkowalczyk/pdfclean) | Compress PDFs in-place via cpdfsqueeze |
| [mdtopdf](https://github.com/marekkowalczyk/mdtopdf) | Convert Markdown to PDF via Pandoc |
| [pdfocr](https://github.com/marekkowalczyk/pdfocr) | OCR a PDF and embed the text layer |
| [pdflogo](https://github.com/marekkowalczyk/pdflogo) | Stamp a logo onto a PDF |
| [pdfstamp](https://github.com/marekkowalczyk/pdfstamp) | Add filename watermark to a PDF |
| [pdfbates](https://github.com/marekkowalczyk/pdfbates) | Add Bates numbers to a PDF |
| [pdfsecret](https://github.com/marekkowalczyk/pdfsecret) | Add "Tajemnica przedsiębiorstwa" overlay |

## Install

```bash
git clone https://github.com/marekkowalczyk/pdftools.git
cd pdftools
bash install.sh
```

Clones any missing tool repos into the same parent directory as `pdftools`, then symlinks each script to `/usr/local/bin`.

## Dependencies

- `cpdf` — pdflogo, pdfstamp, pdfbates, pdfsecret
- `cpdfsqueeze` — pdfclean
- `pandoc`, `exiftool`, `yq` — mdtopdf
- See each tool's repo for its full dependency list
