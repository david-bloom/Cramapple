# Session handoff — slot gaps, Mechanics and Physics 1.3 loads (2026-10-17)

## Done (Production `pcntajvbdfqhbeewmdry`)
- Biology FRQ S-023 table fixed and live (APPROVAL-0193); table rendering and duplicate-parts fixes merged in the app repo (PRs #35, #36).
- Physics C-Mechanics units 1-3: 108 MCQs loaded (APPROVAL-0194 Mechanics record, merged #499/#500).
- Physics 1 topic 1.3: slot A (APPROVAL-0195) and slot B as is (APPROVAL-0196), 8 items; topic now has 12 published MCQs. Both on PR #502 (draft, CI green).
- Slot-gap audit for units 1-3: PR #501 (`docs/handoffs/SLOT_GAP_AUDIT_UNITS_1_3_2026_10_17.md`).

## Correction to the audit (read before acting on it)
- The audit's Statistics "relabel 1.2/1.9" option is invalid. Those 60 MCQs (and the 40 under 1.5) are in the retired pilot pack `7c5a2975`; the live pack is `548f06be`. Relabeling cannot make them servable. Retired pack: 223 published MCQs, 40 servable, 183 stranded.
- Statistics is NOT closed: the live pack has 18 topics with no servable MCQ (1.1-1.5, 1.9, 2.1, 2.3, 2.8, 2.11, 2.12, 3.7, 3.9-3.14).
- Codex's 88 MCQs published 2026-10-17 22:01 UTC are Precalculus (pack `5522b532`; topics 1.1, 1.3, 1.11, 2.1, 2.2, 2.8, 2.9, 2.14, 3.4, 3.8, 3.15; 8 each, all servable), not Statistics. They do not cover the audit's thin Precalculus topics (2.4, 2.10, 2.12, 3.1, 3.2).
- 20 items in the retired pack were updated at 21:46 UTC today by someone other than this session; unexplained.

## Owner decisions
- Statistics generation: owner said do NOT generate more Statistics questions. Nothing was started. The 18-topic gap stands (about 8 items each, roughly $26 at the Mechanics rate) if reopened.
- Not decided: whether the 29 FRQ-gap topics are in scope; other subjects' gaps (Physics 2, Calculus AB/BC, Chemistry, C-E&M, thin topics); Calc AB 1.16 held/provisional items.

## Open items
- Owner phone smoke tests (More help: Q8/S-003, Q5/S-021, Biology 2.10 MCQs, `apphy1-mcq-027`, `apphy1-mcq-004` [one earlier failed receipt, cause unknown], `apphy1-frq-021`), then close APPROVAL-0187.
- Merge PRs #501 and #502 (owner).
- Duplicate approval number: main has two APPROVAL-0194 records (Codex visual release and Mechanics load); renumbering not done.
- Mechanics unfilled slots 1.3-B, 2.2-A, 2.7-B; B4 `apphycm-frq-044`.
- Optional: More help panel still shows tables as pipe lines (MoreHelp.tsx).
- Verification not done: publish tool `verify` (needs access token) and live student-view checks for the Mechanics and Physics 1.3 loads.
