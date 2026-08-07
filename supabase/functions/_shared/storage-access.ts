// Bucket authorization for storage-sign-url.
//
// Extracted from storage-sign-url/index.ts so the rules can be regression
// tested without booting the function (its module load calls Deno.serve and
// requires service-role env). Behavior is unchanged.
//
// TASK-0021 note: students reach prompt visuals through the separate
// student-session-items function, which signs with the service role scoped to
// the exact item version a student is being served. That is deliberately NOT
// a grant here -- content-assets also holds authoring/reviewer-only material,
// so a `student` branch in this predicate would over-share the whole bucket.

export type StorageMode = "sign_upload" | "sign_download" | "sign_delete";

export function canAccessBucket(
  role: string,
  bucket: string,
  mode: StorageMode,
) {
  if (bucket === "learner-uploads") {
    return role === "student" || role === "admin";
  }

  if (bucket === "content-assets") {
    return role === "admin" || role === "content_author";
  }

  if (bucket === "validation-artifacts") {
    return role === "admin" || role === "validator";
  }

  return mode === "sign_delete" && role === "admin";
}
