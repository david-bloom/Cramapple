// Gold-set generation — generalized from stage1_generate.mjs (DECISION-0045) to
// run against any single-point-criteria fixture, not just AP Statistics.
//
// Protocol: docs/research/GOLD_SET_GENERATION_PROTOCOL.md
//   R1  no OpenAI model writes or verifies (the grader under test is OpenAI)
//   R2  a verifier never shares a family with the writer of the answer it verifies
//   R3  verifiers are blind to the script, the grader, and each other
//   R4  the writer never verifies its own output
//
// Model slate resolved by the Phase 0.2 smoke test, 2026-08-03: sonnet-4.5,
// gemini-2.5-flash, deepseek-v3.2 all 20/20; kimi-k2 0/20 (rejected every call).
// DeepSeek takes the third slot per protocol's named alternate. Unchanged here.
//
// Each fixture item carries its own `subject_label` (e.g. "AP Calculus AB",
// "AP Physics C: Mechanics") so one script covers a mixed-subject fixture.
// Each item's own `stem` field is the full part-by-part question text; no
// separate `parts` array is required (some content stores parts structurally
// in prompt_json, some only in stem — stem always has the complete text).
//
// Run: node --env-file=../../vercel-gateway-check/.env generate_generic.mjs <fixture.json> <output.jsonl> [--limit N]

import { generateObject, generateText } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import crypto from 'node:crypto';

const args = process.argv.slice(2).filter((a) => !a.startsWith('--'));
const FIXTURE_PATH = args[0];
const OUT = args[1];
if (!FIXTURE_PATH || !OUT) {
  console.error('Usage: node generate_generic.mjs <fixture.json> <output.jsonl> [--limit N]');
  process.exit(1);
}
const FIXTURE = JSON.parse(fs.readFileSync(FIXTURE_PATH, 'utf8'));

const FAMILY_MODEL = {
  anthropic: process.env.GS_ANTHROPIC ?? 'anthropic/claude-sonnet-4.5',
  google: process.env.GS_GOOGLE ?? 'google/gemini-2.5-flash',
  deepseek: process.env.GS_DEEPSEEK ?? 'deepseek/deepseek-v3.2',
};
const FAMILIES = Object.keys(FAMILY_MODEL);
const CONCURRENCY = Number(process.env.GS_CONCURRENCY ?? 4);

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
  // A6 must NOT reuse A3's index. Sharing it made the two scripts identical on
  // every item (21/21 in the 2026-08-04 corpus) and, with both prompts telling
  // the writer to omit the same element, the texts collapsed into each other —
  // two of the eight probes measuring one thing.
  { type: 'A6', absent: (n) => [Math.max(0, n - 2)], addressed: true, intent:
    'NEAR-MISS. The listed element is addressed with adjacent, hedged or vague wording that sounds plausible but should NOT earn the point — the kind of thing that would start an argument between two reviewers. Do not make it obviously wrong. Everything else is correct.' },
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
  return `Stimulus: ${item.stimulus}\n\n${item.stem}`;
}

function writerPrompt(item, spec, absentIdx) {
  const present = item.elements.filter((_, i) => !absentIdx.includes(i));
  const absent = item.elements.filter((_, i) => absentIdx.includes(i));
  return `You are writing a REALISTIC STUDENT ANSWER to an ${item.subject_label} free-response question.
This answer is test material for a grading system, so it must contain exactly what it is told to contain.

${questionBlock(item)}

MUST BE SATISFIED by your answer:
${present.length ? present.map((e) => `- ${e.label}`).join('\n') : '- (none)'}

${spec.addressed ? 'MUST BE ADDRESSED BUT MUST NOT BE SATISFIED — write about this, but in wording that falls short of earning it:' : 'MUST NOT BE SATISFIED by your answer:'}
${absent.length ? absent.map((e) => `- ${e.label}`).join('\n') : '- (none)'}

Answer type — ${spec.type}: ${spec.intent}

Rules, all of which matter:
- Sound like a real student under time pressure. Informal, uneven, sometimes abbreviated. Run-on sentences and hedges are good. A tidy textbook paragraph is wrong.
- Express ideas, do not announce them. Never write "Part a:" style labels for the rubric, never mention criteria, elements, points, or the rubric itself.
${spec.addressed
  ? `- Do NOT omit the element listed above — omission is a different answer type. Write a sentence that visibly reaches for it and lands short: hedged, vague, or adjacent. A reader must be able to point at the sentence and say "that is where they tried."
- The line to stay behind: do not state the specific claim the element requires. Gesturing at it, qualifying it into meaninglessness, or asserting something merely nearby is what you want.`
  : `- To leave an element out, simply DO NOT WRITE IT. Never write "I don't know" or otherwise flag the omission — an explicit disclaimer is a different test.
- Watch for leakage: an element you were told to exclude can slip in through a side remark. Reread and remove any sentence that would satisfy a MUST NOT item.`}
- Length: 2-5 sentences total, matching what a student produces in the time available.

Return ONLY the student's answer text.`;
}

function verifierPrompt(item, answerText) {
  return `A student answered an ${item.subject_label} question. For each criterion, decide whether the student's
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

// Writer family is derived from the job's position in the FULL cross product,
// not from a running counter over the jobs actually run. A filtered re-run
// (--only / --types) therefore draws the same family the whole-fixture run
// would have drawn, so a single regenerated answer keeps the R2/R5 rotation
// intact instead of collapsing onto FAMILIES[0].
const flag = (name) => {
  const i = process.argv.indexOf(`--${name}`);
  return i === -1 ? null : process.argv[i + 1];
};
const onlyKeys = flag('only')?.split(',').map((s) => s.trim()).filter(Boolean) ?? null;
const onlyTypes = flag('types')?.split(',').map((s) => s.trim().toUpperCase()).filter(Boolean) ?? null;

const jobs = [];
FIXTURE.forEach((item, itemIdx) => {
  TYPES.forEach((spec, typeIdx) => {
    const n = item.elements.length;
    const absentIdx = spec.absent(n).filter((i) => i >= 0 && i < n);
    const writerFamily = FAMILIES[(itemIdx * TYPES.length + typeIdx) % FAMILIES.length];
    jobs.push({ item, spec, absentIdx, writerFamily });
  });
});

const work = jobs
  .filter((j) => !onlyKeys || onlyKeys.includes(j.item.content_key))
  .filter((j) => !onlyTypes || onlyTypes.includes(j.spec.type))
  .slice(0, limitArg);

console.log(`Generating: ${work.length} answers across ${FIXTURE.length} items (${FIXTURE_PATH})`);
console.log(`Families: ${FAMILIES.map((f) => `${f}=${FAMILY_MODEL[f]}`).join(', ')}\n`);

const results = await pool(work.map((job) => async () => {
  const { item, spec, absentIdx, writerFamily } = job;

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
    subject_label: item.subject_label,
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
