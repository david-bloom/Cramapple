# AP Biology CED-conformance — same 20 items, DeepSeek v3.2, 2026-08-06

**Status:** Prototype experiment, read-only. Companion to
`APBIO_CED_CONFORMANCE_SAMPLE20_2026_08_06.md` (Haiku, same 20 items, same
prompt, same fact pack). Run to test whether a second, independent model
family agrees with Haiku or reveals different failure modes — not to decide
which model is "right" by majority.

## Result: 19/20 succeeded (1 schema error), 14 flagged, 5 clean

DeepSeek runs far hotter than Haiku: **14 of 19 items flagged
`contains_out_of_scope_content`**, versus Haiku's 6 of 20. Agreement across
the two models: **12/20 (60%)**.

| content_key | Haiku | DeepSeek | Match |
|---|---|---|---|
| APBIO-MCQ-002 | fully_in_scope | contains_out_of_scope_content | DIFF |
| APBIO-MCQ-099 | contains_out_of_scope_content | contains_out_of_scope_content | same |
| APBIO-MCQ-027 | fully_in_scope | fully_in_scope | same |
| APBIO-FRQ-L-006 | fully_in_scope | ERROR (schema) | DIFF |
| APBIO-MCQ-054 | fully_in_scope | contains_out_of_scope_content | DIFF |
| APBIO-MCQ-022 | fully_in_scope | fully_in_scope | same |
| APBIO-FRQ-L-029 | contains_out_of_scope_content | contains_out_of_scope_content | same |
| APBIO-FRQ-S-061 | fully_in_scope | fully_in_scope | same |
| APBIO-MCQ-093 | fully_in_scope | contains_out_of_scope_content | DIFF |
| APBIO-FRQ-L-015 | contains_out_of_scope_content | contains_out_of_scope_content | same |
| APBIO-FRQ-L-026 | fully_in_scope (wrong) | contains_out_of_scope_content | DIFF |
| APBIO-FRQ-L-014 | contains_out_of_scope_content | contains_out_of_scope_content | same |
| APBIO-FRQ-L-041 | fully_in_scope | fully_in_scope | same |
| APBIO-FRQ-L-008 | fully_in_scope | contains_out_of_scope_content | DIFF |
| APBIO-FRQ-L-001 | contains_out_of_scope_content | contains_out_of_scope_content | same |
| APBIO-FRQ-L-009 | contains_out_of_scope_content | contains_out_of_scope_content | same |
| APBIO-HDG-2026-GRAPH-011 | fully_in_scope | fully_in_scope | same |
| APBIO-HDG-2026-GRAPH-012 | fully_in_scope | fully_in_scope | same |
| APBIO-MCQ-024 | fully_in_scope | contains_out_of_scope_content | DIFF |
| APBIO-MCQ-023 | fully_in_scope | contains_out_of_scope_content | DIFF |

## The one item that mattered most: DeepSeek caught Haiku's miss

`APBIO-FRQ-L-026` — the known-bad item Haiku incorrectly cleared last run —
was correctly flagged here: DeepSeek's `out_of_scope_concepts` list is
effective population size, purging hypothesis, MVP, genetic rescue, MHC
alleles, allelic richness — the same cluster both models caught in the
original 8-item run. This is a genuine independent catch of a real defect the
other model missed on this pass. That's the argument *for* multiple families.

## But DeepSeek has its own systematic bias, not random noise

Spot-checking DeepSeek's flags against the fact pack directly shows a
different, and equally real, failure mode from Haiku's hallucinated
citations: **DeepSeek treats any specific named example, technique, or term
not appearing verbatim in the fact pack as out-of-scope — even when it
explicitly cites the correct EK covering the general principle in the same
breath.**

- `APBIO-MCQ-093` (sea otters / kelp / trophic cascade): flagged because
  "the specific terms 'trophic cascade' and 'keystone species' are not
  explicitly listed in the fact pack." **This is false** — checked directly:
  "trophic cascades" is named at line 974 (EK 8.5.B.3) and keystone species
  is defined at EK 8.6.B.1, both confirmed in the earlier session. DeepSeek's
  own reasoning even says "the underlying concepts... are in scope" one
  sentence before flagging it anyway.
- `APBIO-MCQ-002` (amylase/starch/iodine test): flagged because "amylase,"
  "starch," "iodine test" aren't named verbatim, despite DeepSeek's own
  reasoning stating the tested principle (enzyme-substrate shape
  complementarity, EK 3.1.A.2) is squarely in scope. Naming a specific enzyme
  as an illustrative application of an in-scope mechanism is normal exam
  construction, not a scope violation — this is very likely a false positive.
- `APBIO-MCQ-054` (snapdragons/incomplete dominance), `APBIO-MCQ-024`
  (membrane fatty-acid saturation), `APBIO-MCQ-023` (membrane protein
  classification), `APBIO-FRQ-L-008` (water potential equation, explicitly
  named in the CED as a **Relevant Equation** per the source CED read earlier
  in this session) all show the same pattern: the general principle is
  in-scope by DeepSeek's own admission, but a specific illustrative example,
  standard named phenomenon, or explicitly-provided equation gets flagged
  anyway.

This isn't the same error as Haiku's. Haiku's L-026 miss was a hallucinated
citation (it invented EK coverage that doesn't exist). DeepSeek's pattern
looks like a miscalibrated strictness threshold — conflating "not verbatim in
a necessarily condensed fact pack" with "outside the course" — which would
produce a high false-positive rate if trusted as-is.

## Reading this alongside the Haiku run

Two independent model families agree on only 60% of verdicts, and each has a
*different, identifiable, systematic* bias rather than random error: Haiku
under-flags via hallucinated scope justification; DeepSeek over-flags via
verbatim-matching over-strictness. Neither converges toward the other with
more calls, because the disagreement isn't noise — it's two different
consistent misreadings of the same fact pack. This matches exactly what was
raised before running this: repetition doesn't buy quality when errors are
systematic rather than independent draws; the value of a second family here
was catching one specific miss (`L-026`), not producing a trustworthy
combined verdict on the other 7 disagreements, which still need a human or a
third read to adjudicate.
