# Codex Queue — 2026-09-24 (J.0 → N → N.1)

One paste, three work orders, in order. Each has a QA gate before the next starts.

**Read this before dispatching.** None of these three changes what a student can be served at
launch. AP Biology launches on the **practice path** (DECISION-0063), which serves 71 `targeted_drill`
FRQ and requires no taxonomy label and no difficulty value. J.0 unblocks a written migration; N and
N.1 unblock the unit-gated path, which is dark for eight of ten subjects. They are the right work —
they are just fast-follow, and calling them launch work would be wrong.

---

```text
Codex queue, 2026-09-24. Three work orders, strictly in order: J.0, then N, then N.1.

Merge main first. A lot landed today and two facts below will change how you read your own results.

    git fetch origin
    git merge origin/main
    # read, in this order:
    #   docs/product/AP_BIOLOGY_FAST_FOLLOW.md          -- the launch decision and what it accepts
    #   docs/product/AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md   -- including its own correction
    #   prompts/CODEX_WORK_ORDER_N_BIOLOGY_SERVING_LABELS_2026_09_24.md  -- N, N.1 and the addendum

TWO FACTS THAT FRAME ALL THREE

1. AP Biology launches on the PRACTICE path (public.select_practice_frqs). That function requires no
   taxonomy label and reads no difficulty value. Nothing you produce in this queue changes what a
   student is served on 2026-09-24. Do not optimise for speed at the cost of correctness on the
   theory that something is shipping behind it -- nothing is.

2. The unit-gated path (public.select_unit_gated_practice_items) requires
   label_status = 'validated'. AP Biology has zero validated serving labels, so it serves 0 items;
   across all ten subjects it serves 8. Your N/N.1 labels will land as provisional_model and will
   serve nothing until a separate Product Owner decision promotes them. That decision is not yours
   and not Claude's, and it is not blocked by you.

=== ORDER 1 of 3 — J.0 (also tracked as FF-6): AP Biology difficulty regeneration ===

The full specification is unchanged and lives in
prompts/CODEX_PROJECT_3_ALIGNMENT_AND_DIFFICULTY_2026_09_23.md, section "J.0 -- Biology, and do this
one FIRST". Read it there; it is complete and this order does not amend it. In summary:

  Re-run the existing calibrated method for Biology (assign_difficulty.py and
  finalize_assignments.py, validated at 12/16 against hand-verified points) and emit what it
  currently discards: attainment_ratio, ratio_source, subject_cut_points, and basis mapped to
  'calibrated_task_verb' / 'calibrated_judgement'.

  Expect an 81/37 split -- 81 items with a reconstructable ratio, 37 with none even in principle.
  Leave those 37 null. Do not manufacture a number: a fabricated ratio is worse than a missing one
  because it looks re-derivable and is not.

  Do NOT re-band. If your re-run produces a band that differs from the committed assignment for any
  item, STOP and report it. A changed band means the method is not reproducing, which is a finding
  worth more than a silent correction.

WHY THIS IS FIRST, and the reason is narrower than "difficulty matters":
supabase/migrations/20260924150000_content_item_difficulty.sql is already written and applied to
Production as an EMPTY store. It is the only migration in the Biology set still waiting on an input.
Nothing reads difficulty at serving time today -- grep confirms difficulty_label appears only in
review-decision, review-queue and content-intake, all reviewer surfaces. So J.0's value is
unblocking a written migration and enabling difficulty targeting later, not changing anything a
student sees now. That is a good enough reason to do it first; it is not a reason to rush it.

GATE: stop after J.0 and hand back. Claude QAs it and applies M3's data load. Do not start N until
that QA reports.

=== ORDER 2 of 3 — N: serving labels for the 43 unlabelled Biology short FRQ ===

Full order, plus the addendum answering your four questions and accepting every correction you
proposed, is in prompts/CODEX_WORK_ORDER_N_BIOLOGY_SERVING_LABELS_2026_09_24.md. All of it stands.
The points you raised are resolved there, including:

  - disagreement rows: keep both model outputs, required_units: [], max_required_unit: null,
    needs_human: true
  - MCQ: criterion_units null, plus item_evidence covering the keyed answer and distractor
    refutations
  - model pair: keep gpt-5.5 + gemini-2.5-flash, because the 89% figure was measured on that pair
  - branch: codex/work-order-n-biology-serving-labels from freshly fetched origin/main
  - your scope-query fix is correct and should be made, but it returns the same 43 items; if you get
    a different list, stop and report
  - your challenge to the two-model lane is accepted, and today supplied evidence for it: three of
    four rejected Biology MCQ labels were the SAME error, U3 vs U4. Flag every agreed Unit 3 label
    so QA can sample that band deliberately.

GATE: stop after N and hand back for QA before starting N.1.

=== ORDER 3 of 3 — N.1: the 5 MCQ serving labels QA rejected ===

Also specified in that same file. Five items: APBIO-MCQ-025, -030, -033, -046, -088. Derive them
yourself from current stem, choices and keyed answer; QA's proposed units are recorded so you can
disagree with a reason, not so you can copy them.

While you are there, widen the U3 audit as you proposed -- every current unsuperseded AP Biology
serving label, MCQ and FRQ -- and report the inspected count and candidates either way. Finding none
is a result worth having.

=== APPLIES TO ALL THREE ===

Proposal only. No Production writes in any of the three. Claude QAs each and applies.

One thing that will bite if you do not know it. app.taxonomy_relevant_hash() covers stem, stimulus,
prompt_json, canonical_answer_1/2, mcq_choices and frq_criteria, and the serving selector requires an
exact match on it. It fails SILENTLY -- a mismatch returns fewer rows, never an error. That is how 20
MCQ sat unservable for six weeks and how 28 more dropped out this morning. So: never edit a content
field while labelling, always record which content_item_version_id you worked against, and if
content moves under you, say so rather than proceeding.
```

## Sequencing rationale

| Order | Unblocks | Changes launch-day content |
| --- | --- | ---: |
| **J.0 / FF-6** | M3's data load — the one written migration still waiting on an input | No |
| **N** | FF-3, the unit-gated path (43 of the items it needs) | No |
| **N.1** | FF-3 (5 more), plus closes a QA rejection | No |

J.0 goes first because it is the only one with a migration written and waiting behind it, not
because difficulty is more valuable than serving labels.

**If you want Codex on something that does move launch-day content**, the candidates are FF-1 (make
the 43 MCQ reachable — but FF-13, the `mcq_choices` answer-key exposure, must land first or with it)
and FF-2 (confirm whether any surface offers `full_exam_frq`, which currently returns an empty
queue). Neither is in this order.
