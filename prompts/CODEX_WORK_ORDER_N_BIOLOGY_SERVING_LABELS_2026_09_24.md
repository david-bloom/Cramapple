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

## What Claude does in parallel

Not waiting on this. The other half of the serving gap is **24 MCQ whose serving label carries a
hash that predates today** — they already have authored `required_units`, so they need diagnosis and
re-anchoring rather than authoring. That is QA-shaped work and is mine, and it is independent of
work order N.

## The launch arithmetic

| | Items |
| --- | ---: |
| Servable now | 41 |
| + work order N (43 short FRQ) | 84 |
| + the 24 MCQ re-anchor | **108** |
| Remainder: 6 held with no `required_units`, 4 hand-drawn | 118 |

**108 of 118 is the realistic ceiling for launch**, and the two workstreams above are the whole path
to it.
