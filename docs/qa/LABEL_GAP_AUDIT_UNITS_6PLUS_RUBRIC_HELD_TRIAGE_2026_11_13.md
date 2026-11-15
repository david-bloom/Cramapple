# Label gap Units 6+: triage of the 4 rubric_preflight_failure items (read-only) (2026-11-13)

Owner chose "Rubric failures" as the next held class. This is a diagnosis only: **no content or label was written.** Evidence: the stored held-label payloads (two preflight models each) and the current rubric and prompt text, read from Production.

| Item | Defect | Fix class | Proposed repair |
|---|---|---|---|
| `apcalcab-frq-017` (v1, 9 pts) | `part-c-criterion-4` scores the maximum amount (about 107.953 L) but part (c) asks only for the time of the maximum. One of two models flagged it. | Rubric-side only | Rewrite criterion 4 to score the conclusion the prompt asks for: the amount is greatest at t about 4.443 minutes, supported by the candidate comparison. Prompt unchanged, points unchanged. |
| `apcalcab-frq-036` (v1, 9 pts) | `part-c-criterion-1` and `-2` require cylindrical shells for the y-axis revolution. Prompt only says "revolved about the y-axis"; one model calls shells BC-only. The Calculus fact pack does not mention shells at all, so I could not confirm that classification from it. Washers about the y-axis (topic 8.11) give the same value. | Rubric-side only | Make criterion 1 accept an AB-scope setup, washers in y, pi times the integral of (sqrt(y))^2 minus (y/2)^2 from 0 to 4, with shells as an accepted alternative; keep criterion 2 (8 pi / 3, which I checked by hand for both setups). Prompt unchanged, points unchanged. |
| `apchem-frq-l-023` (v3, 10 pts) | The prompt asks to calculate Kc, but no criterion awards the substitution and Kc = 160; `a3` and `a4` both score the same interpretation. One model flagged it. | Rubric-side only | Rebalance within 10 points: a1 concentrations 2, a2 expression 1, new substitution to Kc = 160 for 2, a4 interpretation (product-favored, distinct from this mixture's composition) 2, a5 Le Chatelier shift with Q versus K 2, a6 Kc unchanged at constant T 1; drop the overlapping a3. Prompt unchanged. |
| `apchem-frq-l-026` (v3, 10 pts) | Rubric: `a1` requires pKa though (a) asks only for Ka; `d2` scores an unasked comparison. **Prompt: parts (d) and (f) ask for the pH change after adding strong acid or base to a buffer, which the CED excludes in Topic 8.9** (fact pack, verbatim: "Computation of the change in pH resulting from the addition of an acid or a base to a buffer will not be assessed on the AP Exam."). Only one of the two models flagged these. | Needs a prompt change, or retire | Options below. |

## Options for `apchem-frq-l-026`
- **A. Keep held** (no change; stays unserved).
- **B. Repair the prompt:** turn (d) and (f) into qualitative reasoning (direction and relative size of the pH change, why a buffer resists it), fix `a1` and `d2`, rebalance the 10 points. This is authored prompt text, so it needs your explicit yes.
- **C. Retire** the item.
My recommendation is B if you want the item served (the buffer content is in scope and well covered by other parts), otherwise A.

## Process if you approve
Same pattern as `APPROVAL-0269`: I draft the edits in session (no gateway authoring), new item versions are published through `publish_rubric_repair.py`, the edited rubrics get a two-family check (about $0.5, cap $1), the topic is voted again with the parts included for the labels (about $0.1), then cells and labels are written under a new approval record after rehearsal and live-selector verification. Nothing here is published until you say yes per item.

## Also open
The other held classes are unchanged: AB/BC-only content `apcalcab-frq-035`, `apcalcbc-mcq-mv045`, `-mv050`; "other" `apchem-frq-l-021`, `apchem-sfrq-035`.
