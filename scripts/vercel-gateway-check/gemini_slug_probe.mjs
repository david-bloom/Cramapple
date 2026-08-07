import { experimental_generateImage as generateImage } from 'ai';

const CANDIDATES = [
  'google/gemini-2.5-flash-image',
  'google/gemini-2.5-flash-image-preview',
  'google/gemini-2.0-flash-exp-image-generation',
  'google/gemini-2.0-flash-preview-image-generation',
  'google/gemini-3-pro-image-preview',
  'google/imagen-3.0-generate-002',
  'google/imagen-4.0-generate-001',
];

function pad(s, n) { return String(s).padEnd(n); }
console.log(pad('model', 42), pad('status', 8), 'note');
console.log('-'.repeat(100));

for (const model of CANDIDATES) {
  try {
    const result = await generateImage({ model, prompt: 'a small black circle on white background', n: 1 });
    console.log(pad(model, 42), pad('ok', 8), `bytes=${(result.image.base64 ?? '').length || (result.image.uint8Array?.length ?? 0)}`);
  } catch (err) {
    let detail = err.message ?? String(err);
    try {
      if (err.cause?.responseBody) {
        const body = JSON.parse(err.cause.responseBody);
        detail = body?.error?.type ?? body?.error?.message ?? detail;
      }
    } catch {}
    console.log(pad(model, 42), pad('error', 8), String(detail).replace(/\s+/g, ' ').slice(0, 90));
  }
}
