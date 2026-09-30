# pdftools Conventions

Standards for behavior and CLI design across all tools in the suite. When building or modifying a tool, treat these as requirements, not suggestions.

## Error output

- All errors and warnings go to **stderr**.
- Prefix every error/warning with the tool name: `toolname: message`.
- Exit code **reflects failure**: exit 1 if any file fails, even if others succeed.

## Output verbosity

- **Rule of Silence.** Success is not news. Tools are silent by default — including on files where something happened (compressed, converted, stamped…). Never print progress headers or "nothing to do" messages.
- `--verbose` / `-v` opts into per-file reporting of what happened.
- `--quiet` / `-q` suppresses all non-error stdout, including `--verbose` and `--dry-run` output — it always wins.
- A `--dry-run` / `-n` flag is appropriate for any tool that modifies files in-place. Because its only purpose is to report what would happen, its preview output is shown by default (not gated behind `--verbose`) — but is still suppressed by `--quiet`.
- Errors and warnings are never affected by any of the above — they always go to stderr.

## Standard flags

Every tool must support:

| Flag | Alias | Behavior |
|------|-------|----------|
| `--help` | `-h` | Print usage and exit 0 |
| `--version` | | Print `toolname VERSION` and key dependency version, then exit 0 |
| `--verbose` | `-v` | Report each file as it's acted on (default: silent on success) |
| `--quiet` | `-q` | Suppress all non-error output; overrides `--verbose` |
| `--` | | End of options; remaining args are filenames |

`--dry-run` / `-n` where the tool modifies files in-place.

## `--version` format

```
toolname X.Y.Z
dependency-name version-string   # e.g. cpdfsqueeze Version 2.3 …
```

If a required dependency is missing, print `dependency: not found` to stderr (still exit 0 from `--version` itself, but the missing dep will surface as an error when the tool is actually used).

## Filename handling

- Accept filenames starting with `-` via `--` end-of-options.
- Warn and skip duplicate filenames rather than processing twice.
- Validate files exist before processing; emit `toolname: 'file' not found, skipping` to stderr.

## In-place file modification

When a tool modifies files in-place:

- Write output to a `mktemp` temp file **in the same directory** as the source (same filesystem → atomic `mv`).
- Swap the temp file over the original **only if the result is actually better** (smaller, valid, etc.).
- Copy **file permissions** (`chmod`) and **extended attributes** (`xattr`) from the original to the temp file before the swap.
- Clean up the temp file on exit/interrupt via `trap`.

## Batch / directory mode

- `.` or `--all` / `-a` processes all relevant files in the current directory.
- Cannot combine `--all` with explicit filenames; error and exit 1 if attempted.
- No recursive directory walking by design — the user controls which files are processed.

## Testing

- Each tool has a bats test suite under `tests/`.
- Tests use mock backends — no real documents required to run the suite.
- A tracked pre-commit hook lives in `hooks/`; install with `bash hooks/install.sh`.

## Repo structure

Every tool repo contains:

| File / directory | Purpose |
|------------------|---------|
| `toolname` | The script itself |
| `README.md` | Usage, options, installation, requirements, how it works |
| `CLAUDE.md` | Context for Claude Code: what the tool does, structure, dependencies, design decisions, pointer to CONVENTIONS.md |
| `hooks/pre-commit` | Runs the bats suite before every commit |
| `hooks/install.sh` | Symlinks hooks into `.git/hooks/` |
| `tests/toolname.bats` | Bats test suite |
| `AAR.md` | After action review log (POOGI record) |
| `NEXT-SESSION.md` | Open questions and carry-over items for the next session |

## Adding a tool to the suite

Adding a tool touches three places in `pdftools`, all in the same change:

1. `TOOLS=(…)` in `install.sh`
2. The tools table in `README.md`
3. The dependency list in `README.md` (e.g. the `cpdf —` line)

Create the GitHub repo before (or together with) the installer change — a fresh-machine install clones from it. Installing the symlink into `/usr/local/bin` needs `sudo` (the directory is root-owned).
