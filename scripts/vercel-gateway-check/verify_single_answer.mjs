// One-off re-verification for a single hand-edited gold-set answer record.
// Mirrors the verifier logic in scripts/content-seed/gold-set/generate_generic.mjs
// (R2: verifiers never share a family with the writer; R3: blind to script/each other).
//
// Run: node --env-file=.env verify_single_answer.mjs <jsonl_path> <content_key> <answer_type>

import { generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';

const [, , JSONL_PATH, CONTENT_KEY, ANSWER_TYPE] = process.argv;
if (!JSONL_PATH || !CONTENT_KEY || !ANSWER_TYPE) {
  console.error('Usage: node verify_single_answer.mjs <jsonl_path> <content_key> <answer_type>');
  process.exit(1);
}

const FIXTURE_PATH = JSONL_PATH.replace('_answers.jsonl', '_fixture.json');
const FIXTURE = JSON.parse(fs.readFileSync(FIXTURE_PATH, 'utf8'));
const item = FIXTURE.find((i) => i.content_key === CONTENT_KEY);
if (!item) { console.error(`No fixture item for ${CONTENT_KEY} in ${FIXTURE_PATH}`); process.exit(1); }

const FAMILY_MODEL = {
  anthropic: process.env.GS_ANTHROPIC ?? 'anthropic/claude-sonnet-4.5',
  google: process.env.GS_GOOGLE ?? 'google/gemini-2.5-flash',
  deepseek: process.env.GS_DEEPSEEK ?? 'deepseek/deepseek-v3.2',
};
const FAMILIES = Object.keys(FAMILY_MODEL);

const VERIFY_SCHEMA = z.object({
  marks: z.array(z.object({
    criterion_key: z.string(),
    present: z.boolean(),
    evidence_quote: z.string(),
  })),
});

function questionBlock(it) {
  return `Stimulus: ${it.stimulus}\n\n${it.stem}`;
}

function verifierPrompt(it, answerText) {
  return `A student answered an ${it.subject_label} question. For each criterion, decide whether the student's
answer ACTUALLY satisfies it, based only on what is written.

${questionBlock(it)}

Student answer:
"""
${answerText}
"""

Criteria:
${it.elements.map((e) => `${e.criterion_key}: ${e.label}`).join('\n')}

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

const lines = fs.readFileSync(JSONL_PATH, 'utf8').split('\n').filter(Boolean);
const idx = lines.findIndex((l) => {
  const r = JSON.parse(l);
  return r.content_key === CONTENT_KEY && r.answer_type === ANSWER_TYPE;
});
if (idx === -1) { console.error(`No record for ${CONTENT_KEY}/${ANSWER_TYPE} in ${JSONL_PATH}`); process.exit(1); }

const record = JSON.parse(lines[idx]);
const writerFamily = record.writer_family;
const verifierFamilies = FAMILIES.filter((f) => f !== writerFamily);
if (verifierFamilies.length !== 2) {
  console.error(`Expected exactly 2 non-writer families, got ${verifierFamilies.length} (writer=${writerFamily})`);
  process.exit(1);
}

console.log(`Verifying ${CONTENT_KEY}/${ANSWER_TYPE} (writer=${writerFamily}) with ${verifierFamilies.join(', ')}`);

const verdicts = await Promise.all(verifierFamilies.map(async (fam) => {
  const { object } = await withRetry(() => generateObject({
    model: FAMILY_MODEL[fam],
    schema: VERIFY_SCHEMA,
    prompt: verifierPrompt(item, record.answer_text),
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
const scriptSig = sig(record.script.expected);
const v1Sig = sig(verdicts[0].marks);
const v2Sig = sig(verdicts[1].marks);

let route, reason;
if (v1Sig !== v2Sig) { route = 'reader_queue'; reason = 'verifiers_split'; }
else if (v1Sig !== scriptSig) { route = 'discard'; reason = 'script_noncompliance'; }
else { route = 'provisional_accept'; reason = 'unanimous'; }

record.verdicts = verdicts;
record.v1_sig = v1Sig;
record.v2_sig = v2Sig;
record.route = route;
record.reason = reason;

lines[idx] = JSON.stringify(record);
fs.writeFileSync(JSONL_PATH, lines.join('\n') + '\n');

console.log(`\nscript_sig: ${scriptSig}`);
for (const v of verdicts) {
  console.log(`${v.family}: ${sig(v.marks)}`);
  for (const m of v.marks) {
    console.log(`  ${m.present ? 'PRESENT' : 'absent '} ${m.criterion_key}${m.present ? `  "${m.evidence_quote}"` : ''}`);
  }
}
console.log(`\nroute: ${route} (${reason})`);
