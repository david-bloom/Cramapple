# Unit 3 seeded variants (2026-09-30)

Seeds: `apcalcab-mcq-005`, `-007`, `-030`, `-008` (all audited first per S0a: keys correct, each had a distractor-rationale defect; see `../calc-ab-seed-audit-2026-09-30/AUDIT_REPORT.md`).
`-029` was varied in the pilot. 2 variants per seed = **8 variants**. Author Claude Sonnet 5.5; checkers Gemini 3.8 Flash + DeepSeek V4 Pro. Nothing loaded to any database.
Seed repairs are handled by a separate task; these variants were written from the seed's structure with rationales re-derived, not copied.

| Stage | Result |
|---|---|
| Sympy (keys + distractor values), first draft | 8 of 8 pass (one harness formatting issue for radicals fixed, not a content error) |
| Blind solve, 2 models | 0 of 16 disagreed with the key |
| Rationale audit, 2 models | **3 of 8 variants had a real defect on first check** (005-v1 B, 007-v2 A, 008-v2 B); both models flagged 2 of them, the third by DeepSeek |
| CED, 2 models | 16 of 16 `fully_in_scope`, 0 issues |
| After patching those 3 and re-running the full checks on them | 0 flags |
| Cost | $0.37 first pass (32 math + 16 CED calls) plus about $0.10 for the 3-item re-check |

Defects, all in the misconception rationale that sympy cannot see: 007-v2 said an exponent was "kept" when the distractor's -1/3 is a negated exponent; 008-v2 said omitting one product-rule term gives -2/3 (it gives -1/6; -2/3 needs the whole xy term dropped, so the distractor value was changed to -1/6 to match its rationale, mirroring 008-v1); 005-v1 said "dropping the 3x in the exponent" (only the 3 is dropped).

Running total across the pilot and Unit 3 (24 variants): 4 with a real first-pass defect (17%), in line with Unit 1's roughly 15%. The pilot's 6% was a lucky small draw.
The pattern is stable: **keys never wrong, prose about "why this is wrong" is where the errors are, and a second model catches what the first misses.**
