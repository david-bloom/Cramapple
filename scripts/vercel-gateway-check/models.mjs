import { streamText } from 'ai';

const MODELS = [
  'openai/gpt-4o-mini',
  'openai/gpt-5.5',
  'anthropic/claude-haiku-4-5',
  'google/gemini-2.5-flash',
  // Kimi (Moonshot) grading experiment. Run this reachability probe FIRST to
  // confirm the exact gateway slugs before spending money on the SP-1 pilot -
  // if either row errors with an unknown-model message, fix the slug here and
  // in sp1_pilot.mjs (Arms + PRICING) before running the paid grading run.
  'moonshotai/kimi-k2-thinking',
  'moonshotai/kimi-k2',
];

const PROMPT = 'Reply with one short sentence confirming you received this.';

const pad = (s, n) => String(s).padEnd(n);

console.log(`Multi-model reachability check via Vercel AI Gateway`);
console.log(`Prompt: ${PROMPT}\n`);
console.log(pad('model', 32), pad('status', 8), pad('ttfb', 8), pad('total', 8), pad('in/out', 10), 'note');
console.log('-'.repeat(90));

for (const model of MODELS) {
  const start = performance.now();
  let firstChunkAt = null;
  let chars = 0;
  try {
    const result = streamText({ model, prompt: PROMPT });
    for await (const chunk of result.textStream) {
      if (firstChunkAt === null) firstChunkAt = performance.now();
      chars += chunk.length;
    }
    const end = performance.now();
    const usage = await result.usage;
    const ttfb = `${(firstChunkAt - start).toFixed(0)}ms`;
    const total = `${(end - start).toFixed(0)}ms`;
    const io = `${usage.inputTokens ?? '?'}/${usage.outputTokens ?? '?'}`;
    console.log(pad(model, 32), pad('ok', 8), pad(ttfb, 8), pad(total, 8), pad(io, 10), '');
  } catch (err) {
    let detail = err.message ?? String(err);
    try {
      if (err.cause?.responseBody) {
        const body = JSON.parse(err.cause.responseBody);
        detail = body?.error?.type ?? body?.error?.message ?? detail;
      }
    } catch {}
    const short = detail.replace(/\s+/g, ' ').slice(0, 60);
    console.log(pad(model, 32), pad('error', 8), pad('-', 8), pad('-', 8), pad('-', 10), short);
  }
}
