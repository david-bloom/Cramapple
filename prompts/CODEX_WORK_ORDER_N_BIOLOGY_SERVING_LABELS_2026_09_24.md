# Codex Work Order N — AP Biology Serving Labels for the 43 Unlabelled Short FRQ

**Why this is now the top of the queue.** Biology serves **41 of its 118 published items**. The
single largest cause is that **43 short FRQ have never had a serving label** — the 2026-08-04/08 run
covered MCQ and long FRQ and stopped there. Without a serving label an item cannot be selected for a
student under any circumstances. This work order is the largest single unblock available.

Paste the block below into Codex.

```text
Work order N — author SERVING labels for the 43 AP Biology short FRQ that have none.

Merge main first. Several Biology migrations landed today (M0–M4, M2.1, M2.2) and the launch
readiness assessment explains why this work order exists:

    git fetch origin
    git merge origin/main
    # read: docs/product/AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md

WHAT A SERVING LABEL IS, AND WHAT IT IS NOT

TAXONOMY_LABELING_PLAN_V3 §7a (T9) splits the label layer in two, and they are not interchangeable:

  SERVING  (this work order)  required_units[], max_required_unit
           "What must a student have covered to ANSWER this item?"
           Derived from every criterion's prerequisite units. Unit granularity (8 units).

  COVERAGE (NOT this work order) assessed_topics[]
           "What does this item COUNT TOWARD?" Topic granularity (61 topics).

Do not output assessed_topics. Biology's coverage labels already exist in Production as
provisional_model and are governed by DECISION-0062. Touching them is out of scope.

The governing rule, quoted from the existing generator:

  A unit is required if a student who has not covered that unit could not earn full credit —
  evaluated criterion by criterion against the rubric.

  Decide from the rubric, not from what the question is broadly "about."
  Scenario dressing that earns no credit is not required.
  primary_unit is the teaching home only and is NOT a serving gate.

REUSE THE EXISTING GENERATOR. scripts/taxonomy/extend_math_serving_labels.mjs already implements
this: the two-model lane, the packet builder, the criterion-by-criterion rule, the rubric preflight,
and the JSON output shape. Extend it to AP Biology rather than writing a new one. If you conclude a
new script is genuinely better, say why in the summary — do not just fork it silently.

THE 43 ITEMS. All are AP Biology, published, frq_form='short', and have zero current serving labels.
Derive the list yourself and assert it comes to 43:

  select ci.content_key, civ.id as content_item_version_id
  from app.content_items ci
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.content_item_versions civ on civ.content_item_id = ci.id
  where ep.exam_code = 'ap_biology' and civ.status = 'published'
    and not exists (select 1 from app.content_taxonomy_labels l
                    where l.content_item_id = ci.id and l.label_scope = 'serving'
                      and l.superseded_by is null);

If that returns anything other than 43, STOP and report — it means Production moved under you.

WHAT TO PRODUCE, per item:

  content_key, content_item_version_id
  required_units[]            integers 1-8, ascending, no duplicates, non-empty
  max_required_unit           = max(required_units); the selector gates on this
  primary_unit                teaching home (nullable); records intent, gates nothing
  criterion_units             per criterion_key: the units that criterion requires, and one
                              sentence of evidence quoting the criterion. This is T7's per-unit
                              justification and it is not optional.
  rubric_preflight            {status: pass|fail, notes}
  model_a / model_b           each model's independent required_units
  agreement                   exact | differs
  needs_human                 true when the models differ, when the item is multi-unit, or when
                              you are not confident
  confidence                  high | medium | low

TWO MODELS, INDEPENDENTLY. T9's serving lane is automatable precisely because two-model unit
agreement measured 16/18 (89%). That number is the justification for this lane existing, so the
second model is the work order, not a nicety. Run both blind to each other and record both.

Note the design has NO TIEBREAKER — agreement is unanimity of two, so a correlated error has no
third vote. That is why every multi-unit item routes to needs_human even when the models agree:
both pilot unit-level splits were multi-unit boundary calls.

CONTEXT THAT WILL HELP AND SHOULD NOT MISLEAD YOU

  - 42 of the 43 now carry a coverage topic from work order topic-tagging (the 43rd, S-071, is
    held). You may read it as a signal. You may NOT derive required_units from it: an item ASSESSING
    topic 2.7 can REQUIRE units 1, 2 and 3 to answer. T9's own example is APBIO-FRQ-L-017, which
    requires units 1-4 but assesses signal transduction.
  - None of the 43 carry prompt_json.subtopics, so there is no author prose to lean on. The rubric
    and stem are the evidence.
  - 4 of the 43 are currently held out of the canonical migration (S-021, S-023, S-058, S-101).
    Label them anyway — a serving label is about the question, not the answer.

DO NOT WRITE TO PRODUCTION. Proposal only, as JSONL plus a SUMMARY.md, under
docs/research/apbio_serving_labels_2026_09_24/. Claude applies it after independent QA, and Claude
computes validated_against_taxo_hash at apply time — do not attempt to compute or supply it.

ONE THING THAT WILL BITE IF YOU DO NOT KNOW IT. The serving selector requires
    label.validated_against_taxo_hash = app.taxonomy_relevant_hash(version_id)
and that hash covers stem, stimulus, prompt_json, canonical_answer_1/2, mcq_choices and
frq_criteria. It fails SILENTLY — a mismatch just returns fewer rows, never an error. This is
exactly how 28 Biology items dropped out of serving earlier today without anything reporting it. So:
label against the CURRENT published version, record which content_item_version_id you labelled, and
do not edit any content field while doing it. If content changes after you label, the label is dead
on arrival.
```

## Addendum — answers to Codex's four questions, and one thing the original order got wrong

Paste this with N and N.1.

```text
Work order N — addendum. All four of your questions are resolved below; every suggested correction
is accepted. One of your challenges is right and is now backed by evidence from today.

FIRST, SOMETHING THE ORIGINAL ORDER DID NOT TELL YOU, because I did not know it when I wrote it.

Authoring these labels will NOT, by itself, make a single item servable. Two facts found after the
order was written, by building a standing check and calling the real functions instead of reading
them:

  * public.select_unit_gated_practice_items requires label_status = 'validated'. AP Biology has
    ZERO validated serving labels, so that path returns 0 items at every unit. Across all ten
    subjects it serves 8 items total -- 4 Calculus AB, 4 Calculus BC.
  * public.select_practice_frqs -- the path students actually get Biology content through today --
    requires no taxonomy label at all. It returns 71 Biology FRQ and your work will not change that
    number either way.

So work order N is necessary and not sufficient. Your labels will land as provisional_model and will
serve nothing until a separate decision promotes serving labels to 'validated'. That is a Product
Owner question, not yours and not mine. Knowing it should change nothing about how you label -- but
you should not be told your work unblocks serving when it does not.

1. DISAGREEMENT VS THE SCHEMA. Adopt your proposal exactly: on disagreement, keep both model
   outputs, set required_units: [], max_required_unit: null, needs_human: true. You spotted a real
   contradiction in my spec. Empty-and-null is also the shape Production already uses for this: the
   6 held Biology serving labels carry empty required_units and null max_required_unit, and the
   serving selector excludes them on max_required_unit being null. So a disagreement row is
   inert by construction rather than by convention.

2. MCQ HAVE NO CRITERION KEYS. Agreed, and you are right that inventing them would violate T9.
   criterion_units: null, plus item_evidence covering the keyed-answer justification and the
   distractor refutations. That is also what the existing generator's own rule already says for MCQ:
   "against the keyed answer and each distractor refutation."

3. MODEL PAIR. Keep gpt-5.5 + gemini-2.5-flash exactly. Not because that pair is best, but because
   the 89% figure was measured on it -- changing the pair would silently invalidate the only
   measurement this lane's existence rests on. Record each model's full preflight, unit set,
   criterion mapping and uncertainty, not just required_units: that is precisely what lets QA check
   your reasoning without re-deriving it, and re-deriving it would make QA the author.

4. BRANCH. Yes. Branch codex/work-order-n-biology-serving-labels from freshly fetched origin/main,
   commit and push there. Same as project2.

EVERY SUGGESTED CORRECTION IS ACCEPTED. Notes on four of them:

  * The scope query fix is correct and you should make it -- but be aware it does not change the
    item set. I ran all three forms: any-published-version, latest-version-published, and
    latest-version-published AND frq_form='short'. All return the same 43 items, and zero Biology
    items are dropped for having a draft as their latest version. My query was right by coincidence
    on this data, not by construction. Make the fix so it stays right; do not expect a different
    list, and if you get one, stop and report.
  * Widening the U3 audit to every current unsuperseded Biology serving label across MCQ and FRQ is
    better than what I asked for. Do that.
  * primary_unit: preserving an intentional null is right. Substituting the first required unit
    fabricates a teaching home nobody chose, and a fabricated value is worse than a null because it
    looks decided.
  * The proposal-only scoped mode matters more than it sounds. A dry run that still emits
    application SQL and legacy report files produces artifacts that look applicable, and somebody
    eventually applies one. Scope it.

YOUR CHALLENGE IS RIGHT, AND TODAY SUPPLIES THE EVIDENCE.

You wrote that two-model agreement is evidence, not validation, and that n=18 is thin. Agreed. What
makes it more than a methodological quibble: QA today rejected four Biology MCQ serving labels, and
three of them are the SAME error -- apoptosis, IP3/PKC signal transduction and TSH/T3 feedback all
labelled Unit 3 Cellular Energetics when they belong to Unit 4 Cell Communication and Cell Cycle.

That is a correlated conceptual error, not three independent slips. Two models sharing a
misconception about where cell signalling lives would agree with each other and both be wrong, and
unanimity-of-two has no third vote to catch it. So agreement is weakest exactly where this corpus
has already failed.

Your routing -- every multi-unit item, every disagreement, every low-confidence result and MCQ-088
to human review, and the single-unit agreement set made easy to sample -- is the right response.
Add one thing: flag any item whose agreed label is Unit 3, so QA can sample that band deliberately
rather than at random. That is the band where the known failure lives.
```

## Work order N.1 — 5 MCQ serving labels QA rejected

Paste this alongside N; same directory, same output shape.

```text
Work order N.1 — re-derive 5 AP Biology MCQ serving labels that QA rejected.

Same method and same output format as work order N. Five items, and four of them share one cause.

Claude's QA is in docs/research/apbio_mcq_serving_label_qa_2026_09_24/qa_report.md. Read it, but
DERIVE THE LABELS YOURSELF from the current stem, choices and keyed answer. The proposed units below
are QA's reading, recorded so you can disagree with a reason -- they are not the answer.

  APBIO-MCQ-030   labelled {3}    apoptosis vs necrosis, sculpting interdigital spaces
  APBIO-MCQ-033   labelled {3}    IP3 receptor, Ca2+ release, PKC activity
  APBIO-MCQ-046   labelled {3}    TSH/T3 negative feedback with a pituitary adenoma
  APBIO-MCQ-025   labelled {2,8}  ADH -> AQP2 -> osmosis in the collecting duct
  APBIO-MCQ-088   labelled {7}    Hamilton's rule and altruism

The first three are one systematic error, not three slips: cell-signalling and cell-cycle content
labelled Unit 3 (Cellular Energetics) when U3 is energetics and U4 is Cell Communication and Cell
Cycle. Check whether the same confusion reaches any OTHER Biology item already carrying U3, and
report the count either way -- finding none is a result worth having.

MCQ-025: U2 (Cells) looks right for aquaporin-mediated osmosis; the U8 (Ecology) tag is the part QA
could not justify, since the item is organismal physiology.

MCQ-088 is a genuine boundary call -- kin selection is taught under Natural Selection (U7),
behaviour under Ecology (U8). Decide it, with reasoning, and mark needs_human=true either way.

All five are currently NOT servable, so there is no rollback risk and no hurry-driven shortcut worth
taking here.
```

## What Claude does in parallel

Not waiting on this. The other half of the serving gap is **24 MCQ whose serving label carries a
hash that predates today** — they already have authored `required_units`, so they need diagnosis and
re-anchoring rather than authoring. That is QA-shaped work and is mine, and it is independent of
work order N.

## The launch arithmetic

| | Items |
| --- | ---: |
| Servable before this work | 41 |
| + the 20 MCQ, QA'd 2026-09-24: 15 accepted and re-anchored | 56 *(done)* |
| + work order N.1 (the 5 MCQ QA rejected) | 61 |
| + work order N (43 short FRQ) | **104** |
| Remainder: 14 held with no `required_units` | 118 |

**104 of 118 is the realistic ceiling**, and work orders N and N.1 are the whole remaining path.
The 14 held items carry empty `required_units` by decision, not by omission, and include the 4
hand-drawn items that are excluded from text serving anyway.
