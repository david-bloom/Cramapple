// Retention by redaction (DECISION-0111) -- the storage/database sequence,
// separated from the handler so every failure point is unit tested
// (TASK-0069 QA P2-b).
//
// Rules:
// * A row is stamped redacted only once its object is verifiably gone: it
//   came back in the storage removal list, or a follow-up existence check says
//   it is absent (a previous, partially failed run already removed it).
// * Any storage error, an unverifiable existence check, or an object that is
//   still present stops the run BEFORE that row is stamped.
// * The sequence is resumable: rows already stamped are skipped, and rows
//   whose bytes were removed by an earlier run are stamped on the retry.
// * The caller records an idempotent result only for a fully successful run.

export interface RedactionRow {
  id: string;
  storage_bucket: string | null;
  storage_path: string;
  redacted_at: string | null;
}

export interface RedactionDeps {
  /** Remove objects; returns the paths storage reports as removed. */
  remove(bucket: string, paths: string[]): Promise<{ removed: string[]; error: string | null }>;
  /** true = present, false = absent, null = could not determine. */
  exists(bucket: string, path: string): Promise<boolean | null>;
  /** Stamp redacted_at on one row; false on failure. */
  stamp(id: string): Promise<boolean>;
  defaultBucket: string;
}

export type RedactionOutcome =
  | { ok: true; redacted: string[]; alreadyRedacted: string[] }
  | { ok: false; status: number; error: string; redacted: string[]; attachments?: string[] };

export async function redactLineage(rows: RedactionRow[], deps: RedactionDeps): Promise<RedactionOutcome> {
  const alreadyRedacted = rows.filter((r) => r.redacted_at).map((r) => r.id);
  const pending = rows.filter((r) => !r.redacted_at);
  const bucketOf = (r: RedactionRow) => r.storage_bucket || deps.defaultBucket;

  const byBucket = new Map<string, RedactionRow[]>();
  for (const r of pending) byBucket.set(bucketOf(r), [...(byBucket.get(bucketOf(r)) ?? []), r]);

  const gone = new Set<string>();
  for (const [bucket, group] of byBucket) {
    const res = await deps.remove(bucket, group.map((r) => r.storage_path));
    if (res.error) return { ok: false, status: 502, error: "redaction_storage_failed", redacted: [] };
    for (const p of res.removed) gone.add(`${bucket}\u0000${p}`);
  }

  for (const r of pending) {
    const key = `${bucketOf(r)}\u0000${r.storage_path}`;
    if (gone.has(key)) continue;
    const present = await deps.exists(bucketOf(r), r.storage_path);
    if (present === null) return { ok: false, status: 502, error: "redaction_storage_check_failed", redacted: [], attachments: [r.id] };
    if (present) return { ok: false, status: 409, error: "redaction_object_still_present", redacted: [], attachments: [r.id] };
    gone.add(key); // removed by an earlier, partially failed run
  }

  const redacted: string[] = [];
  for (const r of pending) {
    if (!(await deps.stamp(r.id))) {
      return { ok: false, status: 500, error: "redaction_stamp_failed", redacted, attachments: [r.id] };
    }
    redacted.push(r.id);
  }
  return { ok: true, redacted, alreadyRedacted };
}
