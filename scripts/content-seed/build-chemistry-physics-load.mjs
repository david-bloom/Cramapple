import fs from "node:fs";
import path from "node:path";

// Run from anywhere; resolves content/ at the repo root regardless of cwd.
const ROOT = path.join(import.meta.dirname, "..", "..", "content");
const SUBJECTS = [
  "ap-chemistry",
  "ap-physics-1",
  "ap-physics-2",
  "ap-physics-c-mechanics",
  "ap-physics-c-em",
];

function esc(s) {
  if (s === null || s === undefined) return "NULL";
  return "'" + String(s).replace(/'/g, "''") + "'";
}
function jsonb(obj) {
  return "'" + JSON.stringify(obj).replace(/'/g, "''") + "'::jsonb";
}

let totalMcq = 0, totalFrq = 0;

for (const subjectDir of SUBJECTS) {
  let sql = "begin;\n\n";

  const pkgPath = path.join(ROOT, "subject-packages", `${subjectDir}.subject-package.json`);
  const pkg = JSON.parse(fs.readFileSync(pkgPath, "utf8"));
  const subjectKey = pkg.subject.subject_key;
  const displayName = pkg.subject.display_name;
  const examCode = pkg.exam_pack.exam_code;
  const examName = pkg.exam_pack.exam_name;
  const schoolYear = pkg.exam_pack.school_year;
  const examDate = pkg.exam_pack.official_exam_date;
  const sourceUri = pkg.sources?.[0]?.uri ?? null;
  const sourcePublishedAt = pkg.sources?.[0]?.source_version ?? null;

  sql += `insert into app.subjects (id, subject_key, display_name, status)
values (gen_random_uuid(), ${esc(subjectKey)}, ${esc(displayName)}, 'active')
on conflict (subject_key) do nothing;\n\n`;

  sql += `insert into app.exam_packs (id, exam_code, exam_name, subject_id)
select gen_random_uuid(), ${esc(examCode)}, ${esc(examName)}, s.id
from app.subjects s where s.subject_key = ${esc(subjectKey)}
on conflict (exam_code) do nothing;\n\n`;

  sql += `insert into app.exam_pack_versions (id, exam_pack_id, school_year, official_exam_date, status, source_uri, source_published_at)
select gen_random_uuid(), ep.id, ${esc(schoolYear)}, ${esc(examDate)}, 'draft', ${esc(sourceUri)}, ${esc(sourcePublishedAt)}
from app.exam_packs ep where ep.exam_code = ${esc(examCode)}
on conflict do nothing;\n\n`;

  const itemDir = path.join(ROOT, "item-packages", subjectDir);
  const files = fs.readdirSync(itemDir).filter((f) => f.endsWith(".json")).sort();

  let mcqCount = 0, frqCount = 0;

  for (const file of files) {
    const item = JSON.parse(fs.readFileSync(path.join(itemDir, file), "utf8"));
    const contentKey = item.content_key;
    const itemType = item.item_type; // mcq | frq
    const frqForm = item.frq_form ?? null;

    const modules = [...new Set((item.taxonomy_refs ?? []).map((t) => t.node_key))];
    const stimulusText = (item.stimuli ?? [])
      .map((s) => s.payload?.text)
      .filter(Boolean)
      .join("\n\n") || null;

    const canonicalAnswer1 = (item.canonical_answers ?? []).join("; ") || null;

    if (itemType === "mcq") {
      const part = item.parts[0];
      const promptJson = {
        modules,
        subject: examCode,
        rubric_type: "mcq",
        evaluator_strategy: "rule_based_mcq",
        item_type: "mcq",
        archetype: item.archetype_ref?.archetype_key ?? null,
        difficulty: item.difficulty ?? null,
        content_key: contentKey,
      };

      sql += `insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
select gen_random_uuid(), epv.id, ${esc(contentKey)}, 'mcq', ${esc(contentKey)}, 'draft'
from app.exam_pack_versions epv
join app.exam_packs ep on ep.id = epv.exam_pack_id
where ep.exam_code = ${esc(examCode)}
on conflict (exam_pack_version_id, content_key) do nothing;\n\n`;

      sql += `insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, canonical_answer_1, prompt_json, rubric_type, evaluator_strategy, status, content_hash)
select gen_random_uuid(), ci.id, 1, ${esc(part.prompt)}, ${esc(stimulusText)}, ${esc(canonicalAnswer1)}, ${jsonb(promptJson)}, 'mcq', 'rule_based_mcq', 'draft', md5(${esc(contentKey)} || ${esc(part.prompt)})
from app.content_items ci where ci.content_key = ${esc(contentKey)};\n\n`;

      for (const choice of item.mcq_choices ?? []) {
        sql += `insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), civ.id, ${esc(choice.choice_key)}, ${esc(choice.choice_text)}, ${choice.is_correct ? "true" : "false"}, ${esc(choice.rationale)}
from app.content_item_versions civ
join app.content_items ci on ci.id = civ.content_item_id
where ci.content_key = ${esc(contentKey)};\n\n`;
      }
      mcqCount++;
    } else {
      const stemLines = (item.parts ?? []).map((p) => `${p.label ?? ""} ${p.prompt}`.trim());
      const stem = "Answer all parts of the following question.\n\n" + stemLines.join("\n\n");
      const totalPoints = (item.parts ?? []).reduce((sum, p) => sum + Number(p.points ?? 0), 0);

      const promptJson = {
        modules,
        subject: examCode,
        frq_type: frqForm,
        total_points: totalPoints,
        archetype: item.archetype_ref?.archetype_key ?? null,
        difficulty: item.difficulty ?? null,
        content_key: contentKey,
      };

      sql += `insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form)
select gen_random_uuid(), epv.id, ${esc(contentKey)}, 'frq', ${esc(contentKey)}, 'draft', ${esc(frqForm)}
from app.exam_pack_versions epv
join app.exam_packs ep on ep.id = epv.exam_pack_id
where ep.exam_code = ${esc(examCode)}
on conflict (exam_pack_version_id, content_key) do nothing;\n\n`;

      sql += `insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, canonical_answer_1, prompt_json, rubric_type, evaluator_strategy, status, content_hash)
select gen_random_uuid(), ci.id, 1, ${esc(stem)}, ${esc(stimulusText)}, ${esc(canonicalAnswer1)}, ${jsonb(promptJson)}, 'discrete_text', 'llm_discrete_text', 'draft', md5(${esc(contentKey)} || ${esc(stem)})
from app.content_items ci where ci.content_key = ${esc(contentKey)};\n\n`;

      for (const part of item.parts ?? []) {
        const criterion = (part.criteria ?? [])[0];
        if (!criterion) continue;
        const evidenceRequirements = Array.isArray(criterion.required_evidence)
          ? criterion.required_evidence.join("; ")
          : null;
        sql += `insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), civ.id, ${esc(part.part_key)}, ${esc(criterion.description)}, ${Number(criterion.points ?? part.points ?? 0)}, ${esc(evidenceRequirements)}, ${esc(criterion.minimum_fix)}, ${jsonb(criterion.accepted_variants ?? [])}
from app.content_item_versions civ
join app.content_items ci on ci.id = civ.content_item_id
where ci.content_key = ${esc(contentKey)};\n\n`;
      }
      frqCount++;
    }
  }

  sql += "commit;\n";
  fs.writeFileSync(path.join(import.meta.dirname, `load-${subjectDir}.sql`), sql);
  console.error(`${subjectDir}: ${mcqCount} MCQ + ${frqCount} FRQ = ${mcqCount + frqCount} items`);
  totalMcq += mcqCount;
  totalFrq += frqCount;
}

console.error(`TOTAL: ${totalMcq} MCQ + ${totalFrq} FRQ = ${totalMcq + totalFrq} items`);
