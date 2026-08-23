-- Course-mode convergence (Prod-side): adopt Dev's newer item-package + semver columns into Prod.
-- Additive, nullable, idempotent; safe on both environments. Applied to Prod 2026-08-23 (David approved).
alter table app.content_item_versions add column if not exists item_package_schema_version text;
alter table app.content_item_versions add column if not exists item_package_payload jsonb;
alter table app.content_item_versions add column if not exists item_package_sha256 text;
alter table app.exam_pack_versions add column if not exists exam_pack_semver text;
