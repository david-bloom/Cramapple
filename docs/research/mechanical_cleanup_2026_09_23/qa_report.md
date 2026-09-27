# QA Report — Work Order I (Mechanical Cleanup)

**Disposition: ACCEPTED.** Both proposals are correct, both escalate the right decision rather than
making it, and I's `rubric_type` analysis answers a question two later work orders were about to ask
again.

No findings against I. One finding **against my own Project 3 charter**, which I's scoping exposed.

This line is the DECISION-0055 independent cross-model QA gate for work order I.

- **QA model:** Claude Opus 5 (non-OpenAI, independent of the Codex builder), 2026-09-24
- **Production:** `pcntajvbdfqhbeewmdry`, read-only throughout.

## I.1 — point totals

**10 items, verified independently against Production:** 9 AP Biology (`APBIO-FRQ-L-004`, `-006`,
`-012`, `-013`, `-015`, `-016`, `-017`, `-019`, `-021`) all stating `total_points = 8` against a
rubric summing to 9, plus `apchem-frq-l-012` stating 10 against a sum of 9. That matches the work
order's expectation exactly.

The 9 Biology items share the identical rubric shape `a=1; b=3; c=3; d=2`, which I records — one bad
authoring template rather than nine independent errors, as the work order predicted.

**I framed the decision correctly.** Rather than picking a number it proposes
`remove_prompt_json_total_points` with `set_prompt_json_total_points_to_rubric_sum` as the
alternative, and carries the runtime evidence that decides it: *"evaluate-attempt sums
`frq_criteria.points_possible`; no runtime reads `prompt_json.total_points`."* That is the question
the work order said to answer — not "which number is right" but "should this field exist at all" —
and it is escalated as `open_product_owner` rather than resolved.

## I.2 — `rubric_type`, and the finding it produces

206 rows, and the important column is `behavior_change`: **every one reads "none; proposal
materializes the route already selected by prompt metadata or item-type fallback."** Split by
`routing_basis`:

- **118 items** — `prompt_json mirror`: the typed `rubric_type` column is null while
  `prompt_json.rubric_type` carries a value the router already uses.
- **88 items** — `published item_type fallback made explicit`: neither carries a value and the
  router's item-type fallback resolves it.

So the honest answer to GAP-3 is that **the nulls are latent, not live**: the routing is already
correct on all 206, and the proposal only writes down what the router already concludes. That is
precisely the shape of finding the work order asked for — establish the runtime behaviour first,
propose values only where the fallback resolves wrongly — and I reached it without being pushed.

I also correctly deferred the adjacent question: whether quantitative FRQ should later migrate from
`discrete_text` to `structured_formula` once the symbolic verifier is wired. Its recommendation —
*"do not combine that behavior change with this mechanical null backfill"* — is right.

## A finding against Project 3's work order L, not against I

`CODEX_PROJECT_3_ALIGNMENT_AND_DIFFICULTY_2026_09_23.md` work order L presents a table of
`rubric_type` nulls totalling roughly 500 FRQ and calls GAP-3 understated. **That table counts
`prompt_json.rubric_type`. I counted the typed `content_item_versions.rubric_type` column.** They are
different fields and they diverge — I's own packet shows **118 items where the typed column is null
while `prompt_json` carries a value**.

Two consequences:

1. **L would send Codex to redo differently-scoped work** that I has already completed and that QA
   has now accepted, and it would very likely reach the same conclusion — no behaviour change.
2. L's framing ("essentially every non-spatial FRQ has a null `rubric_type`") is true of the
   `prompt_json` mirror and misleading about the field the router reads first.

L is being narrowed to the residue I did not cover, with I's conclusion carried forward as the
starting point rather than rediscovered. **This is my error in the charter, not a defect in I** — and
it is the exact failure mode Project 3's own closing section warns about: a work order whose checks
would pass while the underlying purpose is already satisfied elsewhere.

## What this disposition does and does not authorise

**Does:** satisfies DECISION-0055's independent cross-model QA gate for work order I.

**Does not:** apply anything. Both proposals need Product Owner decisions:

- **I-001** — remove `prompt_json.total_points` from these 10 versions (I's recommendation, and the
  runtime evidence supports it), or align it to each rubric sum.
- **I-002** — deferred by I, correctly: `structured_formula` migration is a behaviour change and
  belongs with the symbolic verifier, not with a null backfill.
