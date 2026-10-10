# Arbitration instructions (Product Owner direction 2026-10-10: "Where there are edge cases, you should arbitrate and correct ambiguities.")

You are arbitrating checker flags on AP free-response questions (FRQs) for Cramapple. You are the final judge.
Each row in your input file has the item and the objections raised by two checkers (GPT-6.1 Sol, DeepSeek V4 Pro)
and/or a six-vote topic classifier.

For EVERY objection decide:
- **accept**: the objection identifies a real defect at AP-course level. Correct the item minimally.
- **reject**: the objection is wrong, or demands more than the AP course does (research-level caveats, stylistic
  preference, a demand already met). Give the reason. If a number is disputed, re-derive it with Python before ruling;
  a checker's arithmetic can be wrong (one checker earlier claimed a value that the given constants contradict).

Common real defects and the standard fixes:
- A criterion prescribes a method the part does not require → widen the evidence to accept any valid method, OR add
  "Show the work…/Use … to…" to the prompt if the method is the point of the part.
- A criterion scores something the part never asks for (a justification, units, work) → add it to the prompt, or drop
  it from the evidence.
- Two independent elements bundled in one point → split into two criteria (respect the point limits), or narrow.
- A missing given / inconsistent data / unstated condition a careful AP student could read differently → add the
  given or condition to the setup.
- Wrong or mis-rounded number → fix it everywhere (criteria, model answer, verification_python) and recompute.
- Topic classifier voted another topic or a later unit: read the official CED text for the designated topic (in the
  brief, see below). If the item really drifted or needs a later unit, rewrite the drifting part so it tests the
  designated topic only. If the item already matches the designated topic's CED text and the vote is wrong, keep it and
  give a `topic_ruling` (with the required units, which may not include a later unit than the topic's).

Hard limits still apply (the validator enforces them): exact part and point counts for the subject, every criterion
1 point, fix lines at most 25 words, no "figure"/"diagram", no drawing, plain text with Unicode maths (no LaTeX,
no exclamation marks, no !=, <=, >=), accepted_variants only equivalent forms of a key value, verification_python that
recomputes every number and prints ALL_CHECKS_PASSED. Keep every correction minimal; do not rewrite parts nobody objected to.

The official CED text for each topic and the subject fact pack are in the subject's writing brief:
  ../briefs/<group>.md   (precalc_u12, precalc_u3, physics2, statistics, physics_c, physics1_biology)

Output ONE JSON file `<group>_resolved.json` in this folder: a list, one object per input row:
{"slot_id": "...", "subject_key": "...", "topic_code": "...",
 "decisions": [{"source": "...", "objection": "<first 160 chars>", "ruling": "accept"|"reject", "reason": "..."}],
 "topic_ruling": null | {"required_units": [n], "reason": "..."},
 "item": { ...the corrected item, same shape as the input item... }}
Validate the items (make a temporary list of {subject_key, topic_code, item}):
  node /Users/davidbloom/Documents/Cramapple.nosync/.worktrees/frq-gen-2026-10-09/scripts/vercel-gateway-check/frq_pipeline/validate.mjs <file>
until every item passes. Do not call any external model, API or database; do not edit any other file; do not commit.
