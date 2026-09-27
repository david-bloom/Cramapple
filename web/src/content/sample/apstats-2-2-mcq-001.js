// Sample practice item — see apstats-2-3-frq-001.js for the provenance caveat.

export default {
  schema_version: '1.0.0',
  package_id: 'apstats-2-2-mcq-001',
  item_type: 'mcq',
  difficulty: 'Easy',

  taxonomy: {
    course: 'AP Statistics',
    unit: 'Unit 2',
    unit_title: 'Exploring Two-Variable Data',
    topic: '2.2',
    topic_title: 'Scatterplots & Correlation'
  },

  title: 'Reading a correlation',
  stem: [
    { type: 'text', value: 'For 15 students, the correlation between hours studied per week and final exam score is ' },
    { type: 'math', value: 'r = 0.83' },
    { type: 'text', value: '. Which statement is supported?' }
  ],

  points: 1,
  scoringNote: 'One point. One submission. The key stays closed until you commit.',

  choices: [
    {
      choice_key: 'A',
      text: '83% of the variation in final exam score is explained by hours studied.',
      is_correct: false,
      rationale: 'That figure is r², not r. Here r² is about 0.69, so roughly 69%.',
      minimum_fix: 'Square r before you talk about explained variation.'
    },
    {
      choice_key: 'B',
      text: 'There is a strong positive linear association between hours studied and final exam score.',
      is_correct: true,
      rationale: 'Names direction, form and strength, and stops at association — which is all r can support.',
      minimum_fix: null
    },
    {
      choice_key: 'C',
      text: 'Studying more hours produces higher final exam scores.',
      is_correct: false,
      rationale: 'A correlation from observational data describes association, not production of an effect.',
      minimum_fix: 'Say "association" until a randomised design earns you "causes".'
    },
    {
      choice_key: 'D',
      text: 'The relationship is strong, so the scatterplot has no unusual points.',
      is_correct: false,
      rationale: 'r says nothing about individual points. A single influential observation can hold r up on its own.',
      minimum_fix: 'Check the plot for unusual points; r will not report them.'
    }
  ],

  habits: {
    earned: ['Say direction, form and strength.', 'Keep r and r² apart.', 'Stop at association.'],
    lost: ['Reading r as a percentage.', 'Upgrading association to cause.', 'Trusting r instead of the plot.']
  },

  hints: [
    {
      hint_key: 'eliminate',
      kind: 'eliminate',
      name: 'Rule out two choices',
      receipt: 'Rule out two choices',
      cost: 'This strikes out two distractors and is listed on your feedback.',
      eliminates: ['A', 'D'],
      body: 'A and D are struck out in the question pane. Two remain — one of them uses a verb the data cannot support.'
    }
  ],

  reference: {
    topic: '2.2 Scatterplots & Correlation — describing the relationship between two quantitative variables.',
    skills: [
      '2.B — Describe form, direction and strength from a scatterplot.',
      '2.C — Interpret r and r² correctly.',
      '4.B — Distinguish association from causation.'
    ],
    vocabulary: [
      { term: 'r', definition: 'strength and direction of a linear association, between −1 and 1.' },
      { term: 'r²', definition: 'the proportion of variation in y explained by the linear model.' },
      { term: 'Influential point', definition: 'an observation that moves the line or r noticeably when removed.' }
    ],
    onTheExam: 'r on its own never earns a description point — direction, form and strength do, in context.'
  },

  openHandNote: 'Nothing is scored here. Read every explanation — the r-versus-r² trap appears every year.',

  deepDive: {
    title: 'What r will not tell you',
    sections: [
      { title: 'Not a percentage', body: 'r = 0.83 is a unitless strength, not a share. The share of explained variation is r² ≈ 0.69, and the two get swapped constantly.' },
      { title: 'Not a cause', body: 'Correlation from observational data licenses "association" only. Students who study more may also sleep more, or start with stronger grades.' },
      { title: 'Not a substitute for the plot', body: 'A high r is compatible with curvature and with a single influential point. Always describe the plot, not just the number.' }
    ]
  },

  coaching: {
    correct: 'Right — direction, form, strength, and no causal verb. That is the whole description move.',
    incorrectTail: 'Next time: say what r measures out loud before you read the options.'
  }
};
