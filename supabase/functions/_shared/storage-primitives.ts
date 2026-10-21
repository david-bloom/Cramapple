type StorageClient = { storage: { from(bucket: string): { list(folder: string, options: { search: string; limit: number }): PromiseLike<{
  data: Array<{ name: string; updated_at?: string; metadata?: { eTag?: unknown; size?: unknown } }> | null;
  error: unknown;
}> } } };

// Preserve the fail-closed null result and the original version fingerprint.
export async function storageObjectFingerprint(service: StorageClient, storagePath: string): Promise<string | null> {
  const slash = storagePath.lastIndexOf("/");
  const folder = slash >= 0 ? storagePath.slice(0, slash) : "";
  const name = slash >= 0 ? storagePath.slice(slash + 1) : storagePath;
  const { data, error } = await service.storage.from("learner-uploads").list(folder, { search: name, limit: 100 });
  if (error || !data) return null;
  const entry = data.find(item => item.name === name);
  if (!entry) return null;
  return `${entry.updated_at ?? ""}:${entry.metadata?.eTag ?? entry.metadata?.size ?? ""}`;
}

export function attachmentBindError(message: string | undefined): { status: number; code: string } {
  const code = typeof message === "string" ? message.match(/attach_capture:([a-z_]+)/)?.[1] : undefined;
  // Round-4 QA S1/N7: stale lineage and writability refusals are expected
  // conflicts (409), missing responses are 404, and only unknown failures are
  // technical 500s. Preserve this distinction in each caller's own envelope.
  switch (code) {
    case "no_current_original_to_replace":
    case "stale_retake_target":
    case "original_already_current":
    case "derived_cannot_replace":
      return { status: 409, code: `attach_capture_${code}` };
    case "response_not_writable": return { status: 409, code: "response_already_submitted" };
    case "response_not_found": return { status: 404, code: "response_not_found" };
    default: return { status: 500, code: "attach_capture_failed" };
  }
}
