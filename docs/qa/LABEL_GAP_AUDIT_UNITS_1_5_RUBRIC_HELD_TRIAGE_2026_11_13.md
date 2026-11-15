# Rubric-held FRQs: triage (read-only), 2026-11-13

Status: read-only triage. No Production write, no item edited, nothing labeled. Source: Production `pcntajvbdfqhbeewmdry`, latest version of each item, stored held serving label payload (`source_payload.models[].output.rubric_preflight`) plus `app.frq_criteria`. Raw pull: `scripts/content-seed/label-gap-audit-2026-11-13/stage6/rubric_held_full.json` and `rubric_held_raw.json`.

## What the hold is
In the original labeling run, the serving-label model call first checks whether each rubric criterion matches something the prompt actually asks. 17 FRQs failed that check, so no unit labels were produced and the label was stored `held`. A label cannot fix this; the item text or rubric has to change.

Only one model (gpt-5.5) raised the flag on all 17. No second family has checked any of them. Treat each as a finding to verify, not a verdict.

## The 17, by repair type
**A. A criterion scores something the prompt does not ask (11).** Fix by removing or folding the criterion, or by adding the ask to the prompt. Either changes points or wording.
- `apcalcab-frq-u13-006` part-b criterion 03 (explain approximation)
- `apcalcab-frq-u13-017` part-a criterion 03 (domain restriction; asked in part c)
- `apcalcbc-frq-u13-010` part-a criterion 04 (simplify h'(x); prompt says only "find")
- `apcalcbc-frq-u13-018` part-a criterion 01 (derivative-validity interval vs function domain)
- `apphy1-frq-035` part-a criterion 07 (attainability condition)
- `apphy1-frq-052` part-b "limit" criterion (m2 to infinity)
- `apphycm-frq-036` part-c criterion 03 (time scale m/b)
- `apprecalc-frq-027`, `-029`, `-031` part-a criterion 2 (two-cycle sketch); `-031` also part-c criterion 2
- `apprecalc-frq-u12-004` part-c criteria (profit-positive interval vs domain)

**B. The prompt asks something no criterion scores (5).** Fix by adding a criterion (total points change) or trimming the prompt.
- `apphy1-frq-054` (v0x, v0y components)
- `apphy2-frq-028` (labels, arrow directions)
- `apphycem-frq-np1-002` (spherical-symmetry justification)
- `apphycem-frq-np1-003` (justify the maximum)
- `apphycem-frq-np1-010` (energy accounting)

**C. Structurally broken (1).** `apcalcbc-frq-u13-020`: `prompt_json` is empty and the stem lists no parts, and the criteria set skips keys (a-02, a-03 absent). The prompt has to be authored from the surviving criteria before anything else.

## What repair would take
Each fix is a new item version, so it needs: a drafted edit, a second-family check of both the finding and the edit, a CED check where content changes, a new APPROVAL, a rehearsed Production transaction, publication of the new version, then a fresh topic cell and serving label. None of the 17 is served today, so no student sees them change.

## Decisions needed from the owner
1. Authorize editing published FRQs at all (the original brief excluded edits).
2. For type A, the default direction: change the rubric to match the prompt (recommended, keeps what students see), or change the prompt.
3. Type C: author the missing prompt, or retire `apcalcbc-frq-u13-020`.
