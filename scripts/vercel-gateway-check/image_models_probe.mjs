import { experimental_generateImage as generateImage } from 'ai';
import { writeFileSync, mkdirSync } from 'node:fs';

// Cheap reachability probe for image-capable models via Vercel AI Gateway.
// Run this BEFORE spending on a real content smoke test - confirms exact
// gateway slugs and that the account has image-generation entitlement.
const MODELS = [
  'google/gemini-2.5-flash-image',
  'openai/gpt-image-1',
  'black-forest-labs/flux-1.1-pro',
];

const PROMPT = 'A minimal white background with a single small black circle in the center. Flat vector style, no text.';

const outDir = '/tmp/cramapple-image-model-probe';
mkdirSync(outDir, { recursive: true });

console.log(`Image-model reachability probe via Vercel AI Gateway`);
console.log(pad('model', 34), pad('status', 8), pad('ms', 8), 'note');
console.log('-'.repeat(90));

function pad(s, n) { return String(s).padEnd(n); }

for (const model of MODELS) {
  const start = performance.now();
  try {
    const result = await generateImage({ model, prompt: PROMPT, n: 1 });
    const ms = `${(performance.now() - start).toFixed(0)}ms`;
    const img = result.image;
    const bytes = Buffer.from(img.base64 ?? img.uint8Array, img.base64 ? 'base64' : undefined);
    const path = `${outDir}/${model.replace('/', '_')}.png`;
    writeFileSync(path, bytes);
    console.log(pad(model, 34), pad('ok', 8), pad(ms, 8), `-> ${path} (${bytes.length}B)`);
  } catch (err) {
    let detail = err.message ?? String(err);
    try {
      if (err.cause?.responseBody) {
        const body = JSON.parse(err.cause.responseBody);
        detail = body?.error?.type ?? body?.error?.message ?? detail;
      }
    } catch {}
    console.log(pad(model, 34), pad('error', 8), pad('-', 8), String(detail).replace(/\s+/g, ' ').slice(0, 80));
  }
}
