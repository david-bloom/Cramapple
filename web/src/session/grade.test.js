import test from 'node:test';
import assert from 'node:assert/strict';

import { gradeFrq, gradeMcq, criterionEarned } from './grade.js';
import frqSlope from '../content/sample/apstats-2-3-frq-001.js';
import frqResidual from '../content/sample/apstats-2-3-frq-002.js';
import mcqSlope from '../content/sample/apstats-2-3-mcq-001.js';

const CREDITED = 'For each additional hour studied per week, the predicted mean final exam score increases by 4.1 points.';
const PROMISE = 'Every extra hour of study will raise a score by 4.1 points on the final exam.';

test('the credited response earns every criterion', () => {
  const result = gradeFrq(frqSlope, CREDITED);
  assert.equal(result.earned, 4);
  assert.equal(result.total, 4);
  assert.equal(result.verdict, 'correct');
  assert.ok(result.marks.every((m) => m.state === 'earned'));
});

test('promising one student a score loses only the predicted-mean point', () => {
  const result = gradeFrq(frqSlope, PROMISE);
  assert.equal(result.earned, 3);
  assert.equal(result.verdict, 'incorrect');
  const revisited = result.marks.filter((m) => m.state === 'revisit').map((m) => m.criterion_key);
  assert.deepEqual(revisited, ['E3']);
});

test('a missed point is revisit, never taken', () => {
  const result = gradeFrq(frqSlope, PROMISE);
  assert.ok(result.marks.every((m) => m.state === 'earned' || m.state === 'revisit'));
  assert.ok(!result.marks.some((m) => m.state === 'taken'));
});

test('a causal verb disqualifies the predicted-mean point', () => {
  const e3 = frqSlope.criteria.find((c) => c.criterion_key === 'E3');
  assert.equal(
    criterionEarned(e3, 'Each extra hour causes the predicted mean final exam score to rise by 4.1 points.'),
    false
  );
});

test('a criterion with matchMode all needs every pattern', () => {
  const e1 = frqSlope.criteria.find((c) => c.criterion_key === 'E1');
  assert.equal(criterionEarned(e1, 'hours studied predicts the final exam score'), true);
  assert.equal(criterionEarned(e1, 'hours studied predicts y'), false);
  assert.equal(criterionEarned(e1, 'the final exam score rises'), false);
});

test('an empty response earns nothing and never throws', () => {
  const result = gradeFrq(frqSlope, '');
  assert.equal(result.earned, 0);
  assert.ok(result.coaching.includes('Fix:'));
});

test('coaching names one fix, not all of them', () => {
  const result = gradeFrq(frqSlope, '');
  const fixes = result.coaching.match(/Fix:/g) || [];
  assert.equal(fixes.length, 1);
});

test('the residual sign is required', () => {
  const r2 = frqResidual.criteria.find((c) => c.criterion_key === 'R2');
  assert.equal(criterionEarned(r2, 'the residual is 8.5'), false);
  assert.equal(criterionEarned(r2, 'the residual is -8.5 points'), true);
});

test('mcq scores the credited choice', () => {
  const result = gradeMcq(mcqSlope, 'B');
  assert.equal(result.earned, 1);
  assert.equal(result.verdict, 'correct');
});

test('mcq coaching names the trap the student walked into', () => {
  const result = gradeMcq(mcqSlope, 'C');
  assert.equal(result.earned, 0);
  assert.ok(result.coaching.startsWith('You picked C.'));
  assert.ok(result.coaching.includes('causal'));
  assert.ok(result.coaching.includes('Next time:'));
});

test('mcq marks the picked distractor as revisit, not taken', () => {
  const result = gradeMcq(mcqSlope, 'A');
  const picked = result.marks.find((m) => m.choice_key === 'A');
  assert.equal(picked.state, 'revisit');
  assert.equal(result.marks.find((m) => m.choice_key === 'B').state, 'earned');
});

test('no coaching string uses an exclamation mark or praise word', () => {
  const strings = [
    gradeFrq(frqSlope, CREDITED).coaching,
    gradeFrq(frqSlope, PROMISE).coaching,
    gradeMcq(mcqSlope, 'B').coaching,
    gradeMcq(mcqSlope, 'D').coaching
  ];
  for (const s of strings) {
    assert.ok(!s.includes('!'), `exclamation mark in: ${s}`);
    assert.ok(!/great job|well done|oops|nice work/i.test(s), `praise/judgement in: ${s}`);
  }
});
