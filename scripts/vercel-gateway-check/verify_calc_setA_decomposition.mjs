// Blind independent review of the AP Calculus AB/BC Set A element decomposition
// drafted 2026-08-12 (Phase 0.5 of docs/research/GOLD_SET_GENERATION_PROTOCOL.md).
//
// Why this exists: the protocol requires a reader to "confirm or correct" an
// AI-drafted decomposition before it can be used to generate gold-set answers
// (§6) -- an unconfirmed/wrong decomposition corrupts every answer generated
// against it, identically and invisibly. The draft below was written by
// Claude (Anthropic). A human reader wasn't available in-session, so per
// owner direction this runs an INDEPENDENT MODEL FAMILY (Google Gemini) as a
// blind check in its place -- same spirit as the R1/R2 writer/verifier
// family-independence rules already used for gold-set generation itself,
// applied here to the decomposition step instead.
//
// The reviewer model sees ONLY the item stem/stimulus, the criterion text,
// and the drafted element list -- never who wrote it, never a hint that it's
// "probably fine". It is asked to independently judge each element for
// correctness/distinctness and whether the set jointly and non-redundantly
// covers the full criterion, exactly as a human reader would per protocol
// steps 4.1/4.2.
//
// This produces a REPORT, not a database write. A human (the repo owner)
// reviews the report and directs the actual `confirmed_by`/`confirmed_at`
// update against app.gold_set_elements.
//
// Run: node --env-file=.env.local verify_calc_setA_decomposition.mjs
// Requires AI_GATEWAY_API_KEY (Vercel AI Gateway) reachable from wherever
// this runs -- it was NOT reachable from the Claude Code remote session that
// wrote this script (egress policy blocks ai-gateway.vercel.sh there).

import { generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';

const REVIEWER_MODEL = process.env.GS_GOOGLE ?? 'google/gemini-2.5-flash';

const ITEMS = [
  {
    content_key: 'apcalcab-frq-001',
    stem: '(a) Find lim(x→2)g(x) and show the algebra used.\n\n(b) Choose k so that g is continuous at x=2 and justify the choice.\n\n(c) State whether g is differentiable at x=2 for this k and give g′(2).',
    stimulus: 'Define g(x)=(x²−4)/(x−2) for x≠2 and g(2)=k.',
    criteria: [
      {
        criterion_id: 'ceea2826-6d28-4e7e-a41e-a5e101565bc0',
        criterion_key: 'part-a-criterion-1',
        points_possible: 3,
        learner_facing_text: 'The limit is 4 after factoring x²−4=(x−2)(x+2).',
        elements: [
          'Factors the numerator: x^2-4=(x-2)(x+2).',
          'Cancels the common (x-2) factor, showing g(x)=x+2 for x!=2.',
          'Evaluates the simplified expression at x=2 to get the limit value 4.',
        ],
      },
      {
        criterion_id: '6e894385-2f65-41ea-a912-338b0e0ea8fb',
        criterion_key: 'part-b-criterion-1',
        points_possible: 3,
        learner_facing_text: 'k=4 because continuity requires the function value to equal the limit.',
        elements: [
          'States the continuity condition: g is continuous at x=2 iff g(2) equals lim(x->2)g(x).',
          'Uses the limit value found in part (a), 4, as the required value for g(2).',
          'Sets k=4 to satisfy the continuity condition.',
        ],
      },
      {
        criterion_id: '6fb2bdef-4a35-4750-a949-69f4c4b00790',
        criterion_key: 'part-c-criterion-1',
        points_possible: 3,
        learner_facing_text: 'Yes; the filled function equals x+2, so g′(2)=1.',
        elements: [
          "States that with k=4, the filled-in function equals x+2 for all x near 2 (the removable discontinuity is resolved).",
          'Concludes g is differentiable at x=2 because the filled-in function is a polynomial, differentiable everywhere.',
          "Computes g'(2)=1 (the derivative of x+2 is 1).",
        ],
      },
    ],
  },
  {
    content_key: 'apcalcab-frq-002',
    stem: '(a) Explain what the Intermediate Value Theorem guarantees about zeros on (0,2) and (2,5).\n\n(b) Can the given information establish exactly two zeros on [0,5]? Explain.\n\n(c) Give one additional condition that would make exactly one zero in each interval follow.',
    stimulus: 'A continuous function q satisfies q(0)=3, q(2)=−1, and q(5)=4.',
    criteria: [
      {
        criterion_id: 'bcae0e84-fe74-4da8-abf2-e3dfad42f7e6',
        criterion_key: 'part-a-criterion-1',
        points_possible: 3,
        learner_facing_text: 'There is at least one zero in each interval because the endpoint values change sign.',
        elements: [
          'States the Intermediate Value Theorem: for continuous q, if q(a) and q(b) have opposite signs, there is at least one c in (a,b) with q(c)=0.',
          'Applies IVT to (0,2): q(0)=3>0 and q(2)=-1<0, so there is at least one zero in (0,2).',
          'Applies IVT to (2,5): q(2)=-1<0 and q(5)=4>0, so there is at least one zero in (2,5).',
        ],
      },
      {
        criterion_id: '751f39b3-7658-4092-b842-1bdda783ab09',
        criterion_key: 'part-b-criterion-1',
        points_possible: 3,
        learner_facing_text: 'No; continuity guarantees existence but not uniqueness, so additional crossings are possible.',
        elements: [
          'States the answer is no -- the given information cannot establish exactly two zeros on [0,5].',
          'Explains that IVT guarantees existence of at least one zero per interval but says nothing about how many.',
          'Notes q could cross zero additional times within either interval without contradicting the given values, so exactly two total zeros is not guaranteed.',
        ],
      },
      {
        criterion_id: '92d17f26-d5a0-4348-8d5b-ec08c1af7d52',
        criterion_key: 'part-c-criterion-1',
        points_possible: 3,
        learner_facing_text: 'Strict monotonicity on each interval, with the stated sign changes, would give uniqueness.',
        elements: [
          'States the additional condition: q must be strictly monotonic (strictly increasing or strictly decreasing) on each of (0,2) and (2,5).',
          'Explains that strict monotonicity means q can cross zero at most once on that interval.',
          'Connects this to the given sign changes: combined with monotonicity, each interval would then have exactly one zero.',
        ],
      },
    ],
  },
  {
    content_key: 'apcalcab-frq-003',
    stem: '(a) Find the velocity and acceleration functions.\n\n(b) Find all times when the particle is at rest.\n\n(c) Determine whether the particle speeds up or slows down immediately after t=2.',
    stimulus: 'A particle moves on a line with position x(t)=t³−3t²+2 for 0≤t≤4, measured in meters.',
    criteria: [
      {
        criterion_id: 'b7765cb3-90cc-4161-a395-8178c5b695e1',
        criterion_key: 'part-a-criterion-1',
        points_possible: 3,
        learner_facing_text: 'v(t)=3t²−6t and a(t)=6t−6.',
        elements: [
          "Correctly identifies v(t)=x'(t) and computes v(t)=3t^2-6t.",
          "Correctly identifies a(t)=v'(t) and computes a(t)=6t-6.",
          'Shows correct application of the power rule term-by-term when differentiating x(t) and then v(t).',
        ],
      },
      {
        criterion_id: 'e6e5f67b-2792-4634-8389-7b3ff6055860',
        criterion_key: 'part-b-criterion-1',
        points_possible: 3,
        learner_facing_text: 'The particle is at rest at t=0 and t=2.',
        elements: [
          'Sets v(t)=0: 3t^2-6t=0.',
          'Factors: 3t(t-2)=0, giving t=0 and t=2.',
          'Confirms both t=0 and t=2 lie within the given domain [0,4], so both are valid times when the particle is at rest.',
        ],
      },
      {
        criterion_id: 'a1659944-ffe3-4718-b27f-88b52e4d7043',
        criterion_key: 'part-c-criterion-1',
        points_possible: 3,
        learner_facing_text: 'Immediately after 2, v>0 and a>0, so the particle speeds up.',
        elements: [
          'Evaluates the sign of v(t) immediately after t=2 (v>0, since v(t)=3t(t-2)>0 for t slightly greater than 2).',
          'Evaluates the sign of a(t) immediately after t=2 (a(2)=6(2)-6=6>0).',
          'Applies the speeding-up rule: velocity and acceleration have the same sign, so the particle is speeding up.',
        ],
      },
    ],
  },
  {
    content_key: 'apcalcab-frq-008',
    stem: '(a) Write an expression for the net change in water volume from t=0 to t=6.\n\n(b) Evaluate the net change.\n\n(c) At what times is the water volume increasing?',
    stimulus: 'Water enters a tank at R(t)=12+3sin(t/2) liters per minute and leaves at 10 liters per minute, where 0≤t≤6.',
    criteria: [
      {
        criterion_id: '044fd09d-f20b-44e0-99d4-21ff573d2ba6',
        criterion_key: 'part-a-criterion-1',
        points_possible: 3,
        learner_facing_text: 'The net change is ∫[0 to 6](2+3sin(t/2))dt.',
        elements: [
          'Identifies the net rate of change in volume as inflow minus outflow: R(t)-10 = (12+3sin(t/2))-10 = 2+3sin(t/2).',
          'States that net change in volume equals the definite integral of the net rate over the time interval.',
          'Sets up the definite integral with correct bounds t=0 to t=6: the integral of (2+3sin(t/2)) dt from 0 to 6.',
        ],
      },
      {
        criterion_id: '0155b2fb-0add-4a45-bc83-025ca94f099c',
        criterion_key: 'part-b-criterion-1',
        points_possible: 3,
        learner_facing_text: 'The net change is 12+6(1−cos 3) liters, approximately 23.94 liters.',
        elements: [
          'Finds the antiderivative of 2+3sin(t/2): 2t-6cos(t/2), using substitution/chain rule for the sine term.',
          'Evaluates the antiderivative at the bounds t=6 and t=0 and subtracts, per the Fundamental Theorem of Calculus.',
          'Simplifies to the numeric value: 12+6(1-cos 3) liters, approximately 23.94 liters.',
        ],
      },
      {
        criterion_id: '473e5083-9a0b-46cb-859d-ab60a869dd5f',
        criterion_key: 'part-c-criterion-1',
        points_possible: 3,
        learner_facing_text: 'It is increasing throughout 0≤t≤6 because 2+3sin(t/2)>0 on this interval.',
        elements: [
          'States that volume is increasing exactly when the net rate 2+3sin(t/2) is positive.',
          'Analyzes the sign of 2+3sin(t/2) on [0,6]: sin(t/2) stays above about -0.28 on this interval, so 2+3sin(t/2) stays positive throughout.',
          'Concludes the volume is increasing for the entire interval 0<=t<=6.',
        ],
      },
    ],
  },
  {
    content_key: 'apcalcab-frq-011',
    stem: '(a) Find F′(x) and F″(x).\n\n(b) Find the intervals on which F is increasing.\n\n(c) Find the x-coordinate where F changes concavity.',
    stimulus: 'Define F(x)=∫[0 to x](3t²−4t+1)dt.',
    criteria: [
      {
        criterion_id: 'e1029100-0650-4b87-8747-71c6402beed3',
        criterion_key: 'part-a-criterion-1',
        points_possible: 3,
        learner_facing_text: "F′(x)=3x²−4x+1 and F″(x)=6x−4.",
        elements: [
          "Applies the Fundamental Theorem of Calculus (Part 1) to get F'(x)=3x^2-4x+1 directly from the integrand.",
          "Differentiates F'(x) to find F''(x)=6x-4.",
          "Shows correct application of the power rule when differentiating F'(x) term by term.",
        ],
      },
      {
        criterion_id: '8879a456-c5a2-42b6-a8e9-bbb56c32c920',
        criterion_key: 'part-b-criterion-1',
        points_possible: 3,
        learner_facing_text: 'F is increasing for x<1/3 or x>1.',
        elements: [
          "Sets F'(x)=0: 3x^2-4x+1=0, and solves (factors as (3x-1)(x-1)=0) to get critical points x=1/3 and x=1.",
          "Tests the sign of F'(x) in each interval determined by the critical points (x<1/3, 1/3<x<1, x>1).",
          "Concludes F is increasing where F'(x)>0: x<1/3 or x>1.",
        ],
      },
      {
        criterion_id: 'd93a8f10-f91c-4b5d-8dd9-f88b53d15066',
        criterion_key: 'part-c-criterion-1',
        points_possible: 3,
        learner_facing_text: 'F changes concavity at x=2/3.',
        elements: [
          "Sets F''(x)=0: 6x-4=0, solving for x=2/3.",
          "Verifies F''(x) changes sign at x=2/3 (negative for x<2/3, positive for x>2/3).",
          "Concludes this sign change in F'' confirms x=2/3 is where F changes concavity (an inflection point).",
        ],
      },
    ],
  },
  {
    content_key: 'apcalcbc-frq-002',
    stem: '(a) Use logarithmic differentiation to find y′.\n\n(b) Find the critical point of y and classify it.\n\n(c) Find the minimum value.',
    stimulus: 'For x>0 define y=x^x.',
    criteria: [
      {
        criterion_id: '32e1b4b2-d773-482a-b17e-78cd07969f74',
        criterion_key: 'part-a-criterion-1',
        points_possible: 3,
        learner_facing_text: "y′=x^x(ln x+1).",
        elements: [
          'Takes the natural log of both sides: ln y = x ln x.',
          "Differentiates implicitly using the product rule on x ln x: y'/y = ln x + 1.",
          "Solves for y' and substitutes y=x^x back in: y'=x^x(ln x+1).",
        ],
      },
      {
        criterion_id: '8674e5ca-d6e0-47b3-a51b-28531e048010',
        criterion_key: 'part-b-criterion-1',
        points_possible: 3,
        learner_facing_text: 'The critical point is x=e^(−1), and it is a minimum.',
        elements: [
          "Sets y'=0: since x^x>0 for x>0, solves ln x+1=0, giving x=e^(-1).",
          "Tests the sign of y' on either side of x=e^(-1) (negative for x<e^(-1), positive for x>e^(-1)), or applies the second derivative test.",
          'Concludes x=e^(-1) is a local minimum based on the sign change or second-derivative test result.',
        ],
      },
      {
        criterion_id: '056febde-158f-4ba8-94a2-3da70aac888c',
        criterion_key: 'part-c-criterion-1',
        points_possible: 3,
        learner_facing_text: 'The minimum value is e^(−1/e).',
        elements: [
          'Substitutes x=e^(-1) into y=x^x to evaluate the minimum value.',
          'Simplifies (e^(-1))^(e^(-1)) using exponent rules.',
          'States the final minimum value as e^(-1/e).',
        ],
      },
    ],
  },
  {
    content_key: 'apcalcbc-frq-003',
    stem: '(a) Find dy/dx in terms of x and y.\n\n(b) Find the slope at (0,0).\n\n(c) Find d²y/dx² at (0,0).',
    stimulus: 'A curve is defined implicitly by e^(xy)+x²−y=1 near (0,0).',
    criteria: [
      {
        criterion_id: '67e26238-804b-43cc-82cb-489d46ca4624',
        criterion_key: 'part-a-criterion-1',
        points_possible: 3,
        learner_facing_text: "y′=−(y e^(xy)+2x)/(x e^(xy)−1).",
        elements: [
          "Differentiates e^(xy) implicitly, applying the chain and product rule: d/dx[e^(xy)] = e^(xy)(y+xy').",
          "Differentiates the remaining terms (d/dx[x^2]=2x, d/dx[-y]=-y', d/dx[1]=0) and assembles the full implicit-differentiation equation.",
          "Solves algebraically for y', collecting y' terms to get y'=-(y e^(xy)+2x)/(x e^(xy)-1).",
        ],
      },
      {
        criterion_id: '431ee4a1-c510-4702-966d-756f013daf2a',
        criterion_key: 'part-b-criterion-1',
        points_possible: 3,
        learner_facing_text: 'The slope is 0.',
        elements: [
          "Substitutes the point (0,0) into the y' expression from part (a).",
          'Evaluates e^(xy) at (0,0), which equals e^0=1.',
          'Simplifies the resulting expression to get slope = 0.',
        ],
      },
      {
        criterion_id: '57e9f143-864c-4e18-80d4-e2ff046c3a4f',
        criterion_key: 'part-c-criterion-1',
        points_possible: 3,
        learner_facing_text: 'Differentiating again or using a local expansion gives y″(0)=2.',
        elements: [
          "Sets up differentiating the y' expression (or the original implicit equation) a second time with respect to x to find y''.",
          "Substitutes the known values x=0, y=0, and y'=0 (from parts a/b) into the resulting expression.",
          "Simplifies to obtain y''(0)=2.",
        ],
      },
    ],
  },
  {
    content_key: 'apcalcbc-frq-004',
    stem: '(a) Find the time when the velocity is greatest.\n\n(b) Find the distance traveled from t=0 to t=4.\n\n(c) Explain why displacement and distance are equal on this interval.',
    stimulus: "A drone's horizontal velocity is v(t)=6te^(−t/2) meters per second for t≥0.",
    criteria: [
      {
        criterion_id: 'e4e6bfe2-895c-40b3-8799-475e4146b1c2',
        criterion_key: 'part-a-criterion-1',
        points_possible: 3,
        learner_facing_text: "v′(t)=6e^(−t/2)(1−t/2), so the maximum occurs at t=2 seconds.",
        elements: [
          "Differentiates v(t)=6te^(-t/2) using the product rule to get v'(t)=6e^(-t/2)(1-t/2).",
          "Sets v'(t)=0 and solves: since 6e^(-t/2)>0 always, solves 1-t/2=0, giving t=2.",
          "Confirms t=2 gives a maximum (e.g., via sign change of v' or the first-derivative test) rather than a minimum.",
        ],
      },
      {
        criterion_id: 'ed674ead-caac-450a-bb74-558e676fe035',
        criterion_key: 'part-b-criterion-1',
        points_possible: 3,
        learner_facing_text: 'The distance is ∫[0 to 4]6te^(−t/2)dt=24−72e^(−2) meters.',
        elements: [
          'States that distance traveled equals the definite integral of velocity when velocity does not change sign: the integral of 6te^(-t/2) dt from 0 to 4.',
          'Evaluates the integral using integration by parts (u=6t, dv=e^(-t/2)dt), finding the antiderivative.',
          'Applies the Fundamental Theorem of Calculus with bounds 0 and 4, simplifying to 24-72e^(-2) meters.',
        ],
      },
      {
        criterion_id: 'a8686d21-c3fd-4618-a678-fb5d3a395b40',
        criterion_key: 'part-c-criterion-1',
        points_possible: 3,
        learner_facing_text: 'v(t)≥0 on [0,4], so the drone never reverses horizontal direction.',
        elements: [
          'States the condition for displacement to equal distance: velocity must not change sign over the interval.',
          'Observes that v(t)=6te^(-t/2)>=0 for all t>=0, since both factors (6t and e^(-t/2)) are nonnegative on [0,4].',
          'Concludes that because v(t) never goes negative, the drone never reverses direction, so displacement equals distance on [0,4].',
        ],
      },
    ],
  },
  {
    content_key: 'apcalcbc-frq-005',
    stem: '(a) Find and classify all critical numbers.\n\n(b) Find the intervals where f is increasing.\n\n(c) Determine the concavity of f at x=1.',
    stimulus: 'A function f has f′(x)=x(x−2)³.',
    criteria: [
      {
        criterion_id: 'b9df69ba-cbe0-4823-962f-89c308f03faf',
        criterion_key: 'part-a-criterion-1',
        points_possible: 3,
        learner_facing_text: 'x=0 is a local maximum and x=2 is a local minimum.',
        elements: [
          "Sets f'(x)=0: x(x-2)^3=0, giving critical numbers x=0 and x=2.",
          "Determines the sign of f'(x) on each of the three intervals formed by the critical numbers (x<0, 0<x<2, x>2).",
          "Classifies each critical point using the sign changes: x=0 is a local max (f' changes + to -) and x=2 is a local min (f' changes - to +).",
        ],
      },
      {
        criterion_id: 'c98e5f01-7e55-4944-b207-554b84e83613',
        criterion_key: 'part-b-criterion-1',
        points_possible: 3,
        learner_facing_text: 'f is increasing on (−∞,0) and (2,∞).',
        elements: [
          "Reuses the sign analysis of f'(x): f'(x)>0 on (-infinity,0) and on (2,infinity).",
          "Confirms f'(x)<0 on (0,2), so f is decreasing there.",
          "States the increasing intervals as (-infinity,0) and (2,infinity), based on where f'(x)>0.",
        ],
      },
      {
        criterion_id: 'c319fe8d-fe3b-47da-9b88-f5e5ee347ba7',
        criterion_key: 'part-c-criterion-1',
        points_possible: 3,
        learner_facing_text: 'f″(1)=2>0, so f is concave up at x=1.',
        elements: [
          "Differentiates f'(x)=x(x-2)^3 using the product rule to find f''(x).",
          "Evaluates f''(x) at x=1.",
          "Concludes f is concave up at x=1 since f''(1)=2>0.",
        ],
      },
    ],
  },
  {
    content_key: 'apcalcbc-frq-007',
    stem: '(a) Evaluate ∫x²e^x dx.\n\n(b) Evaluate ∫1/(x²−4) dx.\n\n(c) Evaluate ∫[0 to 1]x/√(1−x²) dx.',
    stimulus: 'Evaluate three integrals and show the method selected.',
    criteria: [
      {
        criterion_id: 'acc4b183-9507-400a-9258-80a30e369384',
        criterion_key: 'part-a-criterion-1',
        points_possible: 3,
        learner_facing_text: 'The antiderivative is e^x(x²−2x+2)+C by repeated integration by parts.',
        elements: [
          'Sets up integration by parts with u=x^2, dv=e^x dx, performing the first pass to reduce the integral to the integral of xe^x dx.',
          'Applies integration by parts a second time to the remaining integral of xe^x dx.',
          'Combines the results and simplifies to the final antiderivative e^x(x^2-2x+2)+C.',
        ],
      },
      {
        criterion_id: 'f667096c-5589-44cc-a275-9038deaa6797',
        criterion_key: 'part-b-criterion-1',
        points_possible: 3,
        learner_facing_text: 'The antiderivative is (1/4)ln|(x−2)/(x+2)|+C.',
        elements: [
          'Sets up partial fraction decomposition of 1/(x^2-4)=1/[(x-2)(x+2)] into A/(x-2)+B/(x+2).',
          'Solves for the constants A and B (A=1/4, B=-1/4).',
          'Integrates each partial fraction term and combines into (1/4)ln|(x-2)/(x+2)|+C.',
        ],
      },
      {
        criterion_id: '651f58a8-9fad-4090-a55d-2afce9d6dc8a',
        criterion_key: 'part-c-criterion-1',
        points_possible: 3,
        learner_facing_text: 'The improper endpoint integral equals 1 using u=1−x².',
        elements: [
          'Recognizes the integral is improper (the integrand is undefined at x=1) and sets it up as a limit.',
          'Uses the substitution u=1-x^2 (du=-2x dx) to rewrite the integral in terms of u.',
          'Evaluates the limit of the resulting expression as the upper bound approaches 1, obtaining the value 1.',
        ],
      },
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
    try { return await fn(); } catch (err) {
      lastErr = err;
      await new Promise((r) => setTimeout(r, 800 * (i + 1)));
    }
  }
  throw lastErr;
}

const results = [];
let approvedCount = 0;
let flaggedCount = 0;

console.log(`Blind decomposition review via ${REVIEWER_MODEL}`);
console.log(`${ITEMS.reduce((n, it) => n + it.criteria.length, 0)} criteria across ${ITEMS.length} items\n`);

for (const item of ITEMS) {
  for (const criterion of item.criteria) {
    process.stdout.write(`${item.content_key} / ${criterion.criterion_key} ... `);
    try {
      const { object } = await withRetry(() => generateObject({
        model: REVIEWER_MODEL,
        schema: REVIEW_SCHEMA,
        prompt: reviewPrompt(item, criterion),
        temperature: 0.1,
      }));
      results.push({
        content_key: item.content_key,
        criterion_id: criterion.criterion_id,
        criterion_key: criterion.criterion_key,
        points_possible: criterion.points_possible,
        learner_facing_text: criterion.learner_facing_text,
        drafted_elements: criterion.elements,
        review: object,
      });
      if (object.overall_verdict === 'approve') approvedCount++; else flaggedCount++;
      console.log(object.overall_verdict.toUpperCase());
    } catch (err) {
      console.log('ERROR');
      results.push({
        content_key: item.content_key,
        criterion_id: criterion.criterion_id,
        criterion_key: criterion.criterion_key,
        error: err.message ?? String(err),
      });
    }
  }
}

const outPath = 'calc_setA_decomposition_review.json';
fs.writeFileSync(outPath, JSON.stringify(results, null, 2) + '\n');

console.log(`\n${'='.repeat(70)}`);
console.log(`SUMMARY: ${approvedCount} approved, ${flaggedCount} flagged, ${results.length - approvedCount - flaggedCount} errored (of ${results.length} criteria)`);
console.log(`Full results written to ${outPath}\n`);

for (const r of results) {
  if (r.error) {
    console.log(`ERROR  ${r.content_key} / ${r.criterion_key}: ${r.error}`);
    continue;
  }
  if (r.review.overall_verdict === 'flag') {
    console.log(`FLAGGED  ${r.content_key} / ${r.criterion_key}`);
    console.log(`  criterion: ${r.learner_facing_text}`);
    if (!r.review.coverage_complete) console.log(`  coverage: ${r.review.coverage_notes}`);
    for (const er of r.review.element_reviews) {
      if (!er.valid) {
        console.log(`  element ${er.index} INVALID: ${er.issue}`);
        console.log(`    was: "${r.drafted_elements[er.index]}"`);
        console.log(`    suggested: "${er.corrected_label}"`);
      }
    }
    console.log('');
  }
}

console.log('Next step: share this console output (or calc_setA_decomposition_review.json)');
console.log('back with the session that drafted the decomposition. Approved criteria get');
console.log('confirmed_by/confirmed_at set on app.gold_set_elements; flagged criteria get');
console.log('corrected and re-reviewed before confirmation.');
