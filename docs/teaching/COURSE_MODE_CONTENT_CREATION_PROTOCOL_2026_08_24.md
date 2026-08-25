# Course Mode — Content Creation Protocol (for parallel Codex agents)

STATUS: operating protocol | DATE: 2026-08-24 | AUDIENCE: David (orchestrator) + the coding agents (Codex/LLM) he assigns cells to.

**Purpose.** Define a repeatable, self-contained recipe so that **one coding agent can build one
Course Mode content cell end-to-end, and many agents can run in parallel** without colliding or
shipping broken/unreviewable content. The unit of parallel work is **one skill-cell = one generator
template**. This protocol is the work order each agent follows and the definition of done that gates
its output.

Grounded in the real pipeline (verified 2026-08-24). Companion docs:
`COURSE_MODE_STATS_UNIT1_PILOT_PLAN_2026_08_24.md` (which cells; the pilot set),
`scripts/course_mode_stats_generator/README.md` (the authoritative "add a procedure" walkthrough),
`docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` (§9 independent re-derivation, §4 CED
conformance — cross-cutting QA disciplines).

---

## 0. The one rule that makes this parallelizable

**Cells are independent; the shared catalogs are not.** Each cell's template is its own function and
its own file-local logic, so two agents building two different cells never touch the same item logic.
But every template draws from three **shared, single-source-of-truth modules**:

- `scripts/course_mode_stats_generator/misconceptions.py` — the distractor/misconception catalog.
- `scripts/course_mode_stats_generator/scenarios.py` — the scenario/framing catalog.
- `scripts/course_mode_stats_generator/cells.py` — the F1 skill taxonomy + 131-cell registry (read-only).

**The collision hazard is edits to `misconceptions.py` and `scenarios.py`.** Two agents adding
entries to the same catalog will merge-conflict or, worse, silently pick the same tag name for
different meanings. **Rules to prevent this (mandatory):**

1. **Each agent works on its own branch/worktree**, one cell per branch. Never two agents in one
   working copy.
2. **Additions to the shared catalogs are append-only and cell-namespaced.** New misconception tags
   and new scenario ids must be prefixed with the cell they were introduced for (e.g.
   `u1_sampling_bias__voluntary_response`, scenario id `u1_11__school_survey`). Never rename, delete,
   reorder, or re-tag an existing entry — a later cell may depend on it.
3. **Prefer reuse over addition.** Before adding a tag/scenario, grep the catalog for an existing one
   that fits. The catalogs are the product's canonical error/scenario vocabulary; growth should be
   deliberate.
4. **Catalog additions merge first, in a short serialized step.** When several cells are done in
   parallel, integrate their `misconceptions.py`/`scenarios.py` additions in one reviewed pass
   (append-only makes this near-trivial), then the template files, then run the full harness once
   over everything (§6). This is a human/orchestrator step, not an agent's.

Everything else in a cell is file-local and conflict-free.

---

## 1. Track A vs Track B — which kind of cell is this?

Decide first; it selects the entire recipe.

- **Track A — computational procedure** (the cell's skill is *calculate a value*, CED skill 3.B and
  similar). A parametrized `gen_*` function that produces a numeric key + distractors + deterministic
  checks. Reference: `summary_stats` / `lsrl_predict` in `generator.py`. **Unit 1 Track A cells:**
  1.7×3.B, 1.9×3.B.
- **Track B — authored conceptual slot-frame** (the cell's skill is *identify / describe / interpret
  / justify*, CED skills 1.x/2.x/3.A/4.x served as MCQ). An authored question frame with validated
  slot pools, in `slot_frames.py` (CM-D16). Reference: the existing 1.9×4.B slot-frame. **Unit 1
  Track B cells:** the other eight pilot cells (1.2×2.A, 1.5×3.A, 1.6×4.A, 1.8×3.A, 1.11×2.A,
  1.12×2.A, 1.13×2.A, 1.9×4.B).

If a cell seems to be neither (e.g. it needs open free-response grading), **stop and escalate** — it
is out of pilot scope (the R&D LLM grader is unbuilt). Do not invent a grading path.

---

## 2. The per-cell work order (hand this to each agent)

Give each Codex agent exactly this, filled in for its assigned cell:

> **Cell:** `<topic_code>×<skill_code>` (e.g. `1.11×2.A`) — *<plain description of the skill>*
> **Track:** A (computational) | B (conceptual slot-frame)
> **Target difficulty:** Easy | Medium | Hard (per the pilot plan / CED)
> **Serving/grading:** numeric-entry (deterministic) [Track A] | MCQ choice-match [Track B]
> **Branch:** `content/course-mode-stats-<topic>-<skill>` (your own worktree)
>
> Build one Course Mode template for this cell, following
> `docs/teaching/COURSE_MODE_CONTENT_CREATION_PROTOCOL_2026_08_24.md`. Deliverables (§3/§4), all QA
> gates (§5), and the Definition of Done (§7) must be met before you hand back. Do NOT run the loader,
> do NOT release, do NOT touch Production, and do NOT edit any DB — your output is code + a passing
> property report + a written independent-re-derivation record.

## 3. Track A recipe — a new computational procedure

Per `README.md:52-95`, a new `gen_*` template must be registered in **four places or it ships broken**:

1. **The generator function** `gen_<name>(rng: random.Random, seed: int) -> Dict` in `generator.py`.
   Contract: pick a scenario from `scenarios.py`; compute the key with `statlib.py` (stdlib-only, no
   scipy); build **3+ distractors** as `(display_text, misconception_tag, numeric_value_or_None)`,
   every tag present in `misconceptions.py`; define per-instance property `checks` as `(name, bool)`;
   return via the shared `_package(...)` assembler.
2. **Register in the `PROCEDURES` dict** (`generator.py:630-641`).
3. **Add its prefix to `COMPUTATIONAL_PREFIXES`** in `build_load_sql.py:74-78` (so the loader marks
   `evaluator_strategy='data_driven_deterministic'`).
4. **Add a `scenarios.py` framing** for the procedure (`_package` raises if a procedure lacks canonical
   framing) and any **new `misconceptions.py` tags** (cell-namespaced, §0).

`_package` handles the invariants you must NOT hand-roll: it seed-shuffles the 4 options so the correct
key is **not always first and not the same letter across procedures** (randomized-key invariant),
appends structural checks, re-parses the displayed key text with the runtime verifier's own number
regex and asserts it against the checks, and stamps
`provenance.release_status="unreleased_generated_pending_review"`.

**Distractor realism is your job, and the harness only half-checks it (see §5).** Each distractor must
be a *documented, cited* misconception (an entry in `misconceptions.py` with an evidence tier and a
cited source) and must sit inside the scenario's plausibility envelope (on-scale, not absurd — no exam
score >100, no negative price), and clear of the key by >2–3× the grading tolerance.

## 4. Track B recipe — an authored conceptual slot-frame

Follow the existing `slot_frames.py` pattern (CM-D16) and the 1.9×4.B reference frame. A slot-frame is
an authored MCQ question frame with **validated slot pools** (the varying surface) and a fixed correct
key + distractor set drawn from cited misconceptions. Same shared-catalog rules (§0) and same QA gates
(§5) apply. The frame must carry its own property checks and its own property-report entry (Track B has
its own harness in `slot_frames.py`).

Because Track B items are conceptual, the "changed surface" that Course Mode's mastery model requires
(same template, different params) must come from the slot pools — design pools deep enough that two
served instances are genuinely different surfaces, not cosmetic swaps.

**Before authoring a Track B frame, read §11 (authoring quality lessons from reviewed cells).** Those
are concrete rules the harness does not enforce — stem readability, per-context distractor
plausibility, and same-prefix option confusability — that an independent review will otherwise catch.

## 5. QA gates — ALL mandatory, in order

An agent's cell is not done until every gate passes and the evidence is written down.

**Gate 1 — Property harness ≥100 instances / 0 rejects.** Run `python3 generator.py` (Track A) or the
`slot_frames.py` harness (Track B). A *reject* = any per-instance check is False. The D8 bar is **≥100
instances / 0 rejects for this template**, plus the meta-tests must stay green
(`correct_answer_position_varies`, catalog self-checks `MISC.validate_catalog()` /
`SCN.validate_scenarios()` returning empty, monotonicity sanity). Paste the report line for your
template into your re-derivation record.

**Gate 2 — Independent re-derivation of the key AND every distractor (the gate the harness CANNOT
do).** This is the load-bearing manual check (`README.md:74-82`; `CONTENT_AUTHORING_AND_QA_PROTOCOL.md`
§9). The harness confirms distractors are on-scale/distinct/clear-of-key, **but not that a distractor's
value actually equals the algebraic transform its tag names** — a garbled formula can pass 1000/1000.
So: pick ≥1 emitted instance per template, and **by hand, from first principles, without reading the
generated key**: re-solve the correct answer, then re-derive each distractor's value from the
misconception its tag claims. Confirm they match the emitted item. Record what you checked and that it
matched. A mismatch means the template is wrong — fix and re-run Gate 1.

**Gate 3 — CED conformance & rights.** The skill and difficulty match the CED cell (verify against the
fact pack, not the source doc's own numbering). **No verbatim College Board questions, keys, or scoring
language** — only documented error patterns and CED *structure*, each cited (DECISION-0031/0033). Track
A/B templates satisfy originality structurally via `scenario_provenance` + `misconception_source`
citations; if you instead author any static item, it must carry
`review_notes.originality_statement` naming the sources and asserting no released/secure/third-party
wording.

**Gate 4 — Realistic distractors.** Every distractor is a plausible student mistake inside the scenario
envelope, tagged to a cited misconception. No "throwaway" wrong options. (This is the SME-review failure
mode that has bitten prior batches — off-scale distractors, absurd scenarios.) **Plausibility is
per-context, not just per-tag:** a distractor that is tempting for one scenario/method can be obviously
wrong (nothing in the stem to support it) for another — see §11.2. Check that each distractor is
*tempting* in the specific instance it appears in, not merely a wrong classification.

## 6. Integration (orchestrator step, after parallel agents return)

1. Merge each cell's **catalog additions** (`misconceptions.py`, `scenarios.py`) first — append-only,
   so conflicts are trivial; resolve any duplicate cell-namespaced ids.
2. Merge the **template files** (`generator.py` procedures / `slot_frames.py` frames, `PROCEDURES`,
   `COMPUTATIONAL_PREFIXES`).
3. **Run the full harness once over everything** (`python3 generator.py` + the Track B harness) — all
   templates, ≥100/0 each, all meta-tests green. A green full sweep is the integration gate.

## 7. Definition of Done (per cell, agent-side)

- [ ] Track chosen and justified (§1).
- [ ] Template registered in all required places (Track A: all four; Track B: frame + harness).
- [ ] Catalog additions are append-only and cell-namespaced (§0); reuse preferred.
- [ ] Gate 1 green: ≥100 instances / 0 rejects for this template + meta-tests green.
- [ ] Gate 2 done and **written up**: independent re-derivation of key + every distractor on ≥1 instance.
- [ ] Gate 3: CED/skill/difficulty match; no verbatim CB; citations present.
- [ ] Gate 4: distractors realistic + cited.
- [ ] On its own branch; no loader run, no DB write, no release, Prod untouched.
- [ ] A short `re-derivation record` committed alongside the code (what was checked, the harness line,
      the by-hand math).

## 8. Handoff to release (NOT the agent's job — David / orchestrator)

After a cell's template is merged and the full harness is green, releasing it to students is a separate,
gated flow (see the pilot plan §7 and `CONTENT_AUTHORING_AND_QA_PROTOCOL.md`):

1. **D8 SME review** — David reviews 20 emitted instances of the template; the attestation must be
   truthful and contain all five fields: `sme_sample_n` (≥20), `sme_defects` (0), `property_instances`
   (≥100), `property_rejects` (0), `verifier_disagreements` (0).
2. **Loader** — run `build_load_sql.py` → `f4_load_DRAFT.sql` against a target env that already has the
   `ap_statistics` exam-pack version and the F1 cell registry; it fail-closes otherwise and lands
   everything `draft` / `review_status=NULL` (nothing served).
3. **CM-D19 release** — `app.cm_d19_release_template(template_id, epv, attestation, released_by,
   bars_version)` (service_role) fail-closed gates on the bars, then two-phase stamps the instances
   `draft → reviewed_approved → published` with `review_status='question_review_approved'`. Reversible
   via `cm_d19_revoke_template_release`.

**Do this Dev-first.** Prod is held for David's explicit go.

## 9. Invariants (never violate)
- **INV-3** correctness independently checkable — only verifier-backed items ship; **no LLM
  "question + claimed answer" generation.**
- **Randomized correct-answer key** across A/B/C/D — structural via `_package`; never defeat it.
- **Independent re-derivation** of key + distractors is mandatory (Gate 2) — approval of scope/pacing
  is not a substitute (the Orly-protocol lesson).
- **No verbatim College Board** content; cited misconceptions + CED structure only.
- **Fail-closed:** an item that can't pass its own checks never emits; the loader aborts rather than
  guess.

## 10. Open items
- **Serving taxonomy label:** CM-D19 does **not** stamp a `validated` serving label. Whether a cell's
  items actually serve depends on which selector the front-end calls (unit-gated selector needs a
  validated label; direct RLS read needs only cell tags). Resolve before scaling releases — it does
  not change how a template is *authored*, only how it's served.
- **Track B depth:** conceptual slot-frames must vary the surface enough to satisfy the mastery model's
  "changed surface" requirement; shallow pools will under-credit transfer.

## 11. Authoring quality lessons (from reviewed cells)

Append-only. Each entry is a concrete rule the automated harness does **not** enforce, learned from an
independent review of a real cell. Read this before authoring; it is where review findings accumulate so
they are not re-discovered per cell.

**11.1 — No dangling pronouns in the stem (from `1.11×2.A`, 2026-08-24).** A `{measure}` slot phrased as
"how many hours **they** spend…" reads as a dangling pronoun when dropped into a stem like "study
{measure} among {population}" → *"study how many hours they spend… among all students."* Write slot text
that composes into clean prose: phrase measures as noun phrases ("weekly hours spent in clubs"), or
restructure the stem so the subject is introduced before the pronoun. Read three fully-rendered
instances aloud before declaring done — the harness cannot hear awkward prose.

**11.2 — Distractor plausibility is per-context, not per-tag (from `1.11×2.A`).** Reusing one distractor
tag across many surfaces (e.g. one `stratified_cluster_confusion` tag applied to all six sampling
methods) yields distractors that are *tempting* for the natural case but *obviously wrong* for others
(a grouping-based distractor on a plan with no grouping). This is pilot-acceptable but weakens the item.
Prefer per-context distractor selection where the wrong option is genuinely tempting *in that instance*;
where a tag is reused across contexts, confirm each rendering is still a believable mistake for that
specific stem, not just a valid wrong label.

**11.3 — Tag names must match the misconception's direction (from `1.11×2.A`).** A tag named
`convenience_or_voluntary_called_random` should render the "convenience/voluntary → labeled random"
error; if the same tag is reused to render the inverse ("a random plan labeled convenience"), the option
is still wrong but the tag mislabels the misconception. Either name the tag for the general confusion or
add a direction-specific tag. Tags are the product's misconception vocabulary — keep them honest.

**11.4 — Same-prefix options are allowed but must be intentional (from `1.11×2.A`).** Two options that
both begin "Stratified random sample, because…" (correct reasoning vs cluster-style reasoning) is a
rigorous, legitimate discrimination — but it raises difficulty and can read as a trick. Use it
deliberately to test a specific boundary (stratified-vs-cluster), not by accident, and flag it for the
SME so difficulty is a choice, not a side effect.
