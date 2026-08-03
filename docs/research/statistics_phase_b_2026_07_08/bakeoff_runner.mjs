#!/usr/bin/env node
// Transcription-fidelity bake-off RUNNER (TASK-0016 Phase B).
//
// Reuses the gateway/image/auth mechanism proven in
// scripts/vercel-gateway-check/hand_drawn_graph_benchmark_run.mjs: auth via
// AI_GATEWAY_API_KEY or VERCEL_OIDC_TOKEN, image sent as an {type:'image'}
// message part through the `ai` package's streamText over the Vercel AI Gateway.
//
// It reads the capture corpus (bakeoff_capture_corpus.jsonl) + a captures
// manifest (item_key -> image_path), asks the model to transcribe each line of
// hand-drawn work into a parseable expression, aligns the model's lines to the
// reference lines by index, and emits one record per line for bakeoff_scorer.py:
//   {item_key,line_id,human_transcription,model_transcription,human_grades_correct,variables}
//
// LIVE run needs gateway creds + captured images (neither present in the
// authoring session — see README). --dry-run needs neither: it emits a PERFECT
// arm (model = reference) so the corpus -> runner -> scorer pipeline can be
// smoke-tested end to end. NO fidelity numbers are produced by dry-run; it only
// proves the wiring.
//
// Usage:
//   node bakeoff_runner.mjs --dry-run [--out records.jsonl]
//   node bakeoff_runner.mjs --arm transcription --model openai/gpt-5.5 \
//        --captures captures.json --out records.jsonl
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const HERE = path.dirname(fileURLToPath(import.meta.url));

function parseArgs(argv) {
  const args = { arm: 'transcription', model: 'openai/gpt-5.5', dryRun: false,
    corpus: path.join(HERE, 'bakeoff_capture_corpus.jsonl'),
    out: path.join(HERE, 'bakeoff_records.jsonl'), captures: null };
  for (let i = 0; i < argv.length; i += 1) {
    const a = argv[i];
    if (a === '--dry-run') args.dryRun = true;
    else if (a === '--arm') args.arm = argv[++i];
    else if (a === '--model') args.model = argv[++i];
    else if (a === '--corpus') args.corpus = argv[++i];
    else if (a === '--captures') args.captures = argv[++i];
    else if (a === '--out') args.out = argv[++i];
  }
  return args;
}

function fail(msg) { console.error(`bakeoff_runner: ${msg}`); process.exit(1); }

function readJsonl(p) {
  return fs.readFileSync(p, 'utf8').split(/\r?\n/).filter(Boolean).map((l) => JSON.parse(l));
}

// The direct-to-expression arm and the transcription arm differ only in prompt;
// both must return a JSON array of one parseable expression string per line, in
// top-to-bottom order, with NO prose (an integral/limit sign a line can't be
// expressed as algebra should be returned as the empty string so it ABSTAINs).
function buildPrompt(arm, expectedLineCount) {
  const base =
    'You are transcribing a photo of a student\'s hand-written mathematical work. '
    + `Return ONLY a JSON array of exactly ${expectedLineCount} strings, one per line of work, top to bottom. `
    + 'Each string must be a machine-parseable expression using ^ for powers, * for multiplication, '
    + 'sqrt(), e^(...), and parentheses. Do not solve, simplify, correct, or explain. '
    + 'If a line cannot be written as a single algebraic expression, return "" for that line.';
  return arm === 'direct'
    ? base + ' Transcribe exactly what is written, character for character in algebraic form.'
    : base + ' Preserve the student\'s exact structure; do not normalize equivalent forms.';
}

async function transcribeImage(model, prompt, imageBuffer) {
  const { streamText } = await import('ai'); // dynamic: only needed for live runs
  const result = streamText({ model, messages: [{ role: 'user', content: [
    { type: 'text', text: prompt }, { type: 'image', image: imageBuffer }] }] });
  let text = '';
  for await (const chunk of result.textStream) text += chunk;
  const match = text.match(/\[[\s\S]*\]/);
  if (!match) throw new Error(`no_json_array_in_output`);
  return JSON.parse(match[0]);
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  if (!args.dryRun && !process.env.AI_GATEWAY_API_KEY && process.env.VERCEL_OIDC_TOKEN) {
    process.env.AI_GATEWAY_API_KEY = process.env.VERCEL_OIDC_TOKEN;
  }
  const items = readJsonl(args.corpus);
  let captures = {};
  if (!args.dryRun) {
    if (!process.env.AI_GATEWAY_API_KEY) fail('no gateway creds (set AI_GATEWAY_API_KEY or VERCEL_OIDC_TOKEN), or use --dry-run');
    if (!args.captures) fail('live run needs --captures <manifest.json> mapping item_key -> image_path');
    captures = JSON.parse(fs.readFileSync(args.captures, 'utf8'));
  }

  const out = fs.createWriteStream(args.out);
  let lineRecords = 0;
  for (const item of items) {
    const refs = item.reference_lines;
    let modelLines;
    if (args.dryRun) {
      modelLines = refs.map((r) => r.human_transcription); // PERFECT arm (wiring smoke test only)
    } else {
      const rel = captures[item.item_key];
      if (!rel) fail(`no image_path for ${item.item_key} in captures manifest`);
      const imageBuffer = fs.readFileSync(path.resolve(path.dirname(args.captures), rel));
      modelLines = await transcribeImage(args.model, buildPrompt(args.arm, refs.length), imageBuffer);
    }
    refs.forEach((ref, i) => {
      out.write(JSON.stringify({
        item_key: item.item_key,
        line_id: ref.line_id,
        human_transcription: ref.human_transcription,
        model_transcription: modelLines[i] ?? '',
        human_grades_correct: ref.human_grades_correct === true,
        variables: ref.variables ?? [],
      }) + '\n');
      lineRecords += 1;
    });
  }
  out.end();
  console.error(`bakeoff_runner: wrote ${lineRecords} line records for ${items.length} items -> ${args.out}`
    + (args.dryRun ? '  [DRY-RUN perfect arm: wiring smoke test only, NOT fidelity evidence]' : `  [arm=${args.arm} model=${args.model}]`));
}

main().catch((e) => fail(e.stack || String(e)));
