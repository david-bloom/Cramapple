import { runOcr } from './ocr_criterion_decider.mjs';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import sharp from 'sharp';

const OCR_BINARY = path.resolve('scripts/vercel-gateway-check/vision_ocr');
async function runOcrQ90(filePath) {
  const normalizedPath = path.join(os.tmpdir(), `debug2_${Date.now()}.jpg`);
  await sharp(filePath).rotate().jpeg({ quality: 90 }).toFile(normalizedPath);
  const raw = execFileSync(OCR_BINARY, [normalizedPath], { maxBuffer: 10 * 1024 * 1024 }).toString('utf8');
  fs.unlinkSync(normalizedPath);
  return JSON.parse(raw);
}

const target = process.argv[2];
const items = await runOcrQ90(target);
for (const it of items) console.log(JSON.stringify(it.text));
