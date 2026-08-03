// One-time (or repeatable) sync of the drawn-response reference-image
// corpus into Supabase Storage. Run this after regenerating images with
// generate_drg_p1_reference_images.py or generate_frq_packages_and_images.py.
//
// Requires SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in the environment —
// the service role key is required because the `validation-artifacts`
// bucket is service-role-only (see
// supabase/migrations/202606200002_storage_buckets_and_policies.sql).
// Never commit that key or put it in a file tracked by git.
//
// Usage:
//   SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... \
//     node scripts/drawn_response/upload_reference_images_to_storage.mjs
//
// See scripts/drawn_response/UPLOAD_TO_STORAGE.md for the full runbook.

import fs from "node:fs";
import path from "node:path";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  console.error(
    "Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY before running this script."
  );
  process.exit(1);
}

const BUCKET = "validation-artifacts";
const ROOT = path.join(import.meta.dirname, "..", "..");

const SOURCES = [
  {
    localDir: path.join(ROOT, "prompts", "DRG_P1_REFERENCE_IMAGES_assets"),
    storagePrefix: "drawn-response-reference-images/drg-p1",
  },
  {
    localDir: path.join(
      ROOT,
      "docs",
      "research",
      "DRAWN_RESPONSE_FRQs_v1.1_images"
    ),
    storagePrefix: "drawn-response-reference-images/drg-p2",
  },
];

async function uploadFile(localPath, storagePath) {
  const body = fs.readFileSync(localPath);
  const url = `${SUPABASE_URL}/storage/v1/object/${BUCKET}/${storagePath}`;
  const res = await fetch(url, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${SERVICE_ROLE_KEY}`,
      "Content-Type": "image/png",
      "x-upsert": "true",
    },
    body,
  });
  if (!res.ok) {
    const text = await res.text().catch(() => "");
    throw new Error(`Upload failed for ${storagePath}: ${res.status} ${text}`);
  }
}

async function main() {
  let uploaded = 0;
  let skippedMissingDir = 0;

  for (const { localDir, storagePrefix } of SOURCES) {
    if (!fs.existsSync(localDir)) {
      console.warn(`Skipping missing directory: ${localDir}`);
      skippedMissingDir++;
      continue;
    }
    const files = fs
      .readdirSync(localDir)
      .filter((f) => f.toLowerCase().endsWith(".png"))
      .sort();

    for (const file of files) {
      const localPath = path.join(localDir, file);
      const storagePath = `${storagePrefix}/${file}`;
      await uploadFile(localPath, storagePath);
      uploaded++;
      console.log(`Uploaded ${storagePath}`);
    }
  }

  console.log(`\nDone. ${uploaded} files uploaded, ${skippedMissingDir} source directories missing.`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
