-- TASK-0078 ruling 6 (David, 2026-10-22): align Development to Production.
-- Slice 4: the layer under the definitions. Measured against Production's catalogs on 2026-10-22 after
-- slices 1-3: check constraints on seven shared tables where Production accepts more values than
-- Development (Development lagged), four non-empty checks on frq_criteria and mcq_choices that only
-- Production enforces, one Development-only constraint and two Development-only indexes, four
-- Production-only indexes, forced RLS on five tables, three table grants, and sixteen function
-- execute ACLs (mostly Supabase's default anon/PUBLIC execute that Production revoked).
-- Prerequisite data touch, run separately on 2026-10-22 before this file (an UPDATE here fires the
-- slice-3 taxonomy-stale trigger and leaves pending trigger events that block the ALTERs below):
-- app.frq_criteria b01a17bf-f4e1-4eea-b85f-b43c7b71feeb (smoke-test-frq-b5b1eaca, a 2026-06-22
-- Development fixture) had null evidence_requirements and minimum_fix; both were backfilled with a
-- labelled placeholder so Production's checks validate. The DO block below refuses to proceed if any
-- row would still fail them. Idempotent.

-- 1. check constraints: Production's definitions
alter table app.attempt_criterion_results drop constraint if exists attempt_criterion_results_status_check;
alter table app.attempt_criterion_results add constraint attempt_criterion_results_status_check
  check ((status = any (array['earned'::text, 'partially_earned'::text, 'not_yet_earned'::text, 'unable_to_determine'::text, 'not_applicable'::text])));
alter table app.canonical_answer_spans drop constraint if exists canonical_answer_spans_source_field_check;
alter table app.canonical_answer_spans add constraint canonical_answer_spans_source_field_check
  check (((source_field is null) or (source_field = any (array['canonical_answer_1'::text, 'canonical_answer_2'::text, 'parent_canonical_answer_1'::text, 'parent_canonical_answer_2'::text, 'authored'::text]))));
alter table app.content_item_cells drop constraint if exists content_item_cells_validation_check;
alter table app.content_item_cells add constraint content_item_cells_validation_check
  check (((assignment_status = 'validated'::text) = ((validated_at is not null) and (validation_decision_id is not null) and ((validated_by is not null) or (model_run_id is not null)))));
alter table app.content_item_versions drop constraint if exists content_item_versions_status_check;
alter table app.content_item_versions add constraint content_item_versions_status_check
  check ((status = any (array['draft'::text, 'assigned'::text, 'changes_requested'::text, 'reviewed_approved'::text, 'reviewed_disapproved'::text, 'published'::text, 'retired'::text])));
alter table app.content_items drop constraint if exists content_items_status_check;
alter table app.content_items add constraint content_items_status_check
  check ((status = any (array['draft'::text, 'assigned'::text, 'changes_requested'::text, 'reviewed_approved'::text, 'reviewed_disapproved'::text, 'published'::text, 'retired'::text])));
alter table app.content_review_assignments drop constraint if exists cra_status_check;
alter table app.content_review_assignments add constraint cra_status_check
  check ((status = any (array['pending'::text, 'in_progress'::text, 'submitted'::text, 'skipped'::text, 'withdrawn'::text])));
alter table app.content_review_decisions drop constraint if exists crd_reader_decision_check;
alter table app.content_review_decisions add constraint crd_reader_decision_check
  check (((reader_decision is null) or (reader_decision = any (array['agree'::text, 'disagree'::text, 'approve'::text, 'approve_with_edits'::text, 'disapprove'::text]))));
alter table app.taxonomy_skills drop constraint if exists taxonomy_skills_practice_number_check;
alter table app.taxonomy_skills add constraint taxonomy_skills_practice_number_check
  check (((practice_number >= 1) and (practice_number <= 12)));

-- 2. Production-only non-empty checks (data precondition verified first)
do $$
begin
  if exists (select 1 from app.frq_criteria where nullif(btrim(evidence_requirements), '') is null or nullif(btrim(minimum_fix), '') is null)
     or exists (select 1 from app.mcq_choices where nullif(btrim(choice_text), '') is null or nullif(btrim(rationale), '') is null) then
    raise exception 'task0078_align: rows would fail the non-empty checks; backfill them before applying';
  end if;
end $$;
alter table app.frq_criteria drop constraint if exists frq_criteria_evidence_requirements_nonempty;
alter table app.frq_criteria add constraint frq_criteria_evidence_requirements_nonempty check ((nullif(btrim(evidence_requirements), ''::text) is not null));
alter table app.frq_criteria drop constraint if exists frq_criteria_minimum_fix_nonempty;
alter table app.frq_criteria add constraint frq_criteria_minimum_fix_nonempty check ((nullif(btrim(minimum_fix), ''::text) is not null));
alter table app.mcq_choices drop constraint if exists mcq_choices_choice_text_nonempty;
alter table app.mcq_choices add constraint mcq_choices_choice_text_nonempty check ((nullif(btrim(choice_text), ''::text) is not null));
alter table app.mcq_choices drop constraint if exists mcq_choices_rationale_nonempty;
alter table app.mcq_choices add constraint mcq_choices_rationale_nonempty check ((nullif(btrim(rationale), ''::text) is not null));

-- 3. Development-only constraint and indexes
alter table app.exam_pack_versions drop constraint if exists exam_pack_versions_semver_check;
drop index if exists app.artifact_label_assignments_label_id_idx;
drop index if exists app.review_assignments_one_active_review_per_artifact_type;

-- 4. Production-only indexes (profiles_active_epv_idx duplicates profiles_active_exam_pack_version_idx on Production too)
create index if not exists content_items_exam_pack_practice_format_idx on app.content_items using btree (exam_pack_version_id, item_type, practice_format, status);
create index if not exists profiles_active_epv_idx on app.profiles using btree (active_exam_pack_version_id);
create index if not exists taxonomy_topics_source_unit_idx on app.taxonomy_topics using btree (taxonomy_source_version, unit_number, topic_code);
create index if not exists taxonomy_units_source_assessed_idx on app.taxonomy_units using btree (taxonomy_source_version, is_exam_assessed, unit_number);

-- 5. forced RLS (Production forces it on these five)
alter table app.content_review_invariant_violations force row level security;
alter table app.content_taxonomy_labels force row level security;
alter table app.taxonomy_source_versions force row level security;
alter table app.taxonomy_topics force row level security;
alter table app.taxonomy_units force row level security;

-- 6. table grants
grant select, insert, update on app.content_review_invariant_violations to service_role;
grant select, insert, update, delete on app.content_taxonomy_labels to service_role;
revoke all on public.profiles from authenticated;
grant select on public.profiles to authenticated;

-- 7. function execute ACLs (Production proacl)
revoke execute on function app.check_content_review_invariants() from public;
grant execute on function app.check_content_review_invariants() to service_role;
revoke execute on function app.content_item_is_published(uuid) from public;
grant execute on function app.content_item_is_published(uuid) to authenticated, service_role;
revoke execute on function app.home_exam_pack_is_eligible(uuid) from authenticated;
revoke execute on function app.start_home_learning_session_for_user(uuid, integer, text) from authenticated;
grant execute on function app.tg_content_pipeline_guard_publish() to public;
grant execute on function app.tg_content_pipeline_on_assignment() to public;
revoke execute on function public._epv_is_selectable(uuid) from anon, authenticated;
revoke execute on function public.content_review_invariant_report() from public, anon;
revoke execute on function public.gold_set_access() from anon;
revoke execute on function public.gold_set_admin_overview() from anon;
revoke execute on function public.gold_set_verification_next(uuid[]) from anon;
revoke execute on function public.gold_set_verification_progress(boolean) from anon;
revoke execute on function public.submit_gold_set_verification(uuid, jsonb, boolean) from anon;
revoke execute on function public.select_practice_frqs(uuid, text, integer) from public;
revoke execute on function public.select_unit_gated_practice_items(uuid, integer, text, text, integer) from public;
