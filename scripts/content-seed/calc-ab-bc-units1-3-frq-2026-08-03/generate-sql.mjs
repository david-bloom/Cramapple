// Generates insert SQL for the AP Calculus AB + AP Calculus BC Units 1-3
// early-year FRQ batch (20 items each, 3 easy / 7 medium / 7 hard / 3 very
// hard, 9 points/item across 3-4 parts per the real Calc FRQ structure) from
// calcab_items.json and calcbc_items.json.
//
// Mirrors scripts/content-seed/stats-precalc-units1-2-frq-2026-08-03/generate-sql.mjs:
// no exam_pack_version_id is hardcoded (not independently confirmed live in
// this authoring session) — each batch looks up the current published
// exam_pack_version for its exam_code at run time and aborts if it can't find
// exactly one. content_key values use a "-u13-NNN" suffix (not a bare
// trailing number) so they cannot collide with unrelated existing numbering
// schemes on either subject.
import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const dir = path.dirname(fileURLToPath(import.meta.url));

const SUBJECTS = [
  { file: "calcab_items.json", examCode: "ap_calculus_ab", label: "apcalcab" },
  { file: "calcbc_items.json", examCode: "ap_calculus_bc", label: "apcalcbc" },
];

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
  const stem =
    `${item.title}: Answer all parts. Show your reasoning and calculations ` +
    "clearly, using standard calculus notation and justifying any qualitative claims.";
  const promptJson = {
    content_key: item.content_key,
    subject: item.subject,
    unit: item.unit,
    topic: item.topic,
    archetype: item.archetype,
    difficulty: item.difficulty,
    ...(item.calculator ? { calculator: item.calculator } : {}),
    source_policy: "Original Cramapple authorship; CED structure and scope only.",
    modules: ["calc-ab-bc-units1-3-frq-2026-08-03"],
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
  const criteriaSql = item.parts
    .flatMap((part) =>
      part.criteria.map(
        ([text, evidence, fix], index) =>
          `(${sqlString(uuid(`${item.content_key}:${part.part_key}:criterion:${index + 1}`))}::uuid, ` +
          `${sqlString(versionId)}::uuid, ` +
          `${sqlString(`${part.part_key}-criterion-${String(index + 1).padStart(2, "0")}`)}, ` +
          `${sqlString(text)}, 1, ${sqlString(evidence)}, ${sqlString(fix)}, '[]'::jsonb)`,
      ),
    )
    .join(",\n      ");

  return `
  if exists (
    select 1
    from app.content_items
    where content_key = ${sqlString(item.content_key)}
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
      v_epv_id,
      ${sqlString(item.content_key)},
      'frq',
      ${sqlString(item.title)},
      'draft',
      'short',
      'targeted_drill',
      ${sqlString(item.archetype)}
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      ${sqlString(versionId)}::uuid,
      ${sqlString(itemId)}::uuid,
      1,
      ${sqlString(stem)},
      ${sqlString(item.stimulus)},
      ${sqlString(JSON.stringify(promptJson))}::jsonb,
      md5(${sqlString(stem)}),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ${criteriaSql};
  end if;`;
}

function batchSql(examCode, items) {
  const totals = items.map((item) => item.parts.reduce((sum, part) => sum + part.points, 0));
  if (!totals.every((total) => total === 9)) {
    throw new Error(`inconsistent per-item point totals for ${examCode} (expected 9)`);
  }

  return `begin;
do $calc_ab_bc_units1_3$
declare
  v_epv_id uuid;
  v_epv_count integer;
begin
  select count(*) into v_epv_count
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = ${sqlString(examCode)}
    and epv.status = 'published';

  if v_epv_count <> 1 then
    raise exception 'expected_exactly_one_published_exam_pack_version:%:%', ${sqlString(examCode)}, v_epv_count;
  end if;

  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = ${sqlString(examCode)}
    and epv.status = 'published';
${items.map((item) => itemSql(item)).join("\n")}
end
$calc_ab_bc_units1_3$;
commit;
`;
}

const manifest = [];
for (const { file, examCode, label } of SUBJECTS) {
  const items = JSON.parse(fs.readFileSync(path.join(dir, file), "utf8"));
  fs.writeFileSync(path.join(dir, `${label}-units1-3-frq-batch.sql`), batchSql(examCode, items));
  for (const item of items) {
    manifest.push({
      content_key: item.content_key,
      subject: item.subject,
      unit: item.unit,
      difficulty: item.difficulty,
      archetype: item.archetype,
      calculator: item.calculator,
      item_id: uuid(`${item.content_key}:item`),
      version_id: uuid(`${item.content_key}:version:1`),
      total_points: item.parts.reduce((sum, part) => sum + part.points, 0),
      part_points: item.parts.map((part) => part.points),
    });
  }
}
fs.writeFileSync(path.join(dir, "manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`);
