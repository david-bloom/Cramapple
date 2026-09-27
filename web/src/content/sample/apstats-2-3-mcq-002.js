// Sample practice item — see apstats-2-3-frq-001.js for the provenance caveat.

export default {
  schema_version: '1.0.0',
  package_id: 'apstats-2-3-mcq-002',
  item_type: 'mcq',
  difficulty: 'Medium',

  taxonomy: {
    course: 'AP Statistics',
    unit: 'Unit 2',
    unit_title: 'Exploring Two-Variable Data',
    topic: '2.3',
    topic_title: 'Least-Squares Regression'
  },

  title: 'Reading an intercept',
  stem: [
    { type: 'text', value: 'For the same study, the least-squares line is ' },
    { type: 'math', value: 'ŷ = 42.6 + 4.1x' },
    { type: 'text', value: ', where x is hours studied per week. Every student in the sample studied between 3 and 14 hours. Which statement about the intercept is defensible?' }
  ],

  points: 1,
  scoringNote: 'One point. One submission. The key stays closed until you commit.',

  choices: [
    {
      choice_key: 'A',
      text: 'A student who does not study will score 42.6 on the final.',
      is_correct: false,
      rationale: 'Two errors at once: it promises one student a result, and it predicts at x = 0, outside the observed 3-to-14-hour range.',
      minimum_fix: 'Do not predict outside the data, and keep the response a predicted mean.'
    },
    {
      choice_key: 'B',
      text: 'The intercept has no reliable interpretation here, because x = 0 lies outside the observed range of hours studied.',
      is_correct: true,
      rationale: 'Names the reason — extrapolation — rather than reciting a definition. The line is only evidence across the range that produced it.',
      minimum_fix: null
    },
    {
      choice_key: 'C',
      text: 'The intercept is meaningless because a score of 42.6 is impossible.',
      is_correct: false,
      rationale: 'The stated reason is wrong. 42.6 is a perfectly possible exam score; the problem is the x-value, not the y-value.',
      minimum_fix: 'Test the x-value against the observed range, not the y-value against plausibility.'
    },
    {
      choice_key: 'D',
      text: 'The predicted mean final exam score at zero hours studied is 42.6 points.',
      is_correct: false,
      rationale: 'The wording is careful, which is what makes it tempting — but careful wording does not license a prediction at an x the data never observed.',
      minimum_fix: 'Correct phrasing is not enough. Check the range before you interpret the intercept.'
    }
  ],

  habits: {
    earned: ['Check the observed range of x first.', 'Name extrapolation when you see it.', 'Give the reason, not the verdict.'],
    lost: ['Interpreting an intercept by reflex.', 'Rejecting a value for the wrong reason.', 'Trusting careful wording over the data.']
  },

  hints: [
    {
      hint_key: 'eliminate',
      kind: 'eliminate',
      name: 'Rule out two choices',
      receipt: 'Rule out two choices',
      cost: 'This strikes out two distractors and is listed on your feedback.',
      eliminates: ['A', 'C'],
      body: 'A and C are struck out in the question pane. Two remain — and both are worded carefully, so decide on the range, not the phrasing.'
    }
  ],

  reference: {
    topic: '2.3 Least-Squares Regression — using a fitted line to predict a quantitative response.',
    skills: [
      '2.D — Interpret slope and intercept in context.',
      '2.C — Identify when a prediction requires extrapolation.',
      '4.B — Distinguish association from causation.'
    ],
    vocabulary: [
      { term: 'Intercept', definition: 'ŷ when x = 0 — interpretable only when x = 0 sits inside the observed data.' },
      { term: 'Extrapolation', definition: 'predicting outside the range of x the line was fitted on.' },
      { term: 'Observed range', definition: 'the smallest to largest x actually in the sample; here 3 to 14 hours.' }
    ],
    onTheExam: 'Readers accept "no reliable interpretation" only when you say why — name the range.'
  },

  openHandNote: 'Nothing is scored here. Two of these four are worded correctly and still wrong, which is the point.',

  deepDive: {
    title: 'When an intercept means nothing',
    sections: [
      { title: 'The rule', body: 'A least-squares line is evidence only across the x-values that produced it. At x = 0 with data from 3 to 14 hours, the line is an extension of a pattern, not a summary of one.' },
      { title: 'The trap', body: 'Option D says "predicted mean" and is still wrong. Careful phrasing protects you from the slope trap, not from the range trap — they are two different checks.' },
      { title: 'The habit', body: 'Before you interpret an intercept, ask one question: is x = 0 inside the data? If not, say so and name the range. That sentence is the credited answer.' }
    ]
  },

  coaching: {
    correct: 'Right, and you gave the reason rather than the verdict — x = 0 is outside the 3-to-14-hour range. That "because" is what earns the point.',
    incorrectTail: 'Next time: check whether x = 0 is inside the observed range before you read the intercept at all.'
  }
};
