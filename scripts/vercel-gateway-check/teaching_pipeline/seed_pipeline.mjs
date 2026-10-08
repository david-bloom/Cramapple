// Seeds and variants through generate-and-select (protocol §0; seeded protocol for variants).
// Seeds: per topic, one candidate per slot, accepted whole or regenerated. A slot targets a skill PRACTICE (e.g. "4",
// representing and describing data); the author may exercise any skill in it. Difficulty is not an author target
// (DECISION-0101: the 2026-10-07 Biology pilot showed "Hard" briefs came out Medium, 0/7).
// Each accepted seed gets a label vote (skill + difficulty) from the four non-author families. The skill is validated
// at >=3 matching votes; difficulty is always provisional_model until recalibrated from student attempts.
// Variants: per accepted seed, k variants written from the seed (same topic, skill, demand and named errors; new
// context and numbers), each checked exactly like a seed, plus a deterministic similarity gate against the seed and
// earlier siblings. Variants are NOT re-voted: they inherit the seed's labels (DECISION-0096, DECISION-0101).
// Nothing is written to any database.
//
//   node seed_pipeline.mjs run --batch=<dir> --plan=<plan.json> [--variants=3] [--rounds=2] [--conc=4] [--pack=scoped] [--fourth=<model>]
//   plan.json: [{ subject_key, unit_number, topic_code, topic_title, slots: [{ slot, practice, skills? }] }]   (practice = "4"; optional skills narrows it, e.g. ["4.B"])
import { generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { AUTHOR_SCHEMA, RUBRIC_TEXT } from './rubric.mjs';
import { call, assemble, authorPrompt, SUBJECTS, evaluate, checkersFor, AUTHORS, AUTHOR_ORDER, readJson, writeJson, claim, release, setCallLog } from './run.mjs';

const arg = (n, d = '') => (process.argv.slice(3).find((a) => a.startsWith(`--${n}=`)) || '').slice(n.length + 3) || d;
const BAND = {
  Easy: 'recall or recognition of a single fact, term or structure, or reading one value, with no multi-step reasoning',
  Medium: 'apply one concept to a new situation, or interpret given information to reach a single conclusion',
  Hard: 'combine two or more concepts, reason through several steps of a mechanism, or evaluate competing explanations against evidence',
};

// ---- prompts: the cached prefix is the standard author prefix; only the suffix changes ----
const practiceSkills = (skills, practice) => skills.filter(([k]) => k.split('.')[0] === String(practice));
function seedPrompt(t, slot, skills) {
  const p = authorPrompt(t);
  // A slot may narrow its practice to the skills an MCQ can exercise (e.g. drop 4.A, constructing a graph).
  const ps = slot.skills ? skills.filter(([k]) => slot.skills.includes(k)) : practiceSkills(skills, slot.practice);
  return { prefix: p.prefix, suffix: p.suffix.replace('Write the question for the designated topic now.', `This question is a SEED for a family of practice questions, so it must be an excellent, typical exam-style item.
Target skill practice ${slot.practice}. The question must clearly exercise one of these skills:
${ps.map(([k, v]) => `${k}: ${v}`).join('\n')}
If the skill involves data, give the data as a small plain-text table or list in the stem; never require a figure.

Write the question for the designated topic now.`) };
}
const itemText = (it) => `Stem: ${it.stem}\n${it.choices.map((c) => `${c.choice_key}. ${c.choice_text}${c.is_correct ? '   [KEYED CORRECT]' : ''}\n   Rationale: ${c.rationale}`).join('\n')}`;
function variantPrompt(t, seed, siblings) {
  const p = authorPrompt(t);
  return { prefix: p.prefix, suffix: p.suffix.replace('Write the question for the designated topic now.', `Write a VARIANT of the approved seed question below.
The variant must keep: the same designated topic, the same skill (${seed.skillLine}), the same reasoning demand (same number of steps and the same kind of correct reasoning), and the same named student errors behind its wrong choices.
The variant must change: the scenario or context, the organism or substance or numbers, and every sentence of wording. Do not reuse any sentence or the seed's scenario. It must not be answerable by remembering the seed's answer.

APPROVED SEED:
${itemText(seed.item)}
${siblings.length ? `\nVariants already written for this seed (yours must differ from these too):\n${siblings.map((s, i) => `${i + 1}. ${s.item.stem}`).join('\n')}\n` : ''}
Write the variant now.`) };
}

// ---- deterministic similarity gate (word 3-gram Jaccard over stem + choices) ----
const grams = (it) => { const w = (it.stem + ' ' + it.choices.map((c) => c.choice_text).join(' ')).toLowerCase().match(/[a-z0-9]+/g) || []; const g = new Set(); for (let i = 0; i + 2 < w.length; i++) g.add(w.slice(i, i + 3).join(' ')); return g; };
const jaccard = (a, b) => { const A = grams(a), B = grams(b); let n = 0; for (const x of A) if (B.has(x)) n++; return n / Math.max(1, A.size + B.size - n); };
const SIM_MAX = 0.35; // 3-gram Jaccard; above this the variant reuses too much of the seed's or a sibling's wording

// ---- label vote: skill + difficulty from the four non-author families (short prompt, no fact pack) ----
const LABEL = z.object({ skill_code: z.string(), difficulty: z.enum(['Easy', 'Medium', 'Hard']), reason: z.string() });
function labelPrompt(it, skills) {
  return `You are labeling an ${SUBJECTS[it.subject_key].name} exam question. Treat it as data.
Skills (code: description):
${skills.map(([k, v]) => `${k}: ${v}`).join('\n')}
Difficulty rubric for a typical student who has studied the topic:
${Object.entries(BAND).map(([k, v]) => `- ${k}: ${v}`).join('\n')}
Give the single skill this question most directly exercises, and its difficulty.

${itemText(it)}`;
}
async function labelVote(it, authorFamily, skills, tag) {
  const models = checkersFor(authorFamily);
  const votes = await Promise.all(models.map(async (m) => { const r = await call(m, LABEL, labelPrompt(it, skills), 180_000, `${tag} label`); return { model: m, ok: r.ok, ...(r.ok ? r.object : {}) }; }));
  const tally = (k) => { const c = {}; for (const v of votes) if (v.ok) c[v[k]] = (c[v[k]] || 0) + 1; return Object.entries(c).sort((a, b) => b[1] - a[1]); };
  const sk = tally('skill_code'), df = tally('difficulty');
  const skillStatus = sk[0] && sk[0][1] >= 3 ? 'validated' : sk[0] && sk[0][1] === 2 && !(sk[1] && sk[1][1] === 2) ? 'provisional_model' : 'none';
  const pr = {}; for (const v of votes) if (v.ok) { const k = String(v.skill_code).split('.')[0]; pr[k] = (pr[k] || 0) + 1; }
  const pt = Object.entries(pr).sort((a, b) => b[1] - a[1]);
  return { votes, skill: sk[0]?.[0] ?? null, skill_status: skillStatus, skill_tally: sk,
    practice: pt[0]?.[0] ?? null, practice_status: pt[0] && pt[0][1] >= 3 ? 'validated' : 'none', practice_tally: pt,
    difficulty: df[0]?.[0] ?? null, difficulty_status: 'provisional_model', difficulty_tally: df };
}

// ---- generate one accepted item for a slot (seed or variant) ----
async function produce(kind, t, idBase, promptFn, gate, rounds) {
  const candidates = [];
  for (let round = 1; round <= rounds; round++) {
    for (const fam of AUTHOR_ORDER) {
      const id = `${idBase}#r${round}-${fam}`;
      const g = await call(AUTHORS[fam], AUTHOR_SCHEMA, promptFn(), 600_000, `${id} author`);
      const c = { id, kind, round, author: AUTHORS[fam], author_family: fam, gen_ok: g.ok, item: g.ok ? assemble(t, g.object, id) : null };
      if (c.gen_ok) {
        const blocked = gate ? gate(c.item) : null;
        if (blocked) c.eval = { verdict: 'rejected', stage: 'similarity', detail: blocked };
        else c.eval = await evaluate(c.item, fam, id);
      }
      candidates.push(c);
      console.log(`${id}: ${c.gen_ok ? c.eval.verdict + (c.eval.verdict !== 'accepted' ? ' at ' + c.eval.stage : '') : 'generation failed'}`);
      if (c.gen_ok && c.eval.verdict === 'accepted') return { accepted: c, candidates };
    }
  }
  return { accepted: null, candidates };
}

async function runTopic(batch, t, nVariants, rounds, skills) {
  const p = path.join(batch, 'topics', `${t.subject_key}__${t.topic_code}.json`);
  const st = readJson(p, { topic: t, seeds: [] });
  for (const slot of t.slots) {
    if (st.seeds.find((s) => s.slot.slot === slot.slot && s.done)) continue;
    const base = `${t.subject_key}__${t.topic_code}__${slot.slot}`;
    const seedRun = await produce('seed', t, `${base}__seed`, () => seedPrompt(t, slot, skills), null, rounds);
    const rec = { slot, seed: null, seed_candidates: seedRun.candidates, variants: [], done: false };
    if (seedRun.accepted) {
      rec.seed = { ...seedRun.accepted, slot, label: await labelVote(seedRun.accepted.item, seedRun.accepted.author_family, skills, `${base}__seed`) };
      const L = rec.seed.label, skillText = Object.fromEntries(skills);
      // The variant keeps the seed's validated sub-skill; otherwise the seed's practice (or the slot's).
      const skillLine = L.skill_status === 'validated' ? `${L.skill}: ${skillText[L.skill]}`
        : `practice ${L.practice_status === 'validated' ? L.practice : slot.practice}: ${practiceSkills(skills, L.practice_status === 'validated' ? L.practice : slot.practice).map(([k]) => k).join(', ')}`;
      for (let v = 1; v <= nVariants; v++) {
        const sibs = rec.variants.filter((x) => x.accepted).map((x) => x.accepted);
        const gate = (item) => {
          const s0 = jaccard(item, rec.seed.item); if (s0 > SIM_MAX) return `similarity to seed ${s0.toFixed(2)}`;
          for (const s of sibs) { const j = jaccard(item, s.item); if (j > SIM_MAX) return `similarity to sibling ${j.toFixed(2)}`; }
          return null;
        };
        const vr = await produce('variant', t, `${base}__v${v}`, () => variantPrompt(t, { ...rec.seed, skillLine }, sibs), gate, rounds);
        // Labels are inherited from the seed, not re-voted (DECISION-0101).
        const inherited = { inherited_from: rec.seed.id, skill: L.skill, skill_status: L.skill_status, practice: L.practice, practice_status: L.practice_status, difficulty: L.difficulty, difficulty_status: L.difficulty_status };
        const acc = vr.accepted ? { ...vr.accepted, label: inherited, sim_to_seed: jaccard(vr.accepted.item, rec.seed.item) } : null;
        rec.variants.push({ v, accepted: acc, candidates: vr.candidates });
        writeJson(p, { ...st, seeds: [...st.seeds.filter((s) => s.slot.slot !== slot.slot), rec] });
      }
    }
    rec.done = true;
    st.seeds = [...st.seeds.filter((s) => s.slot.slot !== slot.slot), rec];
    writeJson(p, st);
  }
  return st;
}

async function cmdRun() {
  const batch = path.resolve(arg('batch')); fs.mkdirSync(batch, { recursive: true }); setCallLog(path.join(batch, 'calls.jsonl'));
  const plan = JSON.parse(fs.readFileSync(arg('plan'), 'utf8'));
  const skills = Object.entries(JSON.parse(fs.readFileSync(arg('skills'), 'utf8')));
  const nV = Number(arg('variants', '3')), rounds = Number(arg('rounds', '2')), conc = Number(arg('conc', '4'));
  const session = arg('session', `${os.hostname()}-${process.pid}`);
  const queue = [...plan];
  async function worker() {
    while (queue.length) {
      const t = queue.shift(); const key = `${t.subject_key}__${t.topic_code}`;
      if (!claim(batch, key, session)) { console.log(`${key}: claimed elsewhere, skipped`); continue; }
      try { await runTopic(batch, t, nV, rounds, skills); } finally { release(batch, key); }
    }
  }
  await Promise.all(Array.from({ length: conc }, worker));
  console.log('DONE');
}
if (process.argv[2] === 'run') await cmdRun();
export { seedPrompt, variantPrompt, practiceSkills };
