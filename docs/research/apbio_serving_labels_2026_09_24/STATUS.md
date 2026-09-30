# STATUS: HISTORICAL — INCOMPLETE (preserved 2026-09-30)

These files are Codex's Work Orders N and N.1, preserved from the never-PR'd branch
`codex/work-order-n-biology-serving-labels` (head `2e85f2d`, 2026-09-27). They were copied onto `main`
unchanged so the branch can be retired without losing the record.

**The work was not finished.** It stopped before any model call (`run_metadata.json`:
`blocked_before_model_calls`). No serving labels were proposed or written, and nothing here was applied
to any database.

- **N:** label 43 unlabelled AP Biology short FRQs (proposal only).
- **N.1:** re-derive 5 rejected AP Biology MCQ serving labels.

What it holds that exists nowhere else on `main`:

- `packet.jsonl`: the 48-item Production input snapshot for N + N.1, as of 2026-09-28 02:04 UTC.
- `u3_audit.csv`: an audit of the 15 unsuperseded AP Biology serving labels that include Unit 3.
- `HANDOFF.md`: two suspected Unit 3/Unit 4 mix-ups **outside** N.1's scope, `APBIO-MCQ-031` and
  `APBIO-MCQ-035`, alongside the known N.1 cases `APBIO-MCQ-030`, `-033`, `-046`.

**Before relying on any of it:** check whether later work (TASK-0049's label promotion, PR #250;
TASK-0050's skill-dimension labelling) already covered these 48 items. The snapshot is stale for any
item republished since 2026-09-28.
