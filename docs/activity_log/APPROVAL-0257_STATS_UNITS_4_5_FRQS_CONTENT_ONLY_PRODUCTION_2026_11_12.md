# APPROVAL-0257 — AP Statistics Units 4-5 FRQs, round 2: 30 FRQs published as content only (labels out)

- **Date:** 2026-11-12.
- **Authorization:** David, in chat: "5.3 is acceptable as an exception ... I approve publication of all", then, asked whether labels are in or out, "Labels out, publish content only". Scope as I stated it before the answer: the 30 round-2 items (10 seeds including the 5.3 exception, 20 variants). The five unreplaced batch-1 seeds (5.2, 4.1, 4.2, 4.8, 4.10) and the superseded Easy batch-1 items are **not** included.
- **What is written (Production, project `pcntajvbdfqhbeewmdry`):** 30 `app.content_items` (item_type `frq`, keys `apstats-frq-u45r2-<topic>-s|v1|v2`), their versions, criteria and an owner approval decision, published. One transaction with an advisory lock, rehearsed first and rolled back (`REHEARSAL OK ... published=30`), then committed.
- **What is NOT written:** no serving label, no topic cell, no difficulty row (a separate labeling task does those). Until it runs these items are published but not topic-labelled, so the student selector will not serve them as topic matches. No schema, function or app change. Variant lineage is recorded in `prompt_json.provenance` (`seed_key`).
- **Evidence behind it:** batch README `scripts/content-seed/frq-stats-u5-2026-11-12/README.md`: seeds passed lint, exact recompute, six-vote topic probe and two checker families with a difficulty gate (no checker rated Easy; 5.3 rated Medium and Easy, accepted by David as an exception); variants passed a diff-style check of both families; model answers graded by a third family 30/30. Distinctness against the 26 published Statistics 4.x/5.x FRQs was compared by title only (contexts differ; closest overlap is the published matched-pairs 5 km item for 4.4).
- **Rollback:** set `app.content_items.status = 'retired'` for keys like `apstats-frq-u45r2-%` (and their versions); nothing else depends on them.
- **Tool:** `scripts/content-seed/frq-stats-u5-2026-11-12/r2/publish_frq_content_only.py` (`plan`, `preflight`, `rehearse`, `publish`, `verify`).
- **Numbering check:** highest APPROVAL on main and all remote branches at this time was 0256.
- **Result:** see the execution record appended below.

## Execution record (2026-11-12)
- Rehearsal (rolled back): `REHEARSAL OK: ap_statistics published=30`. Commit: one transaction, 30 FRQs.
- Independent read after commit: 30 of 30 keys `apstats-frq-u45r2-%` published; 177 criteria rows (59 per set of ten seeds, 118 for the 20 variants, as planned); stored text hashes match the local plan 30/30 with a model answer on each; 0 with a topic cell, 0 with a taxonomy label (as approved).
- Not verified: no student-side serving or grading check (the items are unlabeled, so the selector cannot return them yet); no authenticated app check.
- Publish record: `scripts/content-seed/frq-stats-u5-2026-11-12/r2/publish_prod.json`; plan: `r2/plan.json`.
- **Open:** the separate labeling task must add topic cells, serving labels and difficulty. Until then the items are published but not servable by topic.
