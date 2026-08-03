import { readFile } from "node:fs/promises";
import { homedir } from "node:os";

const projectRef = process.argv[2];
if (!/^[a-z0-9]{20}$/.test(projectRef ?? "")) {
  throw new Error("Usage: node scripts/task0019_concurrency_qa.mjs <project-ref>");
}

const accessToken =
  process.env.SUPABASE_ACCESS_TOKEN?.trim() ||
  (await readFile(`${homedir()}/.supabase/access-token`, "utf8")).trim();
const endpoint = `https://api.supabase.com/v1/projects/${projectRef}/database/query`;

async function query(sql) {
  const response = await fetch(endpoint, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${accessToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ query: sql }),
  });
  const body = await response.text();
  if (!response.ok) {
    throw new Error(`Supabase query failed (${response.status}): ${body}`);
  }
  return JSON.parse(body);
}

const idempotencyKey = `qa-concurrency-${Date.now()}`;
let targetId;
let sessionId;

try {
  const setup = await query(`
    with candidate as (
      select
        se.user_id,
        epv.id as exam_pack_version_id,
        civ.id as content_item_version_id
      from app.subject_entitlements se
      join app.exam_packs ep on ep.subject_id = se.subject_id
      join app.exam_pack_versions epv on epv.exam_pack_id = ep.id
      join app.content_items ci on ci.exam_pack_version_id = epv.id
      join app.content_item_versions civ on civ.content_item_id = ci.id
      where se.status = 'active'
        and se.starts_at <= now()
        and (se.ends_at is null or se.ends_at > now())
        and epv.status = 'published'
        and ci.status = 'published'
        and civ.status = 'published'
        and ci.item_type = 'mcq'
        and not exists (
          select 1
          from app.learning_sessions ls
          where ls.user_id = se.user_id
            and ls.status = 'active'
        )
      order by se.user_id, epv.id, civ.id
      limit 1
    )
    select
      candidate.user_id,
      candidate.exam_pack_version_id,
      public.issue_session_target(
        candidate.user_id,
        candidate.exam_pack_version_id,
        'first_session',
        '${idempotencyKey}',
        jsonb_build_array(jsonb_build_object(
          'content_item_version_id', candidate.content_item_version_id
        )),
        '{"formats":["mcq"]}'::jsonb,
        '{"source":"task0019_concurrency_qa"}'::jsonb,
        '{"mode":"reissue"}'::jsonb,
        5,
        900
      ) as issued
    from candidate;
  `);

  const row = setup[0];
  if (!row?.issued?.target_id) {
    throw new Error("No eligible disposable concurrency-test candidate");
  }
  targetId = row.issued.target_id;

  const consumeSql = `
    select public.consume_session_target(
      '${row.user_id}'::uuid,
      '${targetId}'::uuid,
      '${row.exam_pack_version_id}'::uuid
    ) as consumed;
  `;
  const [left, right] = await Promise.all([query(consumeSql), query(consumeSql)]);
  const results = [left[0]?.consumed, right[0]?.consumed];
  if (
    results.some((result) => result?.ok !== true) ||
    results[0].learning_session_id !== results[1].learning_session_id ||
    results.filter((result) => result.idempotent_replay === false).length !== 1 ||
    results.filter((result) => result.idempotent_replay === true).length !== 1
  ) {
    throw new Error(`Concurrent consume invariant failed: ${JSON.stringify(results)}`);
  }
  sessionId = results[0].learning_session_id;
  console.log(
    JSON.stringify({
      passed: true,
      sameLearningSession: true,
      oneIdempotentReplay: true,
    }),
  );
} finally {
  if (targetId) {
    await query(`
      delete from app.session_targets where id = '${targetId}'::uuid;
      ${
        sessionId
          ? `delete from app.learning_sessions where id = '${sessionId}'::uuid;`
          : ""
      }
    `);
  }
}
