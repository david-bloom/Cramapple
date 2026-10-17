#!/usr/bin/env node
// D vs A, paired: the standard evaluation (arm A, already run) against the cheaper checker profile D on the SAME candidates.
//   CHECKER_PROFILE=D node evaluate_D.mjs --a=batch_A --out=batch_D [--max=60] [--batch=10]
//
// PRE-REGISTERED DECISION RULES (written before any D call). One-sided exact tests, alpha = 0.05. Items are evaluated in a fixed
// shuffled order in batches of 10; after each batch every hypothesis is tested and the run STOPS as soon as all four are significant
// (no more evaluations than needed), or when the pool is used up.
//   H1 cost:      per-candidate evaluation cost (solve+audit+veto) is lower under D than under A. Exact Wilcoxon signed-rank on paired differences.
//   H2 time:      per-candidate summed call time is lower under D than under A. Same test.
//   H3 detection: D rejects planted defects at a rate above 0.80. Exact binomial, H0: rate <= 0.80 (needs 14 of 14 with no miss).
//   H4 agreement: D accepts candidates that A accepted at a rate above 0.75. Exact binomial, H0: rate <= 0.75.
// Pool: every candidate arm A sent to the checkers (accepted and rejected; similarity-gate rejects were never checked) plus planted defects
// made from A-accepted items (wrong key, duplicated correct choice, swapped rationale). Planted items are not run under A (the controls did that).
import fs from 'node:fs';
import path from 'node:path';
import { evaluate, setCallLog } from '../../vercel-gateway-check/teaching_pipeline/run.mjs';

const arg = (n, d = '') => (process.argv.slice(2).find((a) => a.startsWith(`--${n}=`)) || '').slice(n.length + 3) || d;
const A = arg('a', 'batch_A'), OUT = arg('out', 'batch_D'), BATCH = +arg('batch', '10'), MAX = +arg('max', '200');
if (process.env.CHECKER_PROFILE !== 'D') throw new Error('Run with CHECKER_PROFILE=D');
fs.mkdirSync(OUT, { recursive: true }); setCallLog(path.join(OUT, 'calls.jsonl'));

// ---- pool ----
const pool = [];
for (const f of fs.readdirSync(path.join(A, 'topics')).filter((x) => x.endsWith('.json'))) {
  const st = JSON.parse(fs.readFileSync(path.join(A, 'topics', f), 'utf8'));
  for (const s of st.seeds) for (const c of s.seed_candidates || []) {
    const e = c.eval; if (!c.gen_ok || !c.item || !e || e.stage === 'similarity') continue;
    pool.push({ kind: 'candidate', id: c.id, family: c.author_family, item: c.item, aVerdict: e.verdict, aStage: e.stage });
  }
}
let seed = 20261017; const rnd = () => (seed = (seed * 1664525 + 1013904223) % 4294967296) / 4294967296;
const shuffle = (a) => { for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(rnd() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; };
const accepted = pool.filter((p) => p.aVerdict === 'accepted');
// Planted defects that PASS lint (lint is deterministic code shared by both profiles, so it would say nothing about the checker models):
//   key_text_swap: the keyed choice and a distractor trade texts, rationales stay put, so the key is wrong.
//   near_duplicate: a distractor becomes the correct text plus a trailing word, so two choices are defensible.
//   stem_number:    the first number in the stem is changed, so the keyed answer no longer follows from the given.
const hasDigit = (it) => /\d/.test(it.stem);
const kinds = ['key_text_swap', 'near_duplicate', 'stem_number'];
const srcs = shuffle([...accepted]); const sNum = srcs.filter((x) => hasDigit(x.item));
const picks = [...srcs.filter((x) => !sNum.includes(x)).slice(0, 0), ...srcs].slice(0, 0);
const planted = [];
const used = new Set();
const take = (pred) => { const x = srcs.find((y) => !used.has(y.id) && pred(y)); if (x) used.add(x.id); return x; };
for (const [kind, n] of [['key_text_swap', 5], ['near_duplicate', 5], ['stem_number', 4]]) for (let k = 0; k < n; k++) {
  const src = take(kind === 'stem_number' ? (y) => hasDigit(y.item) : () => true); if (!src) continue;
  const item = JSON.parse(JSON.stringify(src.item));
  const ci = item.choices.findIndex((c) => c.is_correct), w = item.choices.findIndex((c, i2) => i2 !== ci);
  if (kind === 'key_text_swap') { const t = item.choices[ci].choice_text; item.choices[ci].choice_text = item.choices[w].choice_text; item.choices[w].choice_text = t; }
  else if (kind === 'near_duplicate') item.choices[w].choice_text = item.choices[ci].choice_text.replace(/\.$/, '') + ' exactly';
  else item.stem = item.stem.replace(/\d+(\.\d+)?/, (m) => String(+m * 2 + 1));
  planted.push({ kind: 'planted', planted: kind, id: `PLANT${planted.length}-${kind}-${src.id.split('__').slice(1, 3).join('_')}`, family: src.family, item });
}
const order = [...planted, ...shuffle([...pool])].slice(0, MAX); // planted first: H3 needs 14 of them, so interleaving would only add evaluations
console.log(`pool: ${pool.length} candidates (${accepted.length} A-accepted, ${pool.length - accepted.length} A-rejected) + ${planted.length} planted; order fixed, batches of ${BATCH}`);

// ---- exact statistics ----
function signedRankP(diffs) { // one-sided P(W+ >= observed) under H0 (symmetric about 0); zeros dropped, ties by average rank
  const d = diffs.filter((x) => x !== 0); const n = d.length; if (!n) return 1;
  const abs = d.map((x, i) => ({ a: Math.abs(x), pos: x > 0, i })).sort((p, q) => p.a - q.a);
  const ranks = new Array(n); for (let i = 0; i < n;) { let j = i; while (j + 1 < n && abs[j + 1].a === abs[i].a) j++; for (let k = i; k <= j; k++) ranks[abs[k].i] = (i + j) / 2 + 1; i = j + 1; }
  const w = d.reduce((s, x, i) => s + (x > 0 ? ranks[i] : 0), 0);
  const r2 = ranks.map((r) => Math.round(r * 2)); const total = r2.reduce((s, x) => s + x, 0);
  const dp = new Array(total + 1).fill(0); dp[0] = 1;
  for (const r of r2) for (let s = total; s >= r; s--) dp[s] += dp[s - r];
  const target = Math.round(w * 2); let tail = 0; for (let s = target; s <= total; s++) tail += dp[s];
  return tail / 2 ** n;
}
function binomTail(k, n, p0) { let t = 0; for (let i = k; i <= n; i++) { let c = 1; for (let j = 0; j < i; j++) c = (c * (n - j)) / (j + 1); t += c * p0 ** i * (1 - p0) ** (n - i); } return t; }

// ---- A-side cost/time per candidate from arm A's call log ----
const P = await (await fetch('https://ai-gateway.vercel.sh/v1/models')).json(); const price = Object.fromEntries(P.data.filter((x) => x.pricing).map((x) => [x.id, x.pricing]));
const usd = (u, p) => { const inp = u?.inputTokens || 0, det = u?.inputTokenDetails || {}, cr = det.cacheReadTokens ?? u?.cachedInputTokens ?? 0, cw = det.cacheWriteTokens || 0, out = u?.outputTokens || 0; return Math.max(inp - cr - cw, 0) * +p.input + cr * +(p.input_cache_read ?? p.input) + cw * +(p.input_cache_write ?? p.input) + out * +p.output; };
function perCandidate(dir) {
  const m = {};
  for (const l of fs.readFileSync(path.join(dir, 'calls.jsonl'), 'utf8').split('\n').filter(Boolean)) {
    let r; try { r = JSON.parse(l); } catch { continue; }
    const mm = /^(\S+) (solve|audit|veto)\b/.exec(r.tag); if (!mm || !price[r.model]) continue;
    const e = (m[mm[1]] ??= { usd: 0, min: 0 }); e.usd += usd(r.usage, price[r.model]); e.min += (r.ms || 0) / 60000;
  }
  return m;
}
const aCost = perCandidate(A);

// ---- run in batches, test after each ----
const results = []; const resPath = path.join(OUT, 'results.jsonl');
async function runBatch(items) {
  const q = [...items];
  await Promise.all(Array.from({ length: 4 }, async () => { while (q.length) {
    const it = q.shift();
    const ev = await evaluate(it.item, it.family, it.id);
    const row = { id: it.id, kind: it.kind, planted: it.planted || null, aVerdict: it.aVerdict || null, aStage: it.aStage || null, dVerdict: ev.verdict, dStage: ev.stage };
    fs.appendFileSync(resPath, JSON.stringify(row) + '\n'); results.push(row);
  } }));
}
function test() {
  const dCost = perCandidate(OUT);
  const pairs = results.filter((r) => r.kind === 'candidate' && aCost[r.id] && dCost[r.id]);
  const h1 = signedRankP(pairs.map((r) => aCost[r.id].usd - dCost[r.id].usd)), h2 = signedRankP(pairs.map((r) => aCost[r.id].min - dCost[r.id].min));
  const pl = results.filter((r) => r.kind === 'planted'), caught = pl.filter((r) => r.dVerdict === 'rejected').length;
  const h3 = pl.length ? binomTail(caught, pl.length, 0.8) : 1;
  const ac = results.filter((r) => r.kind === 'candidate' && r.aVerdict === 'accepted'), dAcc = ac.filter((r) => r.dVerdict === 'accepted').length;
  const h4 = ac.length ? binomTail(dAcc, ac.length, 0.75) : 1;
  const sum = (o, ids) => ids.reduce((s, i) => s + (o[i]?.usd || 0), 0), sumM = (o, ids) => ids.reduce((s, i) => s + (o[i]?.min || 0), 0);
  const ids = pairs.map((r) => r.id);
  return { evaluated: results.length, pairs: pairs.length,
    H1_cost: { p: +h1.toFixed(4), A_usd: +sum(aCost, ids).toFixed(3), D_usd: +sum(dCost, ids).toFixed(3), D_vs_A: ids.length ? +(sum(dCost, ids) / sum(aCost, ids)).toFixed(2) : null },
    H2_time: { p: +h2.toFixed(4), A_call_min: +sumM(aCost, ids).toFixed(1), D_call_min: +sumM(dCost, ids).toFixed(1) },
    H3_detection: { p: +h3.toFixed(4), caught: `${caught}/${pl.length}`, missed: pl.filter((r) => r.dVerdict !== 'rejected').map((r) => r.id) },
    H4_agreement: { p: +h4.toFixed(4), accepted_by_D: `${dAcc}/${ac.length}`, rejected_by_D: ac.filter((r) => r.dVerdict !== 'accepted').map((r) => `${r.id} (${r.dStage})`) },
    A_rejected_also_rejected_by_D: (() => { const rj = results.filter((r) => r.kind === 'candidate' && r.aVerdict === 'rejected'); return `${rj.filter((r) => r.dVerdict === 'rejected').length}/${rj.length}`; })() };
}
let done = 0; let last;
while (done < order.length) {
  await runBatch(order.slice(done, done + BATCH)); done += BATCH; last = test();
  console.log(JSON.stringify(last));
  const ok = last.H1_cost.p < 0.05 && last.H2_time.p < 0.05 && last.H3_detection.p < 0.05 && last.H4_agreement.p < 0.05;
  if (ok) { console.log(`STOP: all four hypotheses significant after ${results.length} evaluations`); break; }
}
fs.writeFileSync(path.join(OUT, 'summary.json'), JSON.stringify({ stopped_after: results.length, pool: order.length, last }, null, 1));
