// Sample practice item — see apstats-2-3-frq-001.js for the provenance caveat.

export default {
  schema_version: '1.0.0',
  package_id: 'apstats-2-3-frq-002',
  item_type: 'frq',
  difficulty: 'Hard',

  taxonomy: {
    course: 'AP Statistics',
    unit: 'Unit 2',
    unit_title: 'Exploring Two-Variable Data',
    topic: '2.3',
    topic_title: 'Least-Squares Regression'
  },

  title: 'Using a residual',
  stem: [
    { type: 'text', value: 'One student studied 9 hours per week and scored 71 on the final. The least-squares line is ' },
    { type: 'math', value: 'ŷ = 42.6 + 4.1x' },
    { type: 'text', value: '. Find this student\'s residual and say what it means for this student.' }
  ],

  points: 3,
  scoringNote: 'This question is worth 3 points. One is arithmetic; two are the sentence around it.',
  answerHint: 'Predicted value, residual, then what it means',

  criteria: [
    {
      criterion_key: 'R1',
      code: 'R1',
      label: 'Computes the predicted value',
      detail: 'ŷ = 42.6 + 4.1(9) = 79.5.',
      points: 1,
      match: ['79\\.5', '79,5'],
      minimum_fix: 'Substitute x = 9 into the line: 42.6 + 4.1(9) = 79.5.'
    },
    {
      criterion_key: 'R2',
      code: 'R2',
      label: 'Subtracts in the right order',
      detail: 'Residual = actual − predicted = 71 − 79.5 = −8.5.',
      points: 1,
      // The sign is the point. A bare "8.5" does not match, which is correct.
      match: ['-\\s?8\\.5', '−\\s?8\\.5', 'negative 8\\.5'],
      minimum_fix: 'Residual is actual minus predicted: 71 − 79.5 = −8.5, and the sign is part of the answer.'
    },
    {
      criterion_key: 'R3',
      code: 'R3',
      label: 'Says what it means for this student',
      detail: 'They scored 8.5 points below what the line predicted for 9 hours.',
      points: 1,
      match: ['below', 'less than predicted', 'lower than predicted', 'overpredict'],
      disqualify: ['\\babove\\b', 'higher than predicted'],
      minimum_fix: 'Say the direction in context: this student scored 8.5 points below the line\'s prediction.'
    }
  ],

  creditedResponse: [
    { text: 'The predicted score is 42.6 + 4.1(9) = 79.5,', criterion: 'R1' },
    { text: 'so the residual is 71 − 79.5 = −8.5' },
    { text: 'points', criterion: 'R2' },
    { text: '— this student scored 8.5 points below what the line predicted for 9 hours of study', criterion: 'R3' },
    { text: '.', literal: true }
  ],

  habits: {
    earned: ['Predict first, then subtract.', 'Keep the sign.', 'Say below or above, in context.'],
    lost: ['Subtracting predicted minus actual.', 'Reporting a bare number.', 'Dropping the units.']
  },

  hints: [
    {
      hint_key: 'rubric',
      kind: 'rubric',
      name: 'Show me the rubric',
      receipt: 'Rubric',
      cost: 'This reveals all three scoring criteria before you write, and is listed on your feedback.'
    }
  ],

  reference: {
    topic: '2.3 Least-Squares Regression — residuals measure what the line missed.',
    skills: [
      '2.D — Interpret slope, intercept and residuals in context.',
      '2.C — Compute a predicted value from a fitted line.',
      '1.E — Report a signed quantity with its units.'
    ],
    vocabulary: [
      { term: 'Residual', definition: 'actual − predicted, for one observation.' },
      { term: 'Negative residual', definition: 'the line overpredicted; the observation sits below the line.' },
      { term: 'Predicted value', definition: 'ŷ at that observation\'s x.' }
    ],
    onTheExam: 'Formula sheet does not give residual = actual − predicted. Memorise the order.'
  },

  deepDive: {
    title: 'The sign is the answer',
    sections: [
      { title: 'The order', body: 'Residual = actual − predicted, always. Reversing it gives the right magnitude with the wrong meaning, and readers mark the meaning.' },
      { title: 'What negative means', body: 'A negative residual says the line overpredicted this observation — the student sits below the line. That is a statement about one student, which is exactly what slope is not.' },
      { title: 'The habit', body: 'Three moves, three points: compute ŷ, subtract in order, then say below or above in the variables. The arithmetic is the cheapest of the three.' }
    ]
  },

  coaching: {
    allEarned: 'Predicted value, signed residual, and the meaning in context — all three. The sign is the part most students drop.',
    lead: 'The parts you have are correct.'
  }
};
