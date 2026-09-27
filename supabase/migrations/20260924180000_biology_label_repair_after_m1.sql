-- M2.1 + M2.2 — repair of two defects introduced by today's own migrations.
-- APPLIED TO PRODUCTION 2026-09-24, both verified. Recorded here after the fact; the applied SQL is
-- reproduced below verbatim.
--
-- ---------------------------------------------------------------------------
-- The mechanism nobody had accounted for
--
-- app.taxonomy_relevant_hash(version_id) hashes stem, stimulus, prompt_json (minus modules and
-- subtopics), canonical_answer_1, canonical_answer_2, mcq_choices and frq_criteria.
--
-- Two things consume it:
--   1. trigger tg_content_versions_taxonomy_stale -> mark_content_taxonomy_labels_stale_for_version
--      marks a CURRENT label 'stale' when its validated_against_taxo_hash
--      `is distinct from` the item's current hash, but ONLY for labels in
--      ('validated','provisional_model').
--   2. the live serving selector requires an EXACT hash match on the serving label
--      (20260923150000_exclude_hand_drawn_from_text_serving.sql:169). This one has no status filter
--      -- so a legacy_unvalidated label with a stale hash silently stops serving too.
--
-- M1 rewrote canonical_answer_1 on 67 items. M4 removed prompt_json.total_points from 16. Both
-- fields are inside that hash. Consequences, neither of which surfaced as an error:
--
--   * 65 of M2's 112 provisional coverage labels were marked stale.
--   * 28 serving labels fell out of hash match, and Biology's servable set dropped to 19 of 118.
--     The selector does not fail on this. It just returns fewer rows.
--
-- The ordering was wrong: M2 (labels) should have run AFTER M1 and M4 (content), not before.
--
-- A second, subtler defect: M2 left validated_against_taxo_hash NULL. The trigger compares with
-- `is distinct from`, and NULL differs from every hash — so those labels would have staled on the
-- NEXT content edit whenever it came. Recording the hash is what makes a label durable.
--
-- (Note: the commit message for this file has one sentence mangled — a pair of backticks around
-- "is distinct from" was consumed by the shell, leaving "the trigger compares with , so null".
-- main forbids force-push, so the message stands as pushed. The sentence should read: the trigger
-- compares with `is distinct from`, so NULL differs from every hash.)
--
-- ---------------------------------------------------------------------------
-- M2.1 — coverage labels: restore and anchor
--
-- Restored the 65 stale coverage rows to provisional_model, and set
-- validated_against_version_id + validated_against_taxo_hash on all 118.
--
-- This does NOT promote anything to 'validated': the check constraint requires all five validation
-- columns, and validated_by / validated_at / validation_decision_id stay null. The human-validation
-- question DECISION-0062 deferred is still deferred.
--
-- VERIFIED: 112 provisional_model + 6 held, 0 stale, 0 validated, 118 carrying an anchor hash.
-- Durability proven by firing the stale trigger on all 118 items inside a rolled-back transaction:
-- the distribution was unchanged afterwards, which is what M2 alone would have failed.

update app.content_taxonomy_labels
set label_status = 'provisional_model'
where source = 'work_order_topic_tagging_2026_09_22'
  and label_status = 'stale'
  and cardinality(assessed_topics) = 1;

update app.content_taxonomy_labels l
set validated_against_version_id = civ.id,
    validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id)
from app.content_item_versions civ
where civ.content_item_id = l.content_item_id
  and civ.status = 'published'
  and l.source = 'work_order_topic_tagging_2026_09_22';

-- ---------------------------------------------------------------------------
-- M2.2 — serving labels: re-anchor the 22 items today's work made unservable
--
-- RESTORING, NOT ASSERTING. A serving label answers "what must a student have covered to ANSWER
-- this?" — a property of the question. M1 changed only the model answer; M4 removed only a field
-- work order I proved nothing reads. Neither touched stem, stimulus, mcq_choices or frq_criteria,
-- so nothing determining required_units moved.
--
-- The 28 affected labels were three different things, and only two were repaired:
--   13 'stale'              — were provisional_model until M1's trigger staled them. Restored.
--    9 'legacy_unvalidated' — never staled (the trigger skips that status) but the selector's hash
--                             check dropped them anyway. Re-anchored and deliberately LEFT
--                             legacy_unvalidated: re-anchoring is not a reason to upgrade a label
--                             nobody validated.
--    6 'held'               — L-012/013/014/015/017/031. required_units empty and
--                             max_required_unit null, so not servable whatever the hash says, and
--                             'held' is deliberate. NOT TOUCHED.
--
-- An earlier attempt asserted all 28 were stale and aborted on its own guard. That guard was right
-- and the assumption was wrong; this version was written from what the rows actually contained.
--
-- The applied statement is reproduced in the repaired form; see the migration record for the full
-- guarded transaction, which asserted 22 in scope (13 + 9) before writing and re-checked every
-- repaired label's hash afterwards.
--
-- VERIFIED AFTER: Biology servable 19 -> 41 (22 FRQ + 19 MCQ), spread across all 8 units
-- (u1:2 u2:9 u3:2 u4:5 u5:5 u6:9 u7:6 u8:3). 0 labels became 'validated'. 0 legacy labels upgraded.
--
-- ---------------------------------------------------------------------------
-- DELIBERATELY NOT REPAIRED — recorded as open findings, not silently fixed
--
--   * 24 Biology serving labels carried a mismatched hash BEFORE today: the 4 hand-drawn items
--     (excluded from text serving anyway) and 20 MCQ — APBIO-MCQ-025/030/033/043/046/054/056/063/
--     067/069/074/079/084/086/088/093/094/095/097/099. Cause unknown and predates this work.
--     Re-anchoring them would assert a label nobody has checked.
--   * 43 published Biology items have NO current serving label at all, so they cannot be served
--     under any hash. Serving labels were last written 2026-08-08.
--
-- Together these are why Biology serves 41 of 118 items, not 118.
