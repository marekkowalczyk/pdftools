# After Action Review

Continuous improvement log. Each session ends with a brief review: what went well, what didn't, what to change. This is the POOGI (Process Of Ongoing Improvement) record for this project.

## 2026-11-08 — Suite BOM v1.0.0; Pages; staggered release plan

**What went well:**
- Design first (definition of released, workflow queue, same-sitting suite bump) before cutting `v1.0.0`, so `VERSIONS` + pin-aware `install.sh` matched an agreed contract (2 pins live: pdfa4, pdfocr; Pages 200).
- Domain candidates stayed out of the public tree; specs/plans moved to personal store for the same reason.

**What didn't go well:**
- **User correction:** earlier this same day the close said “do not create GitHub Releases for `pdftools`” — that rule is obsolete. The suite is now a versioned BOM; tool releases still stagger separately.
- **User correction:** holding specs/plans private is **temporary** (unregistered domain leakage), not a permanent “design docs stay off-repo” policy. First write-up treated it as standing privacy.
- Pages first builds failed until `docs/.nojekyll`; `v1.0.0` was tagged before that fix, so the release tip lagged HEAD until the tag was moved.

**What we'll do differently:**
- Treat `pdftools` GitHub Releases as expected whenever `VERSIONS` changes (same sitting as the tool publish).
- Keep unregistered domain names out of git/Pages; after domains are registered, restore `superpowers/` specs/plans to the repo (scrub leftover candidates).
- When shipping Pages + a suite tag in one sitting: add `.nojekyll` (if static HTML) **before** tagging, or move the tag to HEAD before calling the release done.

---

## 2026-11-08 — pdfa4 added; suite made public; tool repos repaired

**What went well:**
- New-tool checklist held: `install.sh` TOOLS + README table + cpdf deps in one change, then install symlink.
- Root-owned empty-ish `pdfbates` / `pdfsecret` fixed by renaming aside and re-cloning as the user (no sudo password needed).
- User clarified tool semver stays on tool repos; **superseded later the same day** — `pdftools` itself is now BOM-released (see entry above).

**What didn't go well:**
- First pass left `pdftools` wiring uncommitted until the user asked to “update pdftools and install”; should have finished the suite commit in the same breath as creating the tool (recurring theme from 2026-09-30 pdfrem close).
- `AskQuestion` UI unavailable; interview used letter pickers instead.

**What we'll do differently:**
- When a new tool is created: GitHub repo + `~/repos/<tool>` + suite wiring commit + PATH install in one pass; state the absolute path in the reply.
- ~~Do not create GitHub Releases for `pdftools`~~ — **void**; see 2026-11-08 BOM entry.

---

## 2026-09-30 — Recreated pdfrem and added it to the suite

**What went well:**
- Ran real `cpdf` on a PDF with body text plus a `pdfstamp` stamp *before* designing. That established `-remove-text` only strips `/CPDFSTAMP` marked content, so the tool could be a thin, safe inverse of `pdfstamp` instead of a guess.
- Read `CONVENTIONS.md` and a sibling tool first, so the new repo matched the suite layout on the first pass (33 bats tests, all passing).

**What didn't go well:**
- **User correction:** "Put the repo in `~/repos/` as per convention, then add everything for `pdftools/`." The repo was already in `~/repos/`, but I never said so, and I had left the installer/README wiring as an offer instead of doing it. Two turns for one job.
- A nested `EOF` inside a heredoc (the script's own `usage()`) broke the write; the whole command failed to parse. Recoverable only because nothing had executed.
- `make install` failed: `/usr/local/bin` is root-owned. I could have checked `ls -ld` up front. `pdfrem` is still not on `PATH`; that needs the user's `sudo`.
- The behaviour is reconstructed from a one-line description. The original was never committed and may have done more (or differently); nothing verified against it.
- The real-cpdf claim rests on a manual check; the suite only uses a mock cpdf.

**What we'll do differently:**
- When creating a repo, state its absolute path in the reply. When a new tool is created, do the suite wiring in the same pass (now a checklist in `CONVENTIONS.md`).
- Write any script containing heredocs with the Write tool, not a shell heredoc; or use a distinct outer delimiter.
- Before any `make install` / symlink into `/usr/local/bin`, run `ls -ld /usr/local/bin`; if root-owned, hand the user the `sudo` command immediately.
- Commit a tool to a repo at its first working version. This tool was lost once because it lived on one machine, uncommitted.

---

## 2026-07-07 — Repo audit and GitHub Pages evaluation

**What went well:**
- Quick, accurate audit of README vs. GitHub repos — no drift found, no wasted edits.
- The "no GitHub Pages yet" recommendation was concrete and gave clear criteria for when to revisit.

**What didn't go well:**
- User asked to "commit this" after a no-op verification step. Worth making it clearer upfront when a check produces no changes.

**What we'll do differently:**
- When a verification step finds nothing to change, explicitly say "nothing to commit" before the user asks — don't leave it implied.
