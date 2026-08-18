// Path-safety and ownership checks for learner-scoped storage objects.
//
// Extracted from storage-sign-url/index.ts so attempt-response's
// attach_capture operation (TASK-0011/TASK-0020 Program B) can reuse the
// exact same rules without duplicating them, and so both can be regression
// tested without booting a function.

export function isSafeStoragePath(path: string) {
  return path.length > 0 &&
    !path.startsWith("/") &&
    !path.includes("..") &&
    !path.includes("\\") &&
    !path.includes("//") &&
    !path.includes("\0");
}

export function ownsLearnerPath(userId: string, path: string) {
  return path.split("/")[0] === userId;
}
