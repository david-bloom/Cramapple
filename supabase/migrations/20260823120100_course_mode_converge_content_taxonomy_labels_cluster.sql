-- Course-mode convergence: replicate the content_taxonomy_labels cluster into Dev (was missing).
-- Faithful copy of Prod (24 cols, 16 constraints, 6 indexes, RLS, derive trigger). Idempotent; safe on Prod.
-- Applied to Dev 2026-08-23.
create or replace function app.set_content_taxonomy_label_derived_fields()
 returns trigger
 language plpgsql
 set search_path to 'pg_catalog'
as $function$
declare
  v_max integer;
begin
  if new.label_scope = 'serving' then
    select max(unit_number) into v_max from unnest(new.required_units) as units(unit_number);
    new.max_required_unit := v_max;
  else
    new.required_units := '{}'::integer[];
    new.max_required_unit := null;
    new.primary_unit := null;
    new.required_units_by_criterion := null;
  end if;
  if new.label_status <> 'validated' then
    new.validated_by := null;
    new.validated_at := null;
    new.validation_decision_id := null;
  end if;
  return new;
end;
$function$;

create table if not exists app.content_taxonomy_labels (
  content_taxonomy_label_id uuid primary key default gen_random_uuid(),
  content_item_id uuid not null references app.content_items(id) on delete cascade,
  label_version integer not null,
  label_scope text not null,
  validated_against_version_id uuid references app.content_item_versions(id) on delete restrict,
  validated_against_taxo_hash text,
  required_units integer[] not null default '{}'::integer[],
  max_required_unit integer,
  assessed_topics text[] not null default '{}'::text[],
  primary_unit integer,
  required_units_by_criterion jsonb,
  taxonomy_source_version uuid references app.taxonomy_source_versions(taxonomy_source_version) on delete restrict,
  taxonomy_confidence text,
  label_status text not null,
  source text not null default 'migration'::text,
  source_payload jsonb not null default '{}'::jsonb,
  model_run_id text,
  input_packet_hash text,
  validation_decision_id uuid,
  validated_by uuid references app.profiles(user_id),
  validated_at timestamptz,
  superseded_by uuid references app.content_taxonomy_labels(content_taxonomy_label_id),
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id),
  constraint content_taxonomy_labels_unique_version unique (content_item_id, label_scope, label_version),
  constraint content_taxonomy_labels_confidence_check check ((taxonomy_confidence is null) or (taxonomy_confidence = any (array['verified'::text,'provisional'::text]))),
  constraint content_taxonomy_labels_criterion_shape_check check ((required_units_by_criterion is null) or (jsonb_typeof(required_units_by_criterion)='array'::text)),
  constraint content_taxonomy_labels_scope_check check (label_scope = any (array['serving'::text,'coverage'::text])),
  constraint content_taxonomy_labels_scope_payload_check check (((label_scope='serving'::text) and (cardinality(assessed_topics)=0)) or ((label_scope='coverage'::text) and (cardinality(required_units)=0))),
  constraint content_taxonomy_labels_source_payload_shape_check check (jsonb_typeof(source_payload)='object'::text),
  constraint content_taxonomy_labels_status_check check (label_status = any (array['legacy_unvalidated'::text,'provisional_model'::text,'validated'::text,'stale'::text,'held'::text])),
  constraint content_taxonomy_labels_units_check check (((array_position(required_units, null::integer) is null) and ((cardinality(required_units)=0) or (0 < all (required_units))) and ((max_required_unit is null) or (max_required_unit = any (required_units))) and ((primary_unit is null) or (primary_unit>0)))),
  constraint content_taxonomy_labels_validation_check check (((label_status='validated'::text) = ((validated_by is not null) and (validated_at is not null) and (validation_decision_id is not null) and (validated_against_version_id is not null) and (validated_against_taxo_hash is not null))))
);
alter table app.content_taxonomy_labels enable row level security;

create index if not exists content_taxonomy_labels_item_scope_idx on app.content_taxonomy_labels using btree (content_item_id, label_scope, label_status);
create index if not exists content_taxonomy_labels_serving_validated_idx on app.content_taxonomy_labels using btree (content_item_id, max_required_unit) where ((label_scope='serving'::text) and (label_status='validated'::text) and (superseded_by is null));
create index if not exists content_taxonomy_labels_coverage_validated_idx on app.content_taxonomy_labels using gin (assessed_topics) where ((label_scope='coverage'::text) and (label_status='validated'::text) and (superseded_by is null));
create index if not exists content_taxonomy_labels_stale_idx on app.content_taxonomy_labels using btree (label_status, created_at) where (label_status = any (array['legacy_unvalidated'::text,'stale'::text,'held'::text]));

create or replace trigger tg_content_taxonomy_labels_derive before insert or update on app.content_taxonomy_labels for each row execute function app.set_content_taxonomy_label_derived_fields();
