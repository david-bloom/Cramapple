#!/usr/bin/env node
// Live transcription arm for the TASK-0016 Phase B bake-off. Lives here so the
// `ai` package resolves (scripts/vercel-gateway-check/node_modules). Reads the
// Phase B capture corpus + a captures manifest, asks a vision model (via the
// Vercel AI Gateway) to transcribe each line of the image into a parseable
// expression, aligns to the reference lines by index, and writes records.jsonl
// consumable by docs/research/statistics_phase_b_2026_07_08/bakeoff_scorer.py.
//
// Requires AI_GATEWAY_API_KEY in env. Usage:
//   node transcription_bakeoff_live.mjs --corpus <corpus.jsonl> --manifest <manifest.json> \
//        --model openai/gpt-5.5 --out <records.jsonl>
import fs from 'node:fs';
import { streamText } from 'ai';

function arg(name, def) {
  const i = process.argv.indexOf(`--${name}`);
  return i >= 0 ? process.argv[i + 1] : def;
}

const CORPUS = arg('corpus');
const MANIFEST = arg('manifest');
const MODEL = arg('model', 'openai/gpt-5.5');
const OUT = arg('out', 'records.jsonl');

if (!process.env.AI_GATEWAY_API_KEY) {
  console.error('no AI_GATEWAY_API_KEY in env');
  process.exit(1);
}

const items = fs.readFileSync(CORPUS, 'utf8').split(/\r?\n/).filter(Boolean).map((l) => JSON.parse(l));
const manifest = JSON.parse(fs.readFileSync(MANIFEST, 'utf8'));

function prompt(n) {
  return 'You are transcribing an image of hand-written mathematical work. '
    + `Return ONLY a JSON array of exactly ${n} strings, one per line of work, top to bottom. `
    + 'Each string must be a single machine-parseable expression using ^ for powers, * for '
    + 'multiplication, sqrt(...) for roots, e^(...) for exponentials, and parentheses. '
    + 'Transcribe exactly what is written; do NOT solve, simplify, or correct. '
    + 'If a line cannot be written as one expression, use "" for it.';
}

async function transcribe(imgBuf, n) {
  const res = streamText({
    model: MODEL,
    messages: [{ role: 'user', content: [
      { type: 'text', text: prompt(n) },
      { type: 'image', image: imgBuf },
    ] }],
  });
  let text = '';
  for await (const c of res.textStream) text += c;
  const m = text.match(/\[[\s\S]*\]/);
  if (!m) throw new Error('no JSON array in model output');
  return JSON.parse(m[0]);
}

const out = fs.createWriteStream(OUT);
let n = 0;
for (const item of items) {
  const imgPath = manifest[item.item_key];
  if (!imgPath) continue;
  const refs = item.reference_lines;
  let lines;
  try {
    lines = await transcribe(fs.readFileSync(imgPath), refs.length);
  } catch (e) {
    console.error(`  ${item.item_key}: ${e.message} -> emitting empty (ABSTAIN)`);
    lines = [];
  }
  refs.forEach((ref, i) => {
    out.write(JSON.stringify({
      item_key: item.item_key,
      line_id: ref.line_id,
      human_transcription: ref.human_transcription,
      model_transcription: lines[i] ?? '',
      human_grades_correct: ref.human_grades_correct === true,
      variables: ref.variables ?? [],
    }) + '\n');
    n += 1;
  });
  console.error(`  ${item.item_key}: ${refs.length} line(s)`);
}
out.end();
console.error(`\nwrote ${n} records for model ${MODEL} -> ${OUT}`);
