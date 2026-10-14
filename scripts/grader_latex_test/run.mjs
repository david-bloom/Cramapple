// TASK-0074 harness driver. Dev only, synthetic fixtures only. HARD CAP of 54 attempts (failures count),
// enforced by counting lines in the results file so a crash or restart cannot overspend.
import { readFileSync, appendFileSync, existsSync } from "node:fs";
import { execFileSync } from "node:child_process";
const CAP = 54;
const OUT = process.argv[2];
const FN_URL = "https://wmgjsdkphcyhngaffbqf.supabase.co/functions/v1/tmp-latex-grader-test";
const fx = JSON.parse(readFileSync(new URL("./fixtures.json", import.meta.url), "utf8"));
const done = () => (existsSync(OUT) ? readFileSync(OUT, "utf8").split("\n").filter(Boolean).length : 0);
const trials = [];
for (let rep = 1; rep <= 3; rep++)
  for (const item of fx.items)
    for (const resp of ["correct", "wrong", "vague"])
      for (const form of ["plain", "latex"]) trials.push({ rep, item: item.id, resp, form });
if (trials.length !== CAP) throw new Error("trial plan is " + trials.length + ", not " + CAP);
for (const t of trials.slice(done())) {
  if (done() >= CAP) break;
  const item = fx.items.find((i) => i.id === t.item);
  const payload = JSON.stringify({
    exam_name: fx.exam_name, item_title: item.title, stem: item.stem,
    criteria: item.criteria[t.form], criterion_key: item.target, response_text: item.responses[t.resp],
  });
  let out;
  try {
    out = JSON.parse(execFileSync("curl", ["-sS", "-m", "130", "-X", "POST", FN_URL, "-H", "Content-Type: application/json", "-d", "@-"], { input: payload, encoding: "utf8" }));
  } catch (e) { out = { error: "driver_error", detail: String(e).slice(0, 200) }; }
  appendFileSync(OUT, JSON.stringify({ ...t, n: done() + 1, result: out }) + "\n");
  console.log(done(), t.item, t.resp, t.form, out.parsed?.status ?? out.error);
  // Stop on the first failure: a refusal (billing, auth, rate limit) will not fix itself and every attempt counts against the cap.
  if (!out.parsed) { console.log("STOPPING on first failure:", JSON.stringify(out).slice(0, 300)); break; }
}
console.log("attempts used:", done(), "of", CAP);
