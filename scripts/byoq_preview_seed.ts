// TASK-0068 helper: seed one anonymous BYOQ draft with subject/unit context and
// a fresh question pairing, so the review screen can be exercised in a browser
// against a deployed function. Prints the item id, the owner key (a throwaway
// anonymous secret; delete the item afterwards with `delete`), and the capture
// path. Usage:
//   BYOQ_URL=... BYOQ_ANON_KEY=... deno run --allow-net --allow-env scripts/byoq_preview_seed.ts seed ap_statistics 1
//   BYOQ_URL=... BYOQ_ANON_KEY=... deno run --allow-net --allow-env scripts/byoq_preview_seed.ts delete <owner_key> <item_id>
const url = Deno.env.get("BYOQ_URL")!;
const key = Deno.env.get("BYOQ_ANON_KEY")!;
async function call(body: Record<string, unknown>) {
  const r = await fetch(`${url}/functions/v1/byoq`, {
    method: "POST",
    headers: { "content-type": "application/json", apikey: key, authorization: `Bearer ${key}`, origin: "https://app.cramapple.com" },
    body: JSON.stringify(body),
  });
  const j = await r.json();
  if (r.status !== 200) throw new Error(`${body.operation} ${r.status} ${JSON.stringify(j)}`);
  return j.result as Record<string, unknown>;
}
const [cmd, a, b] = Deno.args;
if (cmd === "seed") {
  const created = await call({ operation: "create_item", source_kind: "photo_single", subject_key: a, unit_number: Number(b) });
  const item = created.item as Record<string, unknown>;
  const minted = await call({ operation: "mint_pairing", owner_key: created.owner_key, item_id: item.id, capture_role: "question" });
  console.log(JSON.stringify({ item_id: item.id, owner_key: created.owner_key, capture_path: `/byoq/capture?t=${encodeURIComponent(minted.pairing_handle as string)}` }));
} else if (cmd === "delete") {
  await call({ operation: "delete_item", owner_key: a, item_id: b });
  console.log("deleted");
}
