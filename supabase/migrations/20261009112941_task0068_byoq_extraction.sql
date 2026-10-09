-- TASK-0068: BYOQ photo extraction with student confirmation
-- (DECISION-0108 / APPROVAL-0139; design: docs/product/BYOQ_PHOTO_EXTRACTION_PLAN_V2_2026_10_08.md §5.1).
--
-- Additive only. No new tables, no new policies. The `byoq_items_ready_is_complete`
-- CHECK and the answer-free choices CHECK are unchanged: a proposal lives beside the
-- draft item and reaches `stem` / `choices` only through the same validated update
-- path a typed question uses.
--
--   extraction           the model's proposal and run metadata (status, model, prompt
--                        version, page digests, proposed fields, alternatives, warnings,
--                        latency). Owner-readable only through the byoq function.
--   captured_work        marks on the page that are not the question (the student's own
--                        work, a circled option, a printed answer line). Never shown as
--                        correct, never graded, never read outside BYOQ, not displayed in v1.
--                        A printed answer key is NOT stored here (dropped with a warning).
--   context_unit_number  the unit the student was working in when the photo was taken
--                        (from the app's saved position or the intake select). Narrows the
--                        topic list the model may choose from. Never inferred from the image.

alter table app.byoq_items
  add column if not exists extraction jsonb
    check (extraction is null or jsonb_typeof(extraction) = 'object'),
  add column if not exists captured_work text
    check (captured_work is null or char_length(captured_work) <= 4000),
  add column if not exists context_unit_number integer
    check (context_unit_number is null or context_unit_number between 1 and 20);

comment on column app.byoq_items.extraction is
  'TASK-0068. Model proposal for a photographed question plus run metadata. Untrusted staging data: proposed values reach stem/choices only via the validated update path. Readable by the owner through the byoq function only.';
comment on column app.byoq_items.captured_work is
  'TASK-0068. Marks on the photographed page that are not the question (student work, circled option, printed answer line). The student''s own record: never a key, never graded, never shown as correct, not displayed in v1. Printed answer keys are dropped, not stored.';
comment on column app.byoq_items.context_unit_number is
  'TASK-0068. Unit context supplied by the app (saved position or intake select), never inferred from the photo. Narrows the topic choices offered to the extraction model and the review screen.';
