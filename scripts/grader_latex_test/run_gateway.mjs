// Synthetic-only continuation. All prior/failed/reserved attempts count.
// The Gateway key stays in Development; the client uses the existing QA login.
import { readFileSync, appendFileSync, writeFileSync, renameSync, openSync, closeSync, unlinkSync } from "node:fs";
import { randomUUID } from "node:crypto";
const CAP = 54;
const OUT = process.argv[2];
const LIMIT = Number(process.argv[3] ?? 53);
if (!OUT || !Number.isInteger(LIMIT) || LIMIT < 1 || LIMIT > CAP) throw new Error("need preserved ledger path and valid limit");
const FN_URL = "https://wmgjsdkphcyhngaffbqf.supabase.co/functions/v1/tmp-latex-grader-test";
const QA_FILE = "/private/tmp/more-help-qa.json";
const qa = JSON.parse(readFileSync(QA_FILE, "utf8"));
const publicKey = readFileSync("/private/tmp/more-help-dev-public-key.txt", "utf8").trim();
const fx = JSON.parse(readFileSync(new URL("./fixtures.json", import.meta.url), "utf8"));
const trials = [];
for (let rep = 1; rep <= 3; rep++) for (const item of fx.items)
  for (const resp of ["correct", "wrong", "vague"]) for (const form of ["plain", "latex"])
    trials.push({ rep, item: item.id, resp, form });
if (trials.length !== 54) throw new Error("fixture plan changed");
const lock = OUT + ".lock";
const handle = openSync(lock, "wx", 0o600);
const readRows = () => readFileSync(OUT, "utf8").split("\n").filter(Boolean).map(JSON.parse);
const sameTrial = (a, b) => ["rep", "item", "resp", "form"].every(k => a[k] === b[k]);
const save = rows => {
  writeFileSync(OUT + ".tmp", rows.map(r => JSON.stringify(r)).join("\n") + "\n", { mode: 0o600 });
  renameSync(OUT + ".tmp", OUT);
};
async function post(body) {
  const response = await fetch(FN_URL, {
    method: "POST", headers: { Authorization: "Bearer " + qa.token, apikey: publicKey, "Content-Type": "application/json" },
    body: JSON.stringify(body), signal: AbortSignal.timeout(125000),
  });
  const data = await response.json().catch(() => null);
  return { status: response.status, data };
}
try {
  // Authenticate/preflight without invoking the model. No credential is printed.
  let ping = await post({ ping: true });
  if (ping.status === 401 || ping.status === 403) {
    const auth = await fetch("https://wmgjsdkphcyhngaffbqf.supabase.co/auth/v1/token?grant_type=password", {
      method: "POST", headers: { apikey: publicKey, "Content-Type": "application/json" },
      body: JSON.stringify({ email: qa.email, password: qa.password }), signal: AbortSignal.timeout(15000),
    });
    const data = await auth.json();
    if (!auth.ok || !data.access_token) throw new Error("QA authentication failed");
    qa.token = data.access_token;
    writeFileSync(QA_FILE, JSON.stringify(qa), { mode: 0o600 });
    ping = await post({ ping: true });
  }
  if (ping.status !== 200 || !ping.data?.has_gateway_key || ping.data.model !== "openai/gpt-5.4-mini" || ping.data.max_output_tokens !== 3000 || ping.data.reasoning_effort !== "high")
    throw new Error("Gateway preflight failed: " + JSON.stringify({ status: ping.status, data: ping.data }));
  let made = 0;
  for (;;) {
    const rows = readRows();
    if (rows.some(r => r.result?.state === "reserved")) throw new Error("unresolved reserved call: audit before resuming");
    if (rows.length >= CAP || made >= LIMIT) break;
    const trialIndex = trials.findIndex(t => !rows.some(r => sameTrial(t, r) && r.result?.parsed));
    if (trialIndex < 0) break;
    const trial = trials[trialIndex];
    const row = { ...trial, n: rows.length + 1, route: "vercel-gateway", requestId: randomUUID(), result: { state: "reserved" } };
    // Reserve the allowance before a request; an unknown outcome cannot be retried silently.
    appendFileSync(OUT, JSON.stringify(row) + "\n");
    made++;
    let result;
    try {
      const response = await post({ trialIndex, requestId: row.requestId });
      result = response.data ?? { error: "invalid_http_response" };
      if (response.status !== 200 && !result.error) result = { error: "harness_http_" + response.status };
      const p = result.parsed;
      if (p && (p.criterion_key !== fx.items.find(i => i.id === trial.item).target || !["earned", "partially_earned", "not_yet_earned", "unable_to_determine", "not_applicable"].includes(p.status) || !Number.isInteger(p.points_awarded) || p.points_awarded < 0 || p.points_awarded > 1))
        result = { ...result, parsed: null, error: "invalid_grading_result" };
    } catch { result = { error: "driver_fetch_failed_unknown_outcome" }; }
    const updated = readRows();
    updated[rows.length] = { ...row, result };
    save(updated);
    console.log(row.n, trial.item, trial.resp, trial.form, result.parsed?.status ?? result.error ?? "no_grade");
    if (!result.parsed) { console.log("STOPPING on first Gateway failure"); break; }
  }
  const rows = readRows();
  console.log("attempts used:", rows.length, "of", CAP, "valid grades:", rows.filter(r => r.result?.parsed).length);
} finally {
  closeSync(handle);
  unlinkSync(lock);
}
