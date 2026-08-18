# Deterministic Statistics Key Audit — 2026-08-11

**Task:** replan item 1.1 (`GRADING_ENGINE_REPLAN_EXECUTION_PLAN_2026_08_10.md`)
**Scope:** every `STATISTICS_TARGETS` entry in
`supabase/functions/_shared/statistics-verifier.ts` (23 entries: 19 keyed, 4 null).
**Harness:** `scripts/grading-model-assessment/verify_deterministic_keys.ts` +
`verify_deterministic_keys_test.ts` (6 standing tests, wired into `deno test`).
**Status:** audit complete. One entry failed (`APSTATS-SFRQ-008`); corrected
values are applied in the repo working tree **pending O1 approval — nothing is
deployed**.

## Method

1. **Answer-level check (items with repo gold coverage, SFRQ-001..010).** For
   each gold-set answer in `scripts/content-seed/gold-set/stage1_answers.jsonl`
   (SFRQ-001..006, 48 answers) and `apstats_multipoint_answers.jsonl`
   (SFRQ-007..010, 32 answers), the harness runs
   `checkStatisticsDeterministicEvidence` on `answer_text` and compares the
   verdict with the answer's generation script: expected `pass` iff the script
   marks every keyed numeric element present. The keyed-value → criterion
   mapping (`NUMERIC_ELEMENT_CRITERIA`) was read off each item's element
   decomposition in `stage1_fixture.json` / `apstats_multipoint_fixture.json`.
2. **Canonical check (all keyed entries).** `canonical_answer_1`,
   `content_hash`, and version `status` were fetched read-only from Production
   (`app.content_item_versions` joined to `app.content_items`, project
   `pcntajvbdfqhbeewmdry`, 2026-08-11). Every keyed value was then
   **re-derived from the published stem/stimulus givens** (Phase B
   `validate_keys.py` pattern — derive, never transcribe) and compared to both
   the key and the canonical text.

Failure directions are asymmetric and treated so:

- **False flag** (evidence present, checker flags) — learner-harming: the
  deterministic gate zeroes the response with `points_earned: 0` /
  `action_hint: show_scaffold` and the model never sees it
  (`buildStatisticsDeterministicFallback`). Standing test: **zero tolerated**.
- **False pass** (keyed element absent, checker passes) — lenient: the
  response proceeds to the LLM grader. Tracked against an exact allowlist
  (`KNOWN_FALSE_PASSES`, 8 entries) so new drift still fails the suite.

## Audit table

Verdict codes: **VALIDATED** (derivation + canonical + gold all agree),
**VALIDATED-CANONICAL-ONLY** (derivation + canonical agree; no gold answers
exist in the repo), **FAILED** (keyed values wrong), **NULL** (entry declared
conceptual; checker must abstain).

| Entry | Verdict | Keyed values | Evidence | Corrected values | Provenance |
| --- | --- | --- | --- | --- | --- |
| APSTATS-SFRQ-008 | **FAILED → corrected** | ~~[1.8, 4.9]~~ | Payoff table (10,.10),(2,.20),(−4,.70) ⇒ E(X) = −1.40, SD = √20.04 = 4.4766. All 8 gold answers agree; the 4 evidence-present answers (A1,A2,A3,A6) were all false-flagged pre-fix (specificity 0/4), post-fix 4/4 + 4/4 | **[−1.40, 4.477]** | Old values match the item's **retired v1** canonical (version `d640d4b6…`, hash `863d9416…` — "expected value as 1.8 dollars… about 4.9"); published **v3** canonical (hash `975e2fdf9139370feef4597f46c61d73`) states −1.40 / ≈4.48. Root cause: transcribed from a superseded canonical, never re-derived. |
| APSTATS-SFRQ-001 | VALIDATED | [22, 23.7] | derived: median 22, mean 213/9 = 23.67; gold 6/6 pass, 2/2 flag | — | canonical v1 published, hash `99ffea1d…e07a692` |
| APSTATS-SFRQ-002 | VALIDATED | [1.5, 2.5] | derived: (86−74)/8, (62−52)/4; gold 4/4 pass, 2/4 flag (2 false passes, both script-contested discards) | — | canonical v2 published, hash `50eef52c04477af06c5ae08b0fc8ce6f` |
| APSTATS-SFRQ-003 | VALIDATED | [76.6, −2.6 s.s.] | derived: 52+4.1(6), 74−76.6; gold 4/4 pass, 3/4 flag (A8 script-contested discard) | — | canonical v2 published, hash `917d06ff15ac79f4d45adf603c6563a8` (v1 retired — the pilot's 409) |
| APSTATS-SFRQ-004 | VALIDATED | [5.25, −0.25 s.s.] | derived: 9.8−0.65(7), 5.0−5.25; gold 4/4 pass, 2/4 flag (A4 script-contested; A5 ECF-mention) | — | canonical v2 published, hash `fd47d4f34df01375863cc06d5024cc8b` |
| APSTATS-SFRQ-007 | VALIDATED | [5, 1.94, 0.202] | derived: 20(.25), √3.75 = 1.9365, C(20,5)(.25)⁵(.75)¹⁵ = 0.2023; gold 2/2 pass, 4/6 flag (A5/A7 given-value collision on "5") | — | canonical v2 published, hash `3ba3324d7c28269173ba04f14bcddeef` |
| APSTATS-SFRQ-009 | VALIDATED | [0.28, 0.0225] | derived: p, √(.28·.72/400) = 0.02245; gold 4/4 pass, 3/4 flag (A4 given-value collision — 0.28 **is** the given p) | — | canonical v2 published, hash `e46c5e174443493771ff23baeaa42fa0` |
| APSTATS-SFRQ-010 | VALIDATED | [7.2, 0.3] | derived: μ, 1.8/√36; gold 4/4 + 4/4 — cleanest entry | — | canonical v2 published, hash `63f49475c8786d6d4635c7f071a6555b` |
| APSTAT-MOD3-H001-INV | VALIDATED-CANONICAL-ONLY, method note | [21.9089, 807.05863, 892.94137, 2.28217] | derived: SE = 120/√30 = 21.9089 ✓; t = 50/SE = 2.28217 ✓; CI bounds assume **z\* = 1.96** where the AP-expected t-interval (t\*₂₉ = 2.045) gives (805.19, 894.81) — correct t-bounds still fall inside the 2% tolerance, so no live false flag | — (flag for O1: consider re-keying bounds to the t-interval) | `canonical_answer_1` **null** on all versions; v2 published, hash `9142c9c1b830a08cc330a15a45d68f81`. No gold coverage. |
| APSTAT-MOD6-H001 | VALIDATED-CANONICAL-ONLY | [1.94079, 2.06104] | derived: √(64/30+49/30), 4/1.94079 | — | `canonical_answer_1` null; v1 published. No gold coverage. |
| APSTAT-MOD7-H001 | VALIDATED but item dead | [0.023, 0.65217] | derived: .3(.02)+.5(.03)+.2(.01); .015/.023 | — | only version `reviewed_disapproved` — key cannot fire until republished |
| APSTATS-SFRQ-011 | VALIDATED-CANONICAL-ONLY | [0.70, 0.618, 0.782] | derived: 84/120; ±1.96√(.7·.3/120) | — | canonical v2 published, hash `4b7e82bf0246c544fd5e2d89bec18c98` |
| APSTATS-SFRQ-012 | VALIDATED-CANONICAL-ONLY | [2.40, 0.008] | derived: (0.62−0.50)/0.05; P(Z>2.40) = 0.0082 | — | canonical v2 published, hash `b87b0955f3227162203ba16f4740c348` |
| APSTATS-SFRQ-013 | VALIDATED-CANONICAL-ONLY | [2.00, 69.7, 78.3] | derived: 4/(8/4); 74±2.131(2) = (69.74, 78.26) | — | canonical v2 published, hash `ee083bca99b24c50a19b1b2f66676565` |
| APSTATS-SFRQ-014 | VALIDATED-CANONICAL-ONLY | [7.00] | derived: 4.2/(3.0/5) | — | canonical v2 published, hash `9508393411f53bb4a50c218fbacb01c0` |
| APSTATS-SFRQ-015 | VALIDATED but item dead | [25, 3.12] | derived: 100/4; (49+4+0+25)/25 | — | only version `reviewed_disapproved` |
| APSTATS-SFRQ-016 | VALIDATED-CANONICAL-ONLY | [15, 2.40] | derived: 30·30/60; 4·(9/15) | — | canonical v2 published, hash `c841b2a88e6a383515d19015a246f53f` |
| APSTATS-SFRQ-017 | VALIDATED but item dead + weak key | [4.73, 5.2] | derived: 5.2/1.1 = 4.727; slope 5.2 is itself a stimulus given (given-value collision class) | — | only version `reviewed_disapproved` |
| APSTATS-SFRQ-018 | VALIDATED but item dead | [−3.65 s.s., −1.15 s.s.] | derived: −2.4±2.086(0.6) | — | only version `retired` |
| APSTAT-MOD5-H001-INV | NULL | — | abstains by construction | — | no gold answers |
| APSTAT-MOD8-H001 | NULL | — | abstains by construction; only version status `assigned` (not published) | — | no gold answers |
| APSTATS-SFRQ-005 | NULL | — | abstains on all 8 gold answers ✓ | — | conceptual item (sampling-method critique) |
| APSTATS-SFRQ-006 | NULL | — | abstains on all 8 gold answers ✓ | — | conceptual item (experiment design); only version `retired` |

("s.s." = `sign_sensitive: true` in the key.)

## The SFRQ-008 failure, in full

- **Mechanism:** `STATISTICS_TARGETS["APSTATS-SFRQ-008"]` carried `[1.8, 4.9]`
  — the exact values in the item's **retired v1** `canonical_answer_1`. The
  item was corrected at v2 (2026-07 era; v3 now published) to the payoff table
  (10, 0.10), (2, 0.20), (−4, 0.70) ⇒ E(X) = −1.40, SD ≈ 4.48, but the key was
  never updated. This is the hardcoded-map failure class the replan's Engine 3
  decision #3 names: constants with no linkage to the content they key.
- **Production impact:** every response containing the *correct* values was
  deterministically flagged; `buildStatisticsDeterministicFallback` returns
  `status: "uncertain"`, `points_earned: 0`, all criteria
  `unable_to_determine`, and the model is never called. In the 2026-08-10
  exemplar-pilot capture, all 8×2×5 = 80 SFRQ-008 calls short-circuited this
  way in **both** arms; two of the 8 gold responses carry human `earned`
  labels on the compute criteria (`gold_cases_internal.json`, SFRQ-008
  criteria a-1/a-2).
- **Correction (applied in-repo, pending O1):** `[−1.40, 4.477]`, derived
  (not transcribed): E = 0.10(10)+0.20(2)+0.70(−4) = −1.40; Var =
  0.10(11.4)²+0.20(3.4)²+0.70(2.6)² = 20.04; SD = √20.04 = 4.4766. The 2%
  relative tolerance accepts the canonical's "about 4.48" and a student's
  "4.5".
- **Sign policy:** `sign_sensitive` is deliberately **not** set on −1.40.
  Matching is on |value|, so "loses $1.40" (sign carried lexically — how
  gold answers A1/A3/A5/A7 phrase it alongside the numeral) passes. Setting
  `sign_sensitive: true` would false-flag the lexical form — the exact harm
  direction this fix closes. Cost: a response claiming "+1.40 expected gain"
  passes the gate, but it then proceeds to the LLM grader, whose rubric
  (criterion b: "long-run average net gain is −1.40 dollars") owns the sign
  judgment. Recorded for O1 to confirm.

## False passes (8, all documented in `KNOWN_FALSE_PASSES`)

Two mechanisms, both inherent to substring number-matching:

1. **Script-contested answers (4):** SFRQ-002 A4/A8, SFRQ-003 A8, SFRQ-004 A4
   — the writer's script planned an omission but the produced text computes
   the values anyway; the verifier families disagreed with the script (routes
   `discard`/`reader_queue`). The checker is arguably *correct* on these.
2. **Genuine detector limits (4):** SFRQ-004 A5 (ECF-style mention of 5.25
   inside a wrong computation), SFRQ-007 A5/A7 (keyed mean 5 collides with
   the "5" in "P(X = 5)"), SFRQ-009 A4 (keyed mean 0.28 **equals the given
   p**). Lesson for future key authoring: avoid keying values that appear
   verbatim in the stimulus (SFRQ-017's slope 5.2 has the same defect).

All false passes are in the lenient direction (response still reaches the LLM
grader); none is learner-harming.

## Standing coverage

`verify_deterministic_keys_test.ts` (in `deno test`, alongside the existing
suite — 134 tests total green as of this audit):

1. zero false flags anywhere (production-harm invariant);
2. false passes equal the allowlist exactly (drift detection);
3. null entries abstain on every gold answer;
4. SFRQ-008 regression pin (8/8 verdicts);
5. keyed entries without gold coverage must be on the explicit
   needs-canonical-fetch list (new keys can't ship evidence-free silently);
6. every gold-covered keyed entry has a `NUMERIC_ELEMENT_CRITERIA` mapping.

## Caveats

- Gold coverage exists only for SFRQ-001..010 (80 answers, one subject, AI
  writer families + script sigs; SFRQ-001..006 corpus is the Set B stage-1
  batch, SFRQ-007..010 the multipoint batch). SFRQ-011..018 and the MOD items
  are canonical-derivation-only: the arithmetic is verified, but no
  answer-level sensitivity/specificity evidence exists for them.
- Four keyed entries point at items with no published version (MOD7, SFRQ-015,
  SFRQ-017 `reviewed_disapproved`; SFRQ-018 `retired`) — dead weight, not
  hazards; noted per-entry in the verifier file.
- The mapping in `NUMERIC_ELEMENT_CRITERIA` is itself an audit input (hand-read
  from the fixtures); it is exercised by the tests but should be reviewed with
  O1.
