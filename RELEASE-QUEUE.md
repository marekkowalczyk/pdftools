# Release queue

Staggered first public releases for suite tools. **One tool per sitting**, then bump `VERSIONS` and cut a **pdftools** patch/minor release in the same sitting.

Design notes (private): personal Cursor agent store → `pdftools-private/superpowers/`.

## Status

| # | Tool | Status | Notes |
|---|------|--------|-------|
| — | pdfa4 | done | public + v1.1.0 (pinned in suite v1.0.0) |
| — | pdfocr | done | public + v1.3.0 (pinned in suite v1.0.0) |
| 1 | pdfstamp | pending | private → full release pack → public → release → pin |
| 2 | pdfrem | pending | after pdfstamp |
| 3 | pdflogo | pending | |
| 4 | pdfbates | pending | already public; needs release pack |
| 5 | pdfsecret | pending | already public; needs release pack |
| 6 | pdfclean | pending | has v1.2.0 private — verify bar, make public, pin |
| 7 | mdtopdf | pending | last (heaviest deps) |

## Per-session checklist

1. Set next row to `in_progress`
2. Prep tool repo: LICENSE, CHANGELOG, topics, draft release notes
3. Maintainer smoke-test on a real PDF
4. On approval: public (if needed) + tool GitHub Release
5. Pin in `VERSIONS` → suite `CHANGELOG` → suite GitHub Release
6. Mark row `done`; update `NEXT-SESSION.md`; **stop**
