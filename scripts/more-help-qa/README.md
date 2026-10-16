# More help QA tools (Development only)

Reusable harness for the per-subject rollout. Rules and the full procedure: `docs/qa/MORE_HELP_PER_SUBJECT_ROLLOUT_RUNBOOK_2026_10_16.md`.

- `fixtures.sql` — idempotent: single-item sessions for the synthetic QA identity on real published questions (2 MCQ + 1 FRQ per unit). Substitute `__SUBJECT__`, `__UNITS__`, `__USER__`; run on Development only.
- `run.mjs` — makes live More help requests as the synthetic identity. **Spends model generations.** Refuses any URL that isn't the Development project and any non-`@example.invalid` identity; requires `--cap`; counts every request (including failures); stops at the first non-200; waits between calls. Reads the Dev secret key from the gitignored `.secrets.env`; never prints it.
- `replay.ts` — offline replay of saved outputs through the current validator (no network, no model).
- `packet.mjs` — builds the private review packet; write it under `tmp/` (gitignored), never commit.

Readiness SQL (read-only, Production): `scripts/more-help-readiness/`.
