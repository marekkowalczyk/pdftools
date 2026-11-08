# Next Session

## Completed last session

- [x] ~~Repo made public~~
- [x] ~~All suite tool repos present under `~/repos/` (re-cloned root-owned `pdfbates` / `pdfsecret`)~~
- [x] ~~`pdfa4` created, wired into installer/README, installed to `/usr/local/bin`~~

## Immediate

- Nothing blocking on the suite side. Tool work happens in the individual repos (e.g. `pdfa4` Issues).

## Follow-ups

- `pdfrem`: if the original turns up on another machine, diff behaviour (cpdf stamp-only removal may differ).
- `pdfrem`: optional real-cpdf integration test (skipped when missing) — still open in that repo’s notes.
- Add GitHub **descriptions** (and topics) on tool repos that still lack them — `pdfa4` and `pdfrem` already have descriptions; several others are blank.

## Carried over

- Consider a `dev/` scaffold for new tools (checklist in `CONVENTIONS.md` already covers suite wiring).
- Revisit GitHub Pages when several tools feel stable — **Pages for tools, not for this pointer repo, unless asked.**

## Process notes

- Adding a tool = three edits here (`CONVENTIONS.md` → "Adding a tool to the suite") plus install into `/usr/local/bin` (check `ls -ld`; needs `sudo` / admin prompt).
- **This repo is not version-released** unless the user explicitly asks; releases live on tool repos.
- Scripts with heredocs: use the Write tool.
- State absolute paths when creating repos; wire the suite in the same pass.
