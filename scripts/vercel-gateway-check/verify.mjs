import { streamText } from 'ai';

const MODEL = process.argv[2] ?? 'openai/gpt-5.5';
const PROMPT = 'Reply with one short sentence confirming the Vercel AI Gateway connection is working.';

const start = performance.now();
let firstChunkAt = null;
let chars = 0;

const result = streamText({ model: MODEL, prompt: PROMPT });

process.stdout.write('--- response ---\n');
for await (const chunk of result.textStream) {
  if (firstChunkAt === null) firstChunkAt = performance.now();
  process.stdout.write(chunk);
  chars += chunk.length;
}
process.stdout.write('\n--- end ---\n\n');

const end = performance.now();
const usage = await result.usage;
const finish = await result.finishReason;

console.log(`model:         ${MODEL}`);
console.log(`finish_reason: ${finish}`);
console.log(`ttfb_ms:       ${(firstChunkAt - start).toFixed(0)}`);
console.log(`total_ms:      ${(end - start).toFixed(0)}`);
console.log(`response_chars: ${chars}`);
console.log(`input_tokens:  ${usage.inputTokens ?? 'n/a'}`);
console.log(`output_tokens: ${usage.outputTokens ?? 'n/a'}`);
console.log(`total_tokens:  ${usage.totalTokens ?? 'n/a'}`);
