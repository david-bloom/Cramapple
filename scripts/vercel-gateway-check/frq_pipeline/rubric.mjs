// FRQ generation pipeline: the ONE rubric shared by the author prompt and every checker prompt
// (content authoring protocol v0.6; FRQs follow sections 4-6 and 9). An item is written to the standard it is checked against.
import { z } from 'zod';

export const SPEC = {
  ap_biology: { name: 'AP Biology', crit: [4, 5], parts: [3, 4], calc: false,
    note: 'Short free-response in AP Biology style: a scenario or experiment described in words, with any data as a small plain-text table. Parts use AP task verbs (identify, describe, explain, predict, justify, calculate).' },
  ap_calculus_ab: { name: 'AP Calculus AB', crit: [6, 8], parts: [3, 4], calc: true,
    note: 'Short free-response in AP Calculus style: a function given algebraically, piecewise, or as a small table of values. Parts ask for limits, derivatives, values or justifications; justifications cite the relevant definition or theorem.' },
  ap_calculus_bc: { name: 'AP Calculus BC', crit: [6, 8], parts: [3, 4], calc: true,
    note: 'Short free-response in AP Calculus style: a function given algebraically, piecewise, or as a small table of values. Parts ask for limits, derivatives, values or justifications; justifications cite the relevant definition or theorem.' },
  ap_chemistry: { name: 'AP Chemistry', crit: [4, 5], parts: [3, 5], calc: true,
    note: 'Short free-response in AP Chemistry style: a chemical system or experiment described in words, with data as a small plain-text table. Parts mix calculation (with units and correct significant figures) and particle-level explanation.' },
  ap_physics_1: { name: 'AP Physics 1', crit: [3, 5], parts: [2, 4], calc: true,
    note: 'Short free-response in AP Physics style: a physical setup described fully in words (no diagram). Parts ask for symbolic derivations, numeric calculations with units, or claims justified with physics principles.' },
  ap_physics_2: { name: 'AP Physics 2', crit: [3, 5], parts: [2, 4], calc: true,
    note: 'Short free-response in AP Physics style: a physical setup described fully in words (no diagram; describe any circuit by listing each element and how it is connected). Parts ask for symbolic derivations, numeric calculations with units, or claims justified with physics principles.' },
  ap_physics_c_em: { name: 'AP Physics C: Electricity and Magnetism', crit: [3, 5], parts: [2, 4], calc: true,
    note: 'Short free-response in AP Physics C style: a setup described fully in words (no diagram). Calculus-based derivations are expected where the topic calls for them; numeric answers carry units.' },
  ap_physics_c_mechanics: { name: 'AP Physics C: Mechanics', crit: [3, 5], parts: [2, 4], calc: true,
    note: 'Short free-response in AP Physics C style: a setup described fully in words (no diagram). Calculus-based derivations are expected where the topic calls for them; numeric answers carry units.' },
  ap_precalculus: { name: 'AP Precalculus', crit: [6, 6], parts: [3, 3], calc: true,
    note: 'Short free-response in AP Precalculus style: exactly three parts, (a), (b) and (c), each worth exactly 2 points (two criteria per part). A function or context is given algebraically, in words, or as a small plain-text table.' },
  ap_statistics: { name: 'AP Statistics', crit: [4, 6], parts: [2, 4], calc: true,
    note: 'Short free-response in AP Statistics style: a real-world context with any data as a small plain-text table. Answers must be communicated in context, following AP conventions for the topic (for example parameters defined, conditions checked, conclusions stated in context).' },
};

export const FRQ_RULES = [
  ['on_topic', 'The question squarely tests the designated topic: at least half of its points assess that topic\'s learning objectives and essential knowledge (the official CED text below). A student who has studied the designated topic and the earlier units can answer every part; no part needs a later topic or unit.'],
  ['ced_scope', 'Every concept, term, formula and method a full-credit answer needs is inside the CED (the official topic text and the fact pack), including its exclusion statements. Do not flag a specific numeric value, named object, or illustrative example merely because it is not verbatim in the fact pack; flag it only if the underlying concept it requires is absent or explicitly excluded.'],
  ['self_contained_typed', 'Answerable entirely in typed text. No figure, image, graph or diagram is shown or needed (data appear as plain-text tables, setups are described in words), and no part asks the student to draw, sketch, plot or label a picture. Do not use the words figure or diagram at all; where a topic is usually shown with a picture (free-body diagrams, circuits, graphs of functions), describe it in words and ask the student to list or describe, for example to name each force with its direction.'],
  ['well_posed', 'Every part has one defensible correct answer or a clearly stated set of acceptable answers. The given information is consistent and sufficient and numbers are realistic. Judge at the level of the AP course: the standard simplifying assumptions the course itself makes (for example ideal behavior, effects the course tells students to neglect, the usual biological or chemical generalizations taught in the CED) may be left unstated. Flag only a missing given, a contradiction, or an assumption a careful AP student could reasonably make differently.'],
  ['rubric_points', 'Every scoring criterion is worth exactly 1 point and awards one specific, observable element of a correct answer to the part it belongs to. A complete correct answer earns every criterion. No criterion rewards something the part did not ask for, double-counts another criterion, prescribes a method the part does not require, or rejects a valid alternative method. Accepted variants are only equivalent forms of a key value or key phrase (for example 3/8, 0.375 and 37.5%); they never replace the evidence requirement, which always applies. When a part asks for a magnitude, the rubric and model answer give a magnitude (with any condition that makes a signed expression positive stated in the question).'],
  ['rubric_evidence', 'Every criterion states what a response must show (evidence) and gives a fix: one concrete action, at most 25 words (count them), that a student who missed the point should take next time. Generic advice ("review the topic") fails.'],
  ['accurate', 'Every statement and number in the question, the rubric and the model answer is factually and mathematically correct at the level of the AP course. The standard explanation the CED teaches is accurate even where a more advanced treatment would add caveats; flag a statement only if it is wrong, or wrong as an AP teacher would judge it.'],
  ['model_answer', 'The model answer is written as a strong student would write it in an exam, labelled by part, shows the work each criterion asks for, and earns every criterion.'],
  ['style', 'Plain, calm wording. Mathematics as plain text with Unicode symbols (lim x→3 f(x), f′(x), x², √(x+1), ≤, ≠, π); never LaTeX, HTML, emoji or exclamation marks.'],
  ['distinct', 'Not a near-duplicate of the existing questions listed for this topic: a different scenario, function or data set, and where possible a different angle on the topic.'],
];
export const RULES_TEXT = FRQ_RULES.map(([k, t], i) => `${i + 1}. [${k}] ${t}`).join('\n');

export const AUTHOR_SCHEMA = z.object({
  title: z.string().describe('Short descriptive title, 4-10 words'),
  calculator: z.enum(['not_permitted', 'permitted', 'not_applicable']),
  stimulus: z.string().describe('The setup shared by all parts: context, function definitions, plain-text data tables'),
  parts: z.array(z.object({
    prompt: z.string().describe('What this part asks; do not include the part letter'),
    criteria: z.array(z.object({
      text: z.string().describe('The element that earns this 1 point, stated specifically (include the correct value where there is one)'),
      evidence: z.string().describe('What a response must show to earn the point'),
      fix: z.string().describe('One concrete action, at most 25 words, for a student who missed the point'),
      accepted_variants: z.array(z.string()).describe('Equivalent forms of the key value or key phrase only (for example 3/8; 0.375); never a full alternative answer. The evidence requirement still applies to them. Empty if none'),
    })),
  })),
  model_answer: z.string().describe('Full-credit answer written as a strong student would, labelled (a), (b), ...'),
  verification_python: z.string().describe('Python 3 that recomputes every number in the rubric and model answer from the givens using only sympy, math, fractions, statistics, decimal or itertools, asserts each one, and finally prints ALL_CHECKS_PASSED. If the question has no computed values, a script that only prints ALL_CHECKS_PASSED.'),
});

export const SOLVE_SCHEMA = z.object({
  answers: z.array(z.object({ part: z.string(), answer: z.string() })).describe('Your own complete answer to each part, with the key work and final values'),
  question_issues: z.string().describe('Empty if every part is well posed and answerable; otherwise what is ambiguous, inconsistent, insufficient or out of scope'),
});

export const auditSchema = (withModelAnswer) => z.object({
  primary_topic_code: z.string().describe('The single topic code from the unit list that this question most directly tests'),
  rules: z.object(Object.fromEntries(FRQ_RULES.filter(([k]) => withModelAnswer || k !== 'model_answer')
    .map(([k]) => [k, z.object({ pass: z.boolean(), issue: z.string().describe('Empty if pass; otherwise the specific problem, naming the part and criterion') })]))),
  solution_disagreements: z.string().describe('Compare your own independent solution with the rubric and model answer. Empty if they agree; otherwise each criterion or claim your solution shows is wrong'),
  difficulty: z.enum(['Easy', 'Medium', 'Hard']),
});

// Deterministic lint (no model). Any failure rejects the candidate.
const FIG = /\b((figure|graph|diagram|image|picture|chart) (is |are )?(shown|provided|given) (above|below)|(figure|graph|diagram|image|picture|chart) (above|below)|(the|this) (following|accompanying) (figure|graph|diagram|image|picture|chart)|(refer to|see|use|using|in|from) the (figure|diagram|image|picture|chart)( shown| above| below)?\b|see (the )?(figure|graph|diagram))/i;
const DRAW = /\b(draw|sketch|plot|shade|label (the|a|each) (graph|diagram|axes|figure))\b/i;
export function lint(it, sk) {
  const f = []; const s = SPEC[sk];
  const crit = it.parts.flatMap((p) => p.criteria);
  if (it.parts.length < s.parts[0] || it.parts.length > s.parts[1]) f.push(`${it.parts.length} parts (allowed ${s.parts.join('-')})`);
  if (crit.length < s.crit[0] || crit.length > s.crit[1]) f.push(`${crit.length} criteria/points (allowed ${s.crit.join('-')})`);
  if (sk === 'ap_precalculus' && it.parts.some((p) => p.criteria.length !== 2)) f.push('precalculus parts must have exactly 2 criteria');
  if (it.parts.some((p) => p.criteria.length === 0)) f.push('a part has no criteria');
  for (const c of crit) {
    if ((c.text || '').trim().length < 12 || (c.evidence || '').trim().length < 12) f.push('a criterion lacks text or evidence');
    const fw = (c.fix || '').trim().split(/\s+/).filter(Boolean).length; if (fw < 3 || fw > 25) f.push(`fix length ${fw} words`);
  }
  if ((it.model_answer || '').trim().length < 40) f.push('model answer missing');
  const text = [it.title, it.stimulus, ...it.parts.map((p) => p.prompt), ...crit.flatMap((c) => [c.text, c.evidence, c.fix]), it.model_answer].join('\n');
  if (FIG.test(text)) f.push('refers to a figure/graph/diagram');
  if (it.parts.some((p) => DRAW.test(p.prompt))) f.push('asks the student to draw/sketch/plot');
  if (/\\[()\[\]]|\\(frac|lim|sqrt|infty|cdot|left|right|mathrm|text)\b|\$[^$\n]*[\\^_{}][^$\n]*\$/.test(text)) f.push('LaTeX markup');
  if (/<\/?[a-z][^>]*>|&[a-z]+;/i.test(text)) f.push('HTML markup');
  if (/[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}]|!(?!=)/u.test(text.replace(/\d!/g, ''))) f.push('emoji or exclamation mark');
  if (/!=|<=|>=/.test(text)) f.push('programmer notation');
  if (!/ALL_CHECKS_PASSED/.test(it.verification_python || '')) f.push('verification script missing');
  return f;
}
