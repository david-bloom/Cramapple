// TASK-0039 end-to-end smoke test for the deployed `byoq` edge function.
//
// Drives the real function against a real project (Development by default):
// anonymous intake, the answer-leak gate, practice responses, and the full
// phone capture leg including a real signed upload to Storage. Creates one
// anonymous owner and deletes its item (and photos) at the end.
//
// Runtime-neutral (Node 18+ or Deno). CLI usage:
//   BYOQ_URL=https://<ref>.supabase.co BYOQ_ANON_KEY=<anon or publishable key> \
//   BYOQ_ORIGIN=https://app.cramapple.com node scripts/byoq_smoke.mjs

export async function runByoqSmoke(
  { url, key, origin = "https://app.cramapple.com", log = console.log },
) {
  const fn = `${url}/functions/v1/byoq`;
  let failures = 0;
  const check = (label, ok, detail = "") => {
    log(`${ok ? "PASS" : "FAIL"}  ${label}${ok ? "" : `  ${detail}`}`);
    if (!ok) failures++;
  };

  async function call(body) {
    const res = await fetch(fn, {
      method: "POST",
      headers: {
        "content-type": "application/json",
        apikey: key,
        authorization: `Bearer ${key}`,
        origin,
      },
      body: JSON.stringify(body),
    });
    const text = await res.text();
    let json = null;
    try {
      json = JSON.parse(text);
    } catch { /* keep text */ }
    return {
      status: res.status,
      json,
      text,
      cors: res.headers.get("access-control-allow-origin"),
    };
  }

  // A minimal valid PNG with a tEXt metadata chunk (so stripping is observable).
  function crc32(bytes) {
    let c = 0xffffffff;
    for (const b of bytes) {
      c ^= b;
      for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    }
    return (c ^ 0xffffffff) >>> 0;
  }
  function chunk(type, data) {
    const out = new Uint8Array(12 + data.length);
    const dv = new DataView(out.buffer);
    dv.setUint32(0, data.length);
    out.set(new TextEncoder().encode(type), 4);
    out.set(data, 8);
    dv.setUint32(8 + data.length, crc32(out.slice(4, 8 + data.length)));
    return out;
  }
  function png() {
    const ihdr = new Uint8Array(13);
    const dv = new DataView(ihdr.buffer);
    dv.setUint32(0, 3);
    dv.setUint32(4, 2);
    ihdr.set([8, 2, 0, 0, 0], 8);
    const idat = Uint8Array.from(
      atob("eJxjYGBgAGMGBgYGBgYGAAAQAAE="),
      (c) => c.charCodeAt(0),
    );
    const text = new TextEncoder().encode(
      "GPS\0" + "40.7128,-74.0060 ".repeat(80),
    );
    const parts = [
      new Uint8Array([137, 80, 78, 71, 13, 10, 26, 10]),
      chunk("IHDR", ihdr),
      chunk("tEXt", text),
      chunk("IDAT", idat),
      chunk("IEND", new Uint8Array()),
    ];
    const out = new Uint8Array(parts.reduce((n, p) => n + p.length, 0));
    let o = 0;
    for (const p of parts) {
      out.set(p, o);
      o += p.length;
    }
    return out;
  }

  const start = await call({ operation: "start" });
  check(
    "start creates no owner (page views are free)",
    start.status === 200 && !start.json?.result?.owner_key,
    start.text,
  );
  check(
    "CORS allows the app origin",
    start.cors === origin,
    `got ${start.cors}`,
  );
  const firstItem = await call({ operation: "create_item", stem: "Smoke: first draft" });
  const ownerKey = firstItem.json?.result?.owner_key;
  check("create_item issues an anonymous owner key", ownerKey?.startsWith("byoq_"), firstItem.text);
  if (!ownerKey) {
    log("cannot continue without an owner key");
    return failures;
  }

  const subjects = await call({ operation: "list_subjects" });
  check(
    "list_subjects returns the real taxonomy",
    (subjects.json?.result?.subjects ?? []).includes("ap_statistics"),
    subjects.text,
  );
  const topics = await call({
    operation: "list_topics",
    subject_key: "ap_statistics",
  });
  const firstTopic = topics.json?.result?.units?.[0]?.topics?.[0];
  check(
    "list_topics returns units/topics",
    Boolean(firstTopic?.topic_code),
    topics.text,
  );

  const created = await call({
    operation: "create_item",
    owner_key: ownerKey,
    item_type: "mcq",
    stem: "Which measure of center is resistant to outliers?\nAnswer: B",
    choices: ["Mean", "Median", "Range"],
    subject_key: "ap_statistics",
    unit_number: topics.json?.result?.units?.[0]?.unit_number,
    topic_code: firstTopic?.topic_code,
    title: "Smoke Answer: C",
    source_note: "Smoke test",
  });
  const item = created.json?.result?.item;
  check("create_item succeeds", created.status === 200, created.text);
  check(
    "pasted answer detected and masked",
    item?.answer_text_detected === true && !item?.stem?.includes("Answer: B") &&
      !item?.title?.includes("Answer: C"),
    JSON.stringify(item),
  );

  const blocked = await call({
    operation: "confirm_item",
    owner_key: ownerKey,
    item_id: item?.id,
  });
  check(
    "confirm blocked while answer text present",
    blocked.status === 409 &&
      blocked.json?.readiness_problem === "answer_text_detected",
    blocked.text,
  );
  await call({
    operation: "remove_flagged_text",
    owner_key: ownerKey,
    item_id: item?.id,
  });
  const confirmed = await call({
    operation: "confirm_item",
    owner_key: ownerKey,
    item_id: item?.id,
  });
  check(
    "confirm succeeds after removal",
    confirmed.json?.result?.item?.status === "ready",
    confirmed.text,
  );

  const saved = await call({
    operation: "save_response",
    owner_key: ownerKey,
    item_id: item?.id,
    selected_choice_key: "B",
    is_final: true,
  });
  check(
    "save_response is unscored",
    saved.status === 200 && saved.json?.result?.scoring?.scored === false,
    saved.text,
  );
  check(
    "no answer-key fields anywhere in the response",
    !/is_correct|score_points|verdict/.test(saved.text),
  );

  const outsider = await call({ operation: "create_item", stem: "Smoke: outsider" });
  const peek = await call({
    operation: "get_item",
    owner_key: outsider.json?.result?.owner_key,
    item_id: item?.id,
  });
  check("a different owner gets 404", peek.status === 404, peek.text);

  const mint = await call({
    operation: "mint_pairing",
    owner_key: ownerKey,
    item_id: item?.id,
    capture_role: "question",
  });
  const handle = mint.json?.result?.pairing_handle;
  check(
    "mint_pairing returns a capability",
    handle?.startsWith("bqcap_"),
    mint.text,
  );
  const desc = await call({
    operation: "describe_capture",
    pairing_handle: handle,
  });
  check(
    "describe_capture pairs the phone",
    desc.json?.result?.pairing?.state === "paired",
    desc.text,
  );
  const up = await call({
    operation: "create_capture_upload",
    pairing_handle: handle,
    media_type: "image/png",
  });
  check(
    "create_capture_upload returns a signed URL",
    Boolean(up.json?.result?.signed_url),
    up.text,
  );
  if (!up.json?.result?.signed_url) {
    log("cannot continue without an upload URL");
    return failures;
  }
  const put = await fetch(up.json?.result?.signed_url, {
    method: "PUT",
    headers: { "content-type": "image/png", "x-upsert": "false" },
    body: png(),
  });
  check(
    "signed upload to Storage succeeds",
    put.ok,
    `${put.status} ${await put.text()}`,
  );
  const sub = await call({
    operation: "submit_capture",
    pairing_handle: handle,
    storage_path: up.json?.result?.storage_path,
  });
  check(
    "submit_capture binds page 1",
    sub.json?.result?.attachment?.page_sequence === 1,
    sub.text,
  );
  const fin = await call({
    operation: "finish_capture",
    pairing_handle: handle,
  });
  check(
    "finish_capture consumes the capability",
    fin.json?.result?.pairing?.state === "consumed",
    fin.text,
  );
  const replay = await call({
    operation: "create_capture_upload",
    pairing_handle: handle,
    media_type: "image/png",
  });
  check(
    "a consumed capability cannot upload again",
    replay.status === 409,
    replay.text,
  );

  const got = await call({
    operation: "get_item",
    owner_key: ownerKey,
    item_id: item?.id,
  });
  const att = got.json?.result?.attachments?.[0];
  check(
    "get_item returns the photo with a signed URL",
    Boolean(att?.url),
    got.text,
  );
  check(
    "get_item returns real reference material for the topic",
    got.json?.result?.reference?.missing === false,
    JSON.stringify(got.json?.result?.reference)?.slice(0, 300),
  );
  if (att?.url) {
    const img = new Uint8Array(await (await fetch(att.url)).arrayBuffer());
    const latin = Array.from(img, (b) => String.fromCharCode(b)).join("");
    check(
      "stored photo has metadata stripped",
      img.length > 0 && !latin.includes("40.7128"),
      `len ${img.length}`,
    );
  }

  const del = await call({
    operation: "delete_item",
    owner_key: ownerKey,
    item_id: item?.id,
  });
  check(
    "delete_item removes the item and photos",
    del.json?.result?.deleted === true,
    del.text,
  );
  // A signed URL already handed out can keep serving a CDN-cached copy until
  // it expires (<= 10 minutes), so deletion is checked at the source: the
  // item is gone for its owner. Object removal itself is verified in SQL
  // (storage.objects) by the release checklist.
  const after = await call({
    operation: "get_item",
    owner_key: ownerKey,
    item_id: item?.id,
  });
  check("deleted item is gone for its owner", after.status === 404, after.text);

  log(failures ? `${failures} check(s) FAILED` : "All checks passed");
  return failures;
}

if (
  typeof process !== "undefined" &&
  process.argv?.[1]?.endsWith("byoq_smoke.mjs")
) {
  const url = process.env.BYOQ_URL;
  const key = process.env.BYOQ_ANON_KEY;
  if (!url || !key) throw new Error("set BYOQ_URL and BYOQ_ANON_KEY");
  const failures = await runByoqSmoke({
    url,
    key,
    origin: process.env.BYOQ_ORIGIN,
  });
  process.exit(failures ? 1 : 0);
}
