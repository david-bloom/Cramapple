import { streamObject } from 'ai';
import { z } from 'zod';

const MODELS = [
  'openai/gpt-4o-mini',
  'openai/gpt-5.5',
  'anthropic/claude-haiku-4-5',
  'google/gemini-2.5-flash',
];

const CRITERION_SCHEMA = z.object({
  evidence_quote: z
    .string()
    .describe('The shortest exact phrase from the student response that could support earning the point. Empty string if no phrase supports it.'),
  gate: z.enum(['pass', 'fail']).describe('Whether the response meets the evidence gate for this criterion.'),
  status: z
    .enum(['earned', 'not_earned', 'unable_to_determine'])
    .describe('Final scoring decision.'),
  confidence: z.number().min(0).max(1).describe('Confidence in this decision, 0 to 1.'),
  minimum_fix: z.string().describe('Shortest improvement that would earn the point. Empty if already earned.'),
});

const PROMPT = `
You are grading one criterion of an AP Biology FRQ.

Question stem: Explain why running in heat decreases enzyme activity.

Criterion C1: response must identify that high temperature disrupts enzyme tertiary structure.

Student response: "When it gets hot the enzyme stops working because the heat breaks the shape of the active site."

Decide whether C1 is earned. The evidence_quote must be a verbatim phrase from the student response.
`.trim();

const pad = (s, n) => String(s).padEnd(n);

console.log('Native structured output check via Vercel AI Gateway\n');
console.log(pad('model', 32), pad('status', 12), pad('ttfb', 8), pad('total', 8), pad('valid', 8), 'object summary / error');
console.log('-'.repeat(110));

for (const model of MODELS) {
  const start = performance.now();
  let firstAt = null;
  try {
    const result = streamObject({
      model,
      schema: CRITERION_SCHEMA,
      prompt: PROMPT,
    });
    for await (const _ of result.partialObjectStream) {
      if (firstAt === null) firstAt = performance.now();
    }
    const end = performance.now();
    const final = await result.object;
    const ttfb = firstAt ? `${(firstAt - start).toFixed(0)}ms` : '-';
    const total = `${(end - start).toFixed(0)}ms`;
    const summary = `status=${final.status} gate=${final.gate} conf=${final.confidence}`;
    console.log(pad(model, 32), pad('ok', 12), pad(ttfb, 8), pad(total, 8), pad('yes', 8), summary);
  } catch (err) {
    let detail = err.message ?? String(err);
    try {
      if (err.cause?.responseBody) {
        const body = JSON.parse(err.cause.responseBody);
        detail = body?.error?.type ?? body?.error?.message ?? detail;
      }
    } catch {}
    const short = detail.replace(/\s+/g, ' ').slice(0, 70);
    const category = err?.name?.includes('TypeValidation') ? 'schema-fail' : 'error';
    console.log(pad(model, 32), pad(category, 12), pad('-', 8), pad('-', 8), pad('no', 8), short);
  }
}
