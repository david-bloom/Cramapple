// Sample practice item — see apstats-2-3-frq-001.js for the provenance caveat.

export default {
  schema_version: '1.0.0',
  package_id: 'apstats-2-2-frq-001',
  item_type: 'frq',
  difficulty: 'Easy',

  taxonomy: {
    course: 'AP Statistics',
    unit: 'Unit 2',
    unit_title: 'Exploring Two-Variable Data',
    topic: '2.2',
    topic_title: 'Scatterplots & Correlation'
  },

  title: 'Describing a scatterplot',
  stem: [{ type: 'text', value: 'Describe the association between hours studied per week and final exam score for these 15 students.' }],

  stimulus: {
    kind: 'scatterplot',
    caption: 'Hours studied per week vs. final exam score',
    source: 'n = 15',
    xLabel: 'Hours studied per week',
    yLabel: 'Final exam score',
    label: 'Scatterplot of hours studied against final exam score, with one point away from the pattern',
    points: [
      [86, 150], [122, 146], [158, 132], [194, 134], [230, 118],
      [266, 112], [302, 108], [338, 96], [374, 88], [410, 84],
      [446, 70], [482, 66], [518, 54], [554, 48], [590, 40]
    ],
    highlight: { x: 566, y: 140, label: 'unusual' }
  },

  points: 4,
  scoringNote: 'This question is worth 4 points. Four things must be named, and the pane will not tell you which.',
  answerHint: 'Four named features, in context',

  criteria: [
    {
      criterion_key: 'D1',
      code: 'D1',
      label: 'Names the direction',
      detail: 'Positive — higher hours go with higher scores.',
      points: 1,
      match: ['positive', 'increas', 'upward', 'goes up', 'higher .{0,30}higher'],
      minimum_fix: 'Name the direction: positive.'
    },
    {
      criterion_key: 'D2',
      code: 'D2',
      label: 'Names the form',
      detail: 'Roughly linear.',
      points: 1,
      match: ['linear', 'straight[- ]line', 'a straight line'],
      minimum_fix: 'Name the form: roughly linear.'
    },
    {
      criterion_key: 'D3',
      code: 'D3',
      label: 'Names the strength',
      detail: 'Strong.',
      points: 1,
      match: ['strong', 'fairly strong', 'moderately strong'],
      disqualify: ['\\bweak\\b'],
      minimum_fix: 'Name the strength: strong.'
    },
    {
      criterion_key: 'D4',
      code: 'D4',
      label: 'Names the unusual point',
      detail: 'One student sits well below the pattern.',
      points: 1,
      match: ['unusual', 'outlier', 'influential', 'away from the pattern', 'off the pattern', 'departure'],
      minimum_fix: 'Say there is one unusual point sitting away from the pattern.'
    }
  ],

  creditedResponse: [
    { text: 'There is a strong', criterion: 'D3' },
    { text: 'positive', criterion: 'D1' },
    { text: 'linear', criterion: 'D2' },
    { text: 'association between hours studied per week and final exam score, with' },
    { text: 'one unusual point well below the pattern', criterion: 'D4' },
    { text: '.', literal: true }
  ],

  habits: {
    earned: ['Direction, form, strength — always all three.', 'Say it in the variables.', 'Point out what breaks the pattern.'],
    lost: ['Describing only the direction.', 'Quoting r instead of describing.', 'Ignoring the point off the line.']
  },

  hints: [
    {
      hint_key: 'rubric',
      kind: 'rubric',
      name: 'Show me the rubric',
      receipt: 'Rubric',
      cost: 'This names all four features you have to mention, and is listed on your feedback.'
    }
  ],

  reference: {
    topic: '2.2 Scatterplots & Correlation — describing the relationship between two quantitative variables.',
    skills: [
      '2.B — Describe form, direction and strength from a scatterplot.',
      '2.C — Identify unusual features in a bivariate display.',
      '4.B — Distinguish association from causation.'
    ],
    vocabulary: [
      { term: 'Form', definition: 'linear, curved, or no clear pattern.' },
      { term: 'Direction', definition: 'positive or negative.' },
      { term: 'Unusual feature', definition: 'a point, cluster or gap that departs from the overall pattern.' }
    ],
    onTheExam: 'Readers look for direction, form, strength and unusual features — in the variables, not as adjectives alone.'
  },

  deepDive: {
    title: 'The four-part description',
    sections: [
      { title: 'Why four', body: 'Direction, form, strength and unusual features are four separate claims about the plot, and readers mark them separately. Three of four is a common 3/4.' },
      { title: 'In context', body: '"Strong positive linear" on its own is a vocabulary recital. Name the variables and the sentence becomes a description of this study.' },
      { title: 'The point off the line', body: 'An unusual point changes what the line is worth. Saying it exists costs you one clause and earns the fourth point.' }
    ]
  },

  coaching: {
    allEarned: 'All four features named, in context. That is the full description move — reuse it on every scatterplot.',
    lead: 'The features you named are right.'
  }
};
