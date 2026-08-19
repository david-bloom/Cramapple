import fs from 'node:fs';
import path from 'node:path';
import { runOcr } from './ocr_criterion_decider.mjs';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const OCR_BINARY = path.join(ROOT, 'scripts', 'vercel-gateway-check', 'vision_ocr');
const SUBSAMPLE = JSON.parse(fs.readFileSync(
  path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18', 'gold', 'ocr_smoke_subsample_2026_08_18.json'),
  'utf8',
));

const times = [];
for (const item of SUBSAMPLE) {
  const start = performance.now();
  await runOcr(item.file_path, OCR_BINARY);
  times.push(performance.now() - start);
}
times.sort((a, b) => a - b);
const avg = times.reduce((a, b) => a + b, 0) / times.length;
console.log(`n=${times.length} avg=${Math.round(avg)}ms p50=${Math.round(times[Math.floor(times.length * 0.5)])}ms min=${Math.round(times[0])}ms max=${Math.round(times[times.length - 1])}ms`);
