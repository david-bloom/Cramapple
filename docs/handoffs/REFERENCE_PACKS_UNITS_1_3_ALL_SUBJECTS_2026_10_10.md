# Reference Packs, Units 1-3, All Ten Subjects — Session Record

**STATUS:** Development complete for 25 new unit batches. Production untouched and still a Hard Gate.
After a Product-Owner-directed correction pass, 39 of the 50 escalations are corrected and loaded, 7 are
rejected as inadmissible, and 4 plus one Calculus BC decision remain open. See section 11.

**DATE:** 2026-10-10 (America/New_York)

**OWNER:** Claude session. **PRODUCT OWNER:** David Bloom.

**BRANCH:** `claude/task-0067-production-records`

**TASKS:** `TASK-0067` (unit reference content), `TASK-0066` (memory hooks).

**GOVERNING PROTOCOL:** `docs/product/MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`, with the
AP Chemistry application in `docs/product/AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md`.

## 1. What David decided, and what was built

David, 2026-10-10: **Units 1-3 for all subjects**, **Development only**, and the two AP Chemistry Unit 1
escalations ruled per this session's recommendations. He then supplied the four missing Physics CEDs,
which unblocked the only subjects that could not be run to protocol.

"Units 1-3" means the first three *registry* units, which for three courses are not numbered 1-3:

| Subject | Registry units in scope |
|---|---|
| Statistics, Biology, Calculus AB, Calculus BC, Precalculus, Chemistry, Physics 1, Physics C: Mechanics | 1, 2, 3 |
| Physics 2 | 9, 10, 11 |
| Physics C: E&M | 8, 9, 10 |

**Development now holds 951 published reference entries and 11 published hooks** across nine subjects (912 and 10
before the correction pass in section 11).
786 entries and 6 hooks are new this session; the rest is the pilot (Statistics Unit 1, Chemistry Unit 4)
plus Chemistry Unit 1 from PR #399.

| Subject | Unit | Entries loaded | Hooks | Batch directory |
|---|---:|---:|---:|---|
| ap_biology | 1 | 21 | 0 | `ap-biology-reference-u1-u3-2026-10-10` |
| ap_biology | 2 | 44 | 0 | `ap-biology-reference-u1-u3-2026-10-10` |
| ap_biology | 3 | 29 | 0 | `ap-biology-reference-u1-u3-2026-10-10` |
| ap_calculus_ab | 1 | 24 | 0 | `ap-calculus-ab-reference-u1-u3-2026-10-10` |
| ap_calculus_ab | 2 | 16 | 0 | `ap-calculus-ab-reference-u1-u3-2026-10-10` |
| ap_calculus_ab | 3 | 9 | 1 | `ap-calculus-ab-reference-u1-u3-2026-10-10` |
| ap_chemistry | 2 | 20 | 0 | `ap-chemistry-reference-u2-u3-2026-10-10` |
| ap_chemistry | 3 | 29 | 0 | `ap-chemistry-reference-u2-u3-2026-10-10` |
| ap_physics_1 | 1 | 30 | 3 | `ap-physics-1-reference-u1-u3-2026-10-10` |
| ap_physics_1 | 2 | 38 | 0 | `ap-physics-1-reference-u1-u3-2026-10-10` |
| ap_physics_1 | 3 | 23 | 0 | `ap-physics-1-reference-u1-u3-2026-10-10` |
| ap_physics_2 | 9 | 27 | 0 | `ap-physics-2-reference-u9-u11-2026-10-10` |
| ap_physics_2 | 10 | 34 | 0 | `ap-physics-2-reference-u9-u11-2026-10-10` |
| ap_physics_2 | 11 | 35 | 0 | `ap-physics-2-reference-u9-u11-2026-10-10` |
| ap_physics_c_em | 8 | 32 | 0 | `ap-physics-c-em-reference-u8-u10-2026-10-10` |
| ap_physics_c_em | 9 | 15 | 0 | `ap-physics-c-em-reference-u8-u10-2026-10-10` |
| ap_physics_c_em | 10 | 19 | 0 | `ap-physics-c-em-reference-u8-u10-2026-10-10` |
| ap_physics_c_mechanics | 1 | 31 | 0 | `ap-physics-c-mechanics-reference-u1-u3-2026-10-10` |
| ap_physics_c_mechanics | 2 | 47 | 0 | `ap-physics-c-mechanics-reference-u1-u3-2026-10-10` |
| ap_physics_c_mechanics | 3 | 31 | 0 | `ap-physics-c-mechanics-reference-u1-u3-2026-10-10` |
| ap_precalculus | 1 | 41 | 0 | `ap-precalculus-reference-u1-u3-2026-10-10` |
| ap_precalculus | 2 | 53 | 0 | `ap-precalculus-reference-u1-u3-2026-10-10` |
| ap_precalculus | 3 | 39 | 2 | `ap-precalculus-reference-u1-u3-2026-10-10` |
| ap_statistics | 2 | 42 | 0 | `ap-statistics-reference-u2-u3-2026-10-10` |
| ap_statistics | 3 | 57 | 0 | `ap-statistics-reference-u2-u3-2026-10-10` |
| **Total (this session)** | **25 units** | **786** | **6** | |

Chemistry Unit 1 (24 entries, 1 hook) was already in Development from PR #399 and was not re-run.

## 2. Calculus BC is the one piece of the scope not delivered

Calculus BC units 1-3 are **not loaded**, and the reason is a decision rather than a failure.

Measured on 2026-10-10: BC and AB units 1-3 carry an **identical set of 32 taxonomy topic codes and
titles** (zero asymmetric difference in either direction), and the two courses share one CED PDF. A full
BC run would therefore spend a second extraction-and-checking pass to produce the same content AB
already has.

`scripts/content-seed/ap-calculus-ab-reference-u1-u3-2026-10-10/rekey_bc.py` generates
`out/load_ap_calculus_bc_u1_u3_rekey.sql`, which inserts the BC rows from AB's already-checked rows
verbatim — only `subject_key` changes, and `source_note` records the re-key. **It has not been applied.**
The production protocol describes no re-key path, so this needs a Product Owner call:

- **Re-key (recommended):** zero model cost, content identical to what a BC run would produce,
  provenance states the origin. Deviates from the protocol's one-batch-per-unit shape.
- **Run BC properly:** three more unit batches, roughly $3 and an hour, protocol followed exactly,
  output expected to duplicate AB's.

## 3. Inputs verified before the run

- **CED PDFs.** All ten subjects now have a full CED. The four Physics CEDs came from David's
  `subject packs/` (gitignored) and were copied into `docs/teaching/`, where the protocol points and the
  other six already live.
- **Clarifications PDFs are not content authority.** `subject packs/` also holds Physics 2 and Physics C:
  Mechanics "Clarifications and Corrections" PDFs. Both were read in full: they change exam logistics
  only (Mechanics multiple-choice 40 to 42 questions and 80 to 85 minutes; free-response 100 to 95
  minutes) and alter no learning objective or essential-knowledge statement. One line is worth carrying
  forward: the Physics 2 clarification says some AP Exam conventions in the Appendix I equations table
  were updated, so Physics 2 equation entries should be re-checked against the current table.
- **Unit page ranges** were rebuilt from each CED's unit divider page (the page carrying
  `AP <SUBJECT> UNIT N` with the exam weighting). A first index built from form feeds was off by one to
  two pages; the Statistics Units 2-3 runs used that slightly wider range, which only added the previous
  unit's last two pages as context and produced no cross-unit entries.
- **Taxonomy.** `app.taxonomy_topics` keys subjects through `taxonomy_source_version`, not a
  `subject_key` column; the current verified version per subject supplied the valid topic codes. All ten
  subjects use `ap_*` underscore keys (`ap_biology`, not `biology`).
- **Model roster** re-read live from the gateway: all four configured models present. `smoke.py` passed
  3/3 for each.

## 4. Model slate (proposed for batch ratification)

| Role | Model | Smoke |
|---|---|---|
| Extractor | `anthropic/claude-sonnet-5.5` | 3/3 |
| Checker 1 | `google/gemini-3.5-flash` | 3/3 |
| Checker 2 | `openai/gpt-6-sol` | 3/3 |
| Own-family veto (reject-only) | `anthropic/claude-haiku-5.5` | 3/3 |

Unchanged from the AP Chemistry Unit 1 batch (`DECISION-0107`). Newer models are now on the gateway
(`google/gemini-3.8-flash`, `openai/gpt-6.1-sol`); changing the slate needs the protocol's smoke test and
batch-level ratification, so the ratified slate was kept.

## 5. Controls and QA

- **Every one of the 25 batches passed its controls gate 6/6**, 150 planted defects in total. Each set has
  one hook control, caught only when its planted hook is rejected while its correct entry is accepted.
- One control was wrong and was corrected **before** the run rather than voiding it: the Biology Unit 2
  "non-CED" control asserted the Na+/K+ pump appears nowhere in the CED. It does, at 2.8.A.1.ii — the
  superscripts in the PDF defeated a plain-text search. The CED gives no pumping stoichiometry, so the
  planted defect stayed valid and only its justification was rewritten. The lesson for later batches:
  a string-absence check against CED text must survive superscript mangling.
- `scripts/qa/unit_reference_and_memory_hooks_qa.sql`: **all 8 checks returned ok** (objects exist, RLS
  forced, no anon grants, zero orphan topic codes, owner unit matches taxonomy, published hooks have
  published entries, published_at present, RPC payload keys).
- Read-only RPC probes under a fake `request.jwt.claims`, rolled back:

| Probe | `reference[]` | `memoryHooks[]` |
|---|---:|---:|
| Physics 1 topic 1.3 | 9 | 0 |
| Physics 1 topic 1.5 (hook topic) | 11 | 3 |
| Precalculus topic 3.5 | 6 | 0 |
| Physics C: E&M topic 8.6 | 10 | 0 |
| Physics 2 topic 11.5 | 10 | 0 |
| Physics C: Mechanics unit 2 roll-up | 47 | 0 |
| Calculus BC topic 1.1 (expected empty) | 0 | 0, briefs unchanged |

The RPC is `public.get_topic_point_guides(_subject_key, _unit_number, _topic_code)`; earlier records that
name it `app.get_topic_point_guides` with two arguments are wrong about both the schema and the arity.

## 6. Cost

4,012 gateway calls, **$37.80** at gateway list prices — about $1.45 per unit batch, against roughly $10
per unit in the pilot. The Haiku veto (`DECISION-0107`) is why: it is 1,169 calls for $2.55, while GPT-6
Sol's checker pass alone is $21.99. Per-batch costs are in each batch README. Raw `logs_*` JSONL is not
committed.

## 7. Script changes carried forward

- **`extract.py`**: a hook's `caution` is now explicitly required whenever its wording is not the CED's
  point-earning wording, which is nearly always true of an acronym. The AP Statistics Unit 2 BINS hook
  was correct in every other respect and was rejected twice for exactly that missing caution; the next
  extraction (Chemistry Unit 3, FON) produced the caution unprompted, and 6 hooks passed afterwards.
- **`load.py`**: now refuses to write a row that violates a schema invariant the checkers do not enforce,
  and names it. An accepted Statistics Unit 3 row had `owner_topic_code` 3.3 with `topic_codes` `{3.4}`;
  all three models passed its topic codes, the database check constraint rejected it, and because the
  load is one transaction **the entire batch silently loaded nothing** until the row was removed. The
  guard checks that the owner appears in `topic_codes` and that every code belongs to the unit.
- `finish_unit.sh` (scratchpad, not committed) chained round 2, load and apply per unit.

## 8. Open Product Owner decisions

### 8.1 Ruled by David this session, applied

Nothing from this session's batches has been overridden. The two rulings David gave are recorded in 8.3.

### 8.2 Fifty escalations (section 11 resolves 46 of them)

Each is content that survived a stateless Round 2 and was still rejected. Full reasons, with the CED
citation each checker gave, are in the per-batch READMEs under "Escalated to the Product Owner". The
distribution:

| Subject | Escalations |
|---|---:|
| Precalculus | 12 |
| Physics 1 | 9 |
| Physics 2 | 6 |
| Physics C: E&M | 5 |
| Calculus AB | 4 |
| Chemistry (units 2-3) | 4 |
| Physics C: Mechanics | 4 |
| Biology | 3 |
| Statistics (unit 3) | 3 |

They are not random. Three patterns cover nearly all of them, and each pattern wants one ruling rather
than 45:

1. **Modality and hedging.** The entry turns the CED's "should" into "must", or states a hedged CED claim
   as unconditional ("in many such cases" becomes always). The chemistry and statistics instances are
   the clearest. These are accurate for a student and imprecise against the text.
2. **Over-generalised reuse.** The entry is right for its owner topic but its `topic_codes` claim it for a
   later topic where the CED says something narrower — the Statistics 3.7 conclusion-wording entry
   requires "the parameter" for chi-square, where 3.15.D.3 requires the population(s). These are real
   defects in the reuse tagging, not the body.
3. **Missing qualifying caution.** The body is correct but drops a condition the CED attaches (average
   velocity versus velocity, uniformly distributed charge, sample proportions substituted for population
   proportions) with no `caution`. The veto is strict about this and is defensible each time.

My recommendation is to rule by pattern: **reject pattern 2** (the reuse claim is wrong), and for patterns
1 and 3 decide once whether a correct body with imprecise modality or a missing caution is publishable.
Rejected rows are not lost — they can be regenerated in a later batch against the same CED evidence.

### 8.3 Carried in from PR #399 (ruled by David 2026-10-10, not yet applied)

- `ap_chemistry-u1-r2-003` "Bond likelihood from valence electrons and nuclei" (1.8) — **rejected.**
- `ap_chemistry-u1-r2-004` "Tools for explaining periodic trends" (1.7) — **accepted with 1.7 as owner.**

Applying the acceptance needs `load.py --po-accept` inside PR #399's batch directory
(`scripts/content-seed/task0067-chem-u1-2026-10-09`), which is where those candidates live. That branch
is not merged, so it was left alone rather than edited from here.

## 9. What was not done

- No Production change, no migration, no schema change, no Lovable build, no frontend publish.
- Calculus BC units 1-3: see section 2.
- No hook was hand-edited or rescued; "no hook" and "hook rejected" outcomes are kept as they came.
- `main` was not merged into this branch: `main`'s newer commits collide with untracked files belonging
  to other work, and nothing in this content run depends on them.

## 10. Exact next step

1. Rule the Calculus BC question in section 2 (one line either way).
2. Rule the escalation patterns in section 8.2.
3. Then Production is a separate Hard Gate: an `APPROVALS_LOG.md` entry naming the batches, counts and
   rollback; the same generated SQL applied with the CLI temporarily linked to Production; the QA script
   and RPC probes re-run there; and a separate approval for any frontend publish. The app renders its
   previous output when `reference[]` and `memoryHooks[]` are empty, so a data publish needs no frontend
   change.

**Do not touch:** the unrelated modified and untracked files in the working tree, which belong to other
work.

## 11. Product-Owner-directed correction pass (David, 2026-10-10)

David directed this session to correct the escalations itself rather than regenerate them. The production
protocol bars hand-editing a generated row (`§3` step 6), so this is a recorded deviation taken on the Product
Owner's instruction under his `§4` authority over every escalation. Two safeguards were kept:

1. Each correction restores the CED's own wording or qualification that the checker had identified as missing,
   verified against the CED PDF text rather than the fact pack. No new content was authored.
2. Every corrected row went back through the same two independent checkers and the reject-only own-family veto
   (rounds 3-5). Nothing loaded on the session's judgment alone, and the rationale text was deliberately kept
   out of the candidate files so it could not bias a checker.

**Correction of an earlier count in this record:** the escalation total is **50, not 45**. The 45 was computed
before the last three batches finished and was never recomputed; the per-subject table in section 8.2 was always
right and sums to 50.

### Outcome

| Disposition | Rows |
|---|---:|
| Corrected, re-checked, accepted and loaded | **39** |
| Rejected as inadmissible (not correctable) | **7** |
| Still open for the Product Owner | **4** |
| **Total** | **50** |

Development now holds **951 published entries and 11 published hooks**. One hook came back with its corrected
entry: the Calculus AB implicit-differentiation chain-rule hook, whose caution had over-claimed that every term
containing y carries a factor of dy/dx.

### The 7 rejected as inadmissible

Each had no basis in a learning objective or essential-knowledge statement, which the inclusion rule requires.
Correcting them would have meant inventing a basis, so they stay rejected:

- **`ap_biology-u1-r2-002`** — Cellulose/Starch/Glycogen appear only under ILLUSTRATIVE EXAMPLES; EK 1.4.A.1 does not require reproducing the list.
- **`ap_biology-u3-r2-005`** — The graph components are Skill 4.A, not a Topic 3.5 LO/EK.
- **`ap_calculus_ab-u2-r2-002`** — Three-decimal rounding comes from 'Preparing for the AP Exam', not an LO/EK; the entry also drops 'specified'/'typically'.
- **`ap_calculus_ab-u2-r2-003`** — Derivative-notation rules trace to Skill 4.C plus an invented rule ('do not rename a derivative') the CED never states.
- **`ap_physics_1-u2-r2-003`** — 'Action at a distance is gravitational only' exists solely in the Topic 2.3 boundary statement.
- **`ap_physics_c_em-u8-r2-003`** — The four-or-fewer-charges limit is the Topic 8.1 boundary statement, a scope limit rather than content.
- **`ap_physics_c_em-u10-r2-001`** — The list of quantitatively examinable capacitor geometries is the Topic 10.3 boundary statement.

Three of the seven are the same failure mode and worth noting for later batches: the extractor will mine a
**boundary statement**, a **suggested skill**, or the **"Preparing for the AP Exam"** section as if it were
course content. A future `extract.py` revision should name those sections and forbid them explicitly.

### The 4 still open

Three are one question, and it is a question you have already answered twice. The checkers assign ownership to
the **earliest topic that mentions** an idea; `DECISION-0107` rule 2 and the AP Chemistry Unit 1 "Tools for
explaining periodic trends" call both chose **the topic whose objective requires the entry as such**. Applying
your precedent would load all three as they stand; applying the checkers' rule would move each owner earlier.
I did not self-override a veto or a two-checker rejection, so they are unloaded pending your word:

| Candidate | Entry | Checkers want | Precedent (`DECISION-0107` r2) wants |
|---|---|---|---|
| `ap_physics_1-u1-r3-001` | Kinematic equation v = v0 + at (owner 1.3) | owner **1.1** — 1.1.A.3.ii prints the derived equation first | owner **1.3**, where 1.3.A.2 requires it *as* a kinematic equation |
| `ap_physics_1-u2-r3-005` | Normal force (owner 2.7) | owner **2.6** — 2.6.C.1 uses its magnitude to define apparent weight | owner **2.7**, where 2.7.A.2.ii defines the force |
| `ap_precalculus-u1-r3-001` | Concavity from average rates of change (owner 1.3) | owner **1.1** — 1.1.B.3/1.1.B.4 state concavity from rate of change | owner **1.3**, whose 1.3.B.3 is the average-rate-over-equal-intervals statement the body actually makes |

The fourth is a genuine deadlock between the two model families, not a judgment I should force:

- **`ap_physics_2-u10-r5-003`** — ΔU_E = qΔV. GPT-6 Sol insists the owner is **10.5** (10.5.A.3 defines potential
  difference as the change in potential energy per unit charge, so it requires the relationship first); the
  own-family veto rejected exactly that and insists on **10.7** (10.7.A.1 gives the equation itself). Three
  encodings were tried — owner 10.5, owner 10.7, and owner 10.7 with 10.5 as a reuse code — and each was rejected
  by one of the two. The body, title and caution are agreed; only ownership is contested.

### Where the corrections came from

Every correction and its reason is listed below, and the full machine-readable registry is
`correction_rationales.json` alongside the batch outputs. Each loaded row's `source_note` carries
`product-owner-directed correction by the Claude session (David, 2026-10-10)`, so a corrected row is
distinguishable in the database from a stateless re-extraction.

**ap_biology**

- `ap_biology-u1-r3-001` (1.1, body) — “Hydrogen bonding”. Restored 1.1.A.1's 'contributes to'; the entry had all hydrogen bonding in biological molecules arising from water's bonds.

**ap_calculus_ab**

- `ap_calculus_ab-u2-r3-001` (2.8, topic_codes) — “Product rule”. Dropped 2.10: FUN-3.B.3 covers rewriting tangent, cotangent, secant and cosecant with identities and does not use the product rule.
- `ap_calculus_ab-u3-r3-001` (3.2, caution) — “Chain rule applied to y in implicit differentiation”. Corrected the caution's over-general claim that every term containing y needs a dy/dx factor, using the d(xy)/dx counterexample the checker raised.

**ap_chemistry**

- `ap_chemistry-u2-r3-001` (2.6, body) — “Resonance for equivalent Lewis structures”. Restored 2.6.A.1's hedge 'In many such cases'; the entry had made the accuracy claim universal.
- `ap_chemistry-u3-r3-001` (3.5, caution, title) — “Average kinetic energy of a particle”. 3.5.A.2 ties the equation to average kinetic energy and average velocity; title restored and the gap cautioned.
- `ap_chemistry-u3-r3-002` (3.1, body) — “Noncovalent interactions in large biomolecules”. Restored 3.2.A.7's causal chain through shape; the entry had the interactions dictating properties directly.
- `ap_chemistry-u3-r3-003` (3.9, body) — “Chromatography”. Restored 3.9.A.1's 'between and among the components of the solution (the mobile phase)', which the entry omitted.

**ap_physics_1**

- `ap_physics_1-u2-r3-002` (2.5, body) — “Direction of acceleration and when velocity changes”. Restored 'of the system's center of mass' in the second clause; without it the claim is false for a system whose parts move.
- `ap_physics_1-u2-r3-003` (2.5, body, caution) — “Newton's second law”. Replaced a_sys with a_cm and SigmaF with SigmaF_ext to match 2.5.A.2/2.5.A.3, dropped the redundant second equality, and added the center-of-mass caution the veto asked for twice.
- `ap_physics_1-u2-r3-004` (2.6, caution) — “Weight”. Deleted the unsupported label-acceptance caution; 2.6.A.3 gives 'Weight = F_g = mg' and the body matches it, so no caution is needed.
- `ap_physics_1-u3-r3-001` (3.2, body, caution) — “Work-energy theorem”. Dropped 'Sigma F_parallel d', which gave every force the same displacement; 3.2.A.3 ties work to the displacement of each force's point of application.
- `ap_physics_1-u3-r3-002` (3.3, body) — “Potential energy of a system”. Restored 3.3.A.1's 'if ... only interact through conservative forces'; the entry had turned it into 'only if ... interact', a different and stronger claim.

**ap_physics_2**

- `ap_physics_2-u10-r3-001` (10.1, body) — “Charges of the basic particles”. Restored 10.1.A.1.ii's qualifier 'can be considered to be'.
- `ap_physics_2-u10-r3-002` (10.6, body) — “Uniform field and motion between plates”. Added 10.6.A.3's 'uniformly distributed electric charge' condition and 10.6.A.3.ii's 'near Earth's surface'.
- `ap_physics_2-u11-r3-001` (11.5, topic_codes) — “Series connection”. Dropped 11.7: its LO/EK cover only Kirchhoff's junction rule and do not use the series definition.
- `ap_physics_2-u11-r3-002` (11.5, topic_codes) — “Parallel connection”. Dropped 11.7 for the same reason as the series entry.
- `ap_physics_2-u11-r3-003` (11.8, body, caution) — “RC time constant”. Restricted tau to a circuit reducible to one equivalent R and C, and replaced 'Only qualitative use is required' with the boundary statement's actual terms, which permit mathematical treatment of initial and final states.

**ap_physics_c_em**

- `ap_physics_c_em-u10-r3-001` (10.3, caution, topic_codes) — “Field between parallel plates”. Added the no-dielectric condition from 10.4.A.4 and dropped 10.4 from the reuse codes, since 10.4 uses the dielectric-modified field rather than this formula.
- `ap_physics_c_em-u8-r3-001` (8.1, body) — “Elementary charge and charges of particles”. Restored 8.1.A.1.ii's qualifier 'can be considered to be'.
- `ap_physics_c_em-u9-r3-001` (9.3, caution) — “Change in potential energy of a charge moving through a potential difference”. Added the object-field-system caution the veto required twice.

**ap_physics_c_mechanics**

- `ap_physics_c_mechanics-u1-r4-001` (1.2, caution) — “Average velocity”. Dropped the citation of 1.2.C.1.i, which defines instantaneous velocity as dx/dt rather than the average-velocity component form. My citation error, not the extractor's.
- `ap_physics_c_mechanics-u3-r3-001` (3.2, body) — “Only the parallel force component changes the system's energy”. Restored 3.2.A.3.iv's reference frame: the perpendicular component is perpendicular to the displacement of the center of mass, not of the point of application.
- `ap_physics_c_mechanics-u3-r3-002` (3.2, body, caution) — “Work–energy theorem”. Dropped the unqualified 'Sigma F_parallel d_i': 3.2.A.3 specifies a path integral for a variable force and 3.2.A.3.iii gives the constant-component condition.
- `ap_physics_c_mechanics-u3-r3-003` (3.2, topic_codes) — “Energy dissipated by friction”. Dropped 3.4, which never states the friction-times-path-length relation.

**ap_precalculus**

- `ap_precalculus-u1-r3-002` (1.3, body) — “Concavity from changing average rates of change”. Restored 1.3.B.3's 'for all small-length intervals'; rates rising over some intervals do not establish concavity.
- `ap_precalculus-u1-r3-003` (1.4, body) — “Polynomial function in standard form”. Added 1.4.A.1's condition that every coefficient is real; without it the form admits complex coefficients.
- `ap_precalculus-u1-r3-004` (1.11, body) — “Factored form vs. standard form”. Restored 1.11.A.1's structure: 'readily provides' applies to real zeros, and the rest follows from that.
- `ap_precalculus-u1-r3-005` (1.6, body) — “End behavior limit notation for polynomials”. Added 'nonconstant' from 1.6.A.1-2; a constant polynomial has finite end-behavior limits.
- `ap_precalculus-u1-r3-006` (1.10, body) — “Location of a hole”. Reversed the implication to match 1.10.A.2, which presupposes a hole at x = c and then locates it; a finite limit alone does not establish one.
- `ap_precalculus-u1-r3-008` (1.12, items) — “Additive and multiplicative transformations”. Replaced the absolute-value dilation factors with the CED's own phrasing, 'by a factor of a' and 'by a factor of 1/b', each followed by its reflection condition.
- `ap_precalculus-u1-r4-007` (1.13, items) — “Choosing a function type for a model”. Added the piecewise-defined type from 1.13.A.7 and split 1.13.A.4 from 1.13.A.5, which the entry had folded into one item.
- `ap_precalculus-u3-r3-002` (3.5, caution) — “Concavity of sinusoidal graphs”. Deleted the caution: the CED pages say nothing about scoring guidelines rejecting 'increasing at an increasing rate'. The body matches 3.5.A.5 and needs no caution.
- `ap_precalculus-u3-r3-003` (3.6, caution, owner_topic_code, topic_codes) — “Converting frequency to the parameter b”. Ownership moves to 3.6, the first topic requiring the parameter b, and the caution now gives |b| = 400 pi rather than the entry's incorrect b = 2 pi times 200.
- `ap_precalculus-u3-r3-004` (3.11, body) — “Secant, cosecant, and cotangent definitions”. Separated the cotangent restrictions as 3.11.A.4 does; the combined condition wrongly excluded angles where cos theta = 0.

**ap_statistics**

- `ap_statistics-u3-r3-001` (3.2, body) — “Interpret sampling distribution results in context”. 3.2.C.1 says 'should'; the entry said 'must', which its own cited evidence contradicted.
- `ap_statistics-u3-r3-002` (3.7, body) — “Conclusion wording for a hypothesis test”. The entry required a parameter reference for all three tests; 3.15.D.3 requires the population(s) only. Stated per test so the 3.13/3.15 reuse stays valid.
- `ap_statistics-u3-r3-003` (3.10, caution) — “Standard error of \hat{p}_1 - \hat{p}_2”. 3.10.D.1 defines the SE for the difference between two population proportions; the caution now states that sample proportions stand in for them.

### Cost

The correction pass added 153 checker calls and $1.22, taking the session total to 4,165 calls and **$39.02**.
