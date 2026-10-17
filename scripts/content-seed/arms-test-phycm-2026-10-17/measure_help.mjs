#!/usr/bin/env node
// Helpability of every accepted seed in each arm, measured identically: the real More help prompt and runtime check, with up to two
// rewrites (as in production). Outputs per-arm first-draft flag rate, rewrites needed, and refusals. Usage: node measure_help.mjs batch_A batch_B batch_C
import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
const arms = process.argv.slice(2);
const items = [];
for (const arm of arms) {
  const dir = path.join(arm, 'topics');
  for (const f of fs.readdirSync(dir).filter((x) => x.endsWith('.json'))) {
    const st = JSON.parse(fs.readFileSync(path.join(dir, f), 'utf8'));
    for (const s of st.seeds) if (s.seed) items.push({ id: `${arm.replace('batch_', '')}-${st.topic.topic_code}${s.slot.slot}`, stem: s.seed.item.stem, topic_code: st.topic.topic_code, subject_key: st.topic.subject_key,
      choices: s.seed.item.choices.map((c) => ({ k: c.choice_key, t: c.choice_text, c: c.is_correct })) });
  }
}
fs.writeFileSync('measure_in.json', JSON.stringify(items));
console.log(`measuring ${items.length} items`);
execFileSync('deno', ['run', '-A', 'help_gate.ts', 'measure_in.json', 'measure_out.json', 'measure'], { stdio: 'inherit', env: { ...process.env, HELP_CALL_LOG: path.resolve('measure_calls.jsonl') } });
const out = JSON.parse(fs.readFileSync('measure_out.json', 'utf8'));
const by = {};
for (const r of out) { const a = r.id.split('-')[0]; (by[a] ??= []).push(r); }
for (const [a, rs] of Object.entries(by).sort()) {
  const n = rs.length, fl = rs.filter((r) => r.first === 'FLAGGED').length, rf = rs.filter((r) => r.final === 'REFUSED').length, er = rs.filter((r) => /ERROR/.test(r.final || r.first)).length;
  console.log(`arm ${a}: items ${n} | first draft flagged ${fl} (${Math.round((100 * fl) / n)}%) | refused after 2 rewrites ${rf} | errors ${er} | avg rewrites ${(rs.reduce((s, r) => s + (r.revisions || 0), 0) / n).toFixed(2)}`);
}
