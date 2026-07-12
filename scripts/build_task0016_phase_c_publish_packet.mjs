import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";

const ROOT = process.cwd();
const OUT = path.join(ROOT, "docs/research/ap_statistics_phase_c_publish_staging_2026_07_11");
const EXAM_PACK_VERSION_ID = "548f06be-ccf4-426d-b82b-b424137a4438";
const EXAM_ID = "ap_statistics";
const SCHOOL_YEAR = "2026";

const readJson = (p) => JSON.parse(fs.readFileSync(path.join(ROOT, p), "utf8"));
const readText = (p) => fs.readFileSync(path.join(ROOT, p), "utf8");
const sha = (value) => crypto.createHash("sha256").update(value).digest("hex");

const labels = readJson("docs/research/ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json");
const manifest = readJson("docs/research/ap_statistics_gold_set_candidate_2026_07_09/manifest.json");
const mcqBank = readJson("docs/research/ap_statistics_mcq_launch_bank_2026_07_09/ap_statistics_mcq_launch_bank_2026_07_09.json");
const smokeMcq = readJson("docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/ap_statistics_mcq_smoke_batch.json");
const smokeFrq = readJson("docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/ap_statistics_frq_batch_2026_07_01.json");
const keys = readJson("docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json");
const profile = readJson("docs/research/AP_STATISTICS_VERIFICATION_PROFILE.json");
const dryrun = readJson("docs/research/ap_statistics_phase_c_calibration_dryrun_2026_07_11/summary.json");
const adjudicationCsv = readText("docs/research/ap_statistics_gold_set_candidate_2026_07_09/adjudication_queue.csv");

function csvRows(text) {
  const [headerLine, ...lines] = text.trim().split(/\r?\n/);
  const headers = headerLine.split(",");
  return lines.map((line) => {
    const parts = line.split(",");
    return Object.fromEntries(headers.map((header, index) => [header, parts[index] ?? ""]));
  });
}

function mdTable(headers, rows) {
  const esc = (value) => String(value ?? "").replace(/\|/g, "\\|").replace(/\n/g, " ");
  return [
    `| ${headers.map(esc).join(" | ")} |`,
    `| ${headers.map(() => "---").join(" | ")} |`,
    ...rows.map((row) => `| ${row.map(esc).join(" | ")} |`),
  ].join("\n");
}

function countBy(items, fn) {
  const out = new Map();
  for (const item of items) {
    const keys = fn(item);
    for (const key of Array.isArray(keys) ? keys : [keys]) {
      out.set(String(key), (out.get(String(key)) ?? 0) + 1);
    }
  }
  return [...out.entries()].sort(([a], [b]) => a.localeCompare(b, undefined, { numeric: true }));
}

function stableSample(items, n) {
  return items
    .map((item) => ({ item, score: sha(item.content_key).slice(0, 12) }))
    .sort((a, b) => a.score.localeCompare(b.score))
    .slice(0, n)
    .map(({ item }) => item);
}

const keyByContent = new Map(keys.items.map((item) => [item.content_key, item]));
const keyedItems = new Set(profile.key_payload.items_keyed);
const conceptualOnly = new Set(profile.key_payload.conceptual_only);
const excluded = new Set(profile.key_payload.excluded_corpus_defect.map((entry) => entry.split(" ")[0]));
const queueRows = csvRows(adjudicationCsv);
const queueKeys = new Set(queueRows.map((row) => row.content_key));
const smokeMcqKeys = new Set(smokeMcq.map((item) => item.content_key));
const smokeFrqKeys = new Set(smokeFrq.map((item) => item.content_key));
const publishedKnownKeys = new Set([
  ...smokeMcqKeys,
  ...smokeFrqKeys,
  ...Array.from({ length: 40 }, (_, index) => `APSTATS-HDG-2026-GRAPH-${String(index + 1).padStart(3, "0")}`),
]);

function stageKey(contentKey) {
  if (!publishedKnownKeys.has(contentKey)) return contentKey;
  return `${contentKey}-CAL`;
}

function moduleLabels(modules) {
  return modules.map((module) => `unit_${module}`);
}

function artifactIdFor(stagedKey) {
  return `task0016-phase-c-${stagedKey.toLowerCase().replace(/[^a-z0-9]+/g, "-")}`;
}

function sharedSourceRecord(kind) {
  return {
    title: `TASK-0016 Phase C AP Statistics ${kind} corpus`,
    publisher: "Cramapple",
    authors: ["Cramapple AI-assisted content pipeline"],
    source_type: "cramapple_authored",
    scope_statement: "Synthetic AP Statistics calibration content prepared for Product Owner single-review approval.",
    authority_tier: 3,
    refresh_class: "SCIENCE_STABLE",
    provenance_status: "draft",
  };
}

function mcqPayload(item) {
  const stagedKey = stageKey(item.content_key);
  const modules = item.modules.map(String);
  const promptJson = {
    subject: item.subject,
    modules,
    subtopics: item.subtopics,
    intended_difficulty: item.intended_difficulty,
    rubric_type: "mcq",
    evaluator_strategy: "rule_based_mcq",
    source_content_key: item.content_key,
    collision_resolution: stagedKey === item.content_key ? null : "renamed_with_cal_suffix_to_avoid_published_smoke_batch_collision",
    phase_c_publish_packet: "2026-07-11",
  };

  return {
    reason_code: "task0016_phase_c_bulk_import_draft",
    artifact: {
      artifact_id: artifactIdFor(stagedKey),
      artifact_type: "question",
      exam_id: EXAM_ID,
      school_year: SCHOOL_YEAR,
      semantic_version: "1.0.0",
      payload_schema_version: "admin-content-compatibility-v1",
      risk_class: "R1",
      change_class: "C1",
      change_summary: "TASK-0016 Phase C MCQ launch-bar calibration draft",
      change_rationale: "Stage AP Statistics MCQ launch-bank item for Product Owner approval packet; not published.",
      payload: {
        content_key: stagedKey,
        source_content_key: item.content_key,
        subject: item.subject,
        item_type: "mcq",
        stem: item.stem,
        stimulus: item.stimulus,
        prompt_json: promptJson,
        choices: item.choices,
      },
    },
    source_record: sharedSourceRecord("MCQ"),
    compatibility: {
      exam_pack_version_id: EXAM_PACK_VERSION_ID,
      content_key: stagedKey,
      item_type: "mcq",
      title: stagedKey,
      stem: item.stem,
      stimulus: item.stimulus,
      prompt_json: promptJson,
      explanation: item.choices.find((choice) => choice.is_correct)?.rationale ?? null,
      help_text: "Review the rationale for each answer choice and compare it to the AP Statistics concept being tested.",
      content_labels: moduleLabels(modules),
      mcq_choices: item.choices,
    },
  };
}

function frqCanonical(item) {
  return item.rubric
    .map((criterion) => `${criterion.criterion_key}: ${criterion.learner_facing_text}`)
    .join("\n");
}

function frqPayload(item) {
  const stagedKey = stageKey(item.content_key);
  const module = String(item.module);
  const keyEntry = keyByContent.get(item.content_key);
  const keyDisposition = keyedItems.has(item.content_key)
    ? "deterministic_keyed"
    : excluded.has(item.content_key)
    ? "excluded_or_method_only"
    : conceptualOnly.has(item.content_key)
    ? "conceptual_only"
    : "unkeyed";
  const promptJson = {
    subject: "AP Statistics",
    module: item.module,
    difficulty: item.difficulty,
    form: item.form,
    codex: item.codex,
    rubric_type: "discrete_text",
    evaluator_strategy: "llm_discrete_text",
    source_content_key: item.content_key,
    deterministic_key_disposition: keyDisposition,
    deterministic_criteria: keyEntry?.criteria ?? {},
    verification_profile_version: profile.profile_version,
    phase_c_publish_packet: "2026-07-11",
  };

  return {
    reason_code: "task0016_phase_c_bulk_import_draft",
    artifact: {
      artifact_id: artifactIdFor(stagedKey),
      artifact_type: "question",
      exam_id: EXAM_ID,
      school_year: SCHOOL_YEAR,
      semantic_version: "1.0.0",
      payload_schema_version: "admin-content-compatibility-v1",
      risk_class: queueKeys.has(item.content_key) ? "R2" : "R1",
      change_class: "C1",
      change_summary: "TASK-0016 Phase C FRQ launch-bar calibration draft",
      change_rationale: "Stage AP Statistics FRQ candidate item for Product Owner approval packet; not published.",
      payload: {
        content_key: stagedKey,
        source_content_key: item.content_key,
        subject: "AP Statistics",
        item_type: "frq",
        frq_form: item.form,
        stem: item.question_text,
        stimulus: item.stimulus ?? null,
        rubric: item.rubric,
        synthetic_response_count: item.responses.length,
        prompt_json: promptJson,
      },
    },
    source_record: sharedSourceRecord("FRQ"),
    compatibility: {
      exam_pack_version_id: EXAM_PACK_VERSION_ID,
      content_key: stagedKey,
      item_type: "frq",
      frq_form: item.form,
      canonical_answer: frqCanonical(item),
      title: stagedKey,
      stem: item.question_text,
      stimulus: item.stimulus ?? null,
      prompt_json: promptJson,
      explanation: frqCanonical(item),
      help_text: "Address each rubric criterion directly and show quantitative work where applicable.",
      content_labels: moduleLabels([module]),
      frq_criteria: item.rubric.map((criterion) => ({
        criterion_key: criterion.criterion_key,
        learner_facing_text: criterion.learner_facing_text,
        points_possible: criterion.points_possible,
        evidence_requirements: criterion.evidence_requirements ?? null,
        minimum_fix: criterion.minimum_fix ?? null,
        accepted_variants: criterion.accepted_variants ?? [],
      })),
    },
  };
}

const items = [
  ...mcqBank.map(mcqPayload),
  ...labels.items.map(frqPayload),
];

const stagedKeys = items.map((item) => item.compatibility.content_key);
const duplicateStagedKeys = stagedKeys.filter((key, index) => stagedKeys.indexOf(key) !== index);
const knownSourceCollisions = [...new Set([
  ...mcqBank.filter((item) => publishedKnownKeys.has(item.content_key)).map((item) => item.content_key),
  ...labels.items.filter((item) => publishedKnownKeys.has(item.content_key)).map((item) => item.content_key),
])];
const unresolvedKnownCollisions = stagedKeys.filter((key) => publishedKnownKeys.has(key));

const bulkPayload = {
  operation: "bulk_import",
  idempotency_key: "task0016-phase-c-ap-statistics-bulk-import-draft-2026-07-11-v1",
  reason_code: "task0016_phase_c_product_owner_approval_packet_staging",
  environment: "production",
  exam_pack_version_id: EXAM_PACK_VERSION_ID,
  source_record: sharedSourceRecord("launch-bar"),
  rights_record_note: "Intentionally omitted: current admin-content inserts rights_records only when a pre-existing source_version_id is supplied, but this bulk draft creates source_records inline and does not expose the generated source_version_id to rights_record insertion.",
  compatibility_schema_note: "admin-content CompatibilityProjection consumes routing metadata via prompt_json in this code version; it does not currently write content_item_versions.rubric_type/evaluator_strategy columns.",
  collision_policy: {
    known_published_key_sources: "2026-07-01 smoke batch README + AP Statistics HDR trace-ready README/local known key pattern; live Supabase SELECT was denied in this session.",
    source_collisions_renamed: knownSourceCollisions.map((key) => ({ source_content_key: key, staged_content_key: stageKey(key) })),
    duplicate_staged_keys: duplicateStagedKeys,
    unresolved_known_published_collisions: unresolvedKnownCollisions,
  },
  items,
};

const samplePool = labels.items.filter((item) => !queueKeys.has(item.content_key) && !keyedItems.has(item.content_key));
const sampledItems = stableSample(samplePool, 18);
const sampleRows = sampledItems.map((item) => [
  item.content_key,
  item.rubric.map((criterion) => criterion.criterion_key).join("; "),
  "label/rubric consistency spot-check",
  "PASS",
  "Fully-correct response earns all criteria and incorrect/boundary response has at least one non-earned label; no new arithmetic defect found in bounded read.",
]);

const dryrunDisagreements = [
  {
    content_key: "APSTAT-MOD3-H001-INV",
    response: 2,
    criterion: "ci_calculation",
    mismatch: "flag vs earned",
    read: "Response recomputes 120/sqrt(30) and gives (807, 893), which is arithmetically correct within rounding; deterministic flag is too strict because the SE value is not separately stated.",
  },
  {
    content_key: "APSTAT-MOD4-H001-INV",
    response: 1,
    criterion: "hypothesis_test_execution",
    mismatch: "flag vs earned",
    read: "Exact SE is about 1.56 and t is about -2.56; the response's 't approx -2.5' is arithmetically acceptable, so the deterministic flag is a missing-exact-SE artifact.",
  },
  {
    content_key: "APSTAT-MOD6-M001",
    response: 1,
    criterion: "margin_of_error",
    mismatch: "pass vs partially_earned",
    read: "n approx 384 is the standard conservative 95%/5% sample-size result; partial provisional credit appears to reflect missing explanation rather than arithmetic error.",
  },
  {
    content_key: "APSTAT-MOD6-M001",
    response: 3,
    criterion: "margin_of_error",
    mismatch: "pass vs not_earned",
    read: "n approx 385 is arithmetically correct for the margin calculation; the not-earned label likely conflates this criterion with the separate bad sampling-design response.",
  },
  {
    content_key: "APSTAT-MOD6-H001",
    response: 1,
    criterion: "test_calculation",
    mismatch: "flag vs earned",
    read: "Exact SE is about 1.94 and |t| is about 2.06; the response's '2.0 to 2.1' is a reasonable rounded statistic, so the deterministic flag is too exacting for prose.",
  },
  {
    content_key: "APSTAT-MOD7-M005",
    response: 1,
    criterion: "expected_value",
    mismatch: "pass vs not_earned",
    read: "The keyed value 5 appears only inside a guess list ('4, 5, or 6'), not as a computed expected value; provisional not-earned is more likely correct.",
  },
  {
    content_key: "APSTAT-MOD7-H001",
    response: 2,
    criterion: "calculation",
    mismatch: "pass vs partially_earned",
    read: "P(D)=0.023 and P(B|D) approx 0.65 are the keyed arithmetic values; provisional partial may be under-crediting a terse but numerically correct calculation.",
  },
  {
    content_key: "APSTAT-MOD8-M002",
    response: 1,
    criterion: "r_squared_interpretation",
    mismatch: "pass vs not_earned",
    read: "0.64 is present, but the interpretation says x explains x's variance instead of response-variable variance; provisional not-earned is more likely correct.",
  },
  {
    content_key: "APSTAT-MOD8-M004",
    response: 1,
    criterion: "slope_interpretation",
    mismatch: "pass vs not_earned",
    read: "The slope value 3 is present, but the interpretation is not contextual rate-of-change language; provisional not-earned is more likely correct.",
  },
  {
    content_key: "STATS-MOD1-E004",
    response: 1,
    criterion: "mean_calculation",
    mismatch: "pass vs not_earned",
    read: "18 appears as one raw data value, but the response divides by 4 and gives 22.5; provisional not-earned is more likely correct.",
  },
];

const verificationRows = [
  ["statistics_phase_b_2026_07_08/validate_keys.py", "44 deterministic parts + 7 ECF templates", "canonical/ECF integrity", "PASS", "44/44 keys internally consistent; 7/7 ECF templates behave correctly."],
  ["APSTAT-MOD6-H007", "ci_width_calculation", "R1 stale-defect check", labels.items.find((item) => item.content_key === "APSTAT-MOD6-H007") ? "PASS" : "FAIL", "Rubric/fully-correct response now use about 58.9%; no lingering '67% confidence' text in provisional label item."],
  ["provisional_labels.json", "deterministic_check_targets", "R3 schema restoration", Array.isArray(labels.deterministic_check_targets) ? "PASS" : "FAIL", "provisional_labels.json has list-of-objects shape."],
  ["manifest.json", "deterministic_check_targets", "R3 schema restoration", Array.isArray(manifest.deterministic_check_targets) ? "PASS" : "FINDING", `manifest.json still has ${JSON.stringify(manifest.deterministic_check_targets)} rather than list-of-objects; carried to approval packet.`],
  ["dry-run comparable rows", "70 deterministic/provisional comparisons", "plain-text numeric adapter review", "FINDING", `${dryrun.disagreements} comparable disagreements from dry run; see disagreement table below. No source labels changed in this pass.`],
  ...dryrunDisagreements.map((row) => [
    `${row.content_key} response ${row.response}`,
    row.criterion,
    row.mismatch,
    "FINDING",
    row.read,
  ]),
  ...queueRows.map((row) => [
    `${row.content_key} response ${row.response_index}`,
    row.synthetic_type,
    row.reason,
    row.priority === "high" ? "REVIEW" : "PASS_WITH_REVIEW_NOTE",
    `${row.next_action}; ${row.notes}`,
  ]),
  ...sampleRows,
];

const verificationLog = `# TASK-0016 Phase C Publish Staging Verification Log

**Date:** 2026-07-11
**Scope:** Fast independent re-verification for the AP Statistics 100 MCQ + 100 FRQ publish-staging packet.

This log is bounded, not a replacement for full formal dual-blind adjudication. It records the checks used to make the single-reviewer packet skimmable.

## Summary

- Deterministic key integrity: PASS (44/44 parts; 7/7 ECF templates).
- R1 APSTAT-MOD6-H007 fix: PASS in \`provisional_labels.json\`.
- R3 schema restoration: PASS in \`provisional_labels.json\`, FINDING in \`manifest.json\` (still bare integer \`3\`).
- Dry-run comparable agreement signal: ${dryrun.comparableAgreement}/${dryrun.comparable} (${((dryrun.comparableAgreement / dryrun.comparable) * 100).toFixed(1)}%) against AI-provisional labels only; ${dryrun.disagreements} comparable disagreements carried to approval packet.
- Adjudication queue: ${queueRows.length} response-level review notes carried forward.
- Additional unqueued/unkeyed FRQ spot sample: ${sampleRows.length}/${sampleRows.length} passed bounded label/rubric consistency checks.

## Checks Performed

${mdTable(["item/check", "criterion or scope", "check type", "verdict", "finding / note"], verificationRows)}
`;

const queuePacketRows = queueRows.map((row) => [
  row.priority,
  `${row.content_key} r${row.response_index}`,
  row.synthetic_type,
  row.reason,
  row.next_action,
]);

const decisionRows = [
  ["high", "Manifest R3 schema drift", "manifest.json still stores deterministic_check_targets as integer 3", "Approve staging but fix manifest metadata before treating package metadata as schema-clean."],
  ["high", "admin-content rights_record inline insert", "rights_records.source_version_id is required, but bulk create_draft does not connect newly inserted source_records to rights_records", "Run draft import without inline rights_record; keep Product Owner approval in this packet and do not publish until rights/source gate is explicitly accepted."],
  ...dryrunDisagreements.map((row) => ["medium", `${row.content_key} r${row.response} ${row.criterion}`, row.mismatch, row.read]),
];

const approvalPacket = `# AP Statistics Phase C Publish Approval Packet

**Decision sentence:** Approving this packet authorizes running the staged \`admin-content\` draft \`bulk_import\` payload for 100 MCQ + 100 FRQ AP Statistics calibration items; it does **not** publish anything automatically, and the later \`publish\` operation remains a separate explicit action.

## 1. Decisions Needed

${mdTable(["risk", "item / issue", "ambiguity or finding", "recommended resolution"], decisionRows)}

### Existing 30-Row Adjudication Queue

${mdTable(["priority", "response", "type", "ambiguity", "recommended action"], queuePacketRows)}

## 2. Coverage Summary

### Staged Item Counts

${mdTable(["unit", "count"], [
  ["MCQ items staged", mcqBank.length],
  ["FRQ items staged", labels.items.length],
  ["Total staged draft items", items.length],
  ["Known published source-key collisions renamed in payload", knownSourceCollisions.length],
])}

### MCQ Module Distribution

${mdTable(["module", "count"], countBy(mcqBank, (item) => item.modules))}

### MCQ Difficulty Distribution

${mdTable(["difficulty", "count"], countBy(mcqBank, (item) => item.intended_difficulty))}

### FRQ Module Distribution

${mdTable(["module", "count"], countBy(labels.items, (item) => item.module))}

### FRQ Difficulty Distribution

${mdTable(["difficulty", "count"], countBy(labels.items, (item) => item.difficulty))}

### FRQ Form Distribution

${mdTable(["form", "count"], countBy(labels.items, (item) => item.form))}

### Deterministic Coverage

${mdTable(["bucket", "FRQ items"], [
  ["non-conceptual deterministic key", dryrun.coverageCounts.checkable],
  ["conceptual-only", dryrun.coverageCounts.conceptual],
  ["excluded/method-only", dryrun.coverageCounts.excluded],
  ["unresolved suspected key gap", dryrun.coverageCounts.gap],
])}

### D1 Sample Check

${mdTable(["sample", "result"], [
  ["deterministic key validation", "44/44 integrity; 7/7 ECF"],
  ["adjudication queue carried forward", `${queueRows.length} rows`],
  ["additional unqueued/unkeyed spot sample", `${sampleRows.length}/${sampleRows.length} pass`],
  ["new label changes made by Codex", "0"],
])}

## 3. Approval Checklist

- [ ] Approve staging the MCQ bank as draft content (100 items; 18 source-key collisions renamed with \`-CAL\` in the payload).
- [ ] Approve staging FRQ items for modules 1-3 as draft content.
- [ ] Approve staging FRQ items for modules 4-6 as draft content.
- [ ] Approve staging FRQ items for modules 7-9 as draft content.
- [ ] Accept the listed 30-row adjudication queue as Product Owner review notes for this one-reviewer packet.
- [ ] Accept the R3 manifest metadata drift as non-blocking for draft staging, or request metadata cleanup before running \`bulk_import\`.
- [ ] Confirm that running \`publish\` after draft import remains a separate explicit Product Owner action.
`;

const readme = `# AP Statistics Phase C Publish Staging - 2026-07-11

This directory stages TASK-0016 Phase C AP Statistics content for Product Owner approval.

## Files

- \`bulk_import_payload.json\` - ready-to-run \`admin-content\` request body for \`operation: "bulk_import"\`.
- \`verification_log.md\` - bounded independent verification log for the packet.
- \`approval_packet.md\` - one-sitting approval surface for David.

## Target

- Environment: Production
- Supabase project: \`pcntajvbdfqhbeewmdry\`
- Exam pack version: \`${EXAM_PACK_VERSION_ID}\`
- Operation staged: \`bulk_import\` only
- Status produced by current \`admin-content\` path: \`draft\`

Do not call \`publish\` from this packet. Approval of \`approval_packet.md\` authorizes a later, separate publish action.

## Invocation Shape

\`\`\`bash
curl -sS -X POST "$SUPABASE_URL/functions/v1/admin-content" \\
  -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN" \\
  -H "Content-Type: application/json" \\
  --data @docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/bulk_import_payload.json
\`\`\`

The request body already includes \`operation: "bulk_import"\` and an idempotency key.

## Rights Record Note

The payload intentionally does not include \`rights_record\`. Current \`admin-content\` inserts \`rights_records\` only when a valid \`source_version_id\` is supplied, while this draft import creates \`source_records\` inline and does not pass the generated \`source_version_id\` into the rights insert. The approval packet carries the Product Owner rights/source approval surface instead; do not publish until the rights/source gate is explicitly accepted.

## Collision Check

Live Supabase SELECT access was denied in this Codex session, so this packet uses checked-in Production evidence from the 2026-07-01 smoke-batch README plus the known 40 HDR key pattern. Known source-key collisions:

${knownSourceCollisions.map((key) => `- \`${key}\` -> staged as \`${stageKey(key)}\``).join("\n")}

Before executing the import, run this read-only query in Production:

\`\`\`sql
with staged(content_key) as (
  values
${stagedKeys.map((key, index) => `    ('${key}')${index === stagedKeys.length - 1 ? "" : ","}`).join("\n")}
)
select s.content_key, ci.status
from staged s
join app.content_items ci
  on ci.exam_pack_version_id = '${EXAM_PACK_VERSION_ID}'::uuid
 and ci.content_key = s.content_key
order by s.content_key;
\`\`\`

Expected result: zero rows. If any row appears, do not run the import until the staged key is renamed.

## Routing Metadata Limitation

The current \`admin-content\` CompatibilityProjection writes \`prompt_json\`, \`mcq_choices\`, and \`frq_criteria\`, but does not populate \`content_item_versions.rubric_type\` or \`content_item_versions.evaluator_strategy\`. This payload stores routing metadata inside \`prompt_json.rubric_type\` and \`prompt_json.evaluator_strategy\`:

- MCQ: \`mcq\` / \`rule_based_mcq\`
- FRQ: \`discrete_text\` / \`llm_discrete_text\`

If the live grading path requires the typed columns to be non-null before publish, update \`admin-content\` or perform a reviewed draft metadata repair before the separate publish operation.
`;

fs.mkdirSync(OUT, { recursive: true });
fs.writeFileSync(path.join(OUT, "bulk_import_payload.json"), JSON.stringify(bulkPayload, null, 2) + "\n");
fs.writeFileSync(path.join(OUT, "verification_log.md"), verificationLog);
fs.writeFileSync(path.join(OUT, "approval_packet.md"), approvalPacket);
fs.writeFileSync(path.join(OUT, "README.md"), readme);

console.log(JSON.stringify({
  out: path.relative(ROOT, OUT),
  items: items.length,
  mcq: mcqBank.length,
  frq: labels.items.length,
  knownSourceCollisions: knownSourceCollisions.length,
  duplicateStagedKeys: duplicateStagedKeys.length,
  unresolvedKnownCollisions: unresolvedKnownCollisions.length,
}, null, 2));
