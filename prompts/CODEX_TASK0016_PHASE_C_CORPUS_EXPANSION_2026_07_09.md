# Codex Execution Prompt — TASK-0016 Phase C: AP Statistics Launch-Bar Corpus Expansion

**Status:** cleared to execute as a **content-authoring pass**, not a code
change. This produces AI-provisional calibration materials only — it does
**not** perform the human blind-scoring adjudication itself (that is separate
human labor: two Grading Validators + a Lead adjudicator, per
`CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.1), and it does **not** touch
production code, migrations, or learner-facing scoring.

## Read first (do not skip)

1. `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md` — the launch bar: grade a
   corpus of **100 MCQ + 100 FRQ + 10 Investigative-Task items** at **≥95%**
   criterion-level agreement with adjudicated labels, within cost/latency
   ceilings. Phase C ("gold sets") is the launch gate this work unblocks.
2. `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §12 — the
   `calibration` → `adjudicated_gold` tiering rules and the blind dual-score
   procedure your output package must support.
3. `docs/research/grading_cross_subject_takeaways.md` — binding lessons,
   especially Lesson 1 (boundary contracts are the dominant quality lever) and
   Lesson 8 (corpus defects — isolate, don't silently grade around them).
4. **The existing gold-set-candidate package — replicate this exact shape at
   full scale, do not invent a new schema:**
   `docs/research/ap_statistics_gold_set_candidate_2026_07_08/` (`README.md`,
   `manifest.json`, `provisional_labels.json`, `blind_scoring_template.csv`,
   `adjudication_queue.csv`, `adjudication_workflow.md`). This is a 5-item/
   20-response slice; your job is the same artifact shape at ~100-item scale.
5. `docs/research/AP_STATISTICS_MOD3_MOD6_BOUNDARY_CONTRACTS_2026_07_09.md` —
   **binding, do not re-litigate.** Three boundary-contract decisions were
   resolved and approved 2026-07-09: (a) MOD3-style z*-vs-t* critical-value
   choice — both accepted when within the deterministic checker's 2% relative
   tolerance (no per-item override needed unless `df` is small, roughly < 15,
   where z*/t* diverge beyond tolerance — flag those explicitly rather than
   guessing); (b) two-sample-t sign convention — grade magnitude only when the
   alternative hypothesis is non-directional, sign is never a criterion on its
   own; (c) items with a missing/fabricated dataset (the MOD8 pattern) — scope
   the affected criteria to method/self-consistency grading (does the response
   apply its own formula correctly to its own asserted numbers?) rather than
   fixed-value matching, and flag the item as a corpus defect rather than
   silently keying a fabricated "canonical" value. Apply these same rules to
   every new item that hits the same shape — do not re-derive them per item.
6. `docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json` — **100
   FRQ items with 220 synthetic responses already authored and do not need to
   be regenerated** (10 long/investigative-task + 50 short + 40 short-expansion,
   module-balanced across modules 1–9). This is your primary FRQ source corpus
   — but read item 9 below before assuming it's the *only* one.
7. `docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json` +
   `validate_keys.py` + `docs/research/AP_STATISTICS_VERIFICATION_PROFILE.json`
   — the deterministic key/ECF schema, currently authored for only 5 items.
   `validate_keys.py` is the integrity+ECF regression gate; extend its battery,
   don't bypass it.
8. `supabase/functions/_shared/grading-router.ts` — confirm the `mcq` /
   `rule_based_mcq` dispatch contract (exact-match deterministic path) so your
   MCQ answer-key format is consumable without a schema mismatch.
9. **Existing AP Statistics MCQ/FRQ banks — inventory AND QA these before
   authoring anything new (see C0a/C0b below), do not start from a blank page
   and do not assume "existing" means "correct":**
   - `docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/` — **18
     MCQ items already live in Production** (`content_item_versions`,
     `status='published'`, 2 per module across all 9 modules), plus a sibling
     18-item short-FRQ batch in the same directory. Real, vetted, reusable
     as-is — do not re-author these.
   - `docs/research/apstats_packet_bundle_2026_07_07/frq_only_pool.json` — a
     **separate 40-item non-HDR FRQ pool** (10 sourced from
     `benchmark_corpus_2026_07_06` / PR #30, 30 newly authored), different
     content_key namespace (`APSTATS-FRQ-0xx`) from the bootstrap corpus
     (`APSTAT-MODx-Hxxx` / `APSTATS-SFRQ-xxx`). No synthetic response corpus
     attached — item+rubric+canonical-answer only. Check for overlap/redundancy
     with the bootstrap corpus and pull in any high-value unique items rather
     than ignoring this pool. (Its sibling `hdr_frq_pool.json` is hand-drawn —
     out of scope, per §"Out of scope" below.)
   - `docs/research/ap_chemistry_mcq_grading_experiment_batch_2026_07_07.jsonl`
     (+ its README) — a **100-item MCQ bank for a different subject.** Not
     reusable as content, but is the closest same-shape precedent for an
     MCQ grading-experiment batch at the size you're building — use it as a
     schema/format template if useful.
   - **Do not confuse any of the above with `DECISION-0031`'s approved
     71-MCQ/33-FRQ real curriculum pilot batch** (`docs/product/AP_STATISTICS_
     PHASE4_CONTENT_AUTHORING_BRIEF.md`) — that is Orly's separate,
     still-unstarted, human-authored curriculum content for the live product,
     not a calibration corpus. Your output here is AI-provisional calibration
     material (acceptable under `DECISION-0034` Option B, same footing as the
     bootstrap corpus); it does not substitute for that pilot batch and should
     not be reported as progress against it.
   - Also check `app.content_item_versions` directly for anything published
     beyond the 18+18 smoke batch before concluding what's missing.

### C0a — Inventory reconciliation (do this first, before authoring anything)

Produce a short table: every existing AP Statistics MCQ/FRQ source above, its
item count, whether it has synthetic responses attached, and whether you're
(a) reusing it as-is, (b) folding a subset into the new package, or (c) setting
it aside with a stated reason. Only after this table exists should you decide
how many *net-new* MCQ/FRQ items C1/C2 actually require to reach the launch bar
— it should be well under 100 MCQ from scratch given the 18 already live.

### C0b — QA the existing inventory before reusing it (do not skip)

"Already exists" and "already correct" are not the same claim. Reused items
carry the same risk the MOD3/MOD6/MOD8 review found in the 5-item slice
(§5 above) — that slice was only caught *because* a human happened to review
it; the other ~95 bootstrap-corpus items and the 40-item packet-bundle pool
have never had an equivalent pass. Before folding anything from C0a into the
new package as "reuse as-is," run it through the same scrutiny this session
applied:

1. **The 18 live MCQs:** re-derive the correct answer for each from the stem
   and choices independently (don't trust the stored `is_correct` flag), and
   confirm exactly one choice is marked correct. The batch's own README notes
   two computational errors were found and fixed pre-publish — that means the
   authoring process has a known error rate, not that it's since been proven
   clean; a first QA pass finding errors doesn't guarantee a second pass would
   find none. Flag anything you'd change rather than silently re-verifying and
   moving on.
2. **The 18 sibling short FRQs** (same directory): spot-check rubric criteria
   for the same failure classes found this session — ambiguous critical-value
   choices, sign-conventional numeric answers, or fabricated/missing-dataset
   values presented as canonical.
3. **The 100-item bootstrap corpus (beyond the 5 already reviewed):** you will
   not hand-adjudicate all 95 remaining items' labels (that's C2/the human
   blind-scoring pass), but do scan every item's rubric + canonical answer for
   the three known failure shapes: (a) a keyed critical value that assumes z*
   or t* without checking whether the other is also defensible for that item's
   `df`; (b) a test-statistic or difference-of-means criterion whose canonical
   answer bakes in a sign or subtraction order the rubric doesn't actually
   require; (c) an item whose "canonical" numeric answer is asserted without a
   backing dataset (the MOD8 shape) rather than genuinely computed. Log every
   hit as a finding, not a silent fix — these need the same Learning
   Quality/Product Owner sign-off the MOD3/MOD6/MOD8 resolutions got, not a
   unilateral correction folded invisibly into the new package.
4. **The 40-item packet-bundle pool:** same three-failure-shape scan, plus
   confirm the 10 items sourced from `benchmark_corpus_2026_07_06` actually
   match what's in that PR (no silent drift between the branch and this copy).
5. Output a QA findings list (file:content_key:criterion, the suspected issue,
   confidence) separate from the reconciliation table — this is what lets
   Learning Quality spot-check the highest-risk items instead of re-reviewing
   everything blind, same pattern as the boundary-contract doc from this
   session.

## Goal

Produce the calibration-tier candidate materials needed to run the Phase C
launch-bar calibration, at the full corpus size, in the same package shape as
the existing 5-item slice. Three deliverables:

1. **C1 — Assemble a 100-item AP Statistics MCQ bank**, starting from the 18
   already live in Production and authoring only the delta.
2. **C2 — Expand the FRQ candidate package** from 5 items/20 responses to the
   full ~100-item FRQ corpus (content already exists across the bootstrap
   corpus and the packet-bundle pool — extend the *labeling* package, not the
   item corpus, per C0's reconciliation).
3. **C3 — Extend the deterministic verification keys** from 5 keyed items to
   every FRQ item carrying a checkable numeric/formula criterion.

Explicitly **out of scope**, do not attempt:

- The actual human blind dual-scoring / Lead adjudication pass — that is
  separate labor by Grading Validators, not something you generate.
- Any hand-drawn, image, or QR-capture content (Phase B/D — a different track).
- Engine 2 (Holistic) or Engine 4 (spatial) build.
- Applying any DB migration or touching production code/config.
- Re-opening the three resolved boundary-contract questions above.

## Scope

### C1 — MCQ bank (100 items, starting from 18)

1. Start from the 18 MCQ items already published in Production
   (`ap_statistics_phase4_mcq_smoke_batch_2026_07_01/ap_statistics_mcq_smoke_batch.json`,
   2 per module across all 9 modules) — reuse as-is, do not re-author them.
   Confirm via `content_item_versions` that nothing else is published beyond
   these 18 + the sibling 18 short FRQs.
2. Author the remaining ~82 MCQ items spanning modules 1–9, difficulty-balanced
   (mirror the FRQ corpus's `module_distribution_actual` spread as a starting
   proportion, adjust for MCQ-appropriate topics — MCQ favors discrete
   concept-checks over multi-part investigative reasoning), maintaining the
   same per-module ratio the existing 18 already established rather than
   skewing the combined 100 toward whichever modules are easiest to write.
3. Each new item: question stem, 4–5 answer choices, one correct answer key,
   and a short distractor rationale per wrong choice (why a student would
   plausibly pick it — this is feedback material, not filler), in the same
   shape as the existing 18 (`content_key`, `modules`, `subtopics`,
   `intended_difficulty`, `stimulus`, `stem`, `choices[].choice_key/choice_text/
   is_correct`). No hand-drawn/graph/image stems. `ap_chemistry_mcq_grading_
   experiment_batch_2026_07_07.jsonl` is a same-shape precedent from a
   different subject if you want a second reference point on format.
4. Output format: match whatever schema `grading-router.ts`'s `mcq` /
   `rule_based_mcq` path actually consumes (read the code, do not guess) —
   state the schema you used and why if it required interpretation, and note
   any divergence from the existing 18's schema.
5. Since MCQ grading is exact-match deterministic (not LLM judgment), the
   "adjudication" burden here is answer-key correctness, not criterion
   boundary-drawing — produce a spot-check note (e.g. sample size and method)
   confirming keys were verified against the correct choice, not authored and
   trusted blind. This applies to the 82 new items; the 18 existing ones were
   already QA'd before publish (two computational errors were found and fixed
   at the time — see that batch's own README) and don't need re-verification.

### C2 — FRQ candidate package expansion (5 → ~100 items)

1. Using `ap_statistics_frq_bootstrap_corpus_2026_07_07.json` as the primary
   source (already has 220 synthetic responses — do not regenerate response
   text), produce a full-corpus `provisional_labels.json` in the **exact
   schema** of the existing 5-item file: per-item rubric, per-response
   criterion-level `provisional_label` / `confidence` / `adjudicate` / `note`.
   Per C0, cross-check `apstats_packet_bundle_2026_07_07/frq_only_pool.json`
   (40 items, different content_key namespace, no response corpus attached) for
   any item worth swapping in or supplementing with — it draws 10 items from a
   real PR'd benchmark corpus, which may be higher-value than a synthetic
   equivalent covering the same module/skill. If you pull any of its items in,
   you'll need to author synthetic responses for them to match the bootstrap
   corpus's coverage (fully_correct / borderline / partially_correct /
   subtly_wrong), since that pool doesn't ship with responses.
2. Apply the resolved boundary-contract rules (§5 above) consistently — e.g.
   any new item with a z*-vs-t* choice, a sign-conventional test statistic, or
   a missing-dataset defect gets the same treatment already approved, not a
   fresh judgment call.
3. Build the corresponding `blind_scoring_template.csv` (one row per
   content_key/response_index/criterion_key, empty validator columns — this is
   the human-scoring input, not something you fill in) and `adjudication_queue`
   entries for genuinely ambiguous criterion labels (mirror the existing
   package's bar for what earns a queue entry: boundary questions, terse-but-
   complete calibration probes, deterministic-check targets — not routine
   clear-cut labels).
4. Update `manifest.json` fields (`items`, `responses`, `criterion_judgments`,
   `composition`, `label_distribution`, `adjudication_queue_size`,
   `deterministic_check_targets`) to the new full-corpus counts.
5. Write a `README.md` in the same voice as the existing one: run metadata,
   composition, the highest-value deterministic-check findings, the
   adjudication queue's highest-value flags, any new corpus defects (flag
   explicitly, do not silently grade around them), and the upgrade-to-
   `adjudicated_gold` procedure.
6. Given the corpus size (100 items, ~220 responses, likely 400–700+ criterion
   judgments), do an internal completeness/consistency pass before calling this
   done — spot-check a sample of your own labels against the rubric text for
   drift (e.g. the same criterion type getting inconsistent treatment across
   items), not just schema conformance.

### C3 — Deterministic verification key expansion

1. Extend `statistics_item_keys.json` from the 5 currently-keyed items to every
   FRQ item in the corpus with a checkable numeric or formula criterion (numeric
   answer, algebraic-equivalence formula, or ECF chain) — conceptual-only
   criteria stay `ABSTAIN` as today.
2. Apply the resolved sign-sensitivity rule: only mark `sign_sensitive: true`
   when the sign carries real information the rubric grades (e.g. a residual's
   over/under-prediction direction), never for an arbitrary subtraction-order
   artifact in a non-directional test.
3. Apply the resolved tolerance rule: rely on the existing relative-tolerance
   band for z*-vs-t*-class equivalences; only add a per-item override if the
   divergence would fall outside tolerance (small `df`), and say so explicitly
   when you do.
4. Apply the resolved corpus-defect rule: any item missing real data (the MOD8
   pattern) gets its value-specific criteria scoped to `symbolic_only`/
   self-consistency or `ABSTAIN`, flagged in `corpus_defect`, never keyed
   against a fabricated canonical value.
5. Extend `AP_STATISTICS_VERIFICATION_PROFILE.json`'s `key_payload` counts
   (`items_keyed`, `conceptual_only`, `excluded_corpus_defect`) to match.
6. Extend `validate_keys.py`'s battery to cover every newly-keyed item and
   confirm it still passes canonical-integrity + ECF checks (report the new
   N/N pass count — do not lower the bar or skip failing items silently; if an
   item's declared/recomputed values don't reconcile, that is a real defect to
   flag, not a validator bug to route around).

## Required Evidence on Completion

- The C0a inventory-reconciliation table, so it's visible what was reused vs.
  newly authored vs. set aside, and why.
- The C0b QA findings list on the existing inventory (the 18 live MCQs, their
  18 sibling FRQs, the bootstrap corpus beyond the 5 already reviewed, and the
  packet-bundle pool) — issues found, confidence, and explicitly flagged for
  Learning Quality/Product Owner sign-off rather than silently fixed.
- MCQ bank: 100 items, module/difficulty distribution table, answer-key
  spot-check note, and the exact schema consumed (with file:line reference into
  `grading-router.ts` confirming compatibility).
- FRQ package: full `provisional_labels.json` + `blind_scoring_template.csv` +
  `adjudication_queue.csv` + updated `manifest.json` + `README.md`, with
  item/response/criterion counts stated and matching across all four files.
- Verification keys: updated `statistics_item_keys.json` +
  `AP_STATISTICS_VERIFICATION_PROFILE.json`, and `validate_keys.py`'s new
  pass/total count (must be 100% — no XX rows in the output).
- A short note listing every item where a boundary-contract rule from §5 was
  applied to a new case, so Learning Quality can spot-check the highest-risk
  extrapolations rather than re-reviewing all ~100 items blind.

## Do Not Touch

- Any hand-drawn/image/QR-capture content or pipeline.
- Production code, migrations, secrets, or deployment config.
- The three resolved boundary-contract decisions themselves (extend their
  application, do not reopen the decisions).
- The actual human blind-scoring columns in `blind_scoring_template.csv` (leave
  empty — that's the Grading Validators' input, not yours).

## Next Expected Output

A PR against `main`, branch-prefixed `codex/...`, referencing `TASK-0016`
Phase C, ready for the repo's standard independent QA pattern (fresh-context
review, claims verified from source, Pass/Fail with file:line findings — no
self-certification). This PR unblocks the human blind-scoring pass, which
remains a separate step after this lands.
