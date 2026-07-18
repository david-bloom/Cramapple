import { canonicalJson, sha256 } from "../subject-harness/compiler.ts";
import type { FrqSpec, McqSpec, SubjectSpec } from "./types.ts";
import { calculusAb } from "./items-ab.ts";
import { calculusBc } from "./items-bc.ts";
import { precalculus } from "./items-precalculus.ts";

const subjects: SubjectSpec[] = [calculusAb, calculusBc, precalculus];
const generatedAt = "2026-07-17T00:00:00Z";

const slug = (value: string) =>
  value.toLowerCase().replaceAll(/[^a-z0-9]+/g, "-").replaceAll(/^-|-$/g, "");
const unitKey = (s: SubjectSpec, unit: number) => {
  const title = s.units.find(([n]) => n === unit)?.[1];
  if (!title) throw new Error(`${s.key}: unknown unit ${unit}`);
  return `unit-${unit}-${slug(title)}`;
};

async function writeJson(path: string, value: unknown) {
  await Deno.mkdir(path.substring(0, path.lastIndexOf("/")), {
    recursive: true,
  });
  await Deno.writeTextFile(path, JSON.stringify(value, null, 2) + "\n");
}

async function itemHash(item: Record<string, unknown>) {
  const copy = structuredClone(item) as any;
  delete copy.provenance.content_sha256;
  return await sha256(canonicalJson(copy));
}

function subjectPackage(s: SubjectSpec, factPackHash: string) {
  const practices = s.practices.map((label, index) => ({
    node_key: `practice-${index + 1}`,
    node_type: "practice",
    label,
    ordinal: index + 1,
    source_refs: [s.factPackSourceKey],
  }));
  const units = s.units.map(([number, label]) => ({
    node_key: unitKey(s, number),
    node_type: "unit",
    label,
    ordinal: number,
    source_refs: [s.factPackSourceKey],
  }));
  const practiceRefs = practices.map((p) => p.node_key);
  const archetypes = [
    {
      archetype_key: `${s.key}-mcq`,
      version: "1.0.0",
      item_type: "mcq",
      total_points: 1,
      practice_refs: practiceRefs,
      response_modalities: ["choice"],
    },
    ...s.archetypes.map((a) => ({
      archetype_key: `${s.key}-frq-${a.key}`,
      version: "1.0.0",
      item_type: "frq",
      total_points: s.key === "ap-precalculus" ? 6 : 3,
      practice_refs: practiceRefs,
      response_modalities: ["typed-text", "typed-math", "table"],
    })),
  ];
  return {
    schema_version: "1.0.0",
    package_id: `${s.key}-2025-26-seed`,
    operation: "create-exam-pack-version",
    subject: {
      subject_key: s.key,
      display_name: s.name,
      existing_subject_key: s.key,
    },
    exam_pack: {
      exam_code: s.examCode,
      exam_name: s.name,
      school_year: "2025-26",
      official_exam_date: s.examDate,
      exam_pack_version: "1.0.0",
      effective_from: "2025-07-01",
    },
    sources: [{
      source_key: s.factPackSourceKey,
      source_version: "2026-07-17",
      title: `${s.name} Public Course and Exam Fact Pack`,
      publisher: "Cramapple",
      authority_tier: 1,
      uri: `https://cramapple.local/docs/product/${slug(s.name)}-fact-pack`,
      content_sha256: factPackHash,
      scope:
        "Public course taxonomy and exam-format metadata; no official question or scoring content.",
      rights_status: "cramapple_owned",
      refresh_due_at: "2027-06-01T00:00:00Z",
    }],
    taxonomy: {
      scheme_key: `${s.key}-2025-26`,
      scheme_version: "1.0.0",
      nodes: [...units, ...practices],
    },
    blueprint: {
      sections: [
        {
          section_key: "multiple-choice",
          duration_minutes: s.mcqMinutes,
          score_weight: s.key === "ap-precalculus" ? 0.63 : 0.5,
          item_count: 42,
          item_types: ["mcq"],
        },
        {
          section_key: "free-response",
          duration_minutes: s.frqMinutes,
          score_weight: s.key === "ap-precalculus" ? 0.37 : 0.5,
          item_count: s.frqExamCount,
          item_types: ["frq"],
        },
      ],
      taxonomy_weights: s.units.map(([number, _title, minimum, maximum]) => ({
        taxonomy_node_key: unitKey(s, number),
        minimum,
        maximum,
      })),
    },
    archetypes,
    capabilities: {
      required_renderers: ["markdown", "math", "table"],
      required_response_modalities: [
        "choice",
        "typed-text",
        "typed-math",
        "table",
      ],
      required_graders: ["mcq-key", "statistics-frq-rubric"],
      calculator_modes: ["approved-handheld"],
    },
    inventory: {
      targets: [
        { item_type: "mcq", archetype_key: `${s.key}-mcq`, target_count: 42 },
        ...s.archetypes.map((a) => ({
          item_type: "frq",
          archetype_key: `${s.key}-frq-${a.key}`,
          target_count: a.examTarget,
        })),
      ],
    },
    verification: {
      profile_version: "1.0.0",
      required_check_types: [
        "schema",
        "content-correctness",
        "answer-rubric-consistency",
        "grading-calibration",
        "security-privacy",
      ],
      gold_set_required: true,
      minimum_gold_items: 20,
      calibration_notes:
        "Draft seed only; independent calculus Tutor review and held-out grading calibration are required before publication.",
    },
    review_policy: {
      policy_version: "1.0.0",
      required_capabilities: [`${s.key}-subject-matter`, "assessment-review"],
      independence_required: true,
      minimum_reviewers: 2,
    },
    release_gates: [
      "source",
      "rights",
      "content_clearance",
      "grading_calibration",
      "security_privacy",
      "release_approval",
    ],
    provenance: {
      fact_pack_version: `${s.factPackSourceKey}@2026-07-17`,
      authoring_prompt_version: "CODEX_CALCULUS_THREE_SUBJECT_SEED_2026_07_17",
      generated_by: "Codex",
      generated_at: generatedAt,
    },
    supersession: { strategy: "preserve-prior-pack" },
  };
}

async function makeMcq(s: SubjectSpec, spec: McqSpec, index: number) {
  const contentKey = `${s.prefix}-mcq-${String(index + 1).padStart(3, "0")}`;
  const keys = ["A", "B", "C", "D"] as const;
  const item: any = {
    schema_version: "1.0.0",
    package_id: contentKey,
    content_key: contentKey,
    content_version: 1,
    difficulty: spec.difficulty,
    exam_pack_ref: {
      exam_code: s.examCode,
      school_year: "2025-26",
      exam_pack_version: "1.0.0",
    },
    item_type: "mcq",
    archetype_ref: { archetype_key: `${s.key}-mcq`, version: "1.0.0" },
    taxonomy_refs: [
      {
        scheme_key: `${s.key}-2025-26`,
        scheme_version: "1.0.0",
        node_key: unitKey(s, spec.unit),
      },
      {
        scheme_key: `${s.key}-2025-26`,
        scheme_version: "1.0.0",
        node_key: `practice-${spec.practice}`,
      },
    ],
    stimuli: [],
    mcq_choices: spec.choices.map((choiceText, i) => ({
      choice_key: keys[i],
      choice_text: choiceText,
      is_correct: keys[i] === spec.key,
      rationale: keys[i] === spec.key ? spec.reasoning : spec.distractors[i],
    })),
    canonical_answers: [spec.key],
    parts: [{
      part_key: "question",
      ordinal: 1,
      prompt: `${spec.stem}\n\n${
        spec.choices.map((c, i) => `${keys[i]}. ${c}`).join("\n")
      }`,
      response_modalities: ["choice"],
      points: 1,
      criteria: [{
        criterion_key: "correct-answer",
        points: 1,
        description: "Select the unique correct response.",
        required_evidence: [spec.key, spec.reasoning],
        deterministic_checks: [{
          check_type: "choice-key",
          parameters: { correct_key: spec.key },
        }],
      }],
    }],
    accessibility: {
      language: "en",
      screen_reader_review_required: false,
      accommodation_notes: "All mathematical information is provided in text.",
    },
    review_notes: {
      expected_reasoning: spec.reasoning,
      known_boundary_cases: [
        "Reject alternate choices unless their stated expression is mathematically equivalent to the keyed result.",
      ],
      originality_statement:
        "Independently authored Cramapple practice item; no released or secure question or scoring language was used.",
    },
    provenance: {
      source_refs: [s.factPackSourceKey],
      fact_pack_version: "2026-07-17",
      authoring_prompt_version: "CODEX_CALCULUS_THREE_SUBJECT_SEED_2026_07_17",
      generated_by: "codex",
      generated_at: generatedAt,
      content_sha256: "",
    },
  };
  item.provenance.content_sha256 = await itemHash(item);
  return item;
}

async function makeFrq(s: SubjectSpec, spec: FrqSpec, index: number) {
  const contentKey = `${s.prefix}-frq-${String(index + 1).padStart(3, "0")}`;
  const letters = "abcdefghijklmnopqrstuvwxyz";
  const canonical = spec.parts.flatMap((p) =>
    p.criteria.map((c) => c.description)
  ).join(" | ");
  const item: any = {
    schema_version: "1.0.0",
    package_id: contentKey,
    content_key: contentKey,
    content_version: 1,
    difficulty: spec.difficulty,
    frq_form: spec.parts.length >= 4 ? "long" : "short",
    canonical_answers: [canonical],
    exam_pack_ref: {
      exam_code: s.examCode,
      school_year: "2025-26",
      exam_pack_version: "1.0.0",
    },
    item_type: "frq",
    archetype_ref: {
      archetype_key: `${s.key}-frq-${spec.archetype}`,
      version: "1.0.0",
    },
    taxonomy_refs: [
      {
        scheme_key: `${s.key}-2025-26`,
        scheme_version: "1.0.0",
        node_key: unitKey(s, spec.unit),
      },
      {
        scheme_key: `${s.key}-2025-26`,
        scheme_version: "1.0.0",
        node_key: `practice-${spec.practice}`,
      },
    ],
    stimuli: [{
      stimulus_key: "scenario",
      ordinal: 1,
      kind: "text",
      payload: {
        text: spec.scenario,
        calculator_mode: spec.calculator
          ? "approved-handheld"
          : "not-permitted",
      },
      source_refs: [s.factPackSourceKey],
    }],
    parts: spec.parts.map((part, partIndex) => ({
      part_key: `part-${letters[partIndex]}`,
      ordinal: partIndex + 1,
      label: `(${letters[partIndex]})`,
      prompt: part.prompt,
      stimulus_refs: ["scenario"],
      response_modalities: part.modalities ?? ["typed-text", "typed-math"],
      points: part.criteria.reduce((sum, criterion) => sum + 1, 0),
      criteria: part.criteria.map((criterion, criterionIndex) => ({
        criterion_key: `part-${letters[partIndex]}-criterion-${
          criterionIndex + 1
        }`,
        points: 1,
        description: criterion.description,
        required_evidence: criterion.evidence,
        accepted_variants: criterion.variants ??
          ["Any algebraically equivalent form with correct reasoning."],
        deterministic_checks: criterion.numeric
          ? [{
            check_type: "numeric-tolerance",
            parameters: {
              expected_value: criterion.numeric.expected,
              tolerance: criterion.numeric.tolerance,
              ...(criterion.numeric.unit
                ? { unit: criterion.numeric.unit }
                : {}),
            },
          }]
          : [{
            check_type: "keyword-evidence",
            parameters: { keywords: criterion.evidence.slice(0, 4) },
          }],
      })),
    })),
    accessibility: {
      language: "en",
      screen_reader_review_required: false,
      accommodation_notes:
        "The prompt is complete in text; graph responses may be described with labeled features during accessibility review.",
    },
    review_notes: {
      expected_reasoning: canonical,
      known_boundary_cases: spec.boundaryCases ??
        [
          "Award a criterion only when the conclusion is supported by the stated mathematical evidence.",
          "Carry-forward arithmetic may earn later reasoning credit when the method remains valid.",
        ],
      originality_statement:
        "Independently authored Cramapple draft for Tutor review; no released or secure question or scoring language was used.",
    },
    provenance: {
      source_refs: [s.factPackSourceKey],
      fact_pack_version: "2026-07-17",
      authoring_prompt_version: "CODEX_CALCULUS_THREE_SUBJECT_SEED_2026_07_17",
      generated_by: "codex",
      generated_at: generatedAt,
      content_sha256: "",
    },
  };
  item.provenance.content_sha256 = await itemHash(item);
  return item;
}

for (const subject of subjects) {
  const factPackHash = await sha256(
    await Deno.readTextFile(subject.factPackPath),
  );
  await writeJson(
    `content/subject-packages/${subject.key}.subject-package.json`,
    subjectPackage(subject, factPackHash),
  );
  for (let i = 0; i < subject.mcq.length; i++) {
    await writeJson(
      `content/item-packages/${subject.key}/${subject.prefix}-mcq-${
        String(i + 1).padStart(3, "0")
      }.json`,
      await makeMcq(subject, subject.mcq[i], i),
    );
  }
  for (let i = 0; i < subject.frq.length; i++) {
    await writeJson(
      `content/item-packages/${subject.key}/${subject.prefix}-frq-${
        String(i + 1).padStart(3, "0")
      }.json`,
      await makeFrq(subject, subject.frq[i], i),
    );
  }
}

console.log(
  JSON.stringify({
    subjects: subjects.length,
    mcq: subjects.reduce((n, s) => n + s.mcq.length, 0),
    frq: subjects.reduce((n, s) => n + s.frq.length, 0),
  }),
);
