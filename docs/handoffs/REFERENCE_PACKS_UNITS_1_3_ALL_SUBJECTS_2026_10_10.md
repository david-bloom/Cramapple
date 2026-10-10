# Reference Packs, Units 1-3, All Ten Subjects — Session Record

**STATUS:** Development complete for 25 new unit batches. Production untouched and still a Hard Gate.
45 escalations and two decisions are open for the Product Owner.

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

**Development now holds 912 published reference entries and 10 published hooks** across nine subjects.
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

### 8.2 Forty-five escalations, none loaded

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
