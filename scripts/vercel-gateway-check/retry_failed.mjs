// Standalone retry helper for the 3 gemini calls that failed to parse even at
// MAX_OUTPUT_TOKENS=8000. Reuses the same prompt/schema, appends successful
// retries to the same results file (marked retry:true so the analysis step
// can prefer the retry over the original failed record for the same photo).
import { streamObject } from 'ai';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { z } from 'zod';
function loadEnvFile(envPath) {
  const lines = fs.readFileSync(envPath, 'utf8').split(/\r?\n/);
  for (const rawLine of lines) {
    const line = rawLine.trim();
    if (!line || line.startsWith('#') || !line.includes('=')) continue;
    const idx = line.indexOf('=');
    const key = line.slice(0, idx).trim();
    let value = line.slice(idx + 1).trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) value = value.slice(1,-1);
    if (key && !(key in process.env)) process.env[key] = value;
  }
}
loadEnvFile('/Users/davidbloom/Documents/Cramapple.nosync/scripts/vercel-gateway-check/.env');

const ROOT = '/Users/davidbloom/Documents/Cramapple.nosync';
const SAMPLES_ROOT = path.join(ROOT, 'docs', 'hand drawn samples');
const GOLD_JSONL = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29', 'hand_drawn_graph_questions_2026_06_29.jsonl');
const OUT = process.argv[2];
const MODEL = process.argv[3];
const targetFiles = process.argv.slice(4); // absolute file paths to retry

function sha256File(p) { return crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex'); }
function stableHash(...parts) { return crypto.createHash('sha256').update(parts.join('\0')).digest('hex'); }

const golds = new Map();
for (const line of fs.readFileSync(GOLD_JSONL, 'utf8').split('\n').filter(Boolean)) {
  const r = JSON.parse(line);
  golds.set(r.item_id, r);
}

function buildPrompt(gold) {
  const criteria = gold.criterion_definitions.map((c) => `- ${c.criterion_id}: ${c.met_rule}`).join('\n');
  return [`Item ID: ${gold.item_id}`,`Archetype: ${gold.archetype}`,'Prompt:',gold.student_prompt || gold.stem || '','','Rubric criteria (evaluate strictly against these rules):',criteria,'','Inspect the photographed hand-drawn response and return a criterion status','(earned / not_earned / unable_to_determine) for every criterion listed above,','based only on what is visible in the image.'].join('\n');
}

const output = fs.createWriteStream(OUT, { flags: 'a' });

for (const filePath of targetFiles) {
  const base = path.basename(filePath);
  const match = base.match(/^(HDG-2026-P1-[A-Z]+-\d+)__response-(\d+)\./);
  const itemId = match[1];
  const responseIndex = match[2];
  const gold = golds.get(itemId);
  const prompt = buildPrompt(gold);
  const imageBuffer = fs.readFileSync(filePath);
  const promptHash = stableHash('DECISION_0045_VERIFY_RETRY', MODEL, itemId, prompt);
  const started = performance.now();
  try {
    const result = streamObject({
      model: MODEL,
      schema: z.object({
        criterion_statuses: z.array(z.object({ criterion_id: z.string(), status: z.enum(['earned','not_earned','unable_to_determine']) })),
        confidence: z.enum(['high','medium','low']),
        rationale: z.string(),
      }),
      messages: [{ role: 'user', content: [{ type: 'text', text: prompt }, { type: 'image', image: imageBuffer }] }],
      maxOutputTokens: 16000,
    });
    for await (const _c of result.partialObjectStream) {}
    const final = await result.object;
    const usage = await result.usage;
    const predictedStatuses = {};
    for (const e of final.criterion_statuses || []) if (e?.criterion_id) predictedStatuses[e.criterion_id] = e.status;
    const pricing = { input: 0.30, output: 2.50 };
    const cost = ((usage.inputTokens||0)*pricing.input + (usage.outputTokens||0)*pricing.output)/1e6;
    const record = {
      item_id: itemId, packet: filePath.includes('Packet 2') ? 'packet_2' : filePath.includes('Packet 3') ? 'packet_3' : 'packet_1_root',
      response_index: responseIndex, file_path: filePath, file_name: path.relative(SAMPLES_ROOT, filePath),
      sha256: sha256File(filePath), archetype: gold.archetype, item_version: gold.item_version,
      prompt_hash: promptHash, model_id: MODEL, schema_valid: true,
      latency_ms: performance.now()-started, ttfb_ms: null, cost_usd: cost,
      output_tokens: usage.outputTokens||0, input_tokens: usage.inputTokens||0,
      criterion_statuses: predictedStatuses, confidence: final.confidence || 'low', rationale: final.rationale || '',
      ok: true, error: '', retry: true,
    };
    output.write(JSON.stringify(record) + '\n');
    console.log(itemId, responseIndex, 'RETRY OK', cost.toFixed(5));
  } catch (err) {
    console.log(itemId, responseIndex, 'RETRY STILL FAILED', err.message);
    output.write(JSON.stringify({ item_id: itemId, response_index: responseIndex, file_path: filePath, model_id: MODEL, ok: false, error: err.message || String(err), retry: true }) + '\n');
  }
}
output.end();
