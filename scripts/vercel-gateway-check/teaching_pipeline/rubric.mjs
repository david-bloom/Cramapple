// TASK-0065 generate-and-select pipeline: the ONE rubric. The author prompt and every checker prompt
// are built from RUBRIC_RULES, so an item is written to exactly the standard it is checked against.
// Sources: docs/new_design/CONTENT_AND_PEDAGOGY.md, TASK-0065 item standard, DECISION-0095 (CED scope),
// David 2026-10-06 ("fix lines must be actions"; habit lines come from the topic's point brief, not the item).
import { z } from 'zod';

export const RUBRIC_RULES = [
  ['on_topic', 'The question sits squarely on the designated topic and is answerable from that topic\'s content. A student who has studied only the designated topic (and earlier units) can answer it.'],
  ['ced_scope', 'Every concept, term and method it requires is inside the course\'s CED fact pack, including its exclusion statements. A mechanism supplied in the stem does not bring an out-of-scope term into scope.'],
  ['one_answer', 'Exactly four choices; exactly one is correct and defensible; no other choice is defensible under a careful reading.'],
  ['self_contained', 'No figure, image or calculator is needed. A table or graph may be given in words or as inline text.'],
  ['stem_clean', 'The stem never repeats the choices inline (no A/B/C/D list in the stem).'],
  ['keyed_rationale', 'The correct choice\'s rationale explains WHY it earns the point (the reasoning), never just that it is correct.'],
  ['named_trap', 'Every wrong choice is a named trap. Its rationale (a) names the specific error, misreading or misconception that makes a student pick it, (b) says briefly why it is wrong, and (c) ends with exactly one sentence that starts "Fix: " (it may sit in the same paragraph) and tells the student a concrete ACTION to take next time ("check...", "compute...", "ask whether..."). A fix that only states a fact or the right answer fails. Generic advice ("review the topic", "read carefully") fails.'],
  ['accurate', 'Every statement in every rationale is factually and mathematically correct.'],
  ['concise', 'Each rationale explains in one to three sentences, not counting a wrong choice\'s final Fix sentence. The correct choice\'s rationale is at most 60 words. Each wrong choice\'s rationale is at most 60 words before its Fix sentence, and the Fix sentence is at most 25 words.'],
  ['style', 'Plain, calm teacher voice: no emoji, no exclamation marks, no "Great job" or "Oops". Rationales never refer to other choices by letter. Use proper symbols (for example ≠, ≤, √) rather than programmer notation such as != or <=. Write all mathematics as plain text with Unicode symbols (for example lim x→3 f(x), x², √(x+1), 3/(x−2)); never LaTeX such as \\( \\), $…$ or \\frac, because the app shows text as written.'],
];
export const RUBRIC_TEXT = RUBRIC_RULES.map(([k, t], i) => `${i + 1}. [${k}] ${t}`).join('\n');

// Author output: no letters. The runner places the correct answer at a deterministic random position.
export const AUTHOR_SCHEMA = z.object({
  stem: z.string(),
  correct: z.object({ text: z.string(), rationale: z.string() }),
  distractors: z.array(z.object({ text: z.string(), rationale: z.string().describe('Names the error, says why it is wrong, ends with one "Fix: <action>" sentence') })).length(3),
});

export const SOLVE_SCHEMA = z.object({
  chosen_label: z.string().describe('A, B, C or D'),
  other_defensible_labels: z.array(z.string()).describe('Any other choice a careful expert could defend as correct; empty if none'),
  defect: z.string().describe('Empty if well posed with exactly one correct choice; otherwise what is wrong'),
});

export const AUDIT_SCHEMA = z.object({
  primary_topic_code: z.string().describe('The single topic code from the unit list that this question most directly tests'),
  rules: z.object(Object.fromEntries(RUBRIC_RULES.map(([k]) => [k, z.object({ pass: z.boolean(), issue: z.string().describe('Empty if pass; otherwise the specific problem, naming the choice letter if relevant') })]))),
});

// Deterministic lint (no model). Returns a list of failures; any failure rejects the candidate.
const EMOJI = /[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}\u{FE0F}]/u;
const FIGURE = /\b(shown (above|below)|(the|this) (figure|graph|diagram|image|picture)( shown)? (above|below)|(refer to|in|from|using) the (figure|image|picture)|see (the )?(figure|graph|diagram))\b/i;
export function lint(item) {
  const f = [];
  const ch = item.choices || [];
  if (ch.map((c) => c.choice_key).join('') !== 'ABCD') f.push('choices must be exactly A-D');
  const nCorrect = ch.filter((c) => c.is_correct).length;
  if (nCorrect !== 1) f.push(`${nCorrect} choices marked correct`);
  const stem = item.stem || '';
  if (/(^|\s)\(?A[.)]\s[\s\S]*(^|\s)\(?B[.)]\s/.test(stem)) f.push('stem carries an inline A/B list');
  for (const c of ch) if (c.choice_text.trim().length >= 12 && stem.toLowerCase().includes(c.choice_text.trim().replace(/\.$/, '').toLowerCase())) f.push(`stem repeats choice ${c.choice_key}`);
  if (new Set(ch.map((c) => c.choice_text.trim().toLowerCase())).size < ch.length) f.push('duplicate choice text');
  for (const c of ch) {
    const r = (c.rationale || '').trim();
    if (r.length < 25) f.push(`rationale ${c.choice_key} under 25 chars`);
    if (/^(credited|correct|this is (the )?correct( answer)?)\.?$/i.test(r) || /\bcredited\b/i.test(r)) f.push(`rationale ${c.choice_key} is a bare verdict`);
    if (/\b(choice|option|answer) [A-D]\b|\([A-D]\)/.test(r)) f.push(`rationale ${c.choice_key} refers to a choice by letter`);
    const words = (s) => s.trim().split(/\s+/).filter(Boolean).length;
    const fixAt = r.search(/\b(Fix|Next time):/);
    const body = fixAt >= 0 ? r.slice(0, fixAt) : r;
    if (words(body) > 60) f.push(`rationale ${c.choice_key} over 60 words (${words(body)})`);
    // Approximate sentence count (ignores common abbreviations); the rubric allows one to three before the Fix.
    const sentences = body.replace(/\b(e\.g|i\.e|etc|vs|approx|Fig|ca)\./gi, '$1').split(/(?<=[.?!])\s+(?=[A-Z0-9(])/).filter((x) => x.trim()).length;
    if (sentences > 3) f.push(`rationale ${c.choice_key} has ${sentences} sentences before any Fix (max 3)`);
    if (fixAt >= 0 && words(r.slice(fixAt)) > 26) f.push(`Fix line ${c.choice_key} over 25 words`);
    if (!c.is_correct) {
      const fixes = r.match(/\b(Fix|Next time):/g) || [];
      if (fixes.length !== 1) f.push(`distractor ${c.choice_key} needs exactly one Fix line, has ${fixes.length}`);
      else if (!/(Fix|Next time):[^\n]+$/.test(r)) f.push(`distractor ${c.choice_key}: Fix line must come last`);
    }
  }
  const text = [stem, ...ch.map((c) => `${c.choice_text} ${c.rationale}`)].join(' ');
  if (EMOJI.test(text)) f.push('emoji present');
  if (/<\/?[a-z][^>]*>|&[a-z]+;/i.test(text)) f.push('HTML markup or entity present');
  if (/\\[()\[\]]|\\(frac|lim|sqrt|infty|to|displaystyle|cdot|le|ge|neq)\b|\$[^$]*[\\^_{}][^$]*\$/.test(text)) f.push('LaTeX markup present (write maths as plain text)');
  if (/!=|<=|>=/.test(text)) f.push('programmer notation (!=, <=, >=) instead of a symbol');
  if (/!/.test(text.replace(/!=/g, ''))) f.push('exclamation mark present');
  if (/\bcalculator\b/i.test(text)) f.push('calculator reference');
  if (FIGURE.test(stem)) f.push('stem refers to a figure the student cannot see');
  return f;
}
