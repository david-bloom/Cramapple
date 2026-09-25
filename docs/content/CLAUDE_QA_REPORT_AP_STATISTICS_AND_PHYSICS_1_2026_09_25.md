# Claude QA Report — AP Statistics and AP Physics 1 (Codex's Readiness Measurements), 2026-09-25

**What this is.** Codex produced launch-readiness measurement docs for AP Statistics
(`codex/apstats-launch-readiness-2026-09-24` branch, `docs/product/AP_STATISTICS_LAUNCH_READINESS_2026_09_24.md`)
and AP Physics 1 (`codex/physics1-launch-readiness-2026-09-24` branch,
`docs/product/AP_PHYSICS_1_LAUNCH_READINESS_2026_09_24.md`). Neither branch has been merged to main.
Unlike Calc AB/Chemistry/Physics 2/Physics C, Codex's work here is measurement and diagnosis only —
no canonical answers, labels, or difficulty proposals were authored for either subject. So this is not
a re-derivation of authored content (there isn't any yet); it's an independent re-verification of
Codex's *measured claims* against Production, using the same rigor: don't trust a report's own
numbers, call the real functions and query the real tables yourself.

Every number below was independently re-queried against Production (`pcntajvbdfqhbeewmdry`) on
2026-09-25, not copied from either readiness doc.

## AP Statistics — verdict: Codex's core findings are correct

**The P0 finding is real and independently confirmed.** Two AP Statistics exam-pack versions are
simultaneously `status='published'` and `retired_at IS NULL`:

| exam_pack_version_id | school year | published items |
| --- | --- | ---: |
| `548f06be-ccf4-426d-b82b-b424137a4438` (old/general) | 2026 | 193 |
| `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` (new/pilot) | 2026-27 | 203 |

Both item counts match Codex's report exactly. This is the same class of routing hazard the servability
criteria doc calls out explicitly (criterion 6) — a second published version is a launch blocker
regardless of how good criteria 1-5 look on the primary version.

**Live serving RPC counts, re-called directly, all match exactly:**

| Call | Codex claimed | Independently re-verified |
| --- | ---: | ---: |
| `select_practice_frqs(old, 'targeted_drill', 999)` | 49 | 49 |
| `select_practice_frqs(old, 'full_exam_frq', 999)` | 0 | 0 |
| `select_practice_frqs(new, 'targeted_drill', 999)` | 0 | 0 |
| `select_practice_frqs(new, 'full_exam_frq', 999)` | 0 | 0 |

**Old-pack content counts, re-verified with the correct "current published version" filter (see the
methodology note below — this matters): 69 FRQ, 34 with `canonical_answer_1`, 0 with
`canonical_answer_spans`, 0 with `content_item_difficulty` rows.** All four match Codex's report
exactly.

**Grading-path reachability:** Codex reported 3 AP Statistics FRQ x 3 runs, all returning HTTP 409
`qa_path_ap_biology_only`. I did not re-run the calls, but I independently confirmed the underlying
cause directly from the deployed `evaluate-attempt` function source (not the repo copy, which has
drifted from Production before): `if (examPack.exam_code !== "ap_biology") return respond({ error:
"qa_path_ap_biology_only" }, { status: 409 })`. This gate is subject-agnostic — any non-Biology
`exam_code` fails identically — so Codex's finding is correct and there was no need to re-run it to
confirm.

**One claim I could not reproduce exactly:** Codex's TASK-0022 rubric-defect breakdown states "13 text
FRQ have multi-point criteria; 21 text FRQ still all-1pt; 20 spatial/human-shadow FRQ also all-1pt."
Note these three numbers sum to 54, not 69 — already an internal inconsistency in the original report
relative to its own stated 69-item total. Using the item's `hand_drawn` flag as the text/spatial split
and "every criterion has `points_possible=1`" as the "all-1pt" test, I get 13 / **36** / 20 (summing
correctly to 69). Using "exactly one `frq_criteria` row" as a stricter definition of "flat, unsegmented
rubric" instead gives 8, not 21, for the non-hand-drawn all-1pt group. `prompt_json->>'practice_format'`
is null for every item in this set, so I could not find the exact sub-classification Codex's 21 used.
**The core finding — that a real fraction of Statistics FRQ still carry TASK-0022's flat-1pt rubric
defect — is not in question; only the precise breakdown number needs a follow-up with the exact
methodology Codex used.** This is a P2 (documentation-precision) item, not a P0/P1 correctness issue.

**Session-history claims** (49 sessions/2 users on the old pack, 51 sessions/2 users on the new pilot
pack, with 0 assigned items for all 51 new-pack sessions) were not independently re-verified in this
pass — they require joining `learning_sessions`/`session_target_items` history, which is lower-risk to
get wrong than the structural findings above and was deprioritized given time. Flagging as unverified,
not confirmed.

## AP Physics 1 — verdict: Codex's findings are correct, in unusual detail

**Exam-pack version singularity: confirmed.** Exactly one `ap-physics-1` exam-pack version
(`29c719dc-701b-470f-9e49-fab981722d3f`), published, not retired, 124 published content items — no
routing hazard, matching Codex's report.

**The published-item vs. current-published-version distinction: confirmed exactly, including the
specific content_keys.** 124 items are `content_items.status='published'`, but only 117 have a current
version that is *also* `status='published'`; the other 7 FRQ have a `retired` latest version. I
independently re-derived the same 7 content_keys Codex listed: `apphy1-frq-002`, `-003`, `-004`,
`-009`, `-013`, `-028`, `-034`. This is an exact match down to the individual item level, not just an
aggregate count — strong evidence Codex actually queried Production rather than estimating.

**Content readiness numbers, re-verified against the 117 current-published items, all match exactly:**
54 FRQ / 63 MCQ; 15/54 FRQ have `canonical_answer_1`; 0/54 have `canonical_answer_spans`; 0/117 have
`content_item_difficulty`; 7/117 have a validated serving label; 34/117 have no current serving label
at all (83/117 have at least one).

**Live serving RPC counts, re-called directly, match exactly:** `select_practice_frqs(..., 'targeted_drill',
999)` returns 50 (the hard-capped value); `select_practice_frqs(..., 'full_exam_frq', 999)` returns 3.
I also confirmed the hard cap Codex described (`limit greatest(1, least(coalesce(_limit, 20), 50))`) is
a real, existing pattern in this codebase's serving-selector migrations, consistent with a 50-row
ceiling regardless of the true eligible pool size — though I did not independently re-derive the
specific "51 uncapped eligible rows" figure, since the RPC itself always returns the capped value and
confirming the true uncapped pool needs a different query than the one used for the readiness doc's
headline number.

**Grading-path reachability:** same `qa_path_ap_biology_only` gate as Statistics, confirmed the same
way (via the deployed function source, not by re-running the calls).

## A methodology note that applies beyond just QA'ing Codex

Both re-verifications above required filtering on `content_item_versions.status = 'published'` for the
*current* version, not just `content_items.status = 'published'` at the item level — exactly the
distinction `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`'s criterion 1 already specifies but that is
easy to under-apply in a quick query. Checking this exposed that **my own earlier canonical-answer
closure work this week** (Chemistry, Physics 2, Physics C: Mechanics, Physics C: E&M — not Calc AB,
which has zero affected FRQ) used the looser, item-level-only filter when reporting "FRQ total" counts
(e.g., "37/37" for Physics 2). Re-checked directly: Chemistry has 2 FRQ, Physics 2 has 9, Physics C:
Mechanics has 6, and Physics C: E&M has 6 FRQ whose *latest version* is `retired` even though the
content item itself is `published`. None of these 23 items were among the ones I authored canonicals
for this week (verified: zero overlap with my 121-item list), and all 23 already had a pre-existing
canonical answer from before this week, so **no real gap was missed and no authoring effort was
wasted** — but the denominators I reported (37, 42, 55, 53) were inflated by these retired-version
items and should be read as 28, 36, 49, 51 under the strict, correct definition. Recommend correcting
`docs/product/SUBJECT_SERVABILITY_CRITERIA.md`'s tracking table to note this distinction explicitly for
these four subjects, the same way Physics 1's own readiness doc already does for itself.

## Summary

| Subject | P0 findings confirmed | Content-readiness numbers confirmed | Grading-gate confirmed | Open items |
| --- | --- | --- | --- | --- |
| AP Statistics | Yes — dual published exam-pack versions | Yes, all match exactly | Yes (via source) | TASK-0022's exact 13/21/20 breakdown not reproduced (P2); session-history claims not re-verified |
| AP Physics 1 | N/A (single exam-pack version, correctly) | Yes, all match exactly, including individual content_keys | Yes (via source) | "51 uncapped pool" figure not independently re-derived (low-risk) |

Codex's work on both subjects held up well under independent re-verification — every structural and
numeric claim I checked was accurate, and the one discrepancy found (TASK-0022's sub-breakdown) is a
documentation-precision issue, not a wrong diagnosis. The more consequential finding from this pass is
the one about my own prior work's denominators, corrected above.
