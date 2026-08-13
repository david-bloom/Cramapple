// Re-check of the 7 criteria flagged by verify_calc_setA_decomposition.mjs, with
// corrected elements applied (6 per the reviewer's own corrected_label suggestions;
// 1 per the reviewer's coverage_notes gap, no suggested wording given -- see comments).
// Same blind independent-model review approach, same model, same schema/prompt.

import { generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';

const REVIEWER_MODEL = process.env.GS_GOOGLE ?? 'google/gemini-2.5-flash';

const CORRECTED = [
  {
    content_key: 'apcalcab-frq-003',
    stem: '(a) Find the velocity and acceleration functions.\n\n(b) Find all times when the particle is at rest.\n\n(c) Determine whether the particle speeds up or slows down immediately after t=2.',
    stimulus: 'A particle moves on a line with position x(t)=t³−3t²+2 for 0≤t≤4, measured in meters.',
    criterion_id: 'b7765cb3-90cc-4161-a395-8178c5b695e1',
    criterion_key: 'part-a-criterion-1',
    points_possible: 3,
    learner_facing_text: 'v(t)=3t²−6t and a(t)=6t−6.',
    elements: [
      "Differentiates x(t) term-by-term to find v(t)=3t^2-6t (correct coefficient and power on each term).",
      "Differentiates v(t) term-by-term to find a(t)=6t-6 (correct coefficient and power on each term).",
      "Presents both v(t) and a(t) explicitly as the labeled velocity and acceleration functions of t (not evaluated at a single point), matching what the criterion asks for.",
    ],
  },
  {
    content_key: 'apcalcab-frq-008',
    stem: '(a) Write an expression for the net change in water volume from t=0 to t=6.\n\n(b) Evaluate the net change.\n\n(c) At what times is the water volume increasing?',
    stimulus: 'Water enters a tank at R(t)=12+3sin(t/2) liters per minute and leaves at 10 liters per minute, where 0≤t≤6.',
    criterion_id: '044fd09d-f20b-44e0-99d4-21ff573d2ba6',
    criterion_key: 'part-a-criterion-1',
    points_possible: 3,
    learner_facing_text: 'The net change is ∫[0 to 6](2+3sin(t/2))dt.',
    elements: [
      'Identifies the net rate of change in volume as inflow minus outflow: R(t)-10 = (12+3sin(t/2))-10 = 2+3sin(t/2).',
      "Indicates integration of the net rate (e.g., by writing '∫ ... dt' or similar notation).",
      'Applies the correct limits of integration, 0 and 6.',
    ],
  },
  {
    content_key: 'apcalcab-frq-008',
    stem: '(a) Write an expression for the net change in water volume from t=0 to t=6.\n\n(b) Evaluate the net change.\n\n(c) At what times is the water volume increasing?',
    stimulus: 'Water enters a tank at R(t)=12+3sin(t/2) liters per minute and leaves at 10 liters per minute, where 0≤t≤6.',
    criterion_id: '473e5083-9a0b-46cb-859d-ab60a869dd5f',
    criterion_key: 'part-c-criterion-1',
    points_possible: 3,
    learner_facing_text: 'It is increasing throughout 0≤t≤6 because 2+3sin(t/2)>0 on this interval.',
    elements: [
      'States that volume is increasing exactly when the net rate 2+3sin(t/2) is positive.',
      'Analyzes the sign of 2+3sin(t/2) on [0,6]: notes that sin(t/2) >= 0 on this interval, so 2+3sin(t/2) >= 2, which is always positive.',
      'Concludes the volume is increasing for the entire interval 0<=t<=6.',
    ],
  },
  {
    content_key: 'apcalcab-frq-011',
    stem: '(a) Find F′(x) and F″(x).\n\n(b) Find the intervals on which F is increasing.\n\n(c) Find the x-coordinate where F changes concavity.',
    stimulus: 'Define F(x)=∫[0 to x](3t²−4t+1)dt.',
    criterion_id: 'e1029100-0650-4b87-8747-71c6402beed3',
    criterion_key: 'part-a-criterion-1',
    points_possible: 3,
    learner_facing_text: "F′(x)=3x²−4x+1 and F″(x)=6x−4.",
    elements: [
      "Applies the Fundamental Theorem of Calculus (Part 1) to get F'(x)=3x^2-4x+1 directly from the integrand.",
      "Differentiates F'(x) to find F''(x)=6x-4.",
      "Correctly differentiates the constant term in F'(x) (i.e., d/dx(1)=0).",
    ],
  },
  {
    content_key: 'apcalcbc-frq-003',
    stem: '(a) Find dy/dx in terms of x and y.\n\n(b) Find the slope at (0,0).\n\n(c) Find d²y/dx² at (0,0).',
    stimulus: 'A curve is defined implicitly by e^(xy)+x²−y=1 near (0,0).',
    criterion_id: '431ee4a1-c510-4702-966d-756f013daf2a',
    criterion_key: 'part-b-criterion-1',
    points_possible: 3,
    learner_facing_text: 'The slope is 0.',
    elements: [
      "Substitutes the point (0,0) into the y' expression from part (a).",
      'Correctly evaluates all terms in the numerator and denominator after substitution.',
      'Simplifies the resulting expression to get slope = 0.',
    ],
  },
  {
    // Reviewer found the original decomposition covers only the "differentiate again"
    // method, not the "local expansion" method the criterion explicitly also allows.
    // No corrected_label was suggested; this is a hand-drafted, method-agnostic fix
    // that credits either valid approach, per protocol §6 (draft, not resolve, then
    // re-verify against an independent model rather than assume it's right).
    content_key: 'apcalcbc-frq-003',
    stem: '(a) Find dy/dx in terms of x and y.\n\n(b) Find the slope at (0,0).\n\n(c) Find d²y/dx² at (0,0).',
    stimulus: 'A curve is defined implicitly by e^(xy)+x²−y=1 near (0,0).',
    criterion_id: '57e9f143-864c-4e18-80d4-e2ff046c3a4f',
    criterion_key: 'part-c-criterion-1',
    points_possible: 3,
    learner_facing_text: 'Differentiating again or using a local expansion gives y″(0)=2.',
    elements: [
      "Selects a valid method to find y''(0): either differentiating the y' expression (or the original implicit equation) a second time, or constructing a local quadratic/Taylor expansion of y near x=0 using y(0)=0 and y'(0)=0.",
      "Correctly executes the chosen method to isolate the y'' (or quadratic-coefficient) term -- e.g., substitutes x=0, y=0, y'=0 into the twice-differentiated equation, or matches the x^2 coefficient of the local expansion to y''(0)/2.",
      "Simplifies to obtain y''(0)=2.",
    ],
  },
  {
    content_key: 'apcalcbc-frq-005',
    stem: '(a) Find and classify all critical numbers.\n\n(b) Find the intervals where f is increasing.\n\n(c) Determine the concavity of f at x=1.',
    stimulus: 'A function f has f′(x)=x(x−2)³.',
    criterion_id: 'c98e5f01-7e55-4944-b207-554b84e83613',
    criterion_key: 'part-b-criterion-1',
    points_possible: 3,
    learner_facing_text: 'f is increasing on (−∞,0) and (2,∞).',
    elements: [
      "Reuses the sign analysis of f'(x): f'(x)>0 on (-infinity,0) and on (2,infinity).",
      'Identifies critical points x=0 and x=2.',
      'States the increasing intervals as (-infinity,0) and (2,infinity), based on where f\'(x)>0.',
    ],
  },
];

const REVIEW_SCHEMA = z.object({
  element_reviews: z.array(z.object({
    index: z.number().int(),
    valid: z.boolean(),
    issue: z.string(),
    corrected_label: z.string(),
  })),
  coverage_complete: z.boolean(),
  coverage_notes: z.string(),
  overall_verdict: z.enum(['approve', 'flag']),
});

function reviewPrompt(item, criterion) {
  return `You are an AP Calculus reader checking a proposed decomposition of a multi-point
free-response rubric criterion into its component facts/steps. You do not know who wrote
this decomposition and should evaluate it purely on its own merits.

Question stem:
${item.stem}

Stimulus:
${item.stimulus}

Rubric criterion (worth ${criterion.points_possible} points, one point per correctly-scoped
element -- there should be exactly ${criterion.points_possible} elements):
"${criterion.learner_facing_text}"

Proposed element decomposition:
${criterion.elements.map((e, i) => `${i}: ${e}`).join('\n')}

For EACH element (by index), judge:
- valid: is it mathematically correct and a genuinely distinct, checkable sub-step or
  sub-fact required to fully satisfy the criterion? (Not distinct = it's really the same
  fact as another element restated, or it's not actually required by this criterion.)
- issue: if invalid, explain the specific problem (math error, redundant with another
  element, not actually required, wrong scope). If valid, leave this "".
- corrected_label: if invalid, propose a corrected element label. If valid, leave this "".

Then judge the SET as a whole:
- coverage_complete: do the elements, taken together, cover everything needed to fully
  satisfy the criterion with nothing missing and nothing extraneous?
- coverage_notes: brief explanation, especially if coverage_complete is false.
- overall_verdict: "approve" only if every element is valid AND coverage is complete.
  Otherwise "flag".

Be strict and skeptical -- this decomposition will be reused to generate and grade student
answers, so an error here propagates silently into everything downstream.`;
}

async function withRetry(fn, attempts = 3) {
  let lastErr;
  for (let i = 0; i < attempts; i++) {
    try {
      return await fn();
    } catch (err) {
      lastErr = err;
      await new Promise((r) => setTimeout(r, 1000 * (i + 1)));
    }
  }
  throw lastErr;
}

console.log(`Re-check of ${CORRECTED.length} corrected criteria via ${REVIEWER_MODEL}`);
console.log('');

const results = [];
for (const c of CORRECTED) {
  process.stdout.write(`${c.content_key} / ${c.criterion_key} ... `);
  try {
    const { object } = await withRetry(() => generateObject({
      model: REVIEWER_MODEL,
      schema: REVIEW_SCHEMA,
      prompt: reviewPrompt(c, c),
    }));
    results.push({ ...c, review: object, error: null });
    console.log(object.overall_verdict.toUpperCase());
  } catch (err) {
    results.push({ ...c, review: null, error: String(err) });
    console.log('ERROR: ' + String(err).slice(0, 200));
  }
}

fs.writeFileSync('calc_setA_decomposition_recheck.json', JSON.stringify(results, null, 2));

const approved = results.filter((r) => r.review?.overall_verdict === 'approve').length;
const flagged = results.filter((r) => r.review?.overall_verdict === 'flag').length;
const errored = results.filter((r) => r.error).length;

console.log('');
console.log('='.repeat(70));
console.log(`SUMMARY: ${approved} approved, ${flagged} flagged, ${errored} errored (of ${CORRECTED.length})`);

for (const r of results) {
  if (r.review?.overall_verdict === 'flag') {
    console.log('');
    console.log(`STILL FLAGGED  ${r.content_key} / ${r.criterion_key}`);
    console.log(`  coverage: ${r.review.coverage_notes}`);
    for (const er of r.review.element_reviews) {
      if (!er.valid) {
        console.log(`  element ${er.index} INVALID: ${er.issue}`);
        console.log(`    was: "${r.elements[er.index]}"`);
        console.log(`    suggested: "${er.corrected_label}"`);
      }
    }
  }
}
