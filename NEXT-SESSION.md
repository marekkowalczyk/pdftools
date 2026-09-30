# Next Session

## Follow-ups opened by this session
- `pdfrem` was recreated from a description. If the original turns up on another machine, diff its behaviour against the new one (it used cpdf; the new one only removes cpdf-stamped text).
- Add an integration test that runs real `cpdf` (skipped when cpdf is missing) — the "only stamps are removed" claim is currently a manual check.
- `pdfrem` idea: page-range option, mirroring `pdfstamp -f` (also in pdfrem's own NEXT-SESSION).

## Carried over
- Consider adding a `dev/` directory (new-tool scaffold template, notes) — the "Adding a tool" checklist in `CONVENTIONS.md` is a first step
- Revisit GitHub Pages when 3–5 tools feel "done" (stable, tested, documented)
- Add descriptions to individual tool repos on GitHub (`pdfrem` already has one; the rest are blank)

## Process notes
- Adding a tool = three edits in this repo (see `CONVENTIONS.md` → "Adding a tool to the suite").
- Check `ls -ld /usr/local/bin` before any install; it needs `sudo`.
- Scripts with heredocs: use the Write tool.
