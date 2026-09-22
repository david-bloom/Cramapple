// Sample practice item. Written by hand for the design system's Unit 2 walkthrough;
// NOT produced by the authoring pipeline in prompts/ and not fact-pack sourced.
// Replace with a real content/item-packages/ package before this ships to students.

export default {
  schema_version: '1.0.0',
  package_id: 'apstats-2-3-frq-001',
  item_type: 'frq',
  difficulty: 'Medium',

  taxonomy: {
    course: 'AP Statistics',
    unit: 'Unit 2',
    unit_title: 'Exploring Two-Variable Data',
    topic: '2.3',
    topic_title: 'Least-Squares Regression'
  },

  title: 'Interpreting slope',
  stem: [
    { type: 'text', value: 'The least-squares line for predicting final exam score from hours studied per week is ' },
    { type: 'math', value: 'ŷ = 42.6 + 4.1x' },
    { type: 'text', value: '. Interpret the slope in the context of this study.' }
  ],

  stimulus: {
    kind: 'scatterplot',
    caption: 'Hours studied per week vs. final exam score',
    source: 'n = 15',
    xLabel: 'Hours studied per week',
    yLabel: 'Final exam score',
    label: 'Scatterplot of hours studied against final exam score',
    points: [
      [86, 150], [122, 146], [158, 132], [194, 134], [230, 118],
      [266, 112], [302, 108], [338, 96], [374, 88], [410, 84],
      [446, 70], [482, 66], [518, 54], [554, 48], [590, 40]
    ],
    fitLine: [[70, 156], [600, 34]],
    highlight: { x: 566, y: 140, label: 'influence' }
  },

  points: 4,
  scoringNote: 'This question is worth 4 points. You can answer without seeing how they are split.',
  answerHint: 'Aim for one sentence, four moves',

  criteria: [
    {
      criterion_key: 'E1',
      code: 'E1',
      label: 'Names both variables',
      detail: 'Hours studied predicts final exam score.',
      points: 1,
      // Both variables must appear. "hours studied" and "an extra hour of study"
      // are the same claim, so the explanatory side matches on the quantity.
      match: ['\\bhours?\\b', 'exam score|final exam|final score'],
      matchMode: 'all',
      minimum_fix: 'Name both variables — hours studied and final exam score — not just "x" and "y".'
    },
    {
      criterion_key: 'E2',
      code: 'E2',
      label: 'Reads the slope as a rate',
      detail: 'Per one additional hour studied.',
      points: 1,
      match: [
        'for (each|every)\\s+(additional|extra|one more|1 more)?\\s*hour',
        '(per|each|every)\\s+(additional |extra |one more )?hour',
        'one[- ]unit increase', 'increase of (one|1) hour'
      ],
      minimum_fix: 'Say the slope is per one additional hour studied, not a total.'
    },
    {
      criterion_key: 'E3',
      code: 'E3',
      label: 'Says predicted mean, not actual',
      detail: 'The line predicts an average, not one student.',
      points: 1,
      match: ['predicted mean', 'mean predicted', 'predicted average', 'average predicted', 'mean .{0,24}predicted'],
      disqualify: [
        'will (score|raise|get|earn|rise|increase)',
        '\\bcause[ds]?\\b', 'causing',
        'students who study .{0,40}\\bscore\\b'
      ],
      minimum_fix: 'Write "the predicted mean final exam score" — the line predicts an average, not one student\'s result.'
    },
    {
      criterion_key: 'E4',
      code: 'E4',
      label: 'States the units',
      detail: '4.1 points on the final exam.',
      points: 1,
      match: ['4\\.1\\s*points?'],
      minimum_fix: 'Carry the units: 4.1 points on the final exam, not just 4.1.'
    }
  ],

  // Each segment of the credited response is carrying one rubric point. Open Hand
  // strikes the segment through when its point is taken back.
  creditedResponse: [
    { text: 'For each additional hour studied per week,', criterion: 'E2' },
    { text: 'the predicted mean', criterion: 'E3' },
    { text: 'final exam score', criterion: 'E1' },
    { text: 'increases by 4.1' },
    { text: 'points', criterion: 'E4' },
    { text: '.', literal: true }
  ],

  habits: {
    earned: ['Name both variables.', 'Read the slope as a rate.', 'Say predicted mean.'],
    lost: ['Promising one student a score.', 'Writing cause instead of prediction.', 'Dropping the units.']
  },

  hints: [
    {
      hint_key: 'rubric',
      kind: 'rubric',
      name: 'Show me the rubric',
      receipt: 'Rubric',
      cost: 'This reveals all four scoring criteria before you write, and is listed on your feedback.'
    }
  ],

  reference: {
    topic: '2.3 Least-Squares Regression — using a fitted line to predict a quantitative response.',
    skills: [
      '2.D — Interpret slope and intercept in context.',
      '2.B — Describe form, direction and strength from a scatterplot.',
      '4.B — Distinguish association from causation.'
    ],
    vocabulary: [
      { term: 'Slope', definition: 'change in the predicted mean response per one-unit change in x.' },
      { term: 'Predicted value', definition: 'ŷ, the line\'s estimate, never an individual\'s actual score.' },
      { term: 'Explanatory variable', definition: 'x, here hours studied.' }
    ],
    onTheExam: 'Formula sheet gives ŷ = a + bx and b = r(sy/sx). Context is not on the sheet — you supply it.'
  },

  deepDive: {
    title: 'Why slope is a mean, not a promise',
    sections: [
      { title: 'The claim', body: 'A slope of 4.1 says that among students like these, the predicted mean final exam score is 4.1 points higher for each additional hour studied per week. It is a statement about the line, not about any one student.' },
      { title: 'The trap', body: '“Will score 4.1 points higher” promises an individual an outcome. The regression line has no individuals in it — the residuals hold everything it missed, and for a single student that gap is often larger than the slope.' },
      { title: 'The habit', body: 'Write it in four moves: per one extra hour (rate), the predicted mean final exam score (response, as a mean), increases by 4.1 (magnitude), points (units). Four moves, four rubric points.' }
    ]
  },

  coaching: {
    allEarned: 'All four moves are there — rate, response as a predicted mean, magnitude, units. Write it the same way every time and this rubric stops costing you points.',
    lead: 'The moves you have are solid.'
  }
};
