# DRAFT approval entry (not recorded, not approved)

Paste into `docs/activity_log/APPROVALS_LOG.md` only after David Bloom approves, with the next free number (the log's
highest heading on this branch is `APPROVAL-0176`, but other branches hold numbers; check before recording), the
`Approved By` line filled in with his exact words, and a matching line added above `<!-- INDEX_END -->`. Per the repo
rule, the entry must be recorded **before** any Production write.

Index line to add:

`- APPROVAL-NNNN — Publish 16 FRQs to Production for the Zero-FRQ Topics of AP Biology and AP Statistics, Units 1-4 (2026-10-25)`

---

## APPROVAL-NNNN — Publish 16 FRQs to Production for the Zero-FRQ Topics of AP Biology and AP Statistics, Units 1-4

**Date:** 2026-10-25  
**Approved By:** *(pending)* David Bloom. Requests on record this session: "for each topic with zero FRQs in units 1-4, stats and biology, make 2 New FRQ authored in session", "go ahead and run the checkers", "draft the approval entry and publish script". None of these approves a Production write.  
**Related:** batch `scripts/content-seed/frq-u4-zero-topics-2026-10-25/` (README, `plan.json`, `publish_frq_batch.py`, slot files with every check and arbitration ruling, `answer_grades.json`, `calls.jsonl`), draft PR #566, `APPROVAL-0146` (the Units 1-3 batch this follows, same method and publish path), `APPROVAL-0143` (topic labels).  
**Decision:** *(pending)*

**Approved scope (proposed):** publish 16 new short FRQs (`<subject>-frq-u4z-<topic>-<n>`), two for each of the 8 topics that had zero published FRQs in Production on 2026-10-25: AP Biology 4.2, 4.6 (4 FRQs) and AP Statistics 4.2, 4.4, 4.6, 4.7, 4.8, 4.9 (12 FRQs). Per subject, one transaction (advisory lock): item, version and 1-point criteria; stored-text hash check against `plan.json`; owner approval decision (human review waived, as in `APPROVAL-0146`); validated serving label (required units from the six-vote probe) bound hash-fresh; validated primary topic cell; provisional difficulty; published. Every guard from the Units 1-3 script is kept: the exam pack is the subject's published serving pack, no `content_key` exists, the topic is in the taxonomy, and the topic still has **zero** published FRQs with a primary topic cell (checked before any insert, so both FRQs for a topic go in together). A rehearsal inside each transaction raises and rolls back before the commit.

**Steps (all run by the owner or with explicit go-ahead; none run yet):**
1. `python3 publish_frq_batch.py preflight --env prod` (read-only): confirms no planned topic has gained an FRQ.
2. `python3 publish_frq_batch.py rehearse --env prod --approval APPROVAL-NNNN` (rolls back).
3. `python3 publish_frq_batch.py publish --env prod --approval APPROVAL-NNNN --confirm-production`.
4. `python3 publish_frq_batch.py verify --env prod`: expects 16 of 16 with matching text, a primary topic and a fresh validated label.
5. Recount the census (published FRQs by primary topic, Biology and Statistics Units 1-4); expected result: each of the 8 topics has exactly 2 published FRQs and no other topic count changes.

**Quality evidence:** every item passed lint, an exact recompute (including t critical values and Welch degrees of freedom re-derived with mpmath), the six-vote topic probe (16 of 16 on target at 5 or 6 of 6) and both checker families (GPT-6.1 Sol, DeepSeek V4 Pro) on the final text, after three check rounds (4, then 9, then 16 accepted). Every checker flag was a real rubric defect and was fixed (one was adopted in part); rulings are in each slot file's `arbitration` entries. Model answers: 16 of 16 full credit graded criterion by criterion by a third family (gemini-3.8-flash, `answer_grades.json`). Gateway spend $4.59 (446 calls).

**Gaps the approver should weigh (not hidden):**
- **Planted-defect controls were not re-run** for this batch. The only evidence is the Units 1-3 run's 8 of 8 on the same checker pair and rules.
- **Production grader QA (`app.qa_grade_frq`) was not run.** Its QA path grades published AP Biology only; third-family grading is used in its place, as accepted for `APPROVAL-0146`. This entry asks for the same acceptance.
- **Human review is waived**, as in `APPROVAL-0146`.
- **Difficulty is provisional** (checker majority, `confidence = low`) until attempt data exists.
- **CED scope source:** extracted CED topic text plus the Biology and Statistics fact packs; the CED PDFs were not available in the authoring session.
- **Biology 4.2 versus 4.3 is an open ruling.** Five cascade/amplification versions of a Biology 4.2 item each voted 6 of 6 for 4.3, including after the epinephrine/glycogen scenario (a CED 4.3 illustrative example) was replaced. The vote was not overridden. The published Biology 4.2 FRQs would therefore test receptor location and ligand recognition (EK 4.2.B.1), not cascade amplification (EK 4.2.B.2). This entry does not decide that; David may rule separately.
- **No Development copy** is included. The Units 1-3 batch also loaded Development as a content-only copy; that is a separate, optional step.

**Not approved by this entry:** any other FRQ, any change to the 126 `*-frq-u13g-*` items or the 183 `APPROVAL-0143` topic cells, Units 5+, MCQ work, front-end or Lovable changes, and the Biology 4.2/4.3 ruling.

**Rollback:** each FRQ is a new item with `content_key like '%-frq-u4z-%'`; retire the item and its version (status `retired`) to remove it from serving. No existing row is modified.
