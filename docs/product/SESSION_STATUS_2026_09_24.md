# Session Status — 2026-09-24

Handoff record. Everything below was measured against Production, not read from plans.

---

## In flight right now

**Codex is working on `prompts/CODEX_WORK_ORDER_FF1_MCQ_SERVING_2026_09_24.md` (FF-1).**
Design proposal first, then implementation; no Production writes. It is the only open item that
changes what a Biology student can be served.

**Not yet dispatched:** `prompts/CODEX_WORK_ORDER_QUEUE_2026_09_24.md` — J.0 → N → N.1, gated. All
three are fast-follow; none changes launch-day content.

---

## Applied to Production today

| | What | Result |
| --- | --- | --- |
| **M0** | `app.canonical_answer_spans` | Created empty. RLS proven against all three roles |
| **M4** | Remove `prompt_json.total_points` | 16 Biology items; key total 516 → 500 |
| **M3** | `app.content_item_difficulty` | Created empty. Data load waits on J.0 |
| **M2** | Biology coverage/topic labels | 112 `provisional_model` + 6 `held` |
| **M1** | Canonical answers + segmentation | 67 items, 548 spans, 4 held |
| **M2.1** | Restore + anchor coverage labels | Repair of M2's ordering error |
| **M2.2** | Re-anchor 22 serving labels | Repair of M1/M4 fallout |
| **M2.3** | Re-anchor 15 MCQ serving labels | After QA: 15 accept, 4 reject, 1 flag |
| **—** | `app.servable_items_census()` + self-test | 93 ok, 0 mismatch on first run |

Decisions logged: **DECISION-0062** (coverage labels land `provisional_model`), **DECISION-0063**
(Biology launches on the practice path).

---

## Where Biology actually stands

Launch is on the **practice path** (`select_practice_frqs`), which reads no taxonomy label and no
difficulty value.

- **71 `targeted_drill` FRQ servable.** 70 carry a canonical, 67 carry segmentation.
- **`full_exam_frq`: 0 items.** No session has ever used that format (117 sessions, all time).
- **43 MCQ: not reachable through the serving contract** — but see FF-1 below.
- Unit-gated path: **0 Biology items**, and **8 across all ten subjects**. Effectively dark.

---

## Four things I got wrong today, and corrected

Recorded because each one was corrected by measurement, and the next session should trust the
measurement rather than my earlier summaries.

1. **"41 then 56 servable items."** Both wrong. I computed them from a predicate I assembled by
   reading the selector — hash match plus non-null `max_required_unit`. No live function uses it. I
   had missed that the unit-gated path also requires `label_status = 'validated'` (Biology has none)
   and that a second serving path exists which ignores taxonomy entirely.
2. **Migration ordering.** I applied M2 (labels) before M1/M4 (content). `taxonomy_relevant_hash`
   covers `canonical_answer_1` and `prompt_json`, so M1 staled 65 of M2's labels and silently
   dropped 28 items out of serving. Content migrations must precede label migrations.
3. **FF-13 "blocks FF-1."** The answer-key exposure was already closed. I relied on a memory note
   from 2026-08-24 rather than checking. All three parts of the fix are live.
4. **M2 omitted `validated_against_taxo_hash`.** The stale trigger compares with `is distinct from`,
   and null differs from every hash, so those labels would have staled on the next content edit
   whatever it was.

---

## Open Product Owner decisions

| | Decision | Blocks |
| --- | --- | --- |
| **S-101 rubric** | Criterion `a-iv` requires evidence from two stem sub-parts, so the item clears the grader gate on 1 of 3 runs. Splitting it takes the item 4 → 5 points | One canonical answer |
| **S-021 / S-023 / S-058** | Work order F drafted over their published canonical rather than assembling it. Held rather than applied | Three segmentations |
| **2 osmosis corrections** | `L-008` and `S-071` mislabelled `1.1`, should be `2.7`. Currently `held`, carrying no topic | Two topic labels |
| **Serving-label promotion** | Nothing reaches `validated`, so the unit-gated path stays dark product-wide | FF-3, and the whole course mode |

---

## The through-line worth carrying forward

Four silent failures were found today, three of them by hand and one only because I built a check:

- 20 MCQ republished in August; every serving label stopped matching. **Undetected for six weeks.**
- M1 dropped 28 more items out of serving. **Undetected for hours, and it was mine.**
- The unit-gated path has never served Biology at all. **Undetected since it was built.**
- An empty item queue returns `status: ok` with no reason (FF-15).

None is a bug in the sense of wrong code. Each is a **design choice to report absence as
normality** — a hash mismatch, a missing status, an empty result all look like "nothing to serve".
`scripts/qa/servable_items_check.py` now measures this, self-verifies against the real RPCs, and
fails on any drop. **It has no trigger yet (FF-12).** Until it runs on a schedule, the next silent
drop gets found the way these four did.

---

## Key documents

- `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` — the live tracker, 15 items
- `docs/product/AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md` — six-condition assessment plus its own correction
- `docs/research/ff2_ff13_verification_2026_09_24/` — FF-2 and FF-13, and the privilege-checking trap
- `docs/research/apbio_mcq_serving_label_qa_2026_09_24/` — MCQ label QA, finding MCQ-QA-001
- `docs/research/biology_m1_regrade_and_blocker_2026_09_24/` — S-101 and the M1 contract mismatch
- `docs/research/servable_items_baseline.json` — per-subject baseline the check diffs against
