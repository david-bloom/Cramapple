import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

export const REVIEWER_ID = "cee0cee4-fc59-4084-9a83-b24ccca940b9";

export function mcq(unit, topic, title, question, choices, correct, rationales, difficulty = "Medium") {
  const [correctRationale, ...distractorRationales] = rationales;
  let distractorIndex = 0;
  const alignedRationales = choices.map((_, index) => {
    if (index === correct) return correctRationale;
    const rationale = distractorRationales[distractorIndex];
    distractorIndex += 1;
    return rationale;
  });
  return {
    itemType: "mcq",
    unit,
    topic,
    title,
    question,
    choices,
    correct,
    rationales: alignedRationales,
    difficulty,
    archetype: "Multiple Choice",
  };
}

export function criterion(key, text, evidence, minimumFix, variants = []) {
  return { key, text, points: 1, evidence, minimumFix, variants };
}

export function frq(
  unit,
  topic,
  title,
  archetype,
  form,
  stimulus,
  prompts,
  criteria,
  canonicalAnswer,
  difficulty = "Medium",
) {
  return {
    itemType: "frq",
    unit,
    topic,
    title,
    archetype,
    form,
    stimulus,
    prompts,
    criteria,
    canonicalAnswer,
    difficulty,
  };
}

function esc(value) {
  if (value === null || value === undefined) return "null";
  return `'${String(value).replaceAll("'", "''")}'`;
}

function jsonb(value) {
  return `${esc(JSON.stringify(value))}::jsonb`;
}

function words(value) {
  return String(value).toLowerCase().match(/[a-z0-9]+/g) ?? [];
}

function jaccard(a, b) {
  const left = new Set(words(a));
  const right = new Set(words(b));
  const intersection = [...left].filter((word) => right.has(word)).length;
  const union = new Set([...left, ...right]).size;
  return union ? intersection / union : 0;
}

function finalize(subject) {
  let frqNumber = subject.frozenMaxFrq + 1;
  let mcqNumber = subject.frozenMaxMcq + 1;
  return subject.items.map((item) => {
    const number = item.itemType === "frq" ? frqNumber++ : mcqNumber++;
    const key = `${subject.prefix}-${item.itemType}-${String(number).padStart(3, "0")}`;
    if (item.itemType === "mcq") {
      const choiceKeys = ["A", "B", "C", "D"];
      const stem = `${item.question}\n\n${item.choices
        .map((choice, index) => `${choiceKeys[index]}. ${choice}`)
        .join("\n")}`;
      return {
        ...item,
        key,
        stem,
        stimulus: null,
        form: null,
        canonicalAnswer: choiceKeys[item.correct],
        components: item.choices.map((choice, index) => ({
          key: choiceKeys[index],
          text: choice,
          correct: index === item.correct,
          rationale: item.rationales[index],
        })),
      };
    }
    const stem = `Answer all parts of the following question.\n\n${item.prompts
      .map((prompt, index) => `(${String.fromCharCode(97 + index)}) ${prompt}`)
      .join("\n\n")}`;
    return { ...item, key, stem, components: item.criteria };
  });
}

export function validateSubject(subject) {
  const items = finalize(subject);
  const errors = [];
  const expectedFrq = subject.expectedFrq;
  const expectedMcq = subject.expectedMcq;
  const frqs = items.filter((item) => item.itemType === "frq");
  const mcqs = items.filter((item) => item.itemType === "mcq");
  if (items.length !== 40) errors.push(`expected 40 items, found ${items.length}`);
  if (frqs.length !== expectedFrq) errors.push(`expected ${expectedFrq} FRQs, found ${frqs.length}`);
  if (mcqs.length !== expectedMcq) errors.push(`expected ${expectedMcq} MCQs, found ${mcqs.length}`);

  for (const item of items) {
    if (!item.title || !item.topic || !item.unit) errors.push(`${item.key}: missing title/topic/unit`);
    if (item.itemType === "mcq") {
      if (item.components.length !== 4) errors.push(`${item.key}: must have four choices`);
      if (item.components.filter((choice) => choice.correct).length !== 1) {
        errors.push(`${item.key}: must have exactly one correct choice`);
      }
      for (const choice of item.components) {
        if (!choice.rationale || choice.rationale.length < 28) {
          errors.push(`${item.key}/${choice.key}: rationale is not specific enough`);
        }
      }
    } else {
      const points = item.components.reduce((sum, row) => sum + row.points, 0);
      const expectedRange = item.form === "short" ? [3, 4] : [6, 8];
      if (points < expectedRange[0] || points > expectedRange[1]) {
        errors.push(`${item.key}: ${item.form} FRQ has ${points} points`);
      }
      if (item.prompts.length < 2 || item.prompts.length > 5) {
        errors.push(`${item.key}: invalid prompt-part count`);
      }
      for (const row of item.components) {
        if (!row.evidence || !row.minimumFix || !Array.isArray(row.variants)) {
          errors.push(`${item.key}/${row.key}: incomplete criterion`);
        }
      }
    }
  }

  for (let i = 0; i < items.length; i += 1) {
    for (let j = i + 1; j < items.length; j += 1) {
      const similarity = jaccard(items[i].stem, items[j].stem);
      if (similarity >= 0.72) {
        errors.push(`${items[i].key} and ${items[j].key}: near-duplicate similarity ${similarity.toFixed(2)}`);
      }
    }
  }

  if (subject.calculusBased === false) {
    const forbidden = /(?:∫|d[xyzθωv]\/d[tx]|derivative|integral|differentiat)/i;
    for (const item of items) {
      const allText = [item.stem, item.stimulus, item.canonicalAnswer, JSON.stringify(item.components)].join(" ");
      if (forbidden.test(allText)) errors.push(`${item.key}: calculus notation/language in algebra-based course`);
    }
  }

  const keys = new Set(items.map((item) => item.key));
  if (keys.size !== items.length) errors.push("duplicate generated content keys");
  if (errors.length) throw new Error(`${subject.prefix} validation failed:\n- ${errors.join("\n- ")}`);
  return items;
}

export function buildSql(subject) {
  const items = validateSubject(subject);
  const itemRows = items
    .map((item) => {
      const promptJson = {
        modules: [subject.unitSlugs[item.unit], "physics-expansion-2026-07-24"],
        subject: subject.examCode,
        topic: item.topic,
        archetype: item.archetype,
        difficulty: item.difficulty,
        content_key: item.key,
        source_fact_pack_id: subject.factPackId,
      };
      const payload = {
        content_key: item.key,
        item_type: item.itemType,
        frq_form: item.form,
        title: item.title,
        stem: item.stem,
        stimulus: item.stimulus,
        prompt_json: promptJson,
        canonical_answer_1: item.canonicalAnswer,
        rubric_type: item.itemType === "mcq" ? "mcq" : "discrete_text",
        evaluator_strategy: item.itemType === "mcq" ? "rule_based_mcq" : "llm_discrete_text",
        components: item.components,
      };
      return `(${jsonb(payload)})`;
    })
    .join(",\n");

  return `-- Generated by scripts/content-seed/physics-expansion/build.mjs
-- Subject: ${subject.prefix}; source fact pack: ${subject.factPackId}
begin;

create temporary table physics_expansion_payload (payload jsonb not null) on commit drop;
insert into physics_expansion_payload(payload) values
${itemRows};

do $$
declare
  live_frq integer;
  live_mcq integer;
  candidate_existing integer;
  mismatched integer;
begin
  select
    coalesce(max((regexp_match(content_key, '([0-9]+)$'))[1]::integer)
      filter (where item_type='frq'),0),
    coalesce(max((regexp_match(content_key, '([0-9]+)$'))[1]::integer)
      filter (where item_type='mcq'),0)
  into live_frq, live_mcq
  from app.content_items
  where exam_pack_version_id=${esc(subject.examPackVersionId)}
    and content_key like ${esc(`${subject.prefix}-%`)};

  select count(*) into candidate_existing
  from app.content_items ci
  join physics_expansion_payload p on p.payload->>'content_key'=ci.content_key
  where ci.exam_pack_version_id=${esc(subject.examPackVersionId)};

  select count(*) into mismatched
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  join physics_expansion_payload p on p.payload->>'content_key'=ci.content_key
  where ci.exam_pack_version_id=${esc(subject.examPackVersionId)}
    and md5(p.payload->>'stem') <> civ.content_hash;

  if mismatched > 0 then
    raise exception '${subject.prefix}: existing candidate key has a different stem/hash';
  end if;

  if not (
    (live_frq=${subject.frozenMaxFrq} and live_mcq=${subject.frozenMaxMcq} and candidate_existing=0)
    or
    (candidate_existing=40 and live_frq=${subject.frozenMaxFrq + subject.expectedFrq}
      and live_mcq=${subject.frozenMaxMcq + subject.expectedMcq})
  ) then
    raise exception '${subject.prefix}: live maxima changed (FRQ %, MCQ %, candidate_existing %)',
      live_frq, live_mcq, candidate_existing;
  end if;
end $$;

do $$
declare near_duplicates integer;
begin
  with candidate_tokens as (
    select p.payload->>'content_key' as content_key,
      array(
        select distinct token
        from regexp_split_to_table(
          lower(regexp_replace(p.payload->>'stem','[^[:alnum:]]+',' ','g')),
          '\\s+'
        ) token
        where length(token) > 2
      ) as tokens
    from physics_expansion_payload p
  ),
  existing_tokens as (
    select ci.content_key,
      array(
        select distinct token
        from regexp_split_to_table(
          lower(regexp_replace(civ.stem,'[^[:alnum:]]+',' ','g')),
          '\\s+'
        ) token
        where length(token) > 2
      ) as tokens
    from app.content_items ci
    join app.content_item_versions civ
      on civ.content_item_id=ci.id and civ.version_num=1
    where ci.exam_pack_version_id=${esc(subject.examPackVersionId)}
      and not exists (
        select 1 from physics_expansion_payload p
        where p.payload->>'content_key'=ci.content_key
      )
  ),
  pair_scores as (
    select c.content_key as candidate_key, e.content_key as existing_key,
      (
        select count(*)::numeric
        from unnest(c.tokens) token
        where token=any(e.tokens)
      ) / nullif(
        cardinality(c.tokens)+cardinality(e.tokens)-(
          select count(*)
          from unnest(c.tokens) token
          where token=any(e.tokens)
        ),0
      ) as jaccard_similarity
    from candidate_tokens c
    cross join existing_tokens e
  )
  select count(*) into near_duplicates
  from pair_scores
  where jaccard_similarity >= 0.72;

  if near_duplicates > 0 then
    raise exception '${subject.prefix}: candidate stems have % near-duplicate matches against existing content',
      near_duplicates;
  end if;
end $$;

insert into app.content_items
  (exam_pack_version_id,content_key,item_type,title,status,frq_form)
select
  ${esc(subject.examPackVersionId)}::uuid,
  payload->>'content_key',
  payload->>'item_type',
  payload->>'title',
  'draft',
  nullif(payload->>'frq_form','')
from physics_expansion_payload
on conflict (exam_pack_version_id,content_key) do nothing;

insert into app.content_item_versions
  (content_item_id,version_num,stem,stimulus,prompt_json,canonical_answer_1,
   content_hash,status,rubric_type,evaluator_strategy)
select ci.id,1,p.payload->>'stem',nullif(p.payload->>'stimulus',''),
  p.payload->'prompt_json',p.payload->>'canonical_answer_1',
  md5(p.payload->>'stem'),'draft',p.payload->>'rubric_type',p.payload->>'evaluator_strategy'
from physics_expansion_payload p
join app.content_items ci
  on ci.exam_pack_version_id=${esc(subject.examPackVersionId)}
 and ci.content_key=p.payload->>'content_key'
where not exists (
  select 1 from app.content_item_versions civ
  where civ.content_item_id=ci.id and civ.version_num=1
);

insert into app.mcq_choices
  (content_item_version_id,choice_key,choice_text,is_correct,rationale)
select civ.id,c->>'key',c->>'text',(c->>'correct')::boolean,c->>'rationale'
from physics_expansion_payload p
join app.content_items ci
  on ci.exam_pack_version_id=${esc(subject.examPackVersionId)}
 and ci.content_key=p.payload->>'content_key'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
cross join lateral jsonb_array_elements(p.payload->'components') c
where p.payload->>'item_type'='mcq'
on conflict (content_item_version_id,choice_key) do nothing;

insert into app.frq_criteria
  (content_item_version_id,criterion_key,learner_facing_text,points_possible,
   evidence_requirements,minimum_fix,accepted_variants)
select civ.id,c->>'key',c->>'text',(c->>'points')::integer,
  c->>'evidence',c->>'minimumFix',coalesce(c->'variants','[]'::jsonb)
from physics_expansion_payload p
join app.content_items ci
  on ci.exam_pack_version_id=${esc(subject.examPackVersionId)}
 and ci.content_key=p.payload->>'content_key'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
cross join lateral jsonb_array_elements(p.payload->'components') c
where p.payload->>'item_type'='frq'
on conflict (content_item_version_id,criterion_key) do nothing;

insert into app.content_review_assignments
  (content_item_version_id,reviewer_id,review_stage,review_kind,status,blind_group_id)
select civ.id,${esc(REVIEWER_ID)}::uuid,'tutor_question',
  p.payload->>'item_type','pending',gen_random_uuid()
from physics_expansion_payload p
join app.content_items ci
  on ci.exam_pack_version_id=${esc(subject.examPackVersionId)}
 and ci.content_key=p.payload->>'content_key'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
on conflict (content_item_version_id,reviewer_id,review_stage)
  where content_item_version_id is not null
do nothing;

do $$
declare bad integer;
begin
  select count(*) into bad
  from physics_expansion_payload p
  join app.content_items ci
    on ci.exam_pack_version_id=${esc(subject.examPackVersionId)}
   and ci.content_key=p.payload->>'content_key'
  join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
  where civ.content_hash<>md5(civ.stem)
     or ci.status<>'assigned' or civ.status<>'assigned'
     or (p.payload->>'item_type'='mcq' and
       ((select count(*) from app.mcq_choices c where c.content_item_version_id=civ.id)<>4
        or (select count(*) from app.mcq_choices c where c.content_item_version_id=civ.id and c.is_correct)<>1
        or (select count(*) from app.frq_criteria f where f.content_item_version_id=civ.id)<>0))
     or (p.payload->>'item_type'='frq' and
       ((select count(*) from app.frq_criteria f where f.content_item_version_id=civ.id)=0
        or (select count(*) from app.mcq_choices c where c.content_item_version_id=civ.id)<>0))
     or (select count(*) from app.content_review_assignments a
         where a.content_item_version_id=civ.id)<>1
     or not exists (
       select 1 from app.content_review_assignments a
       where a.content_item_version_id=civ.id
         and a.reviewer_id=${esc(REVIEWER_ID)}::uuid
         and a.review_stage='tutor_question'
         and a.review_kind=p.payload->>'item_type'
         and a.status='pending'
     );
  if bad<>0 then raise exception '${subject.prefix}: post-insert validation failed for % rows',bad; end if;
end $$;

commit;
`;
}

export function writeArtifacts(subjects, outputDirectory) {
  fs.mkdirSync(outputDirectory, { recursive: true });
  const manifest = {};
  for (const subject of subjects) {
    const items = validateSubject(subject);
    fs.writeFileSync(path.join(outputDirectory, `${subject.prefix}.sql`), buildSql(subject));
    manifest[subject.prefix] = items.map((item) => ({
      content_key: item.key,
      item_type: item.itemType,
      unit: item.unit,
      topic: item.topic,
      title: item.title,
      archetype: item.archetype,
      form: item.form,
    }));
  }
  fs.writeFileSync(path.join(outputDirectory, "manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`);
  return manifest;
}

export const dirname = path.dirname(fileURLToPath(import.meta.url));
