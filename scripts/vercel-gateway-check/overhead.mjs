import { streamText } from 'ai';
import { createOpenAI } from '@ai-sdk/openai';

const N = Number(process.argv[2] ?? 30);
const GATEWAY_MODEL = 'openai/gpt-4o-mini';
const DIRECT_MODEL = 'gpt-4o-mini';

const directProvider = process.env.OPENAI_API_KEY
  ? createOpenAI({ apiKey: process.env.OPENAI_API_KEY })
  : null;

async function timeOneCall(model) {
  const nonce = Math.random().toString(36).slice(2, 10);
  const prompt = `Reply with just the word "ok". (Request id: ${nonce})`;
  const start = performance.now();
  let firstChunkAt = null;
  const result = streamText({ model, prompt });
  for await (const _ of result.textStream) {
    if (firstChunkAt === null) firstChunkAt = performance.now();
  }
  const end = performance.now();
  return {
    ttfb: firstChunkAt - start,
    total: end - start,
  };
}

function stats(values) {
  if (values.length === 0) return null;
  const sorted = [...values].sort((a, b) => a - b);
  const median = sorted[Math.floor(sorted.length / 2)];
  const p95 = sorted[Math.min(sorted.length - 1, Math.floor(sorted.length * 0.95))];
  const min = sorted[0];
  const max = sorted[sorted.length - 1];
  const mean = values.reduce((a, b) => a + b, 0) / values.length;
  return { median, p95, min, max, mean };
}

function fmt(v) {
  return v == null ? '   -' : `${v.toFixed(0).padStart(4)}ms`;
}

async function runSeries(label, model) {
  const samples = [];
  for (let i = 0; i < N; i++) {
    process.stdout.write(`\r${label}: ${i + 1}/${N}`);
    try {
      samples.push(await timeOneCall(model));
    } catch (err) {
      process.stdout.write(`\n  call ${i + 1} failed: ${err.message?.slice(0, 80)}\n`);
    }
  }
  process.stdout.write('\n');
  return samples;
}

console.log(`Gateway overhead calibration`);
console.log(`Sample size: ${N} per series`);
console.log(`Gateway model: ${GATEWAY_MODEL}`);
console.log(`Direct model:  ${DIRECT_MODEL}${directProvider ? '' : '  (skipped — OPENAI_API_KEY not set)'}\n`);

const gatewaySamples = await runSeries('gateway', GATEWAY_MODEL);
let directSamples = [];
if (directProvider) {
  directSamples = await runSeries('direct ', directProvider(DIRECT_MODEL));
}

const gwTtfb = stats(gatewaySamples.map(s => s.ttfb));
const gwTotal = stats(gatewaySamples.map(s => s.total));
const drTtfb = stats(directSamples.map(s => s.ttfb));
const drTotal = stats(directSamples.map(s => s.total));

console.log('\nResults');
console.log('series'.padEnd(12), 'metric'.padEnd(8), 'median', '  p95', '  min', '  max', ' mean', '  n');
console.log('-'.repeat(72));
console.log('gateway'.padEnd(12), 'ttfb'.padEnd(8), fmt(gwTtfb?.median), fmt(gwTtfb?.p95), fmt(gwTtfb?.min), fmt(gwTtfb?.max), fmt(gwTtfb?.mean), String(gatewaySamples.length).padStart(3));
console.log('gateway'.padEnd(12), 'total'.padEnd(8), fmt(gwTotal?.median), fmt(gwTotal?.p95), fmt(gwTotal?.min), fmt(gwTotal?.max), fmt(gwTotal?.mean), String(gatewaySamples.length).padStart(3));
if (directProvider) {
  console.log('direct'.padEnd(12), 'ttfb'.padEnd(8), fmt(drTtfb?.median), fmt(drTtfb?.p95), fmt(drTtfb?.min), fmt(drTtfb?.max), fmt(drTtfb?.mean), String(directSamples.length).padStart(3));
  console.log('direct'.padEnd(12), 'total'.padEnd(8), fmt(drTotal?.median), fmt(drTotal?.p95), fmt(drTotal?.min), fmt(drTotal?.max), fmt(drTotal?.mean), String(directSamples.length).padStart(3));

  const ttfbDelta = (gwTtfb.median - drTtfb.median);
  const totalDelta = (gwTotal.median - drTotal.median);
  console.log('\nGateway overhead (gateway median − direct median)');
  console.log(`  ttfb:  ${ttfbDelta >= 0 ? '+' : ''}${ttfbDelta.toFixed(0)}ms`);
  console.log(`  total: ${totalDelta >= 0 ? '+' : ''}${totalDelta.toFixed(0)}ms`);
  console.log(`\nH8 (median ttfb overhead < 30ms): ${ttfbDelta < 30 ? 'PASS' : 'FAIL'}`);
} else {
  console.log('\nSet OPENAI_API_KEY in .env.local and rerun to measure overhead vs direct calls.');
}
