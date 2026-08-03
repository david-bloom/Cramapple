// Generates insert SQL for the AP Physics 1 / 2 / C: Mechanics / C: E&M
// early-year FRQ batch (20 items each, 3 easy / 7 medium / 7 hard / 3 very
// hard) from physics1_items.json, physics2_items.json, physicscm_items.json,
// physicscem_items.json.
//
// Unlike the Stats/Precalc/Calc batches, this one matches the schema shape
// ALREADY LIVE for physics targeted_drill FRQs (verified directly against
// production rows on 2026-08-03, not guessed): prompt_json is flat
// ({modules, subject, frq_type, archetype, difficulty, content_key,
// total_points} — no nested "parts" array), and frq_criteria.criterion_key
// uses "part-<letter>" or "<letter>-<slug>" keys with points_possible always
// 1. content_key continues the EXISTING plain numbering scheme
// (apphy1-frq-NNN etc.) starting at 039, since live max was 38 for all four
// subjects as of 2026-08-03 — confirmed via direct query, not assumed.
//
// As with the other generators: no exam_pack_version_id is hardcoded — each
// batch looks up the current published exam_pack_version for its exam_code
// at run time and aborts if it can't find exactly one.
import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const dir = path.dirname(fileURLToPath(import.meta.url));

const SUBJECTS = [
  { file: "physics1_items.json", examCode: "ap_physics_1", prefix: "apphy1", startAt: 39 },
  { file: "physics2_items.json", examCode: "ap_physics_2", prefix: "apphy2", startAt: 39 },
  { file: "physicscm_items.json", examCode: "ap_physics_c_mechanics", prefix: "apphycm", startAt: 39 },
  { file: "physicscem_items.json", examCode: "ap_physics_c_em", prefix: "apphycem", startAt: 39 },
];

function uuid(seed) {
  const hex = crypto.createHash("md5").update(seed).digest("hex");
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-4${hex.slice(13, 16)}-a${hex.slice(17, 20)}-${hex.slice(20, 32)}`;
}

function sqlString(value) {
  return `'${String(value).replaceAll("'", "''")}'`;
}

function itemSql(item, contentKey) {
  const itemId = uuid(`${contentKey}:item`);
  const versionId = uuid(`${contentKey}:version:1`);
  const promptJson = {
    modules: [item.module_topic, item.practice],
    subject: item.subject,
    frq_type: "short",
    archetype: item.archetype,
    difficulty: item.difficulty,
    content_key: contentKey,
    total_points: item.total_points,
  };
  const criteriaSql = item.criteria
    .map(
      (c, index) =>
        `(${sqlString(uuid(`${contentKey}:criterion:${index + 1}:${c.key}`))}::uuid, ` +
        `${sqlString(versionId)}::uuid, ` +
        `${sqlString(c.key)}, ` +
        `${sqlString(c.text)}, 1, ${sqlString(c.evidence)}, ${sqlString(c.fix)}, '[]'::jsonb)`,
    )
    .join(",\n      ");

  return `
  if exists (
    select 1
    from app.content_items
    where content_key = ${sqlString(contentKey)}
      and id <> ${sqlString(itemId)}::uuid
  ) then
    raise exception 'material_content_key_collision:${contentKey}';
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
      ${sqlString(contentKey)},
      'frq',
      ${sqlString(contentKey)},
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
      ${sqlString(item.stem)},
      ${sqlString(item.stimulus)},
      ${sqlString(JSON.stringify(promptJson))}::jsonb,
      md5(${sqlString(item.stem)}),
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

function batchSql(examCode, expectedMax, items, prefix, startAt) {
  const withKeys = items.map((item, index) => ({
    item,
    contentKey: `${prefix}-frq-${String(startAt + index).padStart(3, "0")}`,
  }));

  return `begin;
do $physics_units1_3$
declare
  v_epv_id uuid;
  v_epv_count integer;
  v_max integer;
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

  select coalesce(max((regexp_match(content_key, '-frq-([0-9]+)$'))[1]::integer), 0)
    into v_max
  from app.content_items
  where content_key ~ '^${prefix}-frq-[0-9]+$';
  if v_max <> ${expectedMax} then
    raise exception 'unexpected_live_max:${prefix}:expected=${expectedMax}:actual=%', v_max;
  end if;
${withKeys.map(({ item, contentKey }) => itemSql(item, contentKey)).join("\n")}
end
$physics_units1_3$;
commit;
`;
}

const manifest = [];
for (const { file, examCode, prefix, startAt } of SUBJECTS) {
  const items = JSON.parse(fs.readFileSync(path.join(dir, file), "utf8"));
  fs.writeFileSync(
    path.join(dir, `${prefix}-units1-3-frq-batch.sql`),
    batchSql(examCode, startAt - 1, items, prefix, startAt),
  );
  items.forEach((item, index) => {
    const contentKey = `${prefix}-frq-${String(startAt + index).padStart(3, "0")}`;
    manifest.push({
      content_key: contentKey,
      subject: item.subject,
      unit: item.unit,
      difficulty: item.difficulty,
      archetype: item.archetype,
      item_id: uuid(`${contentKey}:item`),
      version_id: uuid(`${contentKey}:version:1`),
      total_points: item.total_points,
    });
  });
}
fs.writeFileSync(path.join(dir, "manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`);
