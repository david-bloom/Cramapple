# TASK-0050 Statistics: 23 stranded item rows (Production read, 2026-11-12)

Pack: `548f06be-ccf4-426d-b82b-b424137a4438`. This follow-up checked the 23 keys in `no_published_version.csv` against the live Production tables. The set is unchanged: 8 MCQs and 15 FRQs.

## Result

No published-version skill label can be created for these items now. Each parent item row says `published`, but each has exactly one version and that version says `retired`. All 23 retired versions lack both a primary `app.content_item_cells` topic row and an `app.content_item_topic_resolution` row. A skill code requires a registered topic × skill cell; assigning one from the serving unit alone would guess the topic. None of these versions is eligible for the student practice selector while retired.

Twenty items have a validated *serving-unit* label; three have a held serving label. These labels do not supply a topic or skill. No model calls or Production writes were made for this audit, and no retired version was silently republished or labeled as if live.

| Group | Keys | Count | Serving-unit label |
| --- | --- | ---: | --- |
| FRQ | `APSTAT-MOD6-M001`, `APSTATS-SFRQ-006` | 2 | Validated |
| FRQ graph | `APSTATS-HDG-2026-GRAPH-001`, `002`, `004`, `011`, `022`, `024`, `026`, `029`, `032`, `034`, `035`, `036` | 12 | Validated |
| FRQ graph | `APSTATS-HDG-2026-GRAPH-021` | 1 | Held |
| MCQ | `APSTATS-MCQ-003`, `007`, `007-CAL`, `008`, `010`, `012` | 6 | Validated |
| MCQ | `APSTATS-MCQ-002-CAL`, `017` | 2 | Held |

## Next decision

Resolve the item/version mismatch before a published-version skill pass. For an intentionally withdrawn question, retire the parent item row. For a question intended to return to students, review its content, create and publish an appropriate successor version, establish its primary topic, and then run TASK-0050 skill labeling on that published version. Do not promote or reuse a label tied only to a retired version by ID. Either path changes Production content lifecycle and remains outside `APPROVAL-0236`.

This audit does not imply that the 23 questions should be restored. Existing student practice coverage remains unchanged; all currently published versions in the pack have a skill cell.
