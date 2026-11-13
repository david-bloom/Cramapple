# TASK-0050 — 14 Statistics successor release packet

Scope: the 14 `modification_reserved` item rows on Production pack `548f06be-ccf4-426d-b82b-b424137a4438` reviewed in `scripts/content-seed/task0050-stats-phase-b-2026-11-11/review14_remedy_2026_11_12.md`.

## Source and content

`preflight.sql` matched all 14 exact retired v1 IDs and content hashes. Each parent is `published` but has no published version, topic, or skill cell. MCQ-012 has one historical attempt on v1, which the release preserves. Twelve successors have revised content and two copy v1. The final draft pass fixed MCQ-007 and MCQ-007-CAL's five-spin exponent, MCQ-012's stale p-value rationale, and CAL's legacy Unit 4 metadata. `verify_review14_drafts.py` passes all 12 revised drafts, including MCQ-012 p=0.036963 and GRAPH-036 r=-0.765094.

## Topic and skill

`skill_review_packets.json` contains 14 blind packets from the proposed successor contents and live registered grid. David authorized 33 external calls on the 11 multi-candidate packets. Run `skill-codes-ap_statistics-20261113030247` returned nine unanimous 3/3, two majority 2/3, and zero held, for $0.2444. Three more items have one registered skill each. See `skill_decisions.json` and `skill_vote_report.md`. `working_labels.json` is historical working data; use the vote result for release. The standalone SQL from `label_skill_codes_mcp.mjs` targets retired v1 IDs and must not be applied. The release SQL attaches the decisions to new v2 IDs.

## Rehearsal and remaining gate

`build_release.py` combines the exact source hashes, 12 drafts, two copied source contents, and vote result into `release_commit.sql`. The identical SQL with `rollback` in place of `commit` passed in Production: 14 versions, 12 revised, 14 validated serving labels, 14 topic cells, 14 skill cells, and 14 difficulty rows met every guard. An independent read confirmed zero v2 rows remained afterward. The release SQL is not yet applied.

The content protocol requires two independent CED-scope checks on revised versions. David authorized 24 Gemini and Claude checks, but automatic approval review rejected the proposed command because it also exports the 48 KB internal CED fact pack, which was not named in that approval. The command was not rerouted. Specific authorization for the fact-pack export is pending. Prior v1 checks found no scope issue on 13 items; both checkers flagged old MCQ-017, which the successor replaces with CED-aligned slope interpretation.

Once the CED gate clears, apply `release_commit.sql` under APPROVAL-0258. Verify all 14 new published versions, 14 topic/skill pairs, current serving-label hashes, zero new published-version skill gaps, and the student selector. The eight `photo_required` FRQs remain subject to the separate photo feature gate.
