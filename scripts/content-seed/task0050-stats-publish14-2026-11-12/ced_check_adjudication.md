# TASK-0050 first CED checker pass and source adjudication

David authorized 24 Gemini 2.5 Pro and Claude Opus 5 CED-scope checks on the 12 revised successors, including the internal AP Statistics CED fact pack. The calls completed on 2026-11-13 UTC; all 24 produced structured or validated JSON. Exact verdicts and findings are in `ced_check_first_pass.json` (usage and draft text omitted).

Both families marked the five revised MCQs fully in scope. This includes MCQ-017, whose retired v1 slope-inference content had been flagged by both older checkers. Claude noted two minor issues: MCQ-010 hedged the fixed `np≥10` threshold as “a common threshold,” and MCQ-007-CAL's “balanced” wheel might be ambiguous beside `P(red)=0.3`. Both were corrected in the successor draft.

For the seven graph FRQs, Gemini marked the *hand-drawn/photo submission format* out of scope; Claude marked their assessed concepts fully in scope. The [fact pack §7](../../../docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md) says hand-drawn graph practice is valuable as **supplemental** work, tagged `supplemental_hand_drawn`, and must not be presented as a digital exam simulation. An independent Production read found all eight target graph parent rows have `practice_format='targeted_drill'` and `response_policy='photo_required'`. The release now puts `practice_modality='supplemental_hand_drawn'` on all eight v2 prompt payloads, including copied GRAPH-001, and its postcondition checks the tag. These are targeted drills, not exam-format claims. The subject-matter scope is supported by fact-pack §§1.5, 1.7, 2.1, 5.1, 5.5; the specific §2.1 correction names segmented bars and mosaic plots. This is a source-based adjudication of the seven format flags, not a claim that both models voted in scope.

Claude also identified content issues in the graph drafts. The revised draft file now:

- Separates walking/driving from biking comparisons in GRAPH-021 and dine-in/takeout from delivery comparisons in GRAPH-022, so their two comparison points assess different evidence. “Construct” replaces “Complete” for the segmented bars.
- Makes GRAPH-024 and GRAPH-026 explicitly request a count/area justification. Their final tables make the largest *count* differ from the largest *conditional proportion*: Support vs Sales for in-person, East vs South for no-shows.
- Accepts the roughly symmetric 78–88 cluster or the overall low tail in GRAPH-029's shape criterion, while separately crediting identification of 62 as the outlier.
- Corrects GRAPH-032's strength from “strong” to “moderately strong” (`r≈0.775864`). GRAPH-032 and GRAPH-036 now ask for a reasonable trend line, avoiding an implied hand calculation of least-squares parameters.

The four-point binary rubrics remain because these are short `targeted_drill` questions, not claims to reproduce the May 2027 exam's four 10-point FRQs. The model's stem/stimulus concerns do not prevent a student from seeing the task: the displayed stimulus carries the full instruction and the v2 stem directs submission.

## Final-draft checker pass

David separately authorized 18 follow-up calls on the nine changed drafts with the same internal fact pack. All 18 returned `fully_in_scope`; see `ced_check_final_pass.json`. Gemini reported zero scope or consistency issues on all nine. Claude reported no issue on six; three had minor notes:

- GRAPH-021: the biking criterion's parenthetical could be read as requiring numerical evidence when the prompt asks only to state which class year is larger. The final criterion now names Freshmen without adding a numeric requirement. Its two comparison criterion texts remain distinct (walking/driving vs. biking), although their internal keys are similar.
- GRAPH-029: the shape criterion accepts either an overall low tail or a roughly symmetric 78–88 main cluster. Both are defensible descriptions of different aspects of the displayed distribution, and the separate outlier point requires identifying 62; the accepted alternatives are explicit to the scorer.
- GRAPH-032: the direction, form, and strength description earns one all-or-nothing point. This is a four-point supplemental targeted drill rather than a 10-point exam FRQ; the criterion states all three required characteristics. The full task appears in the displayed stimulus, as on the existing graph-drill format.

The last GRAPH-021/022 criterion wording change removes a stricter reading without adding a concept or changing the key. Source adjudication and deterministic checks cover that final text delta. No unresolved CED-scope or answer/rubric contradiction remains.
