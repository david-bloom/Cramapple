import { gateway } from 'ai'; import fs from 'node:fs'; import path from 'node:path';
const GW = path.join(path.dirname(new URL(import.meta.url).pathname), '../../vercel-gateway-check');
for (const l of fs.readFileSync(path.join(GW, '.env.local'), 'utf8').split('\n')) { const i = l.indexOf('='); if (i > 0 && !l.startsWith('#')) process.env[l.slice(0, i).trim()] ??= l.slice(i + 1).trim().replace(/^["']|["']$/g, ''); }
const m = await gateway.getAvailableModels();
const want = ['google/gemini-3.8-flash','deepseek/deepseek-v4-pro','openai/gpt-6.1-sol'];
for (const w of want) { const x = m.models.find(y => y.id === w); console.log(w, x ? `OK in=${x.pricing?.input} out=${x.pricing?.output}` : 'MISSING'); }
console.log('newer candidates:', m.models.map(y=>y.id).filter(id=>/gemini-3\.[89]|deepseek-v4|gpt-6\.[1-9]/.test(id)).join(', '));
