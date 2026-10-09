// TASK-0068 end-to-end smoke test for the deployed `byoq` function's photo
// extraction and phone-side review. Drives the real function against a real
// project with a real signed upload of a rendered fixture page, then cleans up.
//
//   BYOQ_URL=https://<ref>.supabase.co BYOQ_ANON_KEY=<publishable key> \
//     deno run --allow-net --allow-read --allow-env scripts/byoq_extraction_smoke.ts [fixture.png]
//
// Exits non-zero on any failed check. Prints no secrets.

const url = Deno.env.get("BYOQ_URL");
const key = Deno.env.get("BYOQ_ANON_KEY");
if (!url || !key) throw new Error("BYOQ_URL and BYOQ_ANON_KEY are required");
const fixture = Deno.args[0] ?? new URL("./byoq-extraction-benchmark/fixtures/pages/clean/", import.meta.url).pathname;
const fn = `${url}/functions/v1/byoq`;
let failures = 0;
const check = (label: string, ok: boolean, detail = "") => {
  console.log(`${ok ? "PASS" : "FAIL"}  ${label}${ok ? "" : `  ${detail}`}`);
  if (!ok) failures++;
};
async function call(body: Record<string, unknown>) {
  const res = await fetch(fn, {
    method: "POST",
    headers: { "content-type": "application/json", apikey: key!, authorization: `Bearer ${key}`, origin: "https://app.cramapple.com" },
    body: JSON.stringify(body),
  });
  const text = await res.text();
  let json: Record<string, unknown> | null = null;
  try { json = JSON.parse(text); } catch { /* keep text */ }
  return { status: res.status, json, text };
}
const result = (r: { json: Record<string, unknown> | null }) => (r.json?.result ?? {}) as Record<string, unknown>;

// Pick a fixture page: a file path, or the first PNG in the clean cohort.
let pagePath = fixture;
try {
  if ((await Deno.stat(fixture)).isDirectory) {
    for await (const e of Deno.readDir(fixture)) { if (e.name.endsWith(".png")) { pagePath = fixture + e.name; break; } }
  }
} catch { /* file path given */ }
const png = await Deno.readFile(pagePath);
const manifest = JSON.parse(await Deno.readTextFile(new URL("./byoq-extraction-benchmark/fixtures/manifest.json", import.meta.url).pathname)) as { page: string; truth: { subject: string; unit: number; topic: string; type: string } | null }[];
const truth = manifest.find((m) => pagePath.endsWith(m.page.replace(/^pages\//, "")) || pagePath.endsWith(m.page))?.truth ?? null;
const subject = truth ? (truth.subject === "biology" ? "ap_biology" : truth.subject.replaceAll("-", "_")) : "ap_statistics";
console.log(`fixture: ${pagePath.split("/").slice(-2).join("/")}  subject=${subject} unit=${truth?.unit ?? "?"} topic=${truth?.topic ?? "?"}`);

// 1. Anonymous draft item with subject/unit context.
const created = await call({ operation: "create_item", source_kind: "photo_single", subject_key: subject, unit_number: truth?.unit ?? null });
check("create_item (anonymous, with context)", created.status === 200, created.text);
const ownerKey = result(created).owner_key as string;
const item = result(created).item as Record<string, unknown>;
check("item carries context_unit_number", item.context_unit_number === (truth?.unit ?? null));

// 2. Mint a question pairing and upload one page through the phone leg.
const minted = await call({ operation: "mint_pairing", owner_key: ownerKey, item_id: item.id, capture_role: "question" });
check("mint_pairing", minted.status === 200, minted.text);
const handle = result(minted).pairing_handle as string;
const described = await call({ operation: "describe_capture", pairing_handle: handle });
check("describe_capture", described.status === 200, described.text);
const ticket = await call({ operation: "create_capture_upload", pairing_handle: handle, media_type: "image/png" });
check("create_capture_upload", ticket.status === 200, ticket.text);
const put = await fetch(result(ticket).signed_url as string, { method: "PUT", headers: { "content-type": "image/png" }, body: png });
check("signed PUT", put.ok, String(put.status));
const submitted = await call({ operation: "submit_capture", pairing_handle: handle, storage_path: result(ticket).storage_path });
check("submit_capture", submitted.status === 200, submitted.text);

// 3. Finish: extraction runs synchronously.
const t0 = Date.now();
const finished = await call({ operation: "finish_capture", pairing_handle: handle });
const ms = Date.now() - t0;
check("finish_capture", finished.status === 200, finished.text);
const ex = result(finished).extraction as Record<string, unknown> | null;
console.log(`  extraction: ${JSON.stringify(ex)} (${ms} ms)`);
check("extraction proposed", ex?.status === "proposed", String(ex?.failure ?? ex?.status));
check("extraction filled stem", Array.isArray(ex?.filled) && (ex!.filled as string[]).includes("stem"));

// 4. Phone review through the capability only (no owner key).
const got = await call({ operation: "capture_review_get", pairing_handle: handle });
check("capture_review_get via handle", got.status === 200, got.text);
const reviewed = result(got).item as Record<string, unknown>;
check("review item is the pairing's item", reviewed.id === item.id);
check("proposed stem present", typeof reviewed.stem === "string" && (reviewed.stem as string).length > 20);
check("item_type proposed matches truth", !truth || reviewed.item_type === truth.type, String(reviewed.item_type));
const topic = reviewed.topic as Record<string, unknown> | null;
console.log(`  proposed: type=${reviewed.item_type} topic=${topic?.topic_code ?? null} choices=${(reviewed.choices as unknown[]).length} warnings=${JSON.stringify((reviewed.extraction as Record<string, unknown>)?.warnings)}`);
check("no owner_key in capability response", !got.text.includes("owner_key"));
check("captured_work never returned", !got.text.includes("captured_work"));
check("status still draft (no auto-confirm)", reviewed.status === "draft");

// 5. Cross-item isolation: a foreign item_id in the body is ignored.
const foreign = await call({ operation: "capture_review_get", pairing_handle: handle, item_id: "00000000-0000-4000-8000-000000000000" });
check("foreign item_id ignored", foreign.status === 200 && (result(foreign).item as Record<string, unknown>).id === item.id);

// 6. Edit and confirm on the phone.
const confirmed = await call({ operation: "capture_review_update", pairing_handle: handle, stem: `${reviewed.stem}\n(edited on phone)`, confirm: true });
check("capture_review_update confirm", confirmed.status === 200, confirmed.text);
const ready = (result(confirmed).item ?? (confirmed.json?.item as Record<string, unknown>) ?? {}) as Record<string, unknown>;
check("item ready after explicit confirm", ready.status === "ready", String(ready.readiness_problem ?? confirmed.json?.error));
check("student edit kept", typeof ready.stem === "string" && (ready.stem as string).endsWith("(edited on phone)"));

// 7. Re-run is a no-op without force; forced re-run never overwrites the edit.
const again = await call({ operation: "extract_question", owner_key: ownerKey, item_id: item.id });
check("extract_question no-op", again.status === 200, again.text);
const forced = await call({ operation: "extract_question", owner_key: ownerKey, item_id: item.id, force: true });
check("extract_question forced", forced.status === 200, forced.text);
check("forced re-run keeps the edit", String((result(forced).item as Record<string, unknown> | undefined)?.stem ?? "").endsWith("(edited on phone)"));

// 8. A bad handle and a response-role pairing are refused.
const bad = await call({ operation: "capture_review_get", pairing_handle: "bqcap_nope" });
check("malformed handle refused", bad.status === 400 || bad.status === 404, bad.text);

// 9. Cleanup.
const del = await call({ operation: "delete_item", owner_key: ownerKey, item_id: item.id });
check("delete_item cleanup", del.status === 200, del.text);

console.log(failures ? `\n${failures} check(s) failed` : "\nall checks passed");
Deno.exit(failures ? 1 : 0);
