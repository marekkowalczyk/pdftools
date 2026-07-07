# pdftools Conventions

Standards for behavior and CLI design across all tools in the suite. When building or modifying a tool, treat these as requirements, not suggestions.

## Error output

- All errors and warnings go to **stderr**.
- Prefix every error/warning with the tool name: `toolname: message`.
- Exit code **reflects failure**: exit 1 if any file fails, even if others succeed.

## Output verbosity

- **Silent on non-events.** Only report files where something actually happened (compressed, converted, stamped…). Do not print progress headers or "nothing to do" messages.
- `--quiet` / `-q` suppresses all non-error stdout.
- A `--dry-run` / `-n` flag is appropriate for any tool that modifies files in-place.

## Standard flags

Every tool must support:

| Flag | Alias | Behavior |
|------|-------|----------|
| `--help` | `-h` | Print usage and exit 0 |
| `--version` | | Print `toolname VERSION` and key dependency version, then exit 0 |
| `--quiet` | `-q` | Suppress non-error output |
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
