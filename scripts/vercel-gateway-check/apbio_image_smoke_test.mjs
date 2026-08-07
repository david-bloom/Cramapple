import { experimental_generateImage as generateImage } from 'ai';
import { writeFileSync, mkdirSync } from 'node:fs';

// TASK-0020 follow-on: synthetic prompt-visual smoke test for AP Biology
// construct-sensitive items (see docs/research/APBIO_SYNTHETIC_IMAGE_SURVEY_2026_08_04.md).
// Generates candidate images only - nothing here touches Production content
// or Storage. Model: openai/gpt-image-1 via Vercel AI Gateway (confirmed
// reachable in image_models_probe.mjs; google/gemini-2.5-flash-image and
// black-forest-labs/flux-1.1-pro were not reachable with this account/slug).

const MODEL = 'openai/gpt-image-1';
const outDir = '/tmp/cramapple-apbio-image-smoke-test';
mkdirSync(outDir, { recursive: true });

const ITEMS = [
  {
    key: 'APBIO-FRQ-L-003',
    kind: 'pedigree',
    prompt: `Create a clean, textbook-style genetics pedigree chart on a white background, black lines only, no color, no shading gradients, no photorealism. Standard pedigree conventions: squares = males, circles = females, fully filled black = affected, unfilled/white = unaffected, horizontal line connects mates, vertical lines connect parents to offspring, offspring of the same parents connected by a horizontal sibship line beneath the parents.

Three generations, labeled at left "I", "II", "III".

Generation I: one mated pair. I-1 = affected female (filled circle). I-2 = unaffected male (unfilled square).

Generation II, all six children of I-1 and I-2, left to right: II-1 = affected male (filled square). II-2 = unaffected female (unfilled circle). II-3 = affected female (filled circle). II-4 = unaffected male (unfilled square). II-5 = unaffected male (unfilled square). II-6 = unaffected female (unfilled circle).

Show II-3 and II-4 connected by a horizontal mating line (they are a couple, not siblings mating with each other's line - draw the mating line between II-3 and II-4 specifically, separate from the sibship line above them).

Generation III, children of II-3 and II-4, left to right: III-1 = unaffected (unfilled square or circle, sex not specified - use a square). III-2 = affected (filled circle). III-3 = unaffected (unfilled square). III-4 = unaffected (unfilled circle).

Label every individual with its exact ID text directly beneath its symbol (I-1, I-2, II-1, II-2, II-3, II-4, II-5, II-6, III-1, III-2, III-3, III-4). Include a small legend at the bottom: filled symbol = affected, unfilled symbol = unaffected, square = male, circle = female. No other text, no title, no color.`,
  },
  {
    key: 'APBIO-FRQ-L-009',
    kind: 'food web diagram',
    prompt: `Create a simple, clean textbook-style linear food chain diagram on a white background, black outlines, minimal flat vector style, no photorealism, no color gradients or shading, no background scenery.

Four rectangular boxes in a horizontal row, connected left to right by solid black arrows pointing right (arrow direction = direction of energy flow, from each box into the next). Box labels, in order, exactly as written: "Phytoplankton", "Zooplankton", "Small fish (anchovies)", "Tuna".

No other elements, no numbers, no title, no additional text beyond the four box labels.`,
  },
  {
    key: 'APBIO-FRQ-L-011',
    kind: 'line graph',
    prompt: `Create a clean, textbook-style scientific line graph on a white background, black axes, simple flat vector style, no photorealism, no drop shadows.

X-axis labeled "pH", ranging from 0 to 14, gridlines at every 2 units. Y-axis labeled "Relative enzyme activity", unitless, ranging from 0 (bottom) to a maximum (top), no numeric labels needed on the y-axis ticks.

Plot exactly three smooth bell-shaped (single-peak, roughly symmetric) curves, each a different line style or shade of gray so they are distinguishable in black and white, each with a label directly next to its peak:
1. "Pepsin" - curve peaks sharply at pH 2.0, is near zero below pH 1.0 and above pH 3.5, active range roughly pH 1.0-3.5.
2. "Amylase" - curve peaks at pH 7.0, active range roughly pH 6.0-8.5.
3. "Trypsin" - curve peaks at pH 8.0, active range roughly pH 7.0-9.0.

All three peaks should reach approximately the same maximum height. Include a simple legend identifying the three curves by name. No title, no other text.`,
  },
];

console.log(`AP Biology synthetic prompt-visual smoke test - model: ${MODEL}\n`);
console.log(pad('content_key', 20), pad('status', 8), pad('ms', 8), 'note');
console.log('-'.repeat(90));

function pad(s, n) { return String(s).padEnd(n); }

for (const item of ITEMS) {
  const start = performance.now();
  try {
    const result = await generateImage({ model: MODEL, prompt: item.prompt, n: 1, size: '1024x1024' });
    const ms = `${(performance.now() - start).toFixed(0)}ms`;
    const img = result.image;
    const bytes = Buffer.from(img.base64 ?? img.uint8Array, img.base64 ? 'base64' : undefined);
    const path = `${outDir}/${item.key}.png`;
    writeFileSync(path, bytes);
    console.log(pad(item.key, 20), pad('ok', 8), pad(ms, 8), `-> ${path} (${bytes.length}B)`);
  } catch (err) {
    let detail = err.message ?? String(err);
    try {
      if (err.cause?.responseBody) {
        const body = JSON.parse(err.cause.responseBody);
        detail = body?.error?.type ?? body?.error?.message ?? detail;
      }
    } catch {}
    console.log(pad(item.key, 20), pad('error', 8), pad('-', 8), String(detail).replace(/\s+/g, ' ').slice(0, 100));
  }
}
