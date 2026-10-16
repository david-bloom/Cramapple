#!/usr/bin/env node
// More help QA runner. DEVELOPMENT ONLY. Spends model generations: every request that can
// reach the provider counts against --cap. See README.md for the rules this encodes.
//   node run.mjs --fixtures fixtures.json --user <synthetic uuid> --cap 10 --out results.json [--only ID,ID] [--plan default]
import fs from "node:fs";
import crypto from "node:crypto";
const DEV_REF = "wmgjsdkphcyhngaffbqf"; // Production is pcntajvbdfqhbeewmdry and is refused.
const SECRETS = process.env.SECRETS_FILE || "/Users/davidbloom/Documents/Cramapple.nosync/.secrets.env";
const arg = (n, d) => { const i = process.argv.indexOf("--" + n); return i > 0 ? process.argv[i + 1] : d; };
const fixtures = JSON.parse(fs.readFileSync(arg("fixtures"), "utf8"));
const USER = arg("user"); const OUT = arg("out", "results.json"); const CAP = +arg("cap", "0");
const ONLY = (arg("only", "") || "").split(",").filter(Boolean);
const URL_ = process.env.MORE_HELP_QA_URL || `https://${DEV_REF}.supabase.co`;
if (!URL_.includes(DEV_REF)) throw new Error("Refusing: this runner only targets the Development project");
if (!USER || !CAP) throw new Error("--user and a positive --cap are required (the cap is the approved generation budget)");
const PUB = arg("publishable", "sb_publishable_75zU2AprWByjZi83_Mzmqw_VdtqaAZt"); // Dev publishable key (public)
const SECRET = (fs.readFileSync(SECRETS, "utf8").match(/^SUPABASE_DEV_SECRET_KEY=(.+)$/m) || [])[1]?.trim();
if (!SECRET) throw new Error("SUPABASE_DEV_SECRET_KEY missing from the gitignored secrets file");
const j = async (r) => { const t = await r.text(); try { return JSON.parse(t); } catch { return { raw: t.slice(0, 200) }; } };
const adm = { apikey: SECRET, "Content-Type": "application/json" };
const u = await j(await fetch(`${URL_}/auth/v1/admin/users/${USER}`, { headers: adm }));
if (!u.email?.endsWith("@example.invalid")) throw new Error("Not a synthetic @example.invalid identity; refusing");
const link = await j(await fetch(`${URL_}/auth/v1/admin/generate_link`, { method: "POST", headers: adm, body: JSON.stringify({ type: "magiclink", email: u.email }) }));
const ses = await j(await fetch(`${URL_}/auth/v1/verify`, { method: "POST", headers: { apikey: PUB, "Content-Type": "application/json" }, body: JSON.stringify({ type: "magiclink", token_hash: link.hashed_token }) }));
if (!ses.access_token) throw new Error("could not open a session for the synthetic identity");
const H = { apikey: PUB, Authorization: `Bearer ${ses.access_token}`, "Content-Type": "application/json" };
// Default plan: every fixture once with no student input, plus one focus+work variant for the
// first MCQ and first FRQ. Edit by passing a --cases JSON of {id,fixture,focus,work} instead.
let cases;
if (arg("cases")) cases = JSON.parse(fs.readFileSync(arg("cases"), "utf8"));
else {
  cases = fixtures.map((f, i) => ({ id: `C${String(i + 1).padStart(2, "0")}-u${f.unit}-${f.type}-empty`, fixture: i, focus: "", work: "" }));
  for (const t of ["mcq", "frq"]) {
    const i = fixtures.findIndex((f) => f.type === t);
    if (i >= 0) cases.push({ id: `V-${t}-focus+work`, fixture: i, focus: "I am not sure where to start", work: "I think I should begin by reading what the question gives me." });
  }
}
const out = fs.existsSync(OUT) ? JSON.parse(fs.readFileSync(OUT, "utf8")) : [];
const done = new Set(out.filter((o) => o.status === 200).map((o) => o.case));
let spent = out.length; // every recorded request counts, including failures and refusals, conservatively
for (const c of cases) {
  if (ONLY.length && !ONLY.some((p) => c.id.startsWith(p))) continue;
  if (done.has(c.id)) continue;
  if (spent >= CAP) { console.log(`LEDGER CAP ${CAP} reached; stopping`); break; }
  const f = fixtures[c.fixture];
  const ex = await j(await fetch(`${URL_}/rest/v1/rpc/get_question_experience`, { method: "POST", headers: H, body: JSON.stringify({ p_learning_session_id: f.session, p_ordinal: 1 }) }));
  const body = { requestId: crypto.randomUUID(), sessionId: f.session, questionId: f.version, ordinal: ex?.counter?.index ?? 1, focus: c.focus, work: c.work, phase: "before" };
  const t0 = Date.now(); spent++;
  const r = await fetch(`${URL_}/functions/v1/more-help`, { method: "POST", headers: H, body: JSON.stringify(body) });
  const res = await j(r);
  out.push({ case: c.id, status: r.status, ms: Date.now() - t0, subject: ex?.topic?.subjectKey, unit: ex?.topic?.unitNumber, topic: ex?.topic?.topicCode,
    type: ex?.item?.itemType, stem: ex?.item?.stem, work: c.work, focus: c.focus, result: res });
  fs.writeFileSync(OUT, JSON.stringify(out, null, 1));
  console.log(c.id, r.status, `${Date.now() - t0}ms`, res.ok ? "ok" : res.error || "error");
  if (r.status !== 200) { console.log("STOP on first non-200 (record it; do not retry without owner approval)"); break; }
  await new Promise((s) => setTimeout(s, 12000)); // stay under the 6-attempts-per-minute limit
}
console.log(`ledger: ${spent}/${CAP} requests counted (file ${OUT})`);
