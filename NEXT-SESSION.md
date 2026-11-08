# Next Session

## Completed last session

- [x] Suite v1.0.0 — `VERSIONS`, pin-aware `install.sh`, CHANGELOG, LICENSE, Pages site, RELEASE-QUEUE, GitHub Release
- [x] Specs/plans kept private (personal agent store `pdftools-private/superpowers/`, not in the public repo)

## Immediate

- Start staggered tool queue: **pdfstamp** (one tool + suite pin bump per sitting) — see `RELEASE-QUEUE.md`

## Follow-ups

- Custom domain when registered (private candidate list in personal store); then `docs/CNAME` + DNS
- `pdfrem`: if the original turns up on another machine, diff behaviour
- `pdfrem`: optional real-cpdf integration test (skipped when missing)
- GitHub descriptions/topics on tool repos that still lack them

## Process notes

- Adding a tool = three edits here (`CONVENTIONS.md` → "Adding a tool to the suite") plus pin in `VERSIONS` once released, plus install into `/usr/local/bin` (check `ls -ld`; may need `sudo`).
- Suite release = BOM: bump `VERSIONS` + `CHANGELOG.md` + GitHub Release in the same sitting as the tool publish.
- Scripts with heredocs: use the Write tool.
