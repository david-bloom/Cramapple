-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260712114645
-- recorded name: active_exam_pack_version_20260712
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- ============================================================================
-- PENDING MIGRATION — active_exam_pack_version
-- ============================================================================
-- STATUS: NOT applied. Do not deploy to production.
-- SCOPE:  preview environment only (per plan approval).
--
-- Apply by copying this file into `supabase/migrations/` under the current
-- timestamp and running the migration tool, OR by executing the SQL directly
-- against the preview database as the migration role.
--
-- IMPORTANT: production has:
--   app.profiles              -- real, writable table
--   public.profiles           -- security-invoker VIEW, SELECT only
--
-- This migration:
--   1. Adds a relational uuid column to the REAL table (app.profiles).
--   2. Extends the public.profiles VIEW without dropping it (preserves
--      dependent objects) and keeps column order identical to production,
--      appending the new column at position 10.
--   3. Introduces two hardened SECURITY DEFINER RPCs that are the only
--      supported write paths:
--        - public.set_active_exam_pack_version(_version_id uuid)
--            later switching
--        - public.complete_onboarding(_version_id uuid)
--            atomic first-time completion (sets BOTH
--            active_exam_pack_version_id and onboarding_completed_at)
--
-- Both RPCs validate the (published pack) x (active subject) join server-side
-- via a shared helper so semantics can never drift.
-- ============================================================================

BEGIN;

-- 1. Relational column on the real table.
ALTER TABLE app.profiles
  ADD COLUMN IF NOT EXISTS active_exam_pack_version_id uuid
  REFERENCES app.exam_pack_versions(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS profiles_active_epv_idx
  ON app.profiles (active_exam_pack_version_id);

-- 2. Extend public.profiles WITHOUT DROP. CREATE OR REPLACE preserves grants
--    and dependents; column order matches the current production view.
CREATE OR REPLACE VIEW public.profiles
  WITH (security_invoker = true) AS
SELECT
  p.user_id,
  p.full_name,
  p.role,
  p.review_queue_scope,
  p.timezone,
  p.locale,
  p.onboarding_completed_at,
  p.created_at,
  p.updated_at,
  p.active_exam_pack_version_id
FROM app.profiles p;

REVOKE INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER
  ON TABLE public.profiles
  FROM authenticated;

GRANT SELECT ON TABLE public.profiles TO authenticated;

-- No direct UPDATE grants: the only supported write paths are the validated
-- SECURITY DEFINER RPCs below, which update the base table after server-side
-- validation. `active_exam_pack_version_id` and `onboarding_completed_at`
-- remain writable only through those RPCs.

-- 3a. Shared validation helper. STABLE + SECURITY DEFINER so the caller can
--     check without needing SELECT on the source tables.
CREATE OR REPLACE FUNCTION public._epv_is_selectable(_version_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog
AS $$
  SELECT EXISTS (
    SELECT 1
      FROM app.exam_pack_versions v
      JOIN app.exam_packs         p ON p.id = v.exam_pack_id
      JOIN app.subjects           s ON s.id = p.subject_id
     WHERE v.id     = _version_id
       AND v.status = 'published'
       AND s.status = 'active'
  );
$$;
REVOKE ALL ON FUNCTION public._epv_is_selectable(uuid) FROM PUBLIC;

-- 3b. Later switching. Accepts NULL to clear the selection.
CREATE OR REPLACE FUNCTION public.set_active_exam_pack_version(_version_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog
AS $$
DECLARE
  v_uid       uuid := auth.uid();
  v_returned  uuid;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not_authenticated' USING ERRCODE = '28000';
  END IF;

  IF _version_id IS NOT NULL
     AND NOT public._epv_is_selectable(_version_id) THEN
    RAISE EXCEPTION 'invalid_exam_pack_version' USING ERRCODE = '22023';
  END IF;

  UPDATE app.profiles
     SET active_exam_pack_version_id = _version_id
   WHERE user_id = v_uid
  RETURNING active_exam_pack_version_id INTO v_returned;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'profile_not_found' USING ERRCODE = 'P0002';
  END IF;

  RETURN v_returned;
END;
$$;
REVOKE ALL ON FUNCTION public.set_active_exam_pack_version(uuid) FROM PUBLIC;
GRANT  EXECUTE ON FUNCTION public.set_active_exam_pack_version(uuid) TO authenticated;

-- 3c. Atomic onboarding completion. Sets BOTH fields in a single UPDATE:
--     either both change or neither changes.
--
--     Idempotency: COALESCE preserves the original onboarding_completed_at;
--     UPDATE ... RETURNING returns the stored value, so retries see the
--     original timestamp (not a new one).
CREATE OR REPLACE FUNCTION public.complete_onboarding(_version_id uuid)
RETURNS TABLE (
  active_exam_pack_version_id uuid,
  onboarding_completed_at     timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog
AS $$
DECLARE
  v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not_authenticated' USING ERRCODE = '28000';
  END IF;

  IF _version_id IS NULL
     OR NOT public._epv_is_selectable(_version_id) THEN
    RAISE EXCEPTION 'invalid_exam_pack_version' USING ERRCODE = '22023';
  END IF;

  RETURN QUERY
  UPDATE app.profiles p
     SET active_exam_pack_version_id = _version_id,
         onboarding_completed_at     = COALESCE(p.onboarding_completed_at,
                                                pg_catalog.now())
   WHERE p.user_id = v_uid
  RETURNING p.active_exam_pack_version_id, p.onboarding_completed_at;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'profile_not_found' USING ERRCODE = 'P0002';
  END IF;
END;
$$;
REVOKE ALL ON FUNCTION public.complete_onboarding(uuid) FROM PUBLIC;
GRANT  EXECUTE ON FUNCTION public.complete_onboarding(uuid) TO authenticated;

COMMIT;

-- ============================================================================
-- ROLLBACK REFERENCE
-- ============================================================================
-- To restore the current production ACL exactly:
--
-- BEGIN;
--
-- DROP FUNCTION IF EXISTS public.complete_onboarding(uuid);
-- DROP FUNCTION IF EXISTS public.set_active_exam_pack_version(uuid);
-- DROP FUNCTION IF EXISTS public._epv_is_selectable(uuid);
--
-- DROP INDEX IF EXISTS app.profiles_active_epv_idx;
--
-- ALTER TABLE app.profiles
--   DROP COLUMN IF EXISTS active_exam_pack_version_id;
--
-- DROP VIEW IF EXISTS public.profiles;
--
-- CREATE VIEW public.profiles
--   WITH (security_invoker = true) AS
-- SELECT
--   p.user_id,
--   p.full_name,
--   p.role,
--   p.review_queue_scope,
--   p.timezone,
--   p.locale,
--   p.onboarding_completed_at,
--   p.created_at,
--   p.updated_at
-- FROM app.profiles p;
--
-- ALTER VIEW public.profiles OWNER TO postgres;
--
-- REVOKE ALL ON TABLE public.profiles FROM PUBLIC;
-- REVOKE ALL ON TABLE public.profiles FROM authenticated;
-- REVOKE ALL ON TABLE public.profiles FROM service_role;
--
-- GRANT ALL ON TABLE public.profiles TO postgres;
-- GRANT ALL ON TABLE public.profiles TO authenticated;
-- GRANT ALL ON TABLE public.profiles TO service_role;
--
-- COMMIT;
