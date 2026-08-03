// Gold-set Stage 1 — generate + blind two-family verify (DECISION-0045).
//
// Protocol: docs/research/GOLD_SET_GENERATION_PROTOCOL.md
//   R1  no OpenAI model writes or verifies (the grader under test is OpenAI)
//   R2  a verifier never shares a family with the writer of the answer it verifies
//   R3  verifiers are blind to the script, the grader, and each other
//   R4  the writer never verifies its own output
//
// The target present/absent pattern is assigned HERE, deterministically, before
// any text exists — the model does not choose which elements to omit. That keeps
// coverage balanced across answer types and makes the compliance measurement
// exact: did the text the writer produced actually match the pattern it was told
// to hit? The only prior measurement of that is 5 of 10 answers failing.
//
// Run: node --env-file=scripts/vercel-gateway-check/.env stage1_generate.mjs [--limit N]

import { generateObject, generateText } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import crypto from 'node:crypto';
import path from 'node:path';

const HERE = path.dirname(new URL(import.meta.url).pathname);
const FIXTURE = JSON.parse(fs.readFileSync(path.join(HERE, 'stage1_fixture.json'), 'utf8'));
const OUT = path.join(HERE, 'stage1_answers.jsonl');

// Set by the Phase 0.2 smoke test, 2026-08-03 (20 calls each against the real
// verification schema): sonnet-4.5 20/20, gemini-2.5-flash 20/20,
// deepseek-v3.2 20/20, and moonshotai/kimi-k2 0/20 — every call rejected with
// "Bad Request". Kimi cannot produce this structured output through the
// gateway, so DeepSeek takes the third slot as the protocol's named alternate.
// Three non-OpenAI families, so R5 holds.
const FAMILY_MODEL = {
  anthropic: process.env.GS_ANTHROPIC ?? 'anthropic/claude-sonnet-4.5',
  google: process.env.GS_GOOGLE ?? 'google/gemini-2.5-flash',
  deepseek: process.env.GS_DEEPSEEK ?? 'deepseek/deepseek-v3.2',
};
const FAMILIES = Object.keys(FAMILY_MODEL);
const CONCURRENCY = Number(process.env.GS_CONCURRENCY ?? 4);

// Answer recipe (GOLD_SET_AUTHORING_GUIDE.md v2.0 §3). `pattern(n)` returns the
// 0-indexed elements that must be ABSENT from the finished answer.
const TYPES = [
  { type: 'A1', absent: () => [], intent:
    'Full credit, canonical. Address every part correctly, phrased the way a well-prepared student would.' },
  { type: 'A2', absent: () => [], intent:
    'Full credit, UNCONVENTIONAL. Every element must genuinely be satisfied, but reach them a different way: different vocabulary, a valid alternative method, different order, or unusual notation. Do NOT paraphrase a canonical answer — change the approach. This is the most important answer in the set: it probes whether the grader under-credits correct work that is not phrased canonically.' },
  { type: 'A3', absent: (n) => [n - 1], intent:
    'Partial. Good work, but ONE element is simply ABSENT — not attempted, not denied, just not there. The rest is correct.' },
  { type: 'A4', absent: (n) => (n >= 4 ? [0, 2] : [0]), intent:
    'Partial, a DIFFERENT subset absent from A3. The remaining parts are answered well.' },
  { type: 'A5', absent: (n) => [1 % n], intent:
    'Partial — ATTEMPTED AND WRONG. The listed absent element is addressed but incorrectly (a wrong value, a wrong concept). It must not read as missing; it must read as a real attempt that fails. Everything else is correct.' },
  { type: 'A6', absent: (n) => [n - 1], intent:
    'NEAR-MISS. The listed absent element is addressed with adjacent, hedged or vague wording that sounds plausible but should NOT earn the point — the kind of thing that would start an argument between two reviewers. Do not make it obviously wrong. Everything else is correct.' },
  { type: 'A7', absent: (n) => [1 % n], intent:
    'ERROR CARRIED FORWARD. Make an arithmetic slip early so the listed absent element is wrong, then apply the CORRECT method to that wrong value in the later parts, so the later elements are still satisfied on method.' },
  { type: 'A8', absent: (n) => Array.from({ length: Math.max(0, n - 1) }, (_, i) => i + 1), intent:
    'CONTRADICTION OR NEAR-ZERO. Either state something and contradict it later, or address almost nothing. Only the first element should survive.' },
];

const VERIFY_SCHEMA = z.object({
  marks: z.array(z.object({
    criterion_key: z.string(),
    present: z.boolean(),
    evidence_quote: z.string(),
  })),
});

const sha = (s) => crypto.createHash('sha256').update(s).digest('hex');

function questionBlock(item) {
  return `Stimulus: ${item.stimulus}\n\nParts:\n` +
    item.parts.map((p) => `(${p.part_key}) ${p.prompt_text}`).join('\n');
}

function writerPrompt(item, spec, absentIdx) {
  const present = item.elements.filter((_, i) => !absentIdx.includes(i));
  const absent = item.elements.filter((_, i) => absentIdx.includes(i));
  return `You are writing a REALISTIC STUDENT ANSWER to an AP Statistics short free-response question.
This answer is test material for a grading system, so it must contain exactly what it is told to contain.

${questionBlock(item)}

MUST BE SATISFIED by your answer:
${present.length ? present.map((e) => `- ${e.label}`).join('\n') : '- (none)'}

MUST NOT BE SATISFIED by your answer:
${absent.length ? absent.map((e) => `- ${e.label}`).join('\n') : '- (none)'}

Answer type — ${spec.type}: ${spec.intent}

Rules, all of which matter:
- Sound like a real student under time pressure. Informal, uneven, sometimes abbreviated. Run-on sentences and hedges are good. A tidy textbook paragraph is wrong.
- Express ideas, do not announce them. Never write "Part a:" style labels for the rubric, never mention criteria, elements, points, or the rubric itself.
- To leave an element out, simply DO NOT WRITE IT. Never write "I don't know" or otherwise flag the omission — an explicit disclaimer is a different test.
- Watch for leakage: an element you were told to exclude can slip in through a side remark. Reread and remove any sentence that would satisfy a MUST NOT item.
- Length: 2-5 sentences total, matching what a student produces in the time available.

Return ONLY the student's answer text.`;
}

function verifierPrompt(item, answerText) {
  return `A student answered an AP Statistics question. For each criterion, decide whether the student's
answer ACTUALLY satisfies it, based only on what is written.

${questionBlock(item)}

Student answer:
"""
${answerText}
"""

Criteria:
${item.elements.map((e) => `${e.criterion_key}: ${e.label}`).join('\n')}

Be strict. A vague gesture, a hedge, or an adjacent statement does NOT count. Judge only what is
present, not what the student probably meant. Do not award points or a score.
For each criterion return present (true/false) and evidence_quote (the exact words that satisfy it,
or "" if absent).`;
}

async function withRetry(fn, attempts = 3) {
  let lastErr;
  for (let i = 0; i < attempts; i++) {
    try { return await fn(); } catch (err) {
      lastErr = err;
      await new Promise((r) => setTimeout(r, 800 * (i + 1)));
    }
  }
  throw lastErr;
}

async function pool(tasks, limit) {
  const out = new Array(tasks.length);
  let next = 0;
  await Promise.all(Array.from({ length: Math.min(limit, tasks.length) }, async () => {
    while (next < tasks.length) {
      const i = next++;
      out[i] = await tasks[i]().catch((e) => ({ error: String(e?.message ?? e) }));
    }
  }));
  return out;
}

const limitArg = Number(process.argv[process.argv.indexOf('--limit') + 1]) || Infinity;

// ── Build the work list, assigning writer families round-robin ────────────────
const jobs = [];
let rot = 0;
for (const item of FIXTURE) {
  for (const spec of TYPES) {
    const n = item.elements.length;
    const absentIdx = spec.absent(n).filter((i) => i >= 0 && i < n);
    const writerFamily = FAMILIES[rot++ % FAMILIES.length];
    jobs.push({ item, spec, absentIdx, writerFamily });
  }
}
const work = jobs.slice(0, limitArg);

console.log(`Stage 1: ${work.length} answers across ${FIXTURE.length} items`);
console.log(`Families: ${FAMILIES.map((f) => `${f}=${FAMILY_MODEL[f]}`).join(', ')}\n`);

const results = await pool(work.map((job) => async () => {
  const { item, spec, absentIdx, writerFamily } = job;

  // Script committed and hashed BEFORE any text exists.
  const script = {
    content_key: item.content_key,
    answer_type: spec.type,
    expected: item.elements.map((e, i) => ({
      criterion_key: e.criterion_key,
      present: !absentIdx.includes(i),
    })),
  };
  const scriptHash = sha(JSON.stringify(script));

  const answerText = (await withRetry(() => generateText({
    model: FAMILY_MODEL[writerFamily],
    prompt: writerPrompt(item, spec, absentIdx),
    temperature: 0.85,
  }))).text.trim();

  // R2/R3: the two families that did NOT write this answer, blind and independent.
  const verifierFamilies = FAMILIES.filter((f) => f !== writerFamily);
  const verdicts = await Promise.all(verifierFamilies.map(async (fam) => {
    const { object } = await withRetry(() => generateObject({
      model: FAMILY_MODEL[fam],
      schema: VERIFY_SCHEMA,
      prompt: verifierPrompt(item, answerText),
      temperature: 0.1,
    }));
    const byKey = Object.fromEntries(object.marks.map((m) => [m.criterion_key, m]));
    return { family: fam, marks: item.elements.map((e) => ({
      criterion_key: e.criterion_key,
      present: Boolean(byKey[e.criterion_key]?.present),
      evidence_quote: byKey[e.criterion_key]?.evidence_quote ?? '',
    })) };
  }));

  const sig = (marks) => marks.map((m) => (m.present ? '1' : '0')).join('');
  const scriptSig = sig(script.expected);
  const v1Sig = sig(verdicts[0].marks);
  const v2Sig = sig(verdicts[1].marks);

  let route, reason;
  if (v1Sig !== v2Sig) { route = 'reader_queue'; reason = 'verifiers_split'; }
  else if (v1Sig !== scriptSig) { route = 'discard'; reason = 'script_noncompliance'; }
  else { route = 'provisional_accept'; reason = 'unanimous'; }

  return {
    content_key: item.content_key,
    content_item_version_id: item.content_item_version_id,
    item_content_hash: item.content_hash,
    answer_type: spec.type,
    writer_family: writerFamily,
    writer_model: FAMILY_MODEL[writerFamily],
    script, script_hash: scriptHash, script_sig: scriptSig,
    answer_text: answerText,
    verdicts, v1_sig: v1Sig, v2_sig: v2Sig,
    route, reason,
  };
}), CONCURRENCY);

const ok = results.filter((r) => r && !r.error);
fs.writeFileSync(OUT, ok.map((r) => JSON.stringify(r)).join('\n') + '\n');

const count = (p) => ok.filter(p).length;
console.log(`\nWrote ${ok.length} answers -> ${OUT}`);
if (results.length !== ok.length) console.log(`ERRORS: ${results.length - ok.length}`);
console.log(`\nprovisional_accept : ${count((r) => r.route === 'provisional_accept')}`);
console.log(`reader_queue       : ${count((r) => r.route === 'reader_queue')}`);
console.log(`discard            : ${count((r) => r.route === 'discard')}`);
console.log(`\nScript compliance (verifiers unanimous AND matching script): ` +
  `${count((r) => r.route === 'provisional_accept')}/${ok.length}`);
console.log('\nBy answer type:');
for (const t of TYPES) {
  const rows = ok.filter((r) => r.answer_type === t.type);
  if (!rows.length) continue;
  console.log(`  ${t.type}: accept ${rows.filter((r) => r.route === 'provisional_accept').length}/${rows.length}` +
    `  discard ${rows.filter((r) => r.route === 'discard').length}` +
    `  split ${rows.filter((r) => r.route === 'reader_queue').length}`);
}
console.log('\nBy writer family:');
for (const f of FAMILIES) {
  const rows = ok.filter((r) => r.writer_family === f);
  if (!rows.length) continue;
  console.log(`  ${f}: accept ${rows.filter((r) => r.route === 'provisional_accept').length}/${rows.length}`);
}
