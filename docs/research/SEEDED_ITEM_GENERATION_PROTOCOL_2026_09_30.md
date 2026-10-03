# Seeded item generation protocol — using existing questions as seeds for more

**Status:** Draft v0.1, 2026-09-30. Written after the AP Calculus AB Unit 1 batch
(34 originals + 102 variants, published 2026-09-30; PR #292). Proposed, not yet adopted.
**Product Owner:** David Bloom. **Learning Quality Owner / source of the trigger observation:** Orly Bloom.

**Relationship to other protocols.** This document adds a *front end* (choosing and cleaning a seed)
and a *family model* (one seed → a set of siblings). It does not replace anything:

| Protocol | Role here |
|---|---|
| `CONTENT_AUTHORING_AND_QA_PROTOCOL.md` (authoring, "AQP") | Generating from scratch. **Every item this protocol produces runs through AQP Phases 2-6 unchanged.** |
| `ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md` (mining, "OMP") | Rights boundary for third-party material (OMP §2). This protocol *narrows* what may be taken from such a source and *widens* nothing. |
| `GOLD_SET_GENERATION_PROTOCOL.md` | Different pipeline (student answers). Not merged. |

---

## 1. What we learned

1. **Homework repeats one task in many costumes.** Orly's packets for topics 1.13-1.15 contain runs of
   problems that all test the same underlying move with different functions and numbers. That is the
   pedagogical structure worth keeping: a *family* = one skill, one task shape, one set of typical
   errors, several surface forms. The structure is a fact about how the skill is taught; the particular
   functions, numbers, wording and answer choices are the author's expression (OMP §2).
2. **A family spec can be separated from its expression.** What a family needs in order to be
   regenerated is small: topic, skill, task verb, structural features (e.g. "piecewise, one removable
   point"), typical misconceptions, difficulty band. None of that requires a stem, a number set or a
   choice list.
3. **Variants from our own originals work at scale, and the checks caught real defects.**
   102 variants (3 per original, numbers *and* context changed) were generated and checked:
   - Answer keys: **no key was wrong** on any of 136 items (independent sympy recomputation plus a
     blind solve by two further models). The defects were in the *explanatory text*: about 20 items had
     real rationale or rubric defects (false numbers in rationales, distractor rationales that did not
     produce the shown value, "common factor" misuse, overstated wording, one ambiguous choice).
   - **Patching introduced new defects.** Three of the fixes made in response to the first check were
     themselves wrong (a choice made vacuously true, a false rationale claim, a distractor sign error) and
     were caught only because the whole set was re-checked. A fix is a new draft.
   - Weaker checker models produce noise: one model's audit flags were mostly its own arithmetic slips,
     though it solved reliably. Adjudicate flags by re-deriving, never by counting votes.
4. **A mislabelled seed multiplies its error.** Nine of the 34 authored topic tags were wrong by model
   consensus. The worst case, the "instantaneous rate from shrinking intervals" family (originally
   tagged topic 1.1), is really topic 2.1 / Unit 2, so the seed plus its three variants, and the
   neighbouring pair, all moved units. Labelling the seed correctly *first* is cheaper than fixing four
   copies.
5. **Labels inherit unevenly.** Per-variant agreement with the original: units 99/102, topic 92/102,
   skill 87/102 (9 more had no original consensus), difficulty 85/102. Unit is stable; topic drifts
   between neighbouring topics; skill is unstable even for one item in repeated samples; difficulty is
   coarse (models almost never say Hard). Inheritance therefore needs a per-variant check, not a copy.
6. **Family members are not independent evidence.** Four items on one skill are one unit of coverage,
   not four. Nothing in the schema records which items are siblings (AQP §7.1, provenance, is still open),
   so serving, mastery and spacing cannot yet treat them as one family.
7. **Generators re-randomize.** Correct-answer letters are drawn at random on every build run. Once any
   SQL has been loaded, the generated file must not be rebuilt; chunk it from the file on disk and verify by
   hash. (Same class of bug as the all-`A` batch recorded in OMP's revision note.)
8. **We did not run a clean-room process, and it shows.** The Unit 1 originals were designed by the same
   context that had read the third-party packets, compared "by eye" with no automated check, and two
   distractors that happened to coincide with packet content were replaced after the fact. That was
   defensible for topic-scope-only use; it is *not* sufficient if problems are used as seeds. §4 below is
   the fix.

---

## 1a. How models were combined, and why the roster must be kept current

**Layered, non-overlapping checks.** No single model or method was trusted with anything the pipeline
depends on. In the Unit 1 run each layer caught something the others did not:

| Layer | What it checked | Who / what | What it caught |
|---|---|---|---|
| Author | Draft against the fact pack | One model (Sonnet 5.5) | n/a, and never its own checker |
| Deterministic recompute | Every key and FRQ number | sympy, computed *before* asserting the keyed text | Zero wrong keys; the arithmetic backstop |
| Blind solve | Can an independent solver reach the key without seeing it? | Two further models from different families | Confirmed keys; disagreements were the checker's own errors |
| Rationale/rubric audit | Does each explanation actually produce its number? | The same two solvers | The ~20 real text defects |
| CED-scope check | Is the item inside the course? | Two independent families, chosen by the Product Owner from a menu (§3.2) | Scope violations the author could not see |
| Labeling | Topic, units, skill, difficulty | Three models, blind | 9 of 34 authored topic tags wrong; the 1.1 vs 2.1 unit issue |
| Re-check after patching | Did the fix hold? | Full re-run | 3 regressions introduced by our own fixes |

Rules this implies:
1. **Independence over count.** Pair models from different families and never let the author check itself.
   Agreement between two models of one family is weak evidence.
2. **Use each model for what it is good at.** One solver was reliable at solving but noisy at auditing
   (its flags were mostly its own arithmetic slips); another had unmeasured recall. Measure roles separately
   and adjudicate flags by re-deriving, never by vote count.
3. **A deterministic check is a model's ground truth**, not a peer. Where sympy or a script can settle it,
   it settles it.
4. **Record the roster and role per batch** (AQP §7.1 is still open; the batch README is the record).

**Standing checker design (Product Owner decision, 2026-09-30, after the Fable calibration run,
`calc-ab-fable-calibration-2026-09-30/CALIBRATION_REPORT.md`).** Two checkers from different families per stage,
one patch loop, and a full re-check of every patched item. Treat the **union** of the two checkers' flags as
candidates and verify each by hand or sympy before acting (single-model flags proved real). A stronger model
(e.g. Fable) is a **sample-as-needed** tool, not a standing third stage: use it for a per-batch calibration sample,
to adjudicate single-model flags, or when a repeat pass of the same two checkers disagrees with the first. Count
only key errors and per-choice rationale inaccuracies as defects; style notes are a separate channel.

**Staying current is a maintenance duty, not a preference.**
- The fixed checker roster in AQP had gone stale; the Product Owner spotted that a superseded Gemini
  generation was still in use, and the roster had never been checked against what the gateway actually offered.
  Swapping to the current-generation model fixed all 11 structured-output failures at once (34/34 clean).
- Model quality, structured-output reliability, cost and availability all change faster than protocols do.
  Therefore: **before every batch, check the live gateway roster** (model IDs, structured-output support, a
  smoke test) and pick from the current menu; do not carry a roster forward from the last run.
- A checker-model change does not invalidate published content (the content did not change), but it does
  invalidate any *measured* bias or recall figure for that model. Re-measure before relying on a new model
  in a role, and record uncalibrated models as such.
- Ask the Product Owner which two checkers to use before each run (AQP §2.1). The menu is a proposal
  refreshed against the roster, not a fixed list.

---

## 2. Seed classes and the rights gate (Step S0)

Classify every seed before anything else. The class fixes how much may be taken.

| Class | Examples | May be taken |
|---|---|---|
| **A. Ours** | Items already in `app.content_items` that Cramapple authored or owns | The item itself as a seed: numbers, context, structure. This is what Phase 5b variants do. |
| **B. Third-party, teacher-authored** | A teacher's worksheet or packet | **Family spec only** (§3, S1). No stem wording, numbers, functions, choices or rubric language reach the generator (OMP §2). |
| **C. Third-party, platform/textbook-derived** | Vendor item-bank exports (e.g. DeltaMath printouts), licensed curriculum; anything that looks lifted from a textbook | Topic and skill scope only. **No family spec from individual problems** (OMP §2: go from the topic code straight to an independently designed item). Ambiguous → treat as C and flag. |
| **D. Released exam material / public items** | Released AP items | Not covered here. Rights are separate; do not use as seeds without a decision. |

Gate rules:
- The classification and the source are logged in the OMP source log (OMP §3) before generation starts.
- Class B seeds require the spec to pass the scrub in S2. Class C seeds skip S1 entirely.
- Nothing from a B/C source is stored in the repository or included in any prompt beyond what S1's
  extractor produces.

---

## 3. Procedure

```
S0  Classify seed, log source            (§2)
S0a Audit the seed (class A)             (§3, before any variant is written)
S1  Extract family spec                  (B only; A uses the item as is)
S2  Scrub the spec                       (B only)
S3  Generate from the spec               (fresh context that has never seen the source, for B)
S4  Divergence checks                    (B: against the source; A: against original and siblings)
S5  Enter the AQP pipeline               (Phases 2-6, mapping in §5)
S6  Label originals, then check heirs    (§6)
S7  Record provenance                    (§7)
```

### S0a. Audit the seed first (class A)
Run the same checks on the seed that its variants will get: sympy recompute of the key and every distractor
value, then the two-model blind solve and rationale audit (AQP §9). Pilot result (2026-09-30,
`calc-ab-pilot-2026-09-30/PILOT_REPORT.md`): 6 of 8 published seeds had distractor rationales that do not produce
their shown values, while all keys were right; the review record for those seeds was mostly single-reviewer
approvals and owner remediation approvals, and nothing in that flow re-derives distractor rationales. So:
- A seed with a key defect or a rationale defect is **repaired first** through the owner-remediation path (new
  version, never an in-place edit). Variants are written from the repaired seed, never the defective one.
- A seed that cannot be repaired is dropped as a seed; do not copy its distractor pattern into variants.
- Approval status of a seed (human-reviewed, published, validated) does not exempt it. Doing this audit only for
  seeds actually used, rather than sweeping the whole library, is deliberate: it folds the audit into work that is
  already happening. Record which seeds were audited and the outcome in the batch manifest.

### S1. Extract the family spec (class B)
One spec per *family*, not per problem. Fields:
`topic_code` (verified against the taxonomy, OMP §6.1), `skill_code`(s), task verb, structural features,
2-4 typical misconceptions each described as an *error pattern* ("cancels a term rather than a factor")
and not as a specific wrong number, difficulty band, calculator mode, and the intended number of members.
The extractor is told to record patterns, never text. Spec prose is written fresh, not excerpted.

### S2. Scrub the spec
Mechanical and human. Reject the spec if it contains: any number from the source, any function
expression from the source, any quoted phrase of more than 3 words, any answer value, or any
choice/rubric wording. Also reject if the *structure is so specific* that it fixes the source's exact
instance (one removable point of a named type, a given context noun, a given coefficient pattern).
"Piecewise with one removable discontinuity" is a structure; the source's specific function is
expression. David (or a designated reviewer) signs the scrub for the first several uses; after that it
is spot-checked.

### S3. Generate from the spec
For class B, generation runs in a **fresh context that receives only the scrubbed spec, the AQP
fact-pack, and the topic**, never the source and never the extractor's working notes. The same
model or person must not both read the source and author the items. For class A there is no such
requirement: the seed is ours.
Generation follows AQP Phase 1 (authoring against the full fact-pack) and, for multiple members, the
Phase 5b rules: separate `content_items` with their own keys, numbers *and* context changed, same skill
and same misconception targets, correct-answer letters drawn at random, independent recomputation of every
answer (never parse the keyed text).

### S4. Divergence checks
- **Class A:** word-level Jaccard over stem plus choices below 0.7 against the original and every sibling
  (AQP Phase 5b). The Unit 1 run used this; it is the minimum.
- **Class B:** the same measure against the source problems, run **without storing the source**: the
  checking step is done by a person or an isolated job, and its output is only the similarity number.
  Add: no shared number set; no shared function; no shared distractor values. Any hit is a rewrite,
  not a tweak. Also compare against other family members: a family is meant to *test one skill*, not to
  repeat one instance.
- Record that this was a human/automated-by-similarity check, not proof of originality (as in the Unit 1
  README).

### S5. Enter the AQP pipeline
Everything generated by this protocol is an AQP draft: it needs Phase 2 structural QA, Phase 4 CED
conformance (two independent families, picked from the §3.2 menu), Phase 5 adjudication, and Phase 6 with
§9 independent re-derivation. Details in §5 below. Variants are never publishable "because their original
was".

---

## 4. Clean-room requirement, stated plainly

The Unit 1 batch used class-B packets for topic scope only and is fine on that footing. The next step
this protocol contemplates (using a *problem family* as a seed) is more exposed, so for class B seeds:

1. The person or model that reads the source writes only the spec.
2. A different context authors from the spec.
3. The divergence check in S4 runs against the source without copying it into the authoring context.
4. The record (S7) states which contexts saw which material.

If those conditions cannot be met, fall back to class C treatment: topic and skill scope only.

---

## 5. Cross-reference to the from-scratch authoring protocol

| Seeded protocol step | AQP / OMP section | Relationship |
|---|---|---|
| S0 class and rights | OMP §2, §3 | Adds the seed-class table; OMP's rules unchanged |
| S1-S2 spec | OMP §2 (what is free to use), §4 (category distinctions) | Operationalises "skill categories and structural devices are free"; nothing beyond that |
| S3 authoring | AQP §2 inputs, §2.1 pre-run questions, Phase 1, Phase 5b | Same inputs. §2.1 already asks the Product Owner *variants? how many?* and *which two checker models?*; ask both before a seeded run too |
| Randomized letters | OMP §6.2 | Unchanged; also applies to every variant |
| S4 divergence | AQP Phase 5b (near-duplicate <0.7) | Extended to source comparison for class B |
| S5 Phase 4 | AQP §3.2 (model menu), §4 | Unchanged. On seeded runs, prefer checkers from families that did not generate |
| S5 Phase 6 | AQP §9 | Unchanged and mandatory. In the Unit 1 run it found no wrong key but ~20 text defects |
| S5 after any patch | AQP Phase 6 | **Added:** a patched item is re-checked in full. Patching produced 3 new defects |
| S6 labels | DECISION-0066, serving-label protocol | See §6 |
| S7 provenance | AQP §7.1 (open gap) | Recorded in the batch README until the columns exist |
| Family concept (§7 below) | none yet | New; would extend AQP §7.1 |

---

## 6. Labeling seeded families

1. **Label the seed first** through the normal pipeline, before variants exist, or immediately after
   generation but before any variant is loaded or promoted. A seed with a wrong topic or unit gets fixed
   first (finding 4).
2. **Variants inherit only after a per-variant agreement check** (finding 5): three models blind-label each
   variant; a dimension is inherited when the majority agrees with the seed, otherwise that dimension is
   `held` for that variant. Units are the serving gate; the other dimensions may be held without blocking
   serving but the item then lacks that label.
3. **Skill and difficulty are provisional.** Skill can be promoted only with multi-model consensus on the
   seed; difficulty is coarse and should be treated as a band.
4. **Unit-boundary seeds are the highest risk** (1.1 vs 2.1). If models split on required units for the
   seed, resolve it explicitly (Product Owner decision) before generating the siblings.
5. Validated promotion follows DECISION-0066; a Product Owner waiver of human review must be recorded in
   the approval decision's note.

---

## 7. Open gap: nothing records family membership

There is no `family_id` or `derived_from_content_item_id`. Consequences: the serving path can put four
siblings in one session, mastery evidence from siblings looks independent, and a defect found in a seed
cannot be turned into a query for its descendants. Until AQP §7.1 lands, each batch's manifest
(`variants_manifest.json` in the Unit 1 folder is the pattern) is the only record. Recommendation (not a
decision): add provenance columns `derived_from_content_item_id` and `family_key`, and treat siblings as one
family for spacing and coverage. This needs a task; it is out of scope for this document.

---

## 8. Non-goals

- Not a route to ingest third-party problems, paraphrased or reshaped ("same shape, new numbers" from a
  class B/C problem is still derivative — OMP §2).
- Not bulk automated ingestion (OMP §7): every class-B seed is reviewed by a person.
- Not a change to the review, publish or labeling gates. It generates drafts; the existing gates decide.
- No legal opinion. The classification and scrub are operating rules, not a determination that any
  particular use is lawful; ambiguous sources are treated as more restricted.

## 9. Worked reference

`scripts/content-seed/calc-ab-unit1-original-2026-09-29/` is the reference run for class-A variants
(102 variants of 34 originals) and for the label-inheritance check. It is *not* a reference for class-B
seeding, because it predates the clean-room requirement (finding 8). Reports: `MATH_CHECK_REPORT.md`,
`CED_CONFORMANCE_REPORT.md`, `LABEL_INHERITANCE_SPOT_CHECK.md`, `LABELING_REPORT.md`,
`PUBLICATION_RECORD.md`.

## 10. Variant-run status by subject (as of 2026-10-03)

"Run" means the class-A procedure: S0a seed audit, variants written, blind solve and rationale audit by two checkers from different families, CED scope check, label check. Status below is from the approval and activity logs on `main` and read-only Production queries on 2026-10-03. It replaces the 2026-10-01 table, which was written before the other runs of 2026-10-02 landed.

| Subject | Variant-run status | Detail | Records |
|---|---|---|---|
| AP Calculus AB | **Run, partly continuing** | Unit 1 complete (34 originals, 102 variants, published, `APPROVAL-0065`); Units 1-8 sampled with one seed each plus Unit 3 (24 sampled variants published). 2026-10-02: Units 2-3 pilot started after a read-only readiness pass; S0a audit of the 12 Unit 2-3 seeds found 0 key defects and 1 weak rationale (`026` choice C); seed fixes under `APPROVAL-0083` (originally numbered 0071). The outcome of the Units 2-3 variants is not recorded in the files this entry was written from. Still open: re-check the 24 sampled variants against the repaired seeds. | `calc-ab-*` folders under `scripts/content-seed/`; `APPROVAL-0065`, `0066`, `0082`, `0083` |
| AP Biology | **Run twice, two sets, overlapping** | (a) This session's pilot: 8 seeds, 16 variants (`apbio-mcq-sv-...` keys), fully checked, **not in any database**. (b) A separate 2026-10-02 run: 9 Unit 1-2 seeds, 30 drafts, 24 **published** (`APBIO-MCQ-SV-<seed>-v1..v3` keys, `APPROVAL-0080`); 6 dropped. The two sets cover the same seeds and in several cases the same idea. Seven of the published variants used terms the 2026-10-01 CED-vocabulary ruling excludes and were **retired on 2026-10-03** (`APPROVAL-0091`); 17 remain published. Units 3-8 not run. | `scripts/content-seed/apbio-seeded-pilot-2026-09-30/`; `APPROVAL-0067`, `0068`, `0079`, `0080`, `0091` |
| AP Chemistry | **Run for Units 1-3** | Full pipeline from scratch on 2026-10-02: 8 seeds repaired, 75 variant drafts, 72 loaded and published (`APPROVAL-0075`); the 3 `007` variants held for a CED-scope concern; seeds `007` and `028` have an open CED-scope question. Units 4+ not run. | `APPROVAL-0074`, `0075` |
| AP Statistics | **Run for Units 1-3** | 2026-10-02: 4 rationales repaired as version 2, 132 variants loaded as drafts (`APPROVAL-0077`) and 131 published (`APPROVAL-0078`); 1 variant held as a draft; 8 items on CED-removed topics retired. Units 4+ not run. | `APPROVAL-0076`, `0077`, `0078` |
| AP Calculus BC | **Needs a run** | None. Shares a fact pack with AB; run S0a on BC-only units first. | none |
| AP Physics 1 | **Needs a run** | None. | none |
| AP Physics 2 | **Needs a run** | None. | none |
| AP Physics C: E&M | **Needs a run** | None. | none |
| AP Physics C: Mechanics | **Needs a run** | None. | none |
| AP Precalculus | **Needs a run** | None. | none |

FRQs have had no seeded-variant run in any subject. Two things the table shows that earlier versions missed: runs on different subjects and on the same subject were happening in parallel sessions, and a subject's run can be published without the other session knowing about drafts from an earlier one. Before starting a run, read this table, the approvals log and Production (`content_key ilike '<prefix>-sv-%'`) so a run does not duplicate an existing set.

### Before starting a run on a new subject
1. **Read the subject's CED fact pack and its exclusions first**, and list them in the batch README. Packs exist for every subject in `docs/product/*_CED_FACT_PACK.md`; they are topic-level, so check any term you are unsure of against the CED itself (the AP Biology run found the pack already matched the CED).
2. **Run S0a on the seeds before writing variants.** In Calc the seeds were clean on keys and the defects sat in variants and rationales; in Biology 1 of 8 seeds had a defective rationale and, after the CED check, 5 of 8 depended on terms the CED does not name. Expect seed repairs.
3. **Keep items to CED vocabulary** (Product Owner ruling, 2026-10-01). A mechanism the stem supplies does not make a term in scope. If a seed needs a term the CED lacks, the seed is the thing to repair, through the owner-remediation path, before variants are built from it.
4. **Reuse the Biology scripts as templates** (`scripts/vercel-gateway-check/apbio_seeded_math_check.mjs`, `apbio_seeded_ced_check.mjs`, `apbio_seeded_label_probe.mjs`); each carries a subject role, the fact pack, and a difficulty rubric that must be changed. Math-heavy subjects also need a symbolic recompute of every key and distractor value, as in the Calc pilots.
5. **Run the label probe on drafts**, not only on the final set; it caught unit drift in Biology and costs about a cent per item.
6. **Keep two checkers from different families.** In both subjects most real defects beyond keys were found by DeepSeek alone, and it also over-flags scope; adjudicate every flag against the CED text, never by vote.
