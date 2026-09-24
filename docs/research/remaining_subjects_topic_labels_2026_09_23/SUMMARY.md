# Work Order H — Remaining-Subjects Topic Labels

Status: **in progress — 3 of 6 subjects complete**

Work order H re-entered after D's independent QA disposition changed the dependency gate to ACCEPTED. The earlier gate-skip record is preserved in `SUMMARY.md.20260923T195338Z.bak` and `run_metadata.json.20260923T195338Z.bak`.

## Production scope and pinned registries

Read-only filter: latest `version_num` per `content_item_id` where `status='published'` and `subject_key` is one of the six H subjects. Production writes: **0**.

| Subject | Published items | Charter items | Registry topics | Registry units | Count check | Status |
|---|---:|---:|---:|---:|---|---|
| ap-calculus-bc | 127 | 127 | 111 | 10 | agrees | complete |
| ap-physics-1 | 117 | 117 | 43 | 8 | agrees | complete |
| ap-precalculus | 117 | 117 | 58 | 4 | agrees | complete |
| ap-physics-c-em | 97 | 97 | 31 | 6 | agrees | not attempted |
| ap-physics-c-mechanics | 77 | 77 | 41 | 7 | agrees | not attempted |
| ap-physics-2 | 68 | 68 | 46 | 7 | agrees | not attempted |

All six pinned taxonomy versions report school year 2026–2027 and confidence `verified`. No count disagrees with the charter.

## Completed subjects

AP Calculus BC: 127 packet rows and 127 proposal rows; 17 recovered author codes and 110 content-derived decisions. Per-item recovered-code checks: 16 agrees, 0 disagrees, 1 unclear. Confidence: 96 high, 30 medium, 1 low. One Newton-iteration item is explicitly `undetermined` and routed to human review instead of being forced into a misleading topic. See `ap-calculus-bc/SUMMARY.md` for invariants, topic concentration, template-family evidence, and the lowest-confidence-first QA sample.

AP Physics 1: 117 packet rows and 117 proposal rows; 33 recovered author codes and 84 content-derived decisions. Per-item recovered-code checks: 32 agrees, 0 disagrees, 1 unclear. Confidence: 102 high, 14 medium, 1 low. One item about AP scoring policy rather than physics content is explicitly `undetermined`. Unit-name metadata was used only as a hint. See `ap-physics-1/SUMMARY.md` for subject evidence.

AP Precalculus: 117 packet rows and 117 proposal rows; 19 recovered author codes and 98 content-derived decisions. Per-item recovered-code checks: 19 agrees, 0 disagrees, 0 unclear. Confidence: 86 high, 27 medium, 4 low. Four balanced survey FRQs spanning unrelated units are explicitly `undetermined`. See `ap-precalculus/SUMMARY.md` for subject evidence.

## Remaining sequence

The three subjects marked not attempted have no packet or proposal files yet. Each will be completed and validated as a whole before the next subject begins. Every proposal remains gated on independent cross-model QA and Product Owner approval under DECISION-0055 before serving students.
