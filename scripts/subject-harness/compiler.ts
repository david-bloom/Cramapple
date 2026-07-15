import { validateContract } from "./validate-contracts.ts";

export type Json = null | boolean | number | string | Json[] | {
  [key: string]: Json;
};
export type Issue = { code: string; path: string; message: string };

export class HarnessValidationError extends Error {
  constructor(public issues: Issue[]) {
    super(
      issues.map((issue) => `${issue.code} ${issue.path}: ${issue.message}`)
        .join("\n"),
    );
  }
}

export function canonicalJson(value: unknown): string {
  const normalize = (input: unknown): Json => {
    if (
      input === null || ["string", "number", "boolean"].includes(typeof input)
    ) return input as Json;
    if (Array.isArray(input)) return input.map(normalize);
    if (typeof input !== "object") {
      throw new TypeError(`unsupported canonical JSON value: ${typeof input}`);
    }
    return Object.fromEntries(
      Object.entries(input as Record<string, unknown>)
        .sort(([a], [b]) => a.localeCompare(b)).map((
          [key, item],
        ) => [key, normalize(item)]),
    );
  };
  return JSON.stringify(normalize(value));
}

export async function sha256(value: string): Promise<string> {
  const bytes = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return [...new Uint8Array(bytes)].map((byte) =>
    byte.toString(16).padStart(2, "0")
  ).join("");
}

function record(value: unknown): Record<string, any> {
  return value as Record<string, any>;
}
function values(value: unknown): any[] {
  return Array.isArray(value) ? value : [];
}
function push(issues: Issue[], code: string, path: string, message: string) {
  issues.push({ code, path, message });
}

function uniqueOrdinals(items: any[], path: string, issues: Issue[]) {
  const ordinals = items.map((item) => item.ordinal);
  if (new Set(ordinals).size !== ordinals.length) {
    push(
      issues,
      "structure.duplicate_ordinal",
      path,
      "ordinals must be unique",
    );
  }
}

function verifyPart(
  part: any,
  path: string,
  stimuli: Set<string>,
  checks: Set<string>,
  checkContracts: Record<string, any>,
  issues: Issue[],
): number {
  const criteria = values(part.criteria);
  const criterionPoints = criteria.reduce(
    (sum, criterion) => sum + Number(criterion.points),
    0,
  );
  if (criterionPoints !== Number(part.points)) {
    push(
      issues,
      "rubric.points_mismatch",
      path,
      `criteria total ${criterionPoints}, part declares ${part.points}`,
    );
  }
  for (const stimulus of values(part.stimulus_refs)) {
    if (!stimuli.has(stimulus)) {
      push(issues, "reference.stimulus_not_found", path, stimulus);
    }
  }
  for (const [index, criterion] of criteria.entries()) {
    for (const check of values(criterion.deterministic_checks)) {
      if (!checks.has(check.check_type)) {
        push(
          issues,
          "verifier.check_type_unsupported",
          `${path}/criteria/${index}`,
          String(check.check_type),
        );
      }
      const contract = checkContracts[check.check_type];
      const parameters = record(check.parameters);
      if (check.check_type === "choice-key" && !("choice" in parameters || "correct_key" in parameters)) {
        push(issues, "verifier.parameter_required", `${path}/criteria/${index}/parameters`, "choice or correct_key");
      }
      if (check.check_type === "numeric-tolerance" && !("absolute" in parameters || ("expected_value" in parameters && "tolerance" in parameters))) {
        push(issues, "verifier.parameter_required", `${path}/criteria/${index}/parameters`, "absolute or expected_value+tolerance");
      }
      if (contract) {
        for (const key of values(contract.required)) {
          if (!(key in parameters)) {
            push(
              issues,
              "verifier.parameter_required",
              `${path}/criteria/${index}/parameters`,
              String(key),
            );
          }
        }
        for (const [key, value] of Object.entries(parameters)) {
          const expected = contract.properties?.[key];
          const actual = Array.isArray(value) ? "array" : typeof value;
          if (!expected && contract.additional_properties === false) {
            push(
              issues,
              "verifier.parameter_unknown",
              `${path}/criteria/${index}/parameters/${key}`,
              key,
            );
          } else if (expected && actual !== expected) {
            push(
              issues,
              "verifier.parameter_type",
              `${path}/criteria/${index}/parameters/${key}`,
              `expected ${expected}`,
            );
          }
        }
      }
      if (
        ["code", "script", "sql", "function"].some((key) =>
          key in record(check.parameters)
        )
      ) {
        push(
          issues,
          "verifier.executable_field_rejected",
          `${path}/criteria/${index}/parameters`,
          "executable verifier fields are forbidden",
        );
      }
    }
  }
  const subparts = values(part.subparts);
  uniqueOrdinals(subparts, `${path}/subparts`, issues);
  const childPoints = subparts.reduce(
    (sum, child, index) =>
      sum +
      verifyPart(
        child,
        `${path}/subparts/${index}`,
        stimuli,
        checks,
        checkContracts,
        issues,
      ),
    0,
  );
  if (subparts.length && childPoints !== Number(part.points)) {
    push(
      issues,
      "rubric.subpart_points_mismatch",
      path,
      `subparts total ${childPoints}, parent declares ${part.points}`,
    );
  }
  return Number(part.points);
}

export type CompiledPlan = {
  plan_schema_version: "1.0.0";
  plan_sha256: string;
  plan_canonical_json: string;
  advisories: Issue[];
  subject_package_sha256: string;
  subject_package_canonical_json: string;
  taxonomy_sha256: string;
  taxonomy_canonical_json: string;
  review_policy_sha256: string;
  review_policy_canonical_json: string;
  subject_package: Record<string, unknown>;
  items: Array<
    {
      package: Record<string, unknown>;
      canonical_json: string;
      content_sha256: string;
    }
  >;
  operations: Array<{ action: string; key: string }>;
};

export async function compilePlan(
  subjectPackage: Record<string, any>,
  itemPackages: Record<string, any>[],
  capabilityRegistry: Record<string, any>,
): Promise<CompiledPlan> {
  const issues: Issue[] = [];
  const advisories: Issue[] = [];
  const subjectContract = await validateContract(
    "subject-package",
    subjectPackage,
  );
  for (const message of subjectContract.errors) {
    push(issues, "contract.subject_invalid", "/", message);
  }
  for (const [index, item] of itemPackages.entries()) {
    const result = await validateContract("item-package", item);
    for (const message of result.errors) {
      push(issues, "contract.item_invalid", `/items/${index}`, message);
    }
  }
  if (issues.length) throw new HarnessValidationError(issues);

  const yearStart = Number(
    String(subjectPackage.exam_pack.school_year).slice(0, 4),
  );
  const examYear = Number(
    String(subjectPackage.exam_pack.official_exam_date).slice(0, 4),
  );
  if (examYear !== yearStart + 1) {
    push(
      issues,
      "exam.academic_year_mismatch",
      "/exam_pack/official_exam_date",
      "exam must occur in the ending year",
    );
  }
  const sections = values(subjectPackage.blueprint.sections);
  const sectionWeight = sections.reduce(
    (sum, section) => sum + Number(section.score_weight),
    0,
  );
  if (Math.abs(sectionWeight - 1) > 1e-9) {
    push(
      issues,
      "blueprint.section_weights",
      "/blueprint/sections",
      `weights total ${sectionWeight}`,
    );
  }

  const nodes = values(subjectPackage.taxonomy.nodes);
  const nodeKeys = new Set(nodes.map((node) => node.node_key));
  for (const [index, node] of nodes.entries()) {
    if (node.parent_key && !nodeKeys.has(node.parent_key)) {
      push(
        issues,
        "reference.taxonomy_parent_not_found",
        `/taxonomy/nodes/${index}/parent_key`,
        node.parent_key,
      );
    }
  }
  for (
    const [index, weight] of values(subjectPackage.blueprint.taxonomy_weights)
      .entries()
  ) {
    if (!nodeKeys.has(weight.taxonomy_node_key)) {
      push(
        issues,
        "reference.taxonomy_weight_not_found",
        `/blueprint/taxonomy_weights/${index}`,
        weight.taxonomy_node_key,
      );
    }
    if (Number(weight.minimum) > Number(weight.maximum)) {
      push(
        issues,
        "blueprint.weight_range",
        `/blueprint/taxonomy_weights/${index}`,
        "minimum exceeds maximum",
      );
    }
  }

  const archetypes = new Map(
    values(subjectPackage.archetypes).map((
      archetype,
    ) => [`${archetype.archetype_key}@${archetype.version}`, archetype]),
  );
  const archetypesByKey = new Map(
    values(subjectPackage.archetypes).map((archetype) => [
      archetype.archetype_key,
      archetype,
    ]),
  );
  const declaredModalities = new Set(
    values(subjectPackage.capabilities.required_response_modalities),
  );
  for (
    const [index, archetype] of values(subjectPackage.archetypes).entries()
  ) {
    for (const ref of values(archetype.practice_refs)) {
      if (!nodeKeys.has(ref)) {
        push(
          issues,
          "reference.archetype_practice_not_found",
          `/archetypes/${index}`,
          ref,
        );
      }
    }
    for (const modality of values(archetype.response_modalities)) {
      if (!declaredModalities.has(modality)) {
        push(
          issues,
          "capability.archetype_modality_undeclared",
          `/archetypes/${index}/response_modalities`,
          `${modality} not in capabilities.required_response_modalities`,
        );
      }
    }
  }
  for (
    const [index, target] of values(subjectPackage.inventory.targets).entries()
  ) {
    if (!target.archetype_key) continue;
    const archetype = archetypesByKey.get(target.archetype_key);
    if (!archetype) {
      push(
        issues,
        "reference.inventory_archetype_not_found",
        `/inventory/targets/${index}/archetype_key`,
        String(target.archetype_key),
      );
    } else if (target.item_type !== archetype.item_type) {
      push(
        issues,
        "reference.inventory_item_type_mismatch",
        `/inventory/targets/${index}`,
        `target item_type ${target.item_type}, archetype ${target.archetype_key} is ${archetype.item_type}`,
      );
    }
  }

  const inventoryDemand = new Map<string, number>();
  for (const target of values(subjectPackage.inventory.targets)) {
    const itemType = String(target.item_type);
    inventoryDemand.set(
      itemType,
      (inventoryDemand.get(itemType) ?? 0) + Number(target.target_count),
    );
  }
  const formDemand = new Map<string, number>();
  for (const [index, section] of sections.entries()) {
    const itemTypes = values(section.item_types);
    if (itemTypes.length > 1) {
      push(
        advisories,
        "blueprint.mixed_section_unreconciled",
        `/blueprint/sections/${index}`,
        `section ${section.section_key} mixes item_types; counts not reconciled`,
      );
      continue;
    }
    if (itemTypes.length === 1) {
      const itemType = String(itemTypes[0]);
      formDemand.set(
        itemType,
        (formDemand.get(itemType) ?? 0) + Number(section.item_count),
      );
    }
  }
  for (const [itemType, demand] of formDemand) {
    const inventory = inventoryDemand.get(itemType) ?? 0;
    if (inventory < demand) {
      push(
        issues,
        "inventory.below_form_demand",
        "/inventory/targets",
        `item_type ${itemType}: inventory ${inventory} < one form needs ${demand}`,
      );
    }
  }

  const requiredGates = [
    "source",
    "rights",
    "content_clearance",
    "grading_calibration",
    "security_privacy",
    "release_approval",
  ];
  for (const gate of requiredGates) {
    if (!values(subjectPackage.release_gates).includes(gate)) {
      push(issues, "gate.required_category_missing", "/release_gates", gate);
    }
  }
  const capabilityGroups: Array<[string, string, any[]]> = [
    [
      "renderer",
      "renderers",
      values(subjectPackage.capabilities.required_renderers),
    ],
    [
      "response-modality",
      "response_modalities",
      values(subjectPackage.capabilities.required_response_modalities),
    ],
    ["grader", "graders", values(subjectPackage.capabilities.required_graders)],
    [
      "calculator",
      "calculator_modes",
      values(subjectPackage.capabilities.calculator_modes),
    ],
  ];
  for (const [kind, registryKey, requested] of capabilityGroups) {
    for (const code of requested) {
      const state = capabilityRegistry[registryKey]?.[code];
      if (state !== "supported") {
        push(
          issues,
          state ? "capability.not_supported" : "capability.missing",
          `/capabilities/${kind}/${code}`,
          String(state ?? "unregistered"),
        );
      }
    }
  }
  for (
    const check of values(subjectPackage.verification.required_check_types)
  ) {
    if (!values(capabilityRegistry.verification_check_types).includes(check)) {
      push(
        issues,
        "verification.check_type_missing",
        "/verification/required_check_types",
        check,
      );
    }
  }

  const sourceKeys = new Set(
    values(subjectPackage.sources).map((source) => source.source_key),
  );
  const deterministicChecks = new Set<string>(
    values(capabilityRegistry.deterministic_check_types),
  );
  const checkContracts = record(
    capabilityRegistry.deterministic_check_contracts,
  );
  const compiledItems: CompiledPlan["items"] = [];
  for (const [index, item] of itemPackages.entries()) {
    const path = `/items/${index}`;
    if (item.item_type === "mcq" && item.mcq_choices) {
      const keys = values(item.mcq_choices).map((choice) => choice.choice_key);
      const correct = values(item.mcq_choices).filter((choice) => choice.is_correct);
      if (new Set(keys).size !== 4 || !["A", "B", "C", "D"].every((key) => keys.includes(key))) {
        push(issues, "answer.mcq_choice_keys", `${path}/mcq_choices`, "choices must contain A, B, C, and D exactly once");
      }
      if (correct.length !== 1) {
        push(issues, "answer.mcq_single_correct", `${path}/mcq_choices`, "exactly one choice must be correct");
      }
    }
    if (item.item_type === "frq" && item.frq_form && !item.canonical_answers?.length) {
      push(issues, "answer.frq_canonical_required", `${path}/canonical_answers`, "authored FRQ projections require a canonical answer");
    }
    const expectedRef = subjectPackage.exam_pack;
    for (const key of ["exam_code", "school_year", "exam_pack_version"]) {
      if (item.exam_pack_ref[key] !== expectedRef[key]) {
        push(
          issues,
          "reference.exam_pack_mismatch",
          `${path}/exam_pack_ref/${key}`,
          String(item.exam_pack_ref[key]),
        );
      }
    }
    const archetype = archetypes.get(
      `${item.archetype_ref.archetype_key}@${item.archetype_ref.version}`,
    );
    if (!archetype) {
      push(
        issues,
        "reference.archetype_not_found",
        `${path}/archetype_ref`,
        "exact archetype version not found",
      );
    } else if (archetype.item_type !== item.item_type) {
      push(
        issues,
        "reference.archetype_item_type",
        path,
        "item type differs from archetype",
      );
    }
    for (const ref of values(item.taxonomy_refs)) {
      if (
        ref.scheme_key !== subjectPackage.taxonomy.scheme_key ||
        ref.scheme_version !== subjectPackage.taxonomy.scheme_version ||
        !nodeKeys.has(ref.node_key)
      ) {
        push(
          issues,
          "reference.taxonomy_not_found",
          `${path}/taxonomy_refs`,
          `${ref.scheme_key}@${ref.scheme_version}/${ref.node_key}`,
        );
      }
    }
    for (const source of values(item.provenance.source_refs)) {
      if (!sourceKeys.has(source)) {
        push(
          issues,
          "reference.source_not_found",
          `${path}/provenance/source_refs`,
          source,
        );
      }
    }
    const stimuli = values(item.stimuli);
    uniqueOrdinals(stimuli, `${path}/stimuli`, issues);
    const stimulusKeys = new Set(
      stimuli.map((stimulus) => stimulus.stimulus_key),
    );
    const parts = values(item.parts);
    const archetypeModalities = archetype
      ? new Set(values(archetype.response_modalities))
      : undefined;
    const walkParts = (candidate: any, partPath: string) => {
      for (const modality of values(candidate.response_modalities)) {
        const state = capabilityRegistry.response_modalities?.[modality];
        if (!declaredModalities.has(modality)) {
          push(
            issues,
            "capability.item_modality_undeclared",
            partPath,
            String(modality),
          );
        }
        if (state !== "supported") {
          push(
            issues,
            "capability.item_modality_not_supported",
            partPath,
            String(modality),
          );
        }
        if (archetypeModalities && !archetypeModalities.has(modality)) {
          push(
            issues,
            "reference.part_modality_not_in_archetype",
            `${partPath}/response_modalities`,
            `${modality} not permitted by archetype ${archetype.archetype_key}`,
          );
        }
      }
      values(candidate.subparts).forEach((child, index) =>
        walkParts(child, `${partPath}/subparts/${index}`)
      );
    };
    parts.forEach((part, index) => walkParts(part, `${path}/parts/${index}`));
    const rendererForStimulus: Record<string, string> = {
      text: "markdown",
      table: "table",
      dataset: "table",
      formula: "math",
      image: "image",
      chart: "chart",
    };
    const declaredRenderers = new Set(
      values(subjectPackage.capabilities.required_renderers),
    );
    stimuli.forEach((stimulus, index) => {
      const renderer = rendererForStimulus[stimulus.kind];
      if (!declaredRenderers.has(renderer)) {
        push(
          issues,
          "capability.stimulus_renderer_undeclared",
          `${path}/stimuli/${index}`,
          renderer,
        );
      }
      if (capabilityRegistry.renderers?.[renderer] !== "supported") {
        push(
          issues,
          "capability.stimulus_renderer_not_supported",
          `${path}/stimuli/${index}`,
          renderer,
        );
      }
    });
    uniqueOrdinals(parts, `${path}/parts`, issues);
    const totalPoints = parts.reduce(
      (sum, part, partIndex) =>
        sum +
        verifyPart(
          part,
          `${path}/parts/${partIndex}`,
          stimulusKeys,
          deterministicChecks,
          checkContracts,
          issues,
        ),
      0,
    );
    if (archetype && totalPoints !== Number(archetype.total_points)) {
      push(
        issues,
        "rubric.archetype_points_mismatch",
        path,
        `item totals ${totalPoints}, archetype requires ${archetype.total_points}`,
      );
    }
    const canonicalPackage = structuredClone(item);
    delete canonicalPackage.provenance.content_sha256;
    const canonical = canonicalJson(canonicalPackage);
    const computedHash = await sha256(canonical);
    if (item.provenance.content_sha256 !== computedHash) {
      push(
        issues,
        "hash.item_mismatch",
        `${path}/provenance/content_sha256`,
        `expected ${computedHash}`,
      );
    }
    compiledItems.push({
      package: item,
      canonical_json: canonical,
      content_sha256: computedHash,
    });
  }
  if (issues.length) throw new HarnessValidationError(issues);

  const subjectCanonical = canonicalJson(subjectPackage);
  const taxonomyCanonical = canonicalJson(subjectPackage.taxonomy);
  const policyCanonical = canonicalJson(subjectPackage.review_policy);
  const subjectHash = await sha256(subjectCanonical);
  const taxonomyHash = await sha256(taxonomyCanonical);
  const policyHash = await sha256(policyCanonical);
  const operations = [
    { action: "ensure-subject", key: subjectPackage.subject.subject_key },
    {
      action: "ensure-exam-pack-version",
      key:
        `${subjectPackage.exam_pack.exam_code}/${subjectPackage.exam_pack.school_year}`,
    },
    {
      action: "ensure-taxonomy",
      key:
        `${subjectPackage.taxonomy.scheme_key}@${subjectPackage.taxonomy.scheme_version}`,
    },
    ...values(subjectPackage.archetypes).map((a) => ({
      action: "ensure-archetype",
      key: `${a.archetype_key}@${a.version}`,
    })),
    ...itemPackages.map((item) => ({
      action: "ensure-item-version",
      key: `${item.content_key}@${item.content_version}`,
    })),
  ];
  const unsigned = {
    plan_schema_version: "1.0.0",
    subject_package_sha256: subjectHash,
    subject_package_canonical_json: subjectCanonical,
    taxonomy_sha256: taxonomyHash,
    taxonomy_canonical_json: taxonomyCanonical,
    review_policy_sha256: policyHash,
    review_policy_canonical_json: policyCanonical,
    subject_package: subjectPackage,
    items: compiledItems,
    operations,
  };
  const planCanonical = canonicalJson(unsigned);
  return {
    ...unsigned,
    plan_canonical_json: planCanonical,
    plan_sha256: await sha256(planCanonical),
    advisories,
  } as CompiledPlan;
}
