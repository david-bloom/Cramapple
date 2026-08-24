-- Human-validate the 8 provisional_model serving labels written by
-- scripts/taxonomy/extend_math_serving_labels.mjs for the Orly-protocol
-- Calc AB/BC items. Per docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md
-- §T6, a model may never write label_status='validated' unsupervised -- this
-- requires a human decision, recorded here as David's (Product Owner)
-- explicit review and confirmation of each item's primary_unit/required_units,
-- given in chat on 2026-08-24 after being shown the label table directly.
--
-- Known gap, called out to and accepted by David rather than hidden: there is
-- no validation_decision tracking table in this schema (validation_decision_id
-- is a bare uuid column with no FK, never previously populated anywhere in the
-- repo). A fresh uuid is generated per row as a placeholder and the gap is
-- documented in source_payload.human_validation so a future
-- validation_decision table (if built) can backfill/reconcile against it.

update app.content_taxonomy_labels ctl
set label_status = 'validated',
    validated_by = 'f5a26c6b-3566-4d58-9e97-979fbb947564', -- David, admin
    validated_at = now(),
    validation_decision_id = gen_random_uuid(),
    validated_against_version_id = civ.id,
    validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id),
    source_payload = jsonb_set(
      ctl.source_payload,
      '{human_validation}',
      jsonb_build_object(
        'validated_by_role', 'product_owner',
        'validated_via', 'chat_review_2026_08_24',
        'note', 'No validation_decision table exists in this schema yet; validation_decision_id is a generated placeholder, not a reference to a decision record. David reviewed the primary_unit/required_units table for all 8 items directly and confirmed them explicitly before this write.'
      )
    )
from app.content_items ci
join app.content_item_versions civ
  on civ.content_item_id = ci.id and civ.status = 'published'
where ctl.content_item_id = ci.id
  and ctl.label_scope = 'serving'
  and ctl.superseded_by is null
  and ci.content_key in (
    'apcalcab-mcq-060','apcalcab-mcq-070','apcalcab-mcq-080','apcalcab-mcq-090',
    'apcalcbc-mcq-060','apcalcbc-mcq-070','apcalcbc-mcq-080','apcalcbc-mcq-090'
  );
