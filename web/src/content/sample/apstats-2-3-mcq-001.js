// Sample practice item — see apstats-2-3-frq-001.js for the provenance caveat.

export default {
  schema_version: '1.0.0',
  package_id: 'apstats-2-3-mcq-001',
  item_type: 'mcq',
  difficulty: 'Medium',

  taxonomy: {
    course: 'AP Statistics',
    unit: 'Unit 2',
    unit_title: 'Exploring Two-Variable Data',
    topic: '2.3',
    topic_title: 'Least-Squares Regression'
  },

  title: 'Reading a slope',
  stem: [{ type: 'text', value: 'A least-squares line predicting final exam score from hours studied per week has slope 4.1. Which statement interprets the slope correctly?' }],

  points: 1,
  scoringNote: 'One point. One submission. The key stays closed until you commit.',

  choices: [
    {
      choice_key: 'A',
      text: 'Students who study one more hour per week score 4.1 points higher on the final.',
      is_correct: false,
      rationale: 'Drops “predicted” and “mean”, so it promises every individual student the same 4.1 points.',
      minimum_fix: 'Say the predicted mean score, not what students score.'
    },
    {
      choice_key: 'B',
      text: 'For each additional hour studied per week, the predicted mean final exam score increases by 4.1 points.',
      is_correct: true,
      rationale: 'Names both variables, reads the slope as a rate, keeps the response a predicted mean, and carries the units.',
      minimum_fix: null
    },
    {
      choice_key: 'C',
      text: 'Studying one more hour per week causes final exam scores to rise by 4.1 points.',
      is_correct: false,
      rationale: 'Observational data cannot support a causal claim; the line only describes association.',
      minimum_fix: 'Reserve “causes” for randomised experiments.'
    },
    {
      choice_key: 'D',
      text: 'The mean final exam score for these students is 4.1 points.',
      is_correct: false,
      rationale: 'Reads the slope as if it were a centre. 4.1 is a rate of change, not a mean score.',
      minimum_fix: 'Slope answers “per one more x”, never “on average, y is”.'
    }
  ],

  habits: {
    earned: ['Read the stem before the options.', 'Name the rate, then the response.', 'Check the response is a mean.'],
    lost: ['Picking the first plausible wording.', 'Accepting a causal verb.', 'Reading slope as a centre.']
  },

  hints: [
    {
      hint_key: 'eliminate',
      kind: 'eliminate',
      name: 'Rule out two choices',
      receipt: 'Rule out two choices',
      cost: 'This strikes out two distractors and is listed on your feedback.',
      eliminates: ['A', 'D'],
      body: 'A and D are struck out in the question pane. Two remain — one of them names a cause the data cannot support.'
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
    onTheExam: 'Formula sheet gives ŷ = a + bx. Context is not on the sheet — you supply it.'
  },

  openHandNote: 'Nothing is scored here. Read every explanation — three of these four are traps you will meet again.',

  deepDive: {
    title: 'Three ways a slope sentence fails',
    sections: [
      { title: 'Promising an individual', body: 'The line predicts a mean. Any sentence that tells one student what they will score has left the model behind — the residual for that student is usually bigger than the slope.' },
      { title: 'Claiming a cause', body: 'These data are observational. Hours studied is entangled with prior grades, sleep and course load; the slope describes association only.' },
      { title: 'Confusing rate with centre', body: 'Slope answers “per one more hour”. Intercept answers “at zero hours”. Neither answers “on average, what do students score?”.' }
    ]
  },

  coaching: {
    correct: 'Right, and for the right reason: predicted mean, per one extra hour, in points. Keep all four moves when you write it out on an FRQ.',
    incorrectTail: 'Next time: check that the response is a predicted mean before you check the number.'
  }
};
