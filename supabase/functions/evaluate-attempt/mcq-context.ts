import { type Service } from "./grade-store.ts";

// Skill labels and unit for wrong-answer MCQ feedback (TASK-0079 S3: moved
// verbatim from handleEvaluateAttempt). Lookup errors mean "unknown" and never
// fail the grade.
export async function loadMcqFeedbackContext(input: {
  service: Service;
  contentVersion: { id?: unknown };
  earned: number;
}) {
  const { service, contentVersion, earned } = input;
  let skillLabels: string[] = [];
  let unitNumber: number | null = null;
  if (!earned) {
    const { data: cellRows, error: cellError } = await service.schema("app")
      .from("content_item_cells")
      .select("skill_code, topic_code, taxonomy_source_version")
      .eq("content_item_version_id", contentVersion.id);
    if (!cellError && Array.isArray(cellRows) && cellRows.length > 0) {
      // An item is tagged against exactly one taxonomy version in practice;
      // pin to the first and ignore any stragglers rather than mixing labels
      // from two CED editions into one sentence.
      const taxonomyVersion = cellRows[0].taxonomy_source_version;
      // skill_code is NULLABLE in Production, despite the original DDL
      // declaring it NOT NULL. Most tagged items are topic-only: of the 783
      // published MCQs, 406 carry a topic and only 304 (all Statistics)
      // carry a skill. Passing a null through to .in() would query for a
      // skill code of "null", so drop them here and let the skill sentence
      // be absent rather than wrong.
      const codes = [
        ...new Set(
          cellRows
            .filter((row) => row.taxonomy_source_version === taxonomyVersion)
            .map((row) => row.skill_code)
            .filter((code): code is string =>
              typeof code === "string" && code.length > 0
            ),
        ),
      ];
      const { data: skillRows, error: skillError } = codes.length === 0
        ? { data: [], error: null }
        : await service
          .schema("app")
          .from("taxonomy_skills")
          .select("skill_code, label")
          .eq("taxonomy_source_version", taxonomyVersion)
          .in("skill_code", codes);
      if (!skillError && Array.isArray(skillRows)) {
        skillLabels = codes
          .map((code) =>
            skillRows.find((row) => row.skill_code === code)?.label ?? null
          )
          .filter((label): label is string => typeof label === "string");
      }

      // The unit is an orienting cue ("This is Unit 2 material"), so it is
      // only worth stating when the item sits in ONE unit. A cross-unit item
      // has no single answer here and simply drops the cue rather than
      // picking a unit arbitrarily. As with the skill lookup, an error is
      // treated as "unknown" and never fails the grade.
      const topicCodes = [
        ...new Set(
          cellRows
            .filter((row) => row.taxonomy_source_version === taxonomyVersion)
            .map((row) => row.topic_code),
        ),
      ];
      const { data: topicRows, error: topicError } = await service
        .schema("app")
        .from("taxonomy_topics")
        .select("unit_number")
        .eq("taxonomy_source_version", taxonomyVersion)
        .in("topic_code", topicCodes);
      if (!topicError && Array.isArray(topicRows) && topicRows.length > 0) {
        const units = [
          ...new Set(
            topicRows
              .map((row) => row.unit_number)
              .filter((unit): unit is number => typeof unit === "number"),
          ),
        ];
        if (units.length === 1) unitNumber = units[0];
      }
    }
  }
  return { skillLabels, unitNumber };
}
