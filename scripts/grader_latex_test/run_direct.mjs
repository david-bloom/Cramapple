// TASK-0074 standalone runner. Calls the OpenAI Responses API directly with the same request the production
// criterion grader builds (prompt text, schema and body ported verbatim from supabase/functions/_shared/grading-contract.ts).
// Synthetic fixtures only. Reads no database, writes nothing but the results file.
//
// Usage:  OPENAI_API_KEY=... OPENAI_MODEL=gpt-5.4-mini node run_direct.mjs results.jsonl
// HARD CAP of 54 attempts (failures count) enforced by counting lines in the results file. Stops on the first failure.
import { readFileSync, appendFileSync, existsSync } from "node:fs";
const CAP = 54;
const OUT = process.argv[2];
const KEY = process.env.OPENAI_API_KEY;
const MODEL = process.env.OPENAI_MODEL || "gpt-5.4-mini";
const MAX_TOKENS = Number(process.env.OPENAI_MAX_OUTPUT_TOKENS || 3000);
const PROMPT_VERSION = process.env.EVALUATE_ATTEMPT_PROMPT_VERSION || "v1.0.0";
if (!OUT || !KEY) { console.error("need results-file arg and OPENAI_API_KEY"); process.exit(1); }

const schema = {
  type: "object", additionalProperties: false,
  properties: {
    criterion_key: { type: "string" },
    status: { type: "string", enum: ["earned", "partially_earned", "not_yet_earned", "unable_to_determine", "not_applicable"] },
    points_awarded: { type: "integer" },
    evidence_quote: { type: ["string", "null"] },
    decision_explanation: { type: ["string", "null"] },
    minimum_fix: { type: ["string", "null"] },
    confidence: { type: "string", enum: ["high", "medium", "low"] },
  },
  required: ["criterion_key", "status", "points_awarded", "evidence_quote", "decision_explanation", "minimum_fix", "confidence"],
};
const systemPrompt = (exam) => [
  `You are Cramapple's production criterion-based grader for ${exam}.`,
  "You are grading exactly ONE criterion of a free-response question.",
  "Use only the provided released content, rubric, and student response.",
  "Do not invent evidence.",
  "Judge only the criterion given below. Do not withhold its points because of a fault that belongs to a different criterion.",
  "A criterion worth more than one point may be awarded part of its points: use partially_earned with the number of points genuinely evidenced.",
  "Use earned only for the criterion's full points, and not_yet_earned only when nothing creditable is present.",
  "Error carry forward: when this criterion uses a value the student computed incorrectly earlier, judge the method and reasoning shown here and do not withhold points solely because that inherited value is wrong.",
  "When the response is ambiguous or unsupported, mark the criterion unable_to_determine rather than guessing.",
  "evidence_quote must be an exact substring of the student response, or null.",
  "Return only the JSON object that matches the schema.",
].join(" ");
function userPrompt({ exam, title, stem, criteria, criterion, responseText }) {
  const siblings = criteria.filter((r) => r.criterion_key !== criterion.criterion_key)
    .map((r) => `- ${r.criterion_key} (${r.points_possible} pt): ${r.learner_facing_text}`);
  const contract = [`  criterion_key: ${criterion.criterion_key}`, `  points_possible: ${criterion.points_possible}`, `  learner_facing_text: ${criterion.learner_facing_text}`];
  return [
    `You are Cramapple's production grader for ${exam}.`,
    `Use only the released content and criterion contract provided below.`,
    `Do not invent facts, claims, or criteria that are not present in the contract.`,
    `points_awarded must match the status: equal to points_possible for earned, strictly between 0 and points_possible for partially_earned, and 0 otherwise.`,
    `The operation is grade_initial_attempt.`, `Prompt version: ${PROMPT_VERSION}.`, `Item title: ${title}.`, `Item type: frq.`,
    `Stem: ${stem}`, "Stimulus: none",
    `Criterion contract (grade THIS criterion only):`, contract.join("\n"),
    siblings.length > 0
      ? [`The other criteria on this item, for context only — do NOT grade them and do NOT report on them:`, siblings.join("\n"),
         `Use them only to judge whether the response's treatment of YOUR criterion is complete, rather than assuming any relevant statement it makes was aimed at your criterion.`].join("\n")
      : `This item has no other criteria.`,
    `Student response text:`, responseText, `Student response parts JSON:`, JSON.stringify({}, null, 2),
    `Return JSON matching the schema exactly, with criterion_key set to ${criterion.criterion_key}.`,
  ].filter(Boolean).join("\n\n");
}
const reasoning = /^(o\d|gpt-5)/.test(MODEL.toLowerCase().replace(/^openai\//, "")) ? { reasoning: { effort: "high" } } : {};
const fx = JSON.parse(readFileSync(new URL("./fixtures.json", import.meta.url), "utf8"));
const done = () => (existsSync(OUT) ? readFileSync(OUT, "utf8").split("\n").filter(Boolean).length : 0);
const trials = [];
for (let rep = 1; rep <= 3; rep++) for (const item of fx.items) for (const resp of ["correct", "wrong", "vague"]) for (const form of ["plain", "latex"]) trials.push({ rep, item: item.id, resp, form });
if (trials.length !== CAP) throw new Error("trial plan is " + trials.length);
for (const t of trials.slice(done())) {
  if (done() >= CAP) break;
  const item = fx.items.find((i) => i.id === t.item);
  const criteria = item.criteria[t.form];
  const criterion = criteria.find((c) => c.criterion_key === item.target);
  const up = userPrompt({ exam: fx.exam_name, title: item.title, stem: item.stem, criteria, criterion, responseText: item.responses[t.resp] });
  const body = { model: MODEL, input: [
    { role: "system", content: [{ type: "input_text", text: systemPrompt(fx.exam_name) }] },
    { role: "user", content: [{ type: "input_text", text: up }] }], store: false, ...reasoning, max_output_tokens: MAX_TOKENS,
    text: { format: { type: "json_schema", name: "criterion_grading_result", strict: true, schema } }, user: "tmp-latex-grader-test" };
  let out; const started = Date.now();
  try {
    const r = await fetch("https://api.openai.com/v1/responses", { method: "POST", headers: { Authorization: `Bearer ${KEY}`, "Content-Type": "application/json" }, body: JSON.stringify(body), signal: AbortSignal.timeout(110000) });
    const raw = await r.json().catch(() => null);
    if (!r.ok) out = { error: "openai_http_" + r.status, message: raw?.error?.message ?? null };
    else {
      const text = raw.output_text || raw.output?.flatMap((o) => o.content ?? []).find((c) => typeof c.text === "string")?.text || null;
      let parsed = null; try { parsed = text ? JSON.parse(text) : null; } catch {}
      out = { ok: true, model: MODEL, parsed, raw_text: text, usage: raw.usage ?? null, user_prompt: up };
    }
  } catch (e) { out = { error: "fetch_failed", message: String(e).slice(0, 200) }; }
  out.elapsed_ms = Date.now() - started;
  appendFileSync(OUT, JSON.stringify({ ...t, n: done() + 1, result: out }) + "\n");
  console.log(done(), t.item, t.resp, t.form, out.parsed?.status ?? out.error);
  if (!out.parsed) { console.log("STOPPING on first failure:", JSON.stringify(out).slice(0, 300)); break; }
}
console.log("attempts used:", done(), "of", CAP);
