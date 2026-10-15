# AP Chemistry Topic 2.5 (Lewis Diagrams) reference entry, 2026-10-15

**Why:** Topic 2.5 had no reference entries in Development or Production. The eight published questions mapped to 2.5 were refused by More help (`reference_unavailable`). The 2026-10-10 Chemistry Unit 2 run produced no 2.5 candidate: the CED gives 2.5 one essential-knowledge statement (2.5.A.1, "established set of principles") and does not print the principles.

**Method:** entries hand-authored under Product Owner approval (not extracted), then checked with the standard slate: `google/gemini-3.5-flash` and `openai/gpt-6-sol` (Haiku 5.5 veto only if both accept). Six planted controls reused unchanged from `scripts/content-seed/ap-chemistry-reference-u2-u3-2026-10-10/controls_ap_chemistry_u2.json`: 6/6 rejected. CED pages 49-59 of `pdftotext -layout`. Scripts were copied unmodified from `scripts/content-seed/reference-pack-template/` (not committed here).

| Round | Candidates | Result |
|---|---|---|
| 1 | steps (6-step sequence), ion electron count, expanded octet | all rejected. Expanded octet dropped: 2.7.A.3 Exclusion Statement ("only responsible for the shape" beyond four electron pairs). Ion count merged into the steps entry. |
| 2 | "Principles for constructing a Lewis diagram" (4 items) | Gemini accept; GPT reject x2 (CED does not require the principles as stated; "remaining electrons are lone pairs" and "octet where possible" overstate for odd-electron species, 2.6.A.3) |

**Escalation and ruling:** two rounds exhausted; escalated to the Product Owner, who ruled "Override and publish" on 2026-10-15. The caution on the row records that the CED does not print the principles and cites 2.6.A.3. No worked example is included, so the entry cannot disclose an answer to a 2.5 question.

**Load:** `load.py --po-accept` was blocked by the session's permission classifier; the Product Owner approved applying the equivalent single `insert` directly through the Supabase tool (`out/load_ap_chemistry_u2.sql`, identical to the executed statement). Development `71bdd801-bd6d-477f-bb46-330a76a2b965`, Production `fc3b546c-b200-4151-bab5-57331728bdf6`.

**Verification (Production):** 1,083 -> 1,084 published entries; Chemistry 227 -> 228; Unit 2 21 -> 22; all 8 published 2.5 questions now have a published entry whose `topic_codes` contain 2.5. Development and Production counts match. Not yet checked in the signed-in app.

**Not committed:** the full round-1 verdicts file (about 32 KB, including the six controls) and gateway call logs. Round-1 outcomes are summarised above; the round-2 verdict is in `out/`.

**Open scope note (not changed here):** four of the eight 2.5 questions (apchem-mcq-026 and variants) ask about expanded octets, which the 2.7.A.3 Exclusion Statement says students are not responsible for. This entry deliberately does not cover expanded octets.

**Rollback:** `update app.unit_reference_entries set status='retired' where reference_entry_id='fc3b546c-b200-4151-bab5-57331728bdf6'` (no hooks reference it).
