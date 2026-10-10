# Round 3 addendum (read after ../ARBITRATION_INSTRUCTIONS.md, which still applies)

1. **Follow-through credit (ruling reversed 2026-10-10).** The CED fact packs for AP Calculus AB/BC and all four AP
   Physics courses document follow-through (error-carried-forward) credit: a later part that correctly applies a wrong
   value from an earlier part earns its own point. For those subjects, a criterion that uses an earlier part's value
   SHOULD accept "the correct value, or the value that follows correctly from the response's own answer to part (x)".
   Not for Biology, Chemistry, Precalculus or Statistics (their packs do not document it); leave those as they are.
2. **Accept as is.** If, after re-deriving, you reject EVERY objection on an item, return it unchanged with
   `"accept_as_is": true` and a reason in each decision. Use this only when the item is genuinely correct and on topic.
3. **Third pass, so be decisive.** These items have been corrected once already (see `prior_arbitration`). Fix real
   defects completely this time: when a part asks only for an answer, either add "Justify/Explain/Show the work" to the
   prompt or remove the justification from the evidence; when one point bundles separately requested elements and the
   point cap blocks a split, narrow the prompt so the part asks for one element per point.
4. **Topic/units.** A topic vote with the target in the majority but below 5 of 6, or required units that name a later
   unit only because of a background mention, can be resolved with a `topic_ruling` after reading the CED text. If a
   part genuinely needs a later unit, rewrite that part.

Output `<group>_resolved.json` in this folder, same shape as before, plus optional `"accept_as_is": true`.
