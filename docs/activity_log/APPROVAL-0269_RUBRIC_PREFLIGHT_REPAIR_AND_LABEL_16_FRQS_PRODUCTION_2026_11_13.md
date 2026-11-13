# APPROVAL-0269 — Rubric repair and labeling of 16 rubric-held FRQs, Units 1-5, Production (2026-11-13)

- **Date:** 2026-11-13.
- **Authorization:** David Bloom (Product Owner), in chat: "Rubric-held FRQs" (take the residue item), then "Yes, rubric-side" (authorize editing the published FRQs, rubric changed to match the prompt), then "Yes, $3 cap" (gateway spend cap for checking and relabeling). This lifts the original brief's "no item edits" limit for these 16 items only.
- **What is written (Production `pcntajvbdfqhbeewmdry`):**
  - **Phase 1 (`publish_rubric_repair.py`):** a new published version (version number +1) of each of 16 FRQs, prompt text unchanged, criteria edited per `scripts/content-seed/label-gap-audit-2026-11-13/stage6/rubric_edits.py` (8 items rewritten only at equal points; 3 items lose a criterion; 5 items gain 6 criteria in all, two of them also rewriting one criterion). Old version set to `retired`. Difficulty rows copied to the new version. One rehearsed transaction per subject (7), advisory lock.
  - **Phase 2 (`publish_labels_r3.py`, after the six-vote topic probe on the new versions):** validated primary topic cell and validated, hash-fresh serving label per item, with the same voting rules as APPROVAL-0265.
- **Items (16):** `apcalcab-frq-u13-006`, `-017`; `apcalcbc-frq-u13-010`, `-018`; `apphy1-frq-035`, `-052`, `-054`; `apphy2-frq-028`; `apphycem-frq-np1-002`, `-003`, `-010`; `apphycm-frq-036`; `apprecalc-frq-027`, `-029`, `-031`, `-u12-004`.
- **Point totals that change:** `apcalcab-frq-u13-017` 9→8, `apcalcbc-frq-u13-010` 9→8, `apphy1-frq-052` 8→7, `apphy1-frq-054` 6→7, `apphy2-frq-028` 5→6, `apphycem-frq-np1-002` 6→7, `-003` 5→6, `-010` 6→8. The other seven are unchanged (including `apphy1-frq-035`, kept at 10 because full-exam Physics FRQs have a fixed part-point contract).
- **Checks before writing:** each edited rubric passed a rubric preflight by two model families (GPT-6.1 Sol plus DeepSeek V4 Pro; Gemini 3.8 Flash also passed all 16). Findings from the first pass were fixed and rechecked (results `stage6/check_results.jsonl`). Rubric content for physics additions was not independently checked against the CED PDFs.
- **NOT changed:** `apcalcbc-frq-u13-020` (no prompt parts; owner has not chosen author-or-retire), any prompt text, stem, stimulus, any other item, any validated label or cell, skill cells, schema, functions, migrations, edge functions, frontends.
- **Rollback:** per item, set the new version to `retired` and the old version back to `published` (item stays published); delete phase-2 rows tagged `source like 'rubric_preflight_repair_2026_11_13%'` or `label_gap_fill_u1_5_r3_2026_11_13%`. No student attempts exist on the held items' new versions at write time.
- **Cost:** rubric checks $0.45 measured (ledger `stage6/check_ledger.jsonl`); phase-2 vote cost recorded in `stage6/r3/cost_ledger.jsonl`; cap $3 total. Drafting and rulings by Claude in session (not gateway-priced).
- **Numbering check:** highest APPROVAL on origin/main, open PRs and all remote branches was 0268; this record takes 0269.
- **Rehearsal:** all seven phase-1 subject transactions printed `REHEARSAL OK` and rolled back.
- **Result:** see the execution record appended below.

## Execution record (2026-11-13)
- **Phase 1:** 16 new versions published and read back (`publish_rubric_repair.py verify`: planned rubric hash, one published version per item, 16 of 16 MATCH).
  - First attempt: the two Calculus subjects committed; Physics 1 was refused at commit by `app.validate_full_exam_frq_version` (full-exam Physics FRQs must keep fixed part points: `apphy1-frq-035` expects [7,3]). Nothing from that transaction was written. My rehearsal had passed because the check is deferred to commit; rehearsals now run `set constraints all immediate` first.
  - Fix: the 035 edit changed from deleting a criterion to rewriting two (a-01 general principle, a-07 system-specific energy balance), keeping 10 points; rechecked by three model families, all pass. The five remaining subjects then committed.
- **Phase 2:** 16 validated primary topic cells and 16 validated, hash-fresh serving labels (`publish_labels_r3.py`; topics at 5 of 5 or 5 of 6 votes from the existing blind probe, units named by >= 4; the prompt text is unchanged so the original votes apply). Old held labels superseded. Read-back 16 of 16 MATCH.
- **Live selector:** 16 of 16 returned by `public.select_student_practice_items` with `topic_match = true` (`stage6/selector_check_r3.json`).
- **Cost:** gateway $0.50 measured (rubric checks and rechecks, `stage6/check_ledger.jsonl`); no phase-2 vote spend (existing votes reused). Cap was $3.
- **Not verified:** physics rubric additions were checked by models, not against the CED PDFs by a person.
