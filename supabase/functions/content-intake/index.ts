import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function asUuid(value: unknown) {
  return typeof value === "string" &&
      /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/
        .test(value)
    ? value
    : null;
}

function asStringArray(value: unknown) {
  if (Array.isArray(value)) {
    return value.filter((entry) => typeof entry === "string")
      .map((entry) => entry.trim())
      .filter(Boolean);
  }

  if (typeof value === "string") {
    return value
      .split(/[|,;]/)
      .map((entry) => entry.trim())
      .filter(Boolean);
  }

  return [];
}

function normalizeRows(value: unknown) {
  return Array.isArray(value)
    ? value.filter((entry) => entry && typeof entry === "object" &&
      !Array.isArray(entry)) as Record<string, unknown>[]
    : [];
}

function normalizeReviewStage(row: Record<string, unknown>) {
  const raw = asString(row.review_stage)?.toLowerCase() ??
    asString(row.stage)?.toLowerCase() ??
    "";
  const canonicalAnswerHint = Boolean(
    asString(row.canonical_answer) ||
      asString(row.rubric_summary) ||
      asString(row.criterion_notes),
  );

  if (raw.includes("discussion")) return "difficulty_discussion";
  if (raw.includes("reader") && raw.includes("answer")) return "answer";
  if (raw.includes("reader") && raw.includes("question")) return "question";
  if (raw.includes("answer")) {
    return canonicalAnswerHint ? "canonical_answer" : "answer";
  }
  if (canonicalAnswerHint || raw.includes("frq")) return "canonical_answer";
  return "question";
}

function normalizeReviewKind(row: Record<string, unknown>) {
  const raw = asString(row.question_type)?.toLowerCase() ??
    asString(row.type)?.toLowerCase() ??
    "";
  return raw.includes("frq") ? "frq" : "mcq";
}

// Extracts the short/long FRQ distinction from the upload row.
// Returns null when the row is not an FRQ or the form cannot be determined.
function normalizeFrqForm(row: Record<string, unknown>): string | null {
  const kind = normalizeReviewKind(row);
  if (kind !== "frq") return null;

  const explicit = asString(row.frq_form)?.toLowerCase();
  if (explicit === "short" || explicit === "long") return explicit;

  const qt = asString(row.question_type)?.toLowerCase() ??
    asString(row.type)?.toLowerCase() ??
    "";
  if (qt === "short_frq") return "short";
  if (qt === "long_frq") return "long";

  return null;
}

async function loadProfile(req: Request) {
  const profileResult = await requireProfile(req);
  if (!profileResult) return null;
  const role = profileResult.profile.role as string;
  if (role !== "admin" && role !== "content_author") {
    return null;
  }
  return profileResult;
}

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") {
    return respond({ ok: true }, { status: 200 });
  }

  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }

  const profileResult = await loadProfile(req);
  if (!profileResult) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const bodyRecord = body as Record<string, unknown>;
  const rows = normalizeRows(bodyRecord.rows);
  if (!rows.length) {
    return respond({ error: "missing_rows" }, { status: 400 });
  }

  const subjectId = asUuid(bodyRecord.subject_id);
  const subjectKey = asString(bodyRecord.subject_key);
  const examPackVersionId = asUuid(bodyRecord.exam_pack_version_id);
  const uploadFormat = asString(bodyRecord.upload_format) ?? "csv";
  const rawTemplate = asString(bodyRecord.raw_template) ?? "";
  const parserVersion = asString(bodyRecord.parser_version) ??
    "ux-002-template-v1";
  const originalFilename = asString(bodyRecord.original_filename);
  const defaultAssignedReviewerId = asUuid(
    bodyRecord.default_assigned_reviewer_id,
  );
  const defaultBlindGroupId = asUuid(bodyRecord.blind_group_id);
  const parsedTemplate = bodyRecord.parsed_template &&
      typeof bodyRecord.parsed_template === "object" &&
      !Array.isArray(bodyRecord.parsed_template)
    ? bodyRecord.parsed_template as Record<string, unknown>
    : {};

  const service = createServiceClient();
  let resolvedSubjectId = subjectId;
  if (!resolvedSubjectId && subjectKey) {
    const { data: subjectRow } = await service.schema("app")
      .from("subjects")
      .select("id")
      .eq("subject_key", subjectKey)
      .maybeSingle();
    resolvedSubjectId = subjectRow?.id as string | undefined ?? null;
  }

  if (!resolvedSubjectId) {
    return respond({ error: "missing_subject" }, { status: 400 });
  }

  const { data: batchRow, error: batchError } = await service.schema("app")
    .from("content_ingest_batches")
    .insert({
      subject_id: resolvedSubjectId,
      exam_pack_version_id: examPackVersionId,
      upload_format: uploadFormat,
      original_filename: originalFilename,
      raw_template: rawTemplate,
      parsed_template: parsedTemplate,
      parser_version: parserVersion,
      parse_status: "parsed",
      row_count: rows.length,
      created_by: profileResult.user.id,
    })
    .select("batch_id, subject_id, exam_pack_version_id, upload_format, original_filename, parser_version, parse_status, row_count, created_at")
    .maybeSingle();

  if (batchError || !batchRow) {
    return respond({ error: "batch_insert_failed" }, { status: 500 });
  }

  const ingestRows = rows.map((row, index) => ({
    batch_id: batchRow.batch_id,
    row_number: index + 1,
    row_key: asString(row.item_id) ?? asString(row.id),
    review_stage: normalizeReviewStage(row),
    question_type: normalizeReviewKind(row),
    frq_form: normalizeFrqForm(row),
    stem: asString(row.stem) ?? "",
    answer_letter: asString(row.answer_letter) ?? null,
    answer_text: asString(row.answer_text) ?? null,
    canonical_answer: asString(row.canonical_answer) ?? null,
    modules: asStringArray(row.modules),
    subtopics: asStringArray(row.subtopics),
    change_request: asString(row.change_request) ?? null,
    notes: asString(row.notes) ?? null,
    row_payload: row,
    ingest_status: "parsed",
    created_by: profileResult.user.id,
  }));

  const { data: insertedRows, error: rowsError } = await service.schema("app")
    .from("content_ingest_rows")
    .insert(ingestRows)
    .select("ingest_row_id, row_number, row_key, review_stage, question_type, frq_form, stem, answer_letter, answer_text, canonical_answer, modules, subtopics, ingest_status")
    .order("row_number", { ascending: true });

  if (rowsError) {
    return respond({ error: "row_insert_failed" }, { status: 500 });
  }

  const rowsByKey = new Map(
    (insertedRows ?? []).map((row) => [
      row.row_number as number,
      row as Record<string, unknown>,
    ]),
  );

  // Create an assignment for every row that has a reviewer specified.
  // content_item_version_id is null at this point — set when promoted via admin-content.
  const assignments = ingestRows
    .map((row, index) => ({
      row,
      inserted: rowsByKey.get(index + 1),
    }))
    .filter(({ row, inserted }) =>
      Boolean(
        inserted &&
          (defaultAssignedReviewerId ||
            asUuid(row.row_payload.assigned_reviewer_id)),
      ),
    )
    .map(({ row, inserted }) => ({
      ingest_row_id: inserted?.ingest_row_id as string,
      content_item_version_id: null,
      review_stage: normalizeReviewStage(row.row_payload),
      review_kind: normalizeReviewKind(row.row_payload),
      reviewer_id:
        asUuid(row.row_payload.assigned_reviewer_id) ?? defaultAssignedReviewerId,
      blind_group_id:
        asUuid(row.row_payload.blind_group_id) ?? defaultBlindGroupId,
      due_at: asString(row.row_payload.due_at),
      created_by: profileResult.user.id,
    }));

  let insertedAssignments: unknown[] = [];
  if (assignments.length) {
    const { data: assignmentRows, error: assignmentError } = await service
      .schema("app")
      .from("content_review_assignments")
      .insert(assignments)
      .select(
        "content_review_assignment_id, ingest_row_id, content_item_version_id, review_stage, review_kind, reviewer_id, blind_group_id, due_at, status, created_at",
      );

    if (assignmentError) {
      return respond({ error: "assignment_insert_failed" }, { status: 500 });
    }

    insertedAssignments = assignmentRows ?? [];
  }

  return respond(
    {
      status: "ok",
      function: "content-intake",
      batch: batchRow,
      rows: insertedRows ?? [],
      assignments: insertedAssignments,
    },
    { status: 200 },
  );
});
