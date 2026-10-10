// Server-side rollout for photographed FRQ answers (TASK-0069 QA P2-a).
//
// One knob, FRQ_PHOTO_SUBJECTS, decides who gets the photo experience:
//   "none" (default)  -> admins only (the dark first publish)
//   "all"             -> everyone
//   comma list        -> those subjects (and admins)
// It governs three things that must agree: whether photo_required items are
// SERVED (student-session-items), whether the transcript ops RUN
// (attempt-response), and the `photo_enabled` flag the frontend reads to show
// the control. A client-side flag alone left hand-drawn items served to every
// student with no way to answer them.
//
// Subject keys arrive in two namespaces (registry `biology` / `ap-calculus-ab`,
// guide `ap_biology`); both are normalised before comparison.

export const FRQ_PHOTO_SUBJECTS_DEFAULT = "none";

export function canonicalPhotoSubject(key: string | null | undefined): string | null {
  if (typeof key !== "string") return null;
  const k = key.trim().toLowerCase().replace(/_/g, "-").replace(/^ap-/, "");
  return k || null;
}

export function photoEnabledFor(params: {
  subjectKey: string | null | undefined;
  configured: string | null | undefined;
  isAdmin: boolean;
}): boolean {
  if (params.isAdmin) return true;
  const raw = (params.configured ?? "").trim() || FRQ_PHOTO_SUBJECTS_DEFAULT;
  const value = raw.toLowerCase();
  if (value === "none") return false;
  if (value === "all") return true;
  const subject = canonicalPhotoSubject(params.subjectKey);
  if (!subject) return false;
  return value.split(",").map((s) => canonicalPhotoSubject(s)).includes(subject);
}
