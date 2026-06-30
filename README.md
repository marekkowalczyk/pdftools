# pdftools

A suite of PDF tools for document production workflows.

## Tools

| Tool | Source | What it does |
|------|--------|--------------|
| [pdfclean](https://github.com/marekkowalczyk/pdfclean) | own repo | Compress PDFs in-place via cpdfsqueeze |
| [mdtopdf](https://github.com/marekkowalczyk/mdtopdf) | own repo | Convert Markdown to PDF via Pandoc |
| [pdfocr](https://github.com/marekkowalczyk/pdfocr) | own repo | OCR a PDF and embed the text layer |
| pdflogo | this repo | Stamp a logo onto a PDF |
| pdfstamp | this repo | Add filename watermark to a PDF |
| pdfbates | this repo | Add Bates numbers to a PDF |
| pdfsecret | this repo | Add "Tajemnica przedsiębiorstwa" overlay |

## Install

```bash
git clone https://github.com/marekkowalczyk/pdftools.git
cd pdftools
bash install.sh
```

`install.sh` clones any missing repos into the same parent directory and symlinks all tools to `/usr/local/bin`.

## Dependencies

- `cpdf` — used by pdflogo, pdfstamp, pdfbates, pdfsecret
- `cpdfsqueeze` — used by pdfclean
- `pandoc`, `exiftool`, `yq` — used by mdtopdf
- See each tool's own repo for its full dependency list
