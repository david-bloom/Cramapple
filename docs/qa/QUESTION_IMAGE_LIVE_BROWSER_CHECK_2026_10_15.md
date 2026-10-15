# Four question visuals — live browser check, 2026-10-15

**Result:** all four owner-requested attachments render in the live signed-in student-facing app. Same implementation agent performed this follow-up; this is not an independent content/accessibility verdict. Production authorization remains APPROVAL-0173. No image/content/app/function/schema changes in this follow-up.

| Exact question | Browser path | Image result | Evidence |
| --- | --- | --- | --- |
| `apcalcab-oht-1.3` | Learn from a question, AB topic 1.3 | Complete, 680×700 natural, 622.65625 CSS px wide | [Worked graph](../../scripts/question-visuals-pilot/browser-evidence/calc-example.jpg) |
| `apcalcab-frq-u13g-1-3` | AB FRQ practice, question 1, topic 1.3 | Complete, 680×700 natural, 622.65625 CSS px wide | [Asymptote graph](../../scripts/question-visuals-pilot/browser-evidence/frq-u13g.jpg) |
| `apcalcab-frq-u13-002` | Next FRQ after Skip for now, topic 1.10 | Complete, 680×700 natural, 622.65625 CSS px wide | [Segment graph](../../scripts/question-visuals-pilot/browser-evidence/frq-u13-002.jpg) |
| `apchem-oht-3.8` | Learn from a question, Chemistry topic 3.8, fresh view | Complete, 680×1200 natural, 622.65625 CSS px wide | [Particle diagram](../../scripts/question-visuals-pilot/browser-evidence/chem-example.jpg) |

The accessibility DOM exposes the approved alt text for all four. Both teaching figures also expose their long descriptions. Rendered images match the intended lines/curves and endpoint markers, and the Chemistry image supplies the 8/16-particle, 100/200 mL representation. The normal desktop viewport was used; no phone emulation was performed.

**Identity and side effects:** David’s existing authentication resumed after following Sign in. The browser account is the Product Owner admin profile, viewing ordinary student UI; prior authenticated student-role teaching RPC checks remain separate evidence. No credentials were extracted from the browser. No answers were typed/submitted and no grading calls were made. Practice queues were opened and one FRQ was skipped. AB course position was restored to 2.1, Statistics to 1.8, and active subject returned to Statistics. Chemistry was originally at 1.5; the mismatched Home save described below affected Statistics instead and was restored.

## Open defect: subject switching can keep stale worked content

**Observed reproduction:** open Statistics topic 3.8 in Learn mode, then choose Chemistry in the subject menu. After loading settles, the heading and reference material say Chemistry / Representations of Solutions, but the central question and answer key still show the Statistics hypothesis-test power question. [Screenshot](../../scripts/question-visuals-pilot/browser-evidence/subject-switch-stale-example.jpg). Clicking Return to student hub and using Back remounts the question view; the expected Chemistry 8/16-particle example and new image then load. This is a confirmed view-state defect, not an image attachment failure. No app fix was deployed here.

A related Home mismatch was observed: header Chemistry with Statistics course controls; selecting Unit 3 changed Statistics’s position. It was restored to its original Unit 1 / 1.8. Root cause is not established; do not infer a backend content-binding defect from this symptom.

**Source lead:** the student app’s `QuestionExperience` component (route through the app index before editing): the inspected source stores worked-example state separately from active subject identity. Treat this as a lead, not a verified diagnosis. Capture a regression for switching subjects while worked state is already showing, and fence async results by subject/topic before displaying either the question, answer key or image.

**Next owner:** app maintainer. **Next action:** reproduce and fix the stale subject/question state without altering the four attachments. Wider image audit: periodic-table availability and ten unresolved unit scopes remain separate. No owner approval remains outstanding for the completed four-image attachment/browser-check request.
