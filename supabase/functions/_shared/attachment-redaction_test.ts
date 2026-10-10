import { assertEquals } from "jsr:@std/assert@1";
import { redactLineage, type RedactionDeps, type RedactionRow } from "./attachment-redaction.ts";

const rows = (): RedactionRow[] => [
  { id: "orig", storage_bucket: "learner-uploads", storage_path: "u/orig.png", redacted_at: null },
  { id: "derived", storage_bucket: "learner-uploads", storage_path: "u/derived.png", redacted_at: null },
];

function deps(over: Partial<RedactionDeps> & { stamped?: string[] } = {}): RedactionDeps & { stamped: string[] } {
  const stamped = over.stamped ?? [];
  return {
    defaultBucket: "learner-uploads",
    remove: over.remove ?? ((_b, paths) => Promise.resolve({ removed: paths, error: null })),
    exists: over.exists ?? (() => Promise.resolve(false)),
    stamp: over.stamp ?? ((id) => { stamped.push(id); return Promise.resolve(true); }),
    stamped,
  };
}

Deno.test("happy path removes then stamps every pending row", async () => {
  const d = deps();
  assertEquals(await redactLineage(rows(), d), { ok: true, redacted: ["orig", "derived"], alreadyRedacted: [] });
  assertEquals(d.stamped, ["orig", "derived"]);
});

Deno.test("a storage error stamps nothing", async () => {
  const d = deps({ remove: () => Promise.resolve({ removed: [], error: "boom" }) });
  const out = await redactLineage(rows(), d);
  assertEquals(out.ok, false);
  assertEquals(!out.ok && out.error, "redaction_storage_failed");
  assertEquals(d.stamped, []);
});

Deno.test("an object storage did not report removed and still exists is never stamped", async () => {
  const d = deps({
    remove: (_b, paths) => Promise.resolve({ removed: paths.filter((p) => p !== "u/derived.png"), error: null }),
    exists: (_b, p) => Promise.resolve(p === "u/derived.png"),
  });
  const out = await redactLineage(rows(), d);
  assertEquals(!out.ok && out.error, "redaction_object_still_present");
  assertEquals(!out.ok && out.attachments, ["derived"]);
  assertEquals(d.stamped, []);
});

Deno.test("an unverifiable existence check stops before stamping", async () => {
  const d = deps({ remove: () => Promise.resolve({ removed: [], error: null }), exists: () => Promise.resolve(null) });
  const out = await redactLineage(rows(), d);
  assertEquals(!out.ok && out.error, "redaction_storage_check_failed");
  assertEquals(d.stamped, []);
});

Deno.test("a stamp failure reports what was stamped, and a retry resumes cleanly", async () => {
  let fail = true;
  const stamped: string[] = [];
  const first = deps({ stamped, stamp: (id) => { if (id === "derived" && fail) return Promise.resolve(false); stamped.push(id); return Promise.resolve(true); } });
  const out = await redactLineage(rows(), first);
  assertEquals(out, { ok: false, status: 500, error: "redaction_stamp_failed", redacted: ["orig"], attachments: ["derived"] });

  // Retry: "orig" is stamped now; the bytes of both are already gone (removal returns nothing).
  fail = false;
  const retryRows = rows().map((r) => r.id === "orig" ? { ...r, redacted_at: "T" } : r);
  const retry = deps({ stamped, remove: () => Promise.resolve({ removed: [], error: null }), exists: () => Promise.resolve(false), stamp: first.stamp });
  assertEquals(await redactLineage(retryRows, retry), { ok: true, redacted: ["derived"], alreadyRedacted: ["orig"] });
  assertEquals(stamped, ["orig", "derived"]);
});

Deno.test("an already-redacted lineage is a no-op success", async () => {
  const d = deps();
  const done = rows().map((r) => ({ ...r, redacted_at: "T" }));
  assertEquals(await redactLineage(done, d), { ok: true, redacted: [], alreadyRedacted: ["orig", "derived"] });
});
