-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260712115246
-- recorded name: active_exam_pack_rpc_acl_hardening_20260712
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

BEGIN;

REVOKE EXECUTE ON FUNCTION public._epv_is_selectable(uuid)
  FROM PUBLIC, anon, authenticated;

REVOKE EXECUTE ON FUNCTION public.set_active_exam_pack_version(uuid)
  FROM PUBLIC, anon;

REVOKE EXECUTE ON FUNCTION public.complete_onboarding(uuid)
  FROM PUBLIC, anon;

GRANT EXECUTE ON FUNCTION public.set_active_exam_pack_version(uuid)
  TO authenticated;

GRANT EXECUTE ON FUNCTION public.complete_onboarding(uuid)
  TO authenticated;

COMMIT;
