// Offline grading-engine core run for the second ten-case coaching packet.
// Uses the same prompt, request schema, and sanitizer imported by evaluate-attempt.
// It never calls Supabase or writes Production records.
import {
  buildGradingPrompt,
  buildGradingRequestBody,
  buildSystemPrompt,
  extractOutputText,
  extractUsage,
  sanitizeModelResult,
  type FeedbackCriterionRow,
} from "../../../supabase/functions/_shared/grading-contract.ts";

const here = new URL("./", import.meta.url);
const source = new URL("./ten_case_test_2026_11_14_round2/results.json", here);
const output = new URL("./ten_case_engine_test_2026_11_14/grades.json", here);
const model = "gpt-5.4-mini";
const maxCalls = 10;
const maxAttempts = 14;
const maxOutputTokens = 16000;

type Case = {
  subject: string;
  content_key: string;
  synthetic_type: string;
  question_text: string;
  stimulus: string | null;
  response_text: string;
  rubric: Array<Record<string, unknown>>;
  labels: Record<string, string>;
};

const cases = JSON.parse(await Deno.readTextFile(source)) as Case[];
if (cases.length !== maxCalls) throw new Error("Expected exactly ten cases");
await Deno.mkdir(new URL("./ten_case_engine_test_2026_11_14/", here), { recursive: true });
let grades: Array<Record<string, unknown>> = [];
try { grades = JSON.parse(await Deno.readTextFile(output)); } catch (e) {
  if (!(e instanceof Deno.errors.NotFound)) throw e;
}
if (grades.length > maxCalls) throw new Error("Ten-call cap exceeded");
const failureFile = new URL("./ten_case_engine_test_2026_11_14/failures.jsonl", here);
let failureCount = 0;
try {
  failureCount = (await Deno.readTextFile(failureFile)).trim().split("\n").filter(Boolean).length;
} catch (e) { if (!(e instanceof Deno.errors.NotFound)) throw e; }
const done = new Set(grades.map((x) => String(x.content_key)));

for (const item of cases) {
  if (done.has(item.content_key)) continue;
  if (grades.length >= maxCalls) throw new Error("Ten-call cap reached");
  if (grades.length + failureCount >= maxAttempts) throw new Error("Attempt cap reached");
  const criteria: FeedbackCriterionRow[] = item.rubric.map((row) => ({
    criterion_key: String(row.criterion_key),
    learner_facing_text: String(row.learner_facing_text ?? row.evidence_requirements ?? ""),
    points_possible: Number(row.points_possible),
    evidence_requirements: row.evidence_requirements ? String(row.evidence_requirements) : null,
    minimum_fix: row.minimum_fix ? String(row.minimum_fix) : null,
    accepted_variants: row.accepted_variants ?? null,
  }));
  const examName = item.subject === "biology" ? "AP Biology" : "AP Statistics";
  const body = buildGradingRequestBody({
    modelId: model,
    maxOutputTokens,
    systemPrompt: buildSystemPrompt(examName),
    userPrompt: buildGradingPrompt({
      operation: "grade_initial_attempt", promptVersion: "offline-coaching-test-2026-11-14",
      examName, itemTitle: item.content_key, itemType: "frq",
      stem: item.question_text, stimulus: item.stimulus ?? null,
      responseText: item.response_text, responseParts: {}, criteria,
    }),
    userIdHash: "synthetic-coaching-grading-test-2026-11-14",
  });
  const start = performance.now();
  const response = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${Deno.env.get("OPENAI_API_KEY")}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
    signal: AbortSignal.timeout(120_000),
  });
  const raw = await response.json() as Record<string, unknown>;
  if (!response.ok) throw new Error(`Grader HTTP ${response.status}: ${JSON.stringify(raw.error)}`);
  const text = extractOutputText(raw);
  if (!text) {
    const failure = {
      content_key: item.content_key, response_status: raw.status,
      response_id: raw.id, usage: extractUsage(raw),
      latency_ms: Math.round(performance.now() - start),
      max_output_tokens: maxOutputTokens,
    };
    await Deno.writeTextFile(failureFile, JSON.stringify(failure) + "\n", { append: true, create: true });
    throw new Error(`Grader returned no output for ${item.content_key}; response status ${raw.status}`);
  }
  const parsed = JSON.parse(text);
  const grade = sanitizeModelResult(parsed, criteria, {
    responseText: item.response_text, responseParts: {},
  });
  grades.push({
    content_key: item.content_key, subject: item.subject,
    synthetic_type: item.synthetic_type, provisional_labels: item.labels,
    grade, model, response_id: raw.id, response_status: raw.status,
    usage: extractUsage(raw), latency_ms: Math.round(performance.now() - start),
  });
  await Deno.writeTextFile(output, JSON.stringify(grades, null, 2) + "\n");
  console.log(`${grades.length}/10 ${item.content_key}: ${grade.points_earned}/${grade.points_available} ${grade.status}`);
}
console.log(`Saved ${output.pathname}`);
