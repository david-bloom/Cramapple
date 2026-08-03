// Phase 0.2 — model-slate conformance smoke test (GOLD_SET_GENERATION_PROTOCOL.md).
//
// Gate: >=19/20 schema-valid after at most one repair retry, per candidate family.
// The grader under test is OpenAI, so no OpenAI model may appear here (R1).
// Three non-OpenAI families are required: the writer consumes one and the
// remaining two must reach unanimity (R5).
//
// Run: node --env-file=scripts/vercel-gateway-check/.env scripts/content-seed/gold-set/smoke_model_slate.mjs

import { generateObject } from 'ai';
import { z } from 'zod';

const CANDIDATES = [
  'anthropic/claude-haiku-4-5',
  'anthropic/claude-sonnet-4.5',
  'google/gemini-2.5-flash',
  'moonshotai/kimi-k2',
  'moonshotai/kimi-k2-thinking',
  'deepseek/deepseek-v3.2',
];

// The real verification schema. Deliberately much simpler than the 5-field
// grading verdict that shaped the SP-1 arms, and this runs offline in batch, so
// a repair retry is affordable where it was not in the production latency budget.
const VERIFY_SCHEMA = z.object({
  marks: z.array(z.object({
    criterion_key: z.string(),
    present: z.boolean(),
    evidence_quote: z.string(),
  })),
});

const PROMPT = `A student answered a statistics question. For each criterion below, decide whether the
student's answer actually satisfies it.

Question: A teacher records minutes 9 students spent on a quiz: 18, 19, 20, 21, 22, 23, 24, 25, 41.
(a) Identify the median. (b) Describe the shape and identify any potential outlier.

Student answer: "the middle one is 22. the data is kinda pushed to the right because of that 41 which
is way bigger than everything else so its probably an outlier"

Criteria:
a1: States the median is 22 minutes.
b1: Describes the distribution as right-skewed and identifies 41 as a potential outlier.

Return one mark per criterion. present = whether the answer actually satisfies it.
evidence_quote = the exact words from the answer that satisfy it, or "" if absent.`;

const N = 20;

console.log(`Phase 0.2 smoke test — ${N} calls per candidate, gate >=19/20\n`);
console.log('model'.padEnd(32), 'valid'.padEnd(8), 'repaired'.padEnd(10), 'p50ms'.padEnd(8), 'verdict');
console.log('-'.repeat(84));

const results = {};

for (const model of CANDIDATES) {
  let valid = 0, repaired = 0, failed = 0;
  const times = [];
  let firstError = null;

  for (let i = 0; i < N; i++) {
    const t0 = performance.now();
    let ok = false;
    for (let attempt = 0; attempt < 2 && !ok; attempt++) {
      try {
        const { object } = await generateObject({
          model,
          schema: VERIFY_SCHEMA,
          prompt: PROMPT,
          temperature: 0.3,
        });
        if (Array.isArray(object?.marks) && object.marks.length === 2) {
          ok = true;
          if (attempt > 0) repaired++;
        }
      } catch (err) {
        if (!firstError) firstError = String(err?.message ?? err).slice(0, 90);
      }
    }
    times.push(performance.now() - t0);
    if (ok) valid++; else failed++;
  }

  times.sort((a, b) => a - b);
  const p50 = Math.round(times[Math.floor(times.length / 2)]);
  const verdict = valid >= 19 ? 'PASS' : `FAIL${firstError ? ' — ' + firstError : ''}`;
  results[model] = { valid, repaired, p50, verdict };
  console.log(model.padEnd(32), String(valid).padEnd(8), String(repaired).padEnd(10), String(p50).padEnd(8), verdict);
}

const passing = Object.entries(results).filter(([, r]) => r.verdict === 'PASS').map(([m]) => m);
const families = new Set(passing.map((m) => m.split('/')[0]));

console.log('\nPassing families:', [...families].join(', ') || '(none)');
console.log(families.size >= 3
  ? `\nR5 SATISFIED — ${families.size} non-OpenAI families available. Pilot can run.`
  : `\nR5 NOT SATISFIED — only ${families.size} family(ies). Writer consumes one; two must remain to verify.`);
