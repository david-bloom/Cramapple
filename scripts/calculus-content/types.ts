export type Difficulty = "Easy" | "Medium" | "Hard" | "Very Hard";
export type ChoiceKey = "A" | "B" | "C" | "D";

export type McqSpec = {
  unit: number;
  practice: number;
  difficulty: Difficulty;
  stem: string;
  choices: [string, string, string, string];
  key: ChoiceKey;
  reasoning: string;
  distractors: [string, string, string, string];
};

export type FrqCriterionSpec = {
  description: string;
  evidence: string[];
  variants?: string[];
  numeric?: { expected: number; tolerance: number; unit?: string };
};

export type FrqPartSpec = {
  prompt: string;
  criteria: FrqCriterionSpec[];
  modalities?: Array<"typed-text" | "typed-math" | "table" | "graph">;
};

export type FrqSpec = {
  unit: number;
  practice: number;
  difficulty: Difficulty;
  archetype: string;
  calculator: boolean;
  scenario: string;
  parts: FrqPartSpec[];
  boundaryCases?: string[];
};

export type SubjectSpec = {
  key: string;
  name: string;
  examCode: string;
  examDate: string;
  prefix: string;
  factPackPath: string;
  factPackSourceKey: string;
  units: Array<[number, string, number, number]>;
  practices: string[];
  archetypes: Array<{ key: string; label: string; examTarget: number }>;
  mcq: McqSpec[];
  frq: FrqSpec[];
  mcqMinutes: number;
  frqMinutes: number;
  frqExamCount: number;
};
