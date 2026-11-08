# Next Session

## Completed last session

- [x] ~~Suite v1.0.0 BOM (`VERSIONS`, pin-aware `install.sh`, CHANGELOG, LICENSE, Pages, RELEASE-QUEUE, GitHub Release)~~
- [x] ~~Specs/plans held privately until domain(s) registered (leakage risk); restore to repo after~~

## Immediate

- Start staggered tool queue: **pdfstamp** (smoke-test + approve → public/release → pin in `VERSIONS` → suite patch release) — see `RELEASE-QUEUE.md`

## Follow-ups

- After domain(s) registered: restore `superpowers/` specs/plans to the public repo; add `docs/CNAME` + DNS for Pages
- `pdfrem`: if the original turns up on another machine, diff behaviour
- `pdfrem`: optional real-cpdf integration test (skipped when missing)
- GitHub descriptions/topics on tool repos that still lack them

## Carried over

- Consider a `dev/` scaffold for new tools (`CONVENTIONS.md` checklist already covers suite wiring)

## Process notes

- Suite release = BOM: bump `VERSIONS` + `CHANGELOG.md` + GitHub Release in the **same sitting** as the tool publish.
- Unregistered domain candidates never go in git or Pages; specs that might name them stay private until registration.
- Static Pages under `docs/`: ship `.nojekyll` before tagging a suite release that depends on the site.
- Adding a tool = `CONVENTIONS.md` checklist + later pin in `VERSIONS` once released; `/usr/local/bin` may need `sudo` (`ls -ld` first).
- Scripts with heredocs: use the Write tool.
