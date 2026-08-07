# AP Chemistry CED-conformance — random 20-item sample, Haiku + DeepSeek, 2026-08-06

**Status:** Prototype experiment, read-only. Same blind methodology as the AP
Biology (`APBIO_CED_CONFORMANCE_SAMPLE20_2026_08_06.md`,
`APBIO_CED_CONFORMANCE_SAMPLE20_DEEPSEEK_2026_08_06.md`) and AP Physics runs.
Chemistry was chosen as the second subject to run because, per the earlier
fact-pack survey, it's the only other subject with comparable checkable depth
to Biology: a "High-risk exclusion boundaries" section
(`docs/product/AP_CHEMISTRY_CED_FACT_PACK.md:115-143`, 15 explicit
do-not-assess statements) rather than a bare topic-title list. 20 items
random-sampled from published AP Chemistry content (14 MCQ, 6 FRQ). Both
models ran on every item, same prompt, same fact pack.

## Result: 20/20 succeeded, 3 items flagged, all 3 grep-confirmed real

Chemistry came back far cleaner than Biology's 6/20 flag rate: **17/20 items
clean by both models, 3/20 flagged by at least one model** — and unlike the
biology run, every flag here checks out against a direct grep of the fact
pack, not just plausible-sounding reasoning.

| content_key | Haiku | DeepSeek | Confirmed? |
|---|---|---|---|
| apchem-frq-l-010 | contains_out_of_scope_content | contains_out_of_scope_content | Yes — real chemistry error in the rubric |
| apchem-frq-l-021 | fully_in_scope | contains_out_of_scope_content | Yes — Haiku rationalized past an explicit exclusion |
| apchem-sfrq-035 | fully_in_scope | contains_out_of_scope_content | Yes — Haiku rationalized past an explicit exclusion |

All other 17 items: both models `fully_in_scope`, no disagreement.

## Finding 1 — `apchem-frq-l-010`: real chemistry error, not just scope creep

Both models independently flagged this one, and it's worse than a scope
issue: criterion `e1` requires students to explain that **molten NaCl
conducts electricity via "mobile ion cores plus delocalized electrons."**
That's chemically wrong — molten ionic compounds conduct via ion mobility
alone; "delocalized electrons" is the metallic-bonding model, not the ionic
one, and mixing the two teaches an incorrect mechanism. Both models also
flagged genuine depth-creep beyond the CED's Unit 2/3 topic map: the
electron-sea model used to explain *malleability* specifically, substitutional
alloying and *dislocation motion* used to explain brass's hardness — none of
that mechanistic depth appears in the fact pack, which lists metallic
bonding/alloy structure (2.4) and general solid properties (3.2) but not a
hardness/dislocation mechanism. This item needs a rubric fix, not just a
scope trim — the factual error in `e1` should not stay live regardless of
scope questions.

## Finding 2 — `apchem-frq-l-021`: Haiku rationalized past an explicit exclusion

Fact pack, line 139 (confirmed via grep):

> Do not assess technical distinctions between enthalpy and internal energy
> or the formal concept of state functions.

Part (d) of the question asks students to "explain why Hess's Law is valid
in terms of enthalpy being a state function" — squarely the excluded
concept. DeepSeek caught this directly (confidence 1.0). Haiku saw the same
exclusion text and talked itself out of applying it: *"this question asks
students to explain why Hess's Law works in terms of enthalpy being a state
function, which is pedagogically appropriate and not the same as assessing
technical distinctions... between enthalpy and internal energy."* That's a
distinction the exclusion boundary doesn't draw — it flatly excludes "the
formal concept of state functions," and part (d) requires exactly that
concept to answer. This is the same failure pattern seen in the Biology run
(`APBIO-FRQ-L-026`): Haiku constructing a plausible-sounding argument for why
an explicit exclusion doesn't apply, rather than applying it.

## Finding 3 — `apchem-sfrq-035`: same pattern, second instance

Fact pack, line 139 (confirmed via grep):

> Do not assess calculating buffer pH change after adding acid/base or
> deriving the Henderson-Hasselbalch equation.

Parts (b) and (c) of this question require exactly that calculation (new pH
of two buffers after 0.010 mol HCl is added). DeepSeek flagged it directly.
Haiku again rationalized around the plain exclusion text: *"the restriction
is aimed at preventing questions where pH-change calculation is the primary
focus in isolation... here it's one part of a multi-part conceptual
investigation."* The exclusion boundary makes no such isolation carve-out —
it's an unconditional "do not assess."

## Reading this alongside Biology and Physics

- **Hit rate is comparable to Biology** (3/20 here vs. 3/20 confirmed in the
  Biology sample after re-verification), even though Chemistry's authors,
  reviewers, and (per the user's expectation) development timeline all differ
  from Biology's. This is evidence the two-model blind-check approach is
  finding a real, recurring authoring pattern — explicit CED exclusions being
  either missed or argued around at write time — rather than something
  specific to one subject's content pipeline.
- **The specific failure mode replicates**: in both subjects, Haiku's misses
  are not blind spots but *visible-and-rationalized* — it quotes the correct
  exclusion text, then argues past it. DeepSeek does not show this behavior
  here (no DeepSeek-only false positives in this run, unlike the
  over-strictness bias seen in the Biology DeepSeek run). That's a smaller,
  cleaner sample, so it isn't strong evidence DeepSeek's over-flagging bias is
  gone — just that it didn't surface on these 20 items.
- **Physics remains not meaningfully checkable** by this method (fact packs
  too shallow, no exclusion sections) — unchanged from the prior finding.

## Not yet actioned

All 3 findings here are read-only, matching the "audit, not remediate until
asked" pattern from Biology. `apchem-frq-l-010` needs both a rubric
correction (the chemistry error in `e1`) and a scope trim (parts c/d). The
two state-function/buffer-calculation items need scope trims to remove the
excluded sub-parts. Awaiting instruction on whether/how to repair.
