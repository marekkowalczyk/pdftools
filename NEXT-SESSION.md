# Next Session

## Completed last session

- [x] ~~`pdfopen` sibling CLI (PDF Expert only) + GitHub repo~~
- [x] ~~Suite-wide quoted-glob / PDF-only convention (`lib/pdftools-globs.sh`, CONVENTIONS)~~
- [x] ~~Retrofit bash tools + `pdfocr`; suite membership wiring~~

## Immediate

- Continue staggered release queue: **pdfstamp** (smoke-test + approve → public/release → pin in `VERSIONS` → suite patch release) — see `RELEASE-QUEUE.md`
- When ready: release/pin `pdfopen` (and optionally re-pin retrofitted tools that bumped patch versions)

## Follow-ups

- **Idea — `pdfblank`:** new suite tool that creates a blank A4 PDF. Save for a later sitting (do not start until queue allows). Useful for real-app smoke tests and as a fixture generator.
- After domain(s) registered: restore `superpowers/` specs/plans to the public repo; add `docs/CNAME` + DNS for Pages
- `pdfrem`: if the original turns up on another machine, diff behaviour
- `pdfrem`: optional real-cpdf integration test (skipped when missing)
- GitHub descriptions/topics on tool repos that still lack them

## Carried over

- Consider a `dev/` scaffold for new tools (`CONVENTIONS.md` checklist already covers suite wiring)
- Optional: point `mdtopdf`’s post-convert open at `pdfopen` instead of generic `open`

## Process notes

- Suite release = BOM: bump `VERSIONS` + `CHANGELOG.md` + GitHub Release in the **same sitting** as the tool publish.
- Unregistered domain candidates never go in git or Pages; specs that might name them stay private until registration.
- Static Pages under `docs/`: ship `.nojekyll` before tagging a suite release that depends on the site.
- Adding a tool = `CONVENTIONS.md` checklist + later pin in `VERSIONS` once released; `/usr/local/bin` may need `sudo` (`ls -ld` first).
- Scripts with heredocs: use the Write tool.
- **PDF smoke fixtures:** never open `printf '%%PDF…'` stubs in a real viewer — use a valid minimal PDF (or future `pdfblank`) for live PDF Expert / Preview checks. Mock-`open` bats may keep stubs.
- **Duplicate args:** suite glob helper treats duplicates as a skip that contributes to exit 1 (tests updated accordingly).
