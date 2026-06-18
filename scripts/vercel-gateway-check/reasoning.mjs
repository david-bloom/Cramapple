import { streamText } from 'ai';

const MODEL = 'openai/gpt-5.5';
const EFFORTS = ['low', 'medium', 'high'];

const PROMPT = `
You are grading one criterion of an AP Biology FRQ.

Question stem: Explain why running in heat decreases enzyme activity.
Criterion C1: response must identify that high temperature disrupts enzyme tertiary structure.
Student response: "When it gets hot the enzyme stops working because the heat breaks the shape of the active site."

Decide whether C1 is earned. Reply with JSON only, in the shape:
{"status": "earned" | "not_earned", "evidence_quote": "<verbatim phrase>", "confidence": 0..1}
`.trim();

const pad = (s, n) => String(s).padEnd(n);

console.log(`reasoning_effort passthrough check via Vercel AI Gateway`);
console.log(`Model: ${MODEL}`);
console.log(`Prompt sent verbatim for each effort level\n`);
console.log(pad('effort', 8), pad('ttfb', 10), pad('total', 10), pad('reasoning', 12), pad('output', 8), 'response (truncated)');
console.log('-'.repeat(110));

for (const effort of EFFORTS) {
  const start = performance.now();
  let firstChunkAt = null;
  let buffer = '';
  try {
    const result = streamText({
      model: MODEL,
      prompt: PROMPT,
      providerOptions: {
        openai: { reasoningEffort: effort },
      },
    });
    for await (const chunk of result.textStream) {
      if (firstChunkAt === null) firstChunkAt = performance.now();
      buffer += chunk;
    }
    const end = performance.now();
    const usage = await result.usage;
    const ttfb = firstChunkAt ? `${(firstChunkAt - start).toFixed(0)}ms` : '-';
    const total = `${(end - start).toFixed(0)}ms`;
    const reasoning = String(usage.reasoningTokens ?? '?');
    const output = String(usage.outputTokens ?? '?');
    const short = buffer.replace(/\s+/g, ' ').slice(0, 60);
    console.log(pad(effort, 8), pad(ttfb, 10), pad(total, 10), pad(reasoning, 12), pad(output, 8), short);
  } catch (err) {
    const msg = (err.message ?? String(err)).replace(/\s+/g, ' ').slice(0, 80);
    console.log(pad(effort, 8), pad('-', 10), pad('-', 10), pad('-', 12), pad('-', 8), `error: ${msg}`);
  }
}

console.log('\nExpect reasoning-token counts to scale roughly with effort.');
console.log('If all three rows produce identical timing/reasoning counts, the gateway is ignoring reasoningEffort.');
