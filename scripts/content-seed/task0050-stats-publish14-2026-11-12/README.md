# TASK-0050 — 14 Statistics successor release packet

Scope: the 14 `modification_reserved` item rows on Production pack `548f06be-ccf4-426d-b82b-b424137a4438` reviewed in `scripts/content-seed/task0050-stats-phase-b-2026-11-11/review14_remedy_2026_11_12.md`.

## Source and content

`preflight.sql` matched all 14 exact retired v1 IDs and content hashes. Each parent is `published` but has no published version, topic, or skill cell. MCQ-012 has one historical attempt on v1, which the release preserves. Twelve successors have revised content and two copy v1. The final draft pass fixed MCQ-007 and MCQ-007-CAL's five-spin exponent, MCQ-012's stale p-value rationale, and CAL's legacy Unit 4 metadata. `verify_review14_drafts.py` passes all 12 revised drafts, including MCQ-012 p=0.036963 and GRAPH-036 r=-0.765094.

## Topic and skill

`skill_review_packets.json` contains 14 blind packets from the proposed successor contents and live registered grid. David authorized 33 external calls on the 11 multi-candidate packets. Run `skill-codes-ap_statistics-20261113030247` returned nine unanimous 3/3, two majority 2/3, and zero held, for $0.2444. Three more items have one registered skill each. See `skill_decisions.json` and `skill_vote_report.md`. `working_labels.json` is historical working data; use the vote result for release. The standalone SQL from `label_skill_codes_mcp.mjs` targets retired v1 IDs and must not be applied. The release SQL attaches the decisions to new v2 IDs.

## Rehearsal and remaining gate

`build_release.py` combines the exact source hashes, 12 drafts, two copied source contents, and vote result into `release_commit.sql`. The identical SQL with `rollback` in place of `commit` passed in Production: 14 versions, 12 revised, 14 validated serving labels, 14 topic cells, 14 skill cells, and 14 difficulty rows met every guard. An independent read confirmed zero v2 rows remained afterward. The same guarded SQL was then committed under APPROVAL-0258 on 2026-11-13 ET.

The manual change-by-change CED read is in `ced_delta_review.md`. David authorized 24 initial Gemini and Claude CED checks, the fact-pack export, and 18 final-draft checks after corrections. All 42 completed. Both families cleared the final nine changed drafts (18/18) and the three other revised MCQs in the first pass (6/6). `ced_check_adjudication.md` records the source-based disposition of the initial format flags and minor final notes. All eight graph v2 prompt payloads are explicitly tagged `supplemental_hand_drawn`, and the release guards that tag.

The Production commit and independent read-back passed: all 14 v2 versions are published with validated hash-current serving labels, topic/skill pairs, difficulty and topic-resolution rows. All 12 revised v2 contents match the saved drafts; the two copied items match their retired sources; six MCQs have one correct choice each and eight FRQs have four criteria totaling four points. The real student selector returned all 14 v2 keys and topic matches for an unanswered synthetic user at unit 5. The eight `photo_required` FRQs remain subject to the separate TASK-0069 student photo gate. The full receipt is in APPROVAL-0258.
