import { compilePlan } from "../subject-harness/compiler.ts";

const databaseUrl = Deno.args[0];
if (!databaseUrl) {
  throw new Error("usage: harness-db-regression.ts <disposable-database-url>");
}

const subjectKeys = ["ap-calculus-ab", "ap-calculus-bc", "ap-precalculus"];
const actor = "00000000-0000-0000-0000-000000000001";
const registry = JSON.parse(
  await Deno.readTextFile(
    "schemas/subject-onboarding/platform-capabilities.v1.json",
  ),
);
const literal = (value: string) => `'${value.replaceAll("'", "''")}'`;

async function sql(query: string) {
  const child = new Deno.Command("psql", {
    args: [
      databaseUrl,
      "--no-psqlrc",
      "--set=ON_ERROR_STOP=1",
      "--tuples-only",
    ],
    stdin: "piped",
    stdout: "piped",
    stderr: "piped",
  }).spawn();
  const writer = child.stdin.getWriter();
  await writer.write(new TextEncoder().encode(query));
  await writer.close();
  const result = await child.output();
  if (!result.success) throw new Error(new TextDecoder().decode(result.stderr));
  return new TextDecoder().decode(result.stdout).trim();
}

const results = [];
for (const subjectKey of subjectKeys) {
  const subject = JSON.parse(
    await Deno.readTextFile(
      `content/subject-packages/${subjectKey}.subject-package.json`,
    ),
  );
  const items = [];
  for await (
    const entry of Deno.readDir(`content/item-packages/${subjectKey}`)
  ) {
    if (entry.isFile && entry.name.endsWith(".json")) {
      items.push(
        JSON.parse(
          await Deno.readTextFile(
            `content/item-packages/${subjectKey}/${entry.name}`,
          ),
        ),
      );
    }
  }
  items.sort((a, b) => a.package_id.localeCompare(b.package_id));
  const plan = await compilePlan(subject, items, registry);

  const output = await sql(`do $$ declare
    v_subject uuid; v_pack uuid; v_pack_version uuid; v_item jsonb; v_content uuid;
    v_first_count int; v_result jsonb;
  begin
    insert into app.subjects(subject_key,display_name,status)
      values(${literal(subject.subject.subject_key)},${
    literal(subject.subject.display_name)
  },'active')
      returning id into v_subject;
    insert into app.exam_packs(exam_code,exam_name,subject_id)
      values(${literal(subject.exam_pack.exam_code)},${
    literal(subject.exam_pack.exam_name)
  },v_subject)
      returning id into v_pack;
    insert into app.exam_pack_versions(exam_pack_id,school_year,official_exam_date,status,created_by)
      values(v_pack,${literal(subject.exam_pack.school_year)},${
    literal(subject.exam_pack.official_exam_date)
  }::date,'draft',${literal(actor)}::uuid)
      returning id into v_pack_version;

    for v_item in select value from jsonb_array_elements(${
    literal(JSON.stringify(items))
  }::jsonb) loop
      insert into app.content_items(exam_pack_version_id,content_key,item_type,title,status,created_by)
        values(v_pack_version,v_item->>'content_key',v_item->>'item_type',v_item->>'content_key','draft',${
    literal(actor)
  }::uuid)
        returning id into v_content;
      insert into app.content_item_versions(content_item_id,version_num,stem,prompt_json,content_hash,status,created_by)
        values(v_content,(v_item->>'content_version')::int,v_item#>>'{parts,0,prompt}',v_item,
          v_item#>>'{provenance,content_sha256}','draft',${
    literal(actor)
  }::uuid);
    end loop;

    select count(*) into v_first_count from app.content_item_versions version
      join app.content_items item on item.id=version.content_item_id
      where item.exam_pack_version_id=v_pack_version;
    if v_first_count<>36 then raise exception 'CALCULUS_HARNESS:preseed_count_%',v_first_count; end if;

    v_result:=app.apply_subject_package_atomic(${
    literal(JSON.stringify(plan))
  }::jsonb,
      ${literal(actor)}::uuid,'local',null);
    if (select count(*) from app.content_item_versions version
      join app.content_items item on item.id=version.content_item_id
      where item.exam_pack_version_id=v_pack_version)<>36 then
      raise exception 'CALCULUS_HARNESS:version_was_duplicated';
    end if;
    if (select count(*) from app.content_item_versions version
      join app.content_items item on item.id=version.content_item_id
      where item.exam_pack_version_id=v_pack_version
        and version.item_package_sha256 is not null
        and version.item_package_payload=version.prompt_json
        and version.archetype_version_id is not null
        and version.status='draft')<>36 then
      raise exception 'CALCULUS_HARNESS:not_all_drafts_adopted';
    end if;
    if (select count(*) from app.item_package_applications application
      join app.subject_package_applications parent
        on parent.subject_package_application_id=application.subject_package_application_id
      where parent.package_id=${
    literal(subject.package_id)
  } and application.environment='local')<>36 then
      raise exception 'CALCULUS_HARNESS:item_application_count';
    end if;
    if exists(select 1 from app.content_review_assignments assignment
      join app.content_item_versions version on version.id=assignment.content_item_version_id
      join app.content_items item on item.id=version.content_item_id
      where item.exam_pack_version_id=v_pack_version) then
      raise exception 'CALCULUS_HARNESS:unexpected_assignment';
    end if;

    perform app.apply_subject_package_atomic(${
    literal(JSON.stringify(plan))
  }::jsonb,
      ${literal(actor)}::uuid,'local',null);
    if (select count(*) from app.subject_package_applications
      where package_id=${
    literal(subject.package_id)
  } and environment='local')<>1 then
      raise exception 'CALCULUS_HARNESS:subject_reapply_not_idempotent';
    end if;
  end $$;
  select ${
    literal(
      `${subjectKey.toUpperCase().replaceAll("-", "_")}_ATOMIC_HARNESS_PASS`,
    )
  };`);
  results.push({
    subject: subjectKey,
    items: items.length,
    plan_sha256: plan.plan_sha256,
    result: output.split("\n").at(-1)?.trim(),
  });
}

console.log(JSON.stringify({ valid: true, results }, null, 2));
