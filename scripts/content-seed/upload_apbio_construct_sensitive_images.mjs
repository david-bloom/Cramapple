// One-time upload of the 7 code-drawn AP Biology construct-sensitive images
// (see docs/research/APBIO_SYNTHETIC_IMAGE_SURVEY_2026_08_04.md) into the
// `content-assets` bucket, matching the existing storage-path convention
// used by APBIO-FRQ-S-009 (Biology/FRQ/<content_key>.png).
//
// This is a REVIEWER-visibility step only. It does NOT make these images
// visible to students - storage-sign-url's canAccessBucket has no student
// grant for content-assets (confirmed live, unchanged since TASK-0020), and
// the deployed student /session route does not render stimulus_image_path
// at all right now. See the survey doc for what's still required for
// student-facing delivery.
//
// These images have NOT passed Learning Quality construct-equivalence or
// scientific-accuracy review by anyone other than the preparer. Uploading
// them makes them visible to reviewer roles (tutor/reader/validator/admin/
// content_author) for that review to happen - it is not itself an approval.
//
// Requires SUPABASE_URL and SUPABASE_SECRET_KEY in the environment.
// Never commit that key or put it in a file tracked by git.
//
// Supabase's legacy `service_role` key still works (Supabase keeps it valid
// through end of 2026) but the current-generation replacement is a secret
// key (`sb_secret_...`), issued/rotated independently via JWT Signing Keys
// instead of being derived from the project's JWT secret. It's a drop-in
// replacement in the same Authorization: Bearer header used below - get one
// from Dashboard > Settings > API Keys > "Publishable and secret API keys"
// (create the `default` secret key if the project hasn't migrated yet).
// A `service_role` key still works here too if that's what you have handy.
//
// Note: SUPABASE_SECRET_KEYS (plural, JSON-map-of-named-keys) is what
// Supabase auto-injects into Edge Functions deployed on their platform -
// this is a plain local script, nothing auto-injects anything into it, so
// this reads a single literal key value from SUPABASE_SECRET_KEY (singular).
//
// Usage:
//   SUPABASE_URL=https://pcntajvbdfqhbeewmdry.supabase.co \
//   SUPABASE_SECRET_KEY=<paste secret key, sb_secret_... or legacy service_role> \
//     node scripts/content-seed/upload_apbio_construct_sensitive_images.mjs

import fs from "node:fs";
import path from "node:path";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SECRET_KEY = process.env.SUPABASE_SECRET_KEY ?? process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SECRET_KEY) {
  console.error(
    "Set SUPABASE_URL and SUPABASE_SECRET_KEY (or legacy SUPABASE_SERVICE_ROLE_KEY) before running this script."
  );
  process.exit(1);
}

const BUCKET = "content-assets";
const ROOT = path.join(import.meta.dirname, "..", "..");
const LOCAL_DIR = path.join(
  ROOT,
  "docs",
  "research",
  "apbio_synthetic_image_smoke_test_2026_08_04"
);

const CONTENT_KEYS = [
  "APBIO-FRQ-L-003",
  "APBIO-FRQ-L-009",
  "APBIO-FRQ-L-011",
  "APBIO-FRQ-L-019",
  "APBIO-FRQ-L-020",
  "APBIO-FRQ-L-021",
  "APBIO-FRQ-L-027",
];

async function uploadFile(localPath, storagePath) {
  const body = fs.readFileSync(localPath);
  const url = `${SUPABASE_URL}/storage/v1/object/${BUCKET}/${storagePath}`;
  // Secret keys (sb_secret_...) are opaque tokens, not JWTs. Sending them
  // on Authorization: Bearer makes Storage try to parse them as a JWT and
  // reject with "Invalid Compact JWS" - the same issue Supabase's own docs
  // flag for pg_net/webhook calls. The documented fix for direct REST calls
  // is the apikey header instead, with no Authorization header at all. This
  // also still works with a legacy service_role key (a JWT), since apikey
  // accepts either format.
  const res = await fetch(url, {
    method: "POST",
    headers: {
      apikey: SECRET_KEY,
      "Content-Type": "image/png",
      "x-upsert": "true",
    },
    body,
  });
  if (!res.ok) {
    const text = await res.text().catch(() => "");
    throw new Error(`upload failed (${res.status}): ${text}`);
  }
}

async function main() {
  console.log(`Uploading ${CONTENT_KEYS.length} images to ${BUCKET}/Biology/FRQ/\n`);
  for (const key of CONTENT_KEYS) {
    const localPath = path.join(LOCAL_DIR, `${key}.png`);
    if (!fs.existsSync(localPath)) {
      console.log(`SKIP  ${key} - not found at ${localPath}`);
      continue;
    }
    const storagePath = `Biology/FRQ/${key}.png`;
    try {
      await uploadFile(localPath, storagePath);
      console.log(`OK    ${key} -> ${BUCKET}/${storagePath}`);
    } catch (err) {
      console.log(`FAIL  ${key}: ${err.message}`);
    }
  }
  console.log(
    "\nDone. Next step is the stimulus_image_path DB update - do not run that until every row above says OK."
  );
}

main();
