# APPROVAL-0201 — Publish 16 FRQs to Production for the Zero-FRQ Topics of AP Biology and AP Statistics, Units 1-4

- **Date:** 2026-10-28
- **Decision:** Approved. Recorded before any Production write.
- **Granted by:** David Bloom (Product Owner), in session, replying to the draft approval entry and publish script (`scripts/content-seed/frq-u4-zero-topics-2026-10-25/APPROVAL_DRAFT.md`, `publish_frq_batch.py`, merged in PR #566): "I approve document it and run those steps".
- **Earlier requests in the same work (not Production approvals):** "for each topic with zero FRQs in units 1-4, stats and biology, make 2 New FRQ authored in session"; "go ahead and run the checkers"; "draft the approval entry and publish script".
- **Related:** batch `scripts/content-seed/frq-u4-zero-topics-2026-10-25/` (README, `plan.json`, `publish_frq_batch.py`, slot files with every check and arbitration ruling, `answer_grades.json`, `calls.jsonl`); PR #566; `APPROVAL-0146` (the Units 1-3 batch this follows: same method, same publish path); `APPROVAL-0143` (topic labels).

## Approved scope

Publish 16 new short FRQs (`<subject>-frq-u4z-<topic>-<n>`), two for each of the 8 topics that had zero published FRQs in Production on 2026-10-25:

| Subject | Topics | FRQs |
| --- | --- | --- |
| AP Biology | 4.2, 4.6 | 4 |
| AP Statistics | 4.2, 4.4, 4.6, 4.7, 4.8, 4.9 | 12 |

Per subject, one transaction (advisory lock): item, version and 1-point criteria; stored-text hash check against `plan.json`; owner approval decision (human review waived, as in `APPROVAL-0146`); validated serving label (required units from the six-vote probe) bound hash-fresh; validated primary topic cell; provisional difficulty; published. Guards kept from the Units 1-3 script: the exam pack is the subject's published serving pack, no `content_key` exists, the topic is in the taxonomy, and the topic still has **zero** published FRQs with a primary topic cell (checked before any insert, so both FRQs for a topic go in together). A rehearsal inside each transaction raises and rolls back before the commit.

Steps approved: `preflight` (read-only), `rehearse` (rolls back), `publish --confirm-production`, `verify`, then a recount of published FRQs by primary topic for Biology and Statistics Units 1-4. Expected result: each of the 8 topics has exactly 2 published FRQs and no other topic count changes.

## Quality evidence

Every item passed lint, an exact recompute (t critical values and Welch degrees of freedom re-derived with mpmath), the six-vote topic probe (16 of 16 on target at 5 or 6 of 6) and both checker families (GPT-6.1 Sol, DeepSeek V4 Pro) on the final text, after three check rounds (4, then 9, then 16 accepted). Every checker flag was a real rubric defect and was fixed (one adopted in part); rulings are in each slot file's `arbitration` entries. Model answers: 16 of 16 full credit graded criterion by criterion by a third family (gemini-3.8-flash, `answer_grades.json`). Gateway spend $4.59 (446 calls).

## Gaps accepted by this approval

- Planted-defect controls were not re-run for this batch; the evidence is the Units 1-3 run's 8 of 8 on the same checker pair and rules.
- Production grader QA (`app.qa_grade_frq`) was not run (its QA path grades published AP Biology only); third-family grading stands in, as accepted for `APPROVAL-0146`.
- Human review waived, as in `APPROVAL-0146`.
- Difficulty is provisional (checker majority, `confidence = low`) until attempt data exists.
- Scope came from extracted CED topic text and the Biology and Statistics fact packs; the CED PDFs were not available when the items were authored.

## Not approved by this entry

- **The Biology 4.2 versus 4.3 ruling remains open.** Five cascade/amplification versions of a Biology 4.2 item each voted 6 of 6 for 4.3 (including after the CED's own 4.3 illustrative example, epinephrine and glycogen, was replaced). The vote was not overridden. The published Biology 4.2 FRQs test receptor location and ligand recognition (EK 4.2.B.1), not cascade amplification (EK 4.2.B.2).
- Any other FRQ; any change to the 126 `*-frq-u13g-*` items or the 183 `APPROVAL-0143` topic cells; Units 5 and above; MCQ work; front-end or Lovable changes; a Development copy.

## Rollback

Each FRQ is a new item with `content_key like '%-frq-u4z-%'`. Retire the item and its version (status `retired`) to remove it from serving. No existing row is modified.

## Execution

Executed 2026-10-29 by Claude (Sonnet 5.5) in session, from `scripts/content-seed/frq-u4-zero-topics-2026-10-25/` on `origin/main` (post PR #571), Production (`pcntajvbdfqhbeewmdry`), with the steps in the approved order:

1. `publish_frq_batch.py preflight --env prod`: `ap_biology` 4 planned, `ap_statistics` 12 planned; state absent; no planned topic already had an FRQ.
2. `publish_frq_batch.py rehearse --env prod`: `REHEARSAL OK` for both subjects (4 and 12), rolled back.
3. `publish_frq_batch.py publish --env prod --approval APPROVAL-0201 --confirm-production`: `ap_biology` rehearsed, committed, verified (4 FRQs); `ap_statistics` rehearsed, committed, verified (12 FRQs).
4. `publish_frq_batch.py verify --env prod` (run again standalone): 16/16 published with matching text, a primary topic and a fresh validated label.
5. Recount of published FRQs by primary topic (latest published version, `is_primary`, `skill_code is null`, the plan's taxonomy version per subject): Biology 4.2 and 4.6 each have exactly 2 (both `-frq-u4z-`); Statistics 4.2, 4.4, 4.6, 4.7, 4.8 and 4.9 each have exactly 2 (all `-frq-u4z-`). No Biology or Statistics topic in Units 1-4 has zero published FRQs now. The other Units 1-4 topic counts carry no `-frq-u4z-` items, so no other topic count changed from this publish (the pre-publish counts were not captured, so "unchanged" rests on that, not on a before/after diff).

Outcome: as approved, 16 FRQs published, nothing beyond scope touched. No errors, retries or partial states. The Biology 4.2 versus 4.3 ruling stays open (see "Not approved by this entry"). Rollback is unchanged: retire items with `content_key like '%-frq-u4z-%'`.
