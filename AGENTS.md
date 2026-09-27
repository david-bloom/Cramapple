# Agent Operating Notes (Repo-Wide)

This file is read automatically by Codex-family agents on session start. Its job is to keep
routine work from turning into a full repo scan. It does not replace
`docs/team_charter/CRAMAPPLE_SESSION_START.md` or the `CODEX_NEW_SESSION_PROMPT.md` /
`CLAUDE_NEW_SESSION_PROMPT.md` tier-first startup rules — those govern *what to read*; this file
governs *how to search*.

## Route through the index, don't scan for it

Use `docs/INDEX.md` to find the canonical doc for a topic before grepping the repo for it. If
`docs/INDEX.md` has no entry for the task's area, say so rather than falling back to a broad scan.

## Do not broadly scan, list, or read these paths by default

- `docs/research`
- `docs/teaching`
- `prompts`
- `tmp`
- `output`
- `.worktrees`
- `.claude/worktrees`
- `node_modules`
- `.venv`
- generated SQL/output folders (e.g. `scripts/*/out`)
- raw `.jsonl` model-call logs
- image/PDF corpora
- archived activity logs (`docs/activity_log/archive/`)

Enter one of these only with a specific reason (the active task names it, or a targeted search
result points into it), and then use exact filenames, task/decision/approval IDs, dates, or narrow
search terms — never an unbounded `find`, `ls -R`, or repo-wide grep over these directories.

## Search and output discipline (applies everywhere, not just the paths above)

- Prefer targeted searches (`grep` for an exact string/ID, `find` scoped to a subdirectory) over
  repo-wide listings.
- Cap command output; if a search returns hundreds of matches, narrow it before reading further,
  not after.
- Inspect large files by line range instead of reading the whole file when you only need one
  section.
- In `docs/activity_log/ACTIVITY_LOG.md`, `APPROVALS_LOG.md`, and `DECISIONS_LOG.md`: read only
  through the `<!-- INDEX_END -->` marker first, then search by exact ID/date/keyword. Read past
  the marker only when that targeted search fails and the missing record is actually needed —
  and say so, rather than silently concluding the record doesn't exist.
- Summarize counts instead of printing every matching path.

## Precedence

If a specific task's instructions conflict with this file, the task's instructions govern for
that task — but note the conflict rather than silently overriding this file's defaults.
