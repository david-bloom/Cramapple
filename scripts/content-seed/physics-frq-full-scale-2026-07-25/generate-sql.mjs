import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const dir = path.dirname(fileURLToPath(import.meta.url));
const items = JSON.parse(fs.readFileSync(path.join(dir, "items.json"), "utf8"));
const reviewerId = "cee0cee4-fc59-4084-9a83-b24ccca940b9";

function uuid(seed) {
  const hex = crypto.createHash("md5").update(seed).digest("hex");
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-4${hex.slice(13, 16)}-a${hex.slice(17, 20)}-${hex.slice(20, 32)}`;
}

function sqlString(value) {
  return `'${String(value).replaceAll("'", "''")}'`;
}

function itemSql(item) {
  const itemId = uuid(`${item.content_key}:item`);
  const versionId = uuid(`${item.content_key}:version:1`);
  const assignmentId = uuid(`${item.content_key}:assignment:${reviewerId}:tutor_question`);
  const stem =
    `${item.title}: Answer all mandatory subparts. ` +
    "Show reasoning and calculations clearly. Use standard AP Physics notation " +
    "and justify qualitative claims.";
  const promptJson = {
    content_key: item.content_key,
    subject: item.subject,
    unit: item.unit,
    topic: item.topic,
    archetype: item.archetype,
    difficulty: item.difficulty,
    source_fact_pack_id: item.source_fact_pack_id,
    source_policy: "Original Cramapple authorship; CED structure and scope only.",
    modules: ["physics-full-scale-frq-structure-2026-07-25"],
    parts: item.parts.map((part) => ({
      part_key: part.part_key,
      prompt: part.prompt,
      points: part.points,
      criteria: part.criteria.map((criterion, index) => ({
        criterion_key: `${part.part_key}-criterion-${String(index + 1).padStart(2, "0")}`,
        points: 1,
      })),
    })),
  };
  const variant = item.subject.includes("physics_c")
    ? "Equivalent calculus-based reasoning with consistent signs and units earns credit."
    : "Equivalent algebraically correct reasoning with consistent signs and units earns credit.";
  const criteriaSql = item.parts
    .flatMap((part) =>
      part.criteria.map(
        ([text, evidence, fix], index) =>
          `(${sqlString(uuid(`${item.content_key}:${part.part_key}:criterion:${index + 1}`))}::uuid, ` +
          `${sqlString(versionId)}::uuid, ` +
          `${sqlString(`${part.part_key}-criterion-${String(index + 1).padStart(2, "0")}`)}, ` +
          `${sqlString(text)}, 1, ${sqlString(evidence)}, ${sqlString(fix)}, ` +
          `${sqlString(JSON.stringify([variant]))}::jsonb)`,
      ),
    )
    .join(",\n      ");

  return `
  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = ${sqlString(item.exam_pack_version_id)}::uuid
      and content_key = ${sqlString(item.content_key)}
      and id <> ${sqlString(itemId)}::uuid
  ) then
    raise exception 'material_content_key_collision:${item.content_key}';
  end if;

  if not exists (
    select 1 from app.content_items where id = ${sqlString(itemId)}::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      ${sqlString(itemId)}::uuid,
      ${sqlString(item.exam_pack_version_id)}::uuid,
      ${sqlString(item.content_key)},
      'frq',
      ${sqlString(item.title)},
      'assigned',
      'long',
      'full_exam_frq',
      ${sqlString(item.archetype)}
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, content_hash, status, review_status, rubric_type,
      evaluator_strategy
    ) values (
      ${sqlString(versionId)}::uuid,
      ${sqlString(itemId)}::uuid,
      1,
      ${sqlString(stem)},
      ${sqlString(item.stimulus)},
      ${sqlString(JSON.stringify(promptJson))}::jsonb,
      ${sqlString(item.explanation)},
      md5(${sqlString(stem)}),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ${criteriaSql};

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      ${sqlString(assignmentId)}::uuid,
      ${sqlString(versionId)}::uuid,
      ${sqlString(reviewerId)}::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;`;
}

function batchSql(batch) {
  const maxima = [...new Set(batch.map((item) => item.content_key.split("-frq-")[0]))]
    .map((prefix) => {
      const expected = 34;
      return `
  select coalesce(max((regexp_match(content_key, '([0-9]+)$'))[1]::integer), 0)
    into v_max
  from app.content_items
  where content_key ~ '^${prefix}-frq-[0-9]+$';
  if v_max not between ${expected} and 38 then
    raise exception 'unexpected_live_max:${prefix}:%', v_max;
  end if;`;
    })
    .join("\n");

  return `begin;
do $physics_full_scale$
declare
  v_max integer;
begin
${maxima}
${batch.map(itemSql).join("\n")}
end
$physics_full_scale$;
commit;
`;
}

const batches = [items.slice(0, 8), items.slice(8, 16)];
for (const [index, batch] of batches.entries()) {
  fs.writeFileSync(path.join(dir, `batch-${index + 1}.sql`), batchSql(batch));
}

const manifest = items.map((item) => ({
  content_key: item.content_key,
  item_id: uuid(`${item.content_key}:item`),
  version_id: uuid(`${item.content_key}:version:1`),
  assignment_id: uuid(`${item.content_key}:assignment:${reviewerId}:tutor_question`),
  subject: item.subject,
  unit: item.unit,
  archetype: item.archetype,
  total_points: item.parts.reduce((sum, part) => sum + part.points, 0),
  part_points: item.parts.map((part) => part.points),
}));
fs.writeFileSync(path.join(dir, "manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`);
