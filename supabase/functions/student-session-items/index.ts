// TASK-0021 — student-authorized prompt-visual delivery.
// Task: docs/tasks/TASK-0021-BIOLOGY-PROMPT-VISUAL-STUDENT-DELIVERY.md
//
// Serves render-ready practice items to the student who owns a learning
// session, including short-TTL signed URLs for required prompt visuals.
//
// Two request shapes share the same ownership + visibility gates and the same
// signing/delivery path (`deliverRows`):
//   1. ORDINARY QUEUE (default): POST { learning_session_id, limit? } — serves the
//      session's practice_format selection via select_practice_frqs.
//   2. CONFIRM-TRANSFER (Course Mode, SESSION_ASSEMBLY §7.1): POST
//      { learning_session_id, confirm_transfer: { source_content_item_version_id } }
//      — serves at most ONE different published item tagged to the SAME content
//      cell as the source item (app.select_confirm_transfer_item), so a correct
//      follow-up can confirm transfer before a cell earns full `independent`.
//      Additive and out-of-band: it selects nothing from, and mutates nothing in,
//      the ordinary session-target queue; the ordinary queue cursor lives entirely
//      client-side. Fail-closed: when no valid parallel item exists (no same-cell
//      approved MCQ, a numeric-answer cell that is excluded, an untagged source, or
//      a candidate withheld by the media gate) it returns `item: null` with a
//      reason so the client never makes a false "same skill" claim.
//
// Why this is here instead of a role grant on storage-sign-url: content-assets
// is a private bucket that also holds authoring/reviewer-only material, so
// widening canAccessBucket for `student` would expose far more than the item
// a student is being served. This mirrors review-queue's pattern instead --
// sign with the service role, scoped per request to exactly the assets the
// caller is entitled to right now. This function never accepts a bucket or
// path from the client; every path comes from the database.
//
// Two independent gates, both enforced here and both fail-closed:
//   1. Eligibility -- the caller owns an active session whose exam pack and
//      practice_format actually select this item version. This is the same
//      contract attempt-response enforces at submission
//      (attempt-response/index.ts:286-310), applied earlier, before delivery.
//   2. Student-visibility -- a required visual is only sent to a student when
//      app.content_asset_metadata carries approved accessibility text
//      (approved_at IS NOT NULL). Staff/QA roles may render unapproved assets
//      so the delivery path can be exercised before Learning Quality sign-off;
//      students cannot. See 20260805100000_content_asset_metadata.sql.

import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";
import {
  applyItemPackageFallback,
  type AssetMetadata,
  annotateOpenHandExclusions,
  buildRenderItem,
  buildResolvedCells,
  indexAssets,
  isStaffQaRole,
  type ItemPackagePayload,
  type LearnerFacingCriterion,
  MAX_ITEMS,
  type McqChoice,
  type Omission,
  partitionDeliverable,
  type RenderItem,
  type SelectedRow,
  SIGNED_URL_TTL_SECONDS,
  STIMULUS_IMAGE_BUCKET,
  type TopicResolutionRow,
  type VisualRequirement,
} from "../_shared/student-item-delivery.ts";

type ServiceClient = ReturnType<typeof createServiceClient>;

// Dependency seams for tests: production wires the real service client + auth
// via `Deno.serve` at the bottom of the file; a test injects in-memory fakes so
// the confirm-transfer branch, ownership gates, and fail-closed rules are
// exercised without a database. Mirrors capture-pairing's handler DI.
type StudentSessionItemsDeps = {
  service?: ServiceClient;
  requireProfile?: typeof requireProfile;
};

// FF-15. "session_practice_format_unset" is a third, pre-existing case that
// already carried a reason before this fix; kept out of the type so the
// early-return literal continues to narrow correctly.
type EmptyQueueReason = "no_matching_content" | "all_items_omitted";

const UUID_RE =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function asUuid(value: unknown) {
  return typeof value === "string" && UUID_RE.test(value.trim())
    ? value.trim()
    : null;
}

function asPositiveInt(value: unknown, fallback: number) {
  const parsed = Number(value);
  if (!Number.isInteger(parsed) || parsed < 1) return fallback;
  return Math.min(parsed, MAX_ITEMS);
}

// Every selector RPC (select_practice_frqs, select_unit_gated_practice_items,
// select_confirm_transfer_item, select_hand_drawn_pilot_items) returns a raw
// prompt_json column. This is the ONLY place that column is read -- it
// derives the single safe boolean SelectedRow.hand_drawn and prompt_json
// itself is discarded, so nothing downstream (buildRenderItem, RenderItem)
// ever has to carry or filter the rest of prompt_json (which holds
// answer-bearing fields like expected_graph_spec). TASK-0038 Phase 3.
function withHandDrawnFlag(
  rows: ReadonlyArray<SelectedRow & { prompt_json?: unknown }>,
): SelectedRow[] {
  return rows.map(({ prompt_json, ...row }) => ({
    ...row,
    hand_drawn: typeof prompt_json === "object" && prompt_json !== null &&
      (prompt_json as Record<string, unknown>).hand_drawn === true,
  }));
}

// Only these three columns are ever read from frq_criteria. The same table
// carries evidence_requirements, minimum_fix, and accepted_variants, which are
// answer-bearing and must never reach a student. Verified 2026-08-05.
const LEARNER_FACING_CRITERION_COLUMNS =
  "content_item_version_id, criterion_key, learner_facing_text, points_possible";

// Shared signing + delivery for a set of selected rows. Fetches learner-facing
// criteria + asset/visual metadata, applies the student-visibility gate
// (partitionDeliverable), signs only what survives both gates, and builds the
// whitelist render payload. Both request shapes route through this so the
// answer-safety and fail-closed rules live in exactly one place.
type DeliverResult =
  | { ok: true; items: RenderItem[]; omitted: Omission[]; expiresAt: string }
  | { ok: false; error: "item_details_failed" | "stimulus_image_sign_failed" };

async function deliverRows(
  service: ServiceClient,
  rows: SelectedRow[],
  qaMode: boolean,
): Promise<DeliverResult> {
  const versionIds = rows
    .map((r) => r.content_item_version_id)
    .filter((id): id is string => Boolean(id));

  const expiresAt = new Date(
    Date.now() + SIGNED_URL_TTL_SECONDS * 1000,
  ).toISOString();

  if (!versionIds.length) {
    return { ok: true, items: [], omitted: [], expiresAt };
  }

  const [
    criteriaResult,
    assetResult,
    visualResult,
    choicesResult,
    packageResult,
    resolutionResult,
  ] = await Promise.all([
      service.schema("app").from("frq_criteria")
        .select(LEARNER_FACING_CRITERION_COLUMNS)
        .in("content_item_version_id", versionIds)
        .order("criterion_key", { ascending: true }),
      service.schema("app").from("content_asset_metadata")
        .select(
          "content_item_version_id, storage_bucket, storage_path, alt_text, long_description, approved_at",
        )
        .in("content_item_version_id", versionIds),
      service.schema("app").from("content_visual_requirements")
        .select("content_item_version_id, image_needed, image_approval")
        .in("content_item_version_id", versionIds),
      // Only choice_key/choice_text -- is_correct and rationale are
      // answer-bearing and must never reach a student (same rule as
      // frq_criteria's evidence_requirements/minimum_fix above).
      service.schema("app").from("mcq_choices")
        .select("content_item_version_id, choice_key, choice_text")
        .in("content_item_version_id", versionIds)
        .order("choice_key", { ascending: true }),
      // TASK-0047 Workstream E -- dual-read adapter. Fetched unconditionally
      // for every request (cheap: at most MAX_ITEMS=20 rows, same versionIds
      // already used above) rather than only when legacy data looks empty,
      // so this never becomes a second, order-dependent round trip. Only used
      // as a fallback below -- see applyItemPackageFallback.
      service.schema("app").from("content_item_versions")
        .select("id, item_package_payload")
        .in("id", versionIds),
      // TASK-0047 Decision 17 follow-on / Phase 1 step 5 -- resolved
      // topic/cell identity, read from the single canonical view
      // (CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md §3.2). The view
      // already carries topic_title/unit_number and already excludes
      // anything that isn't a primary assignment -- no second query, no
      // client-side merge of two source tables.
      service.schema("app").from("content_item_topic_resolution")
        .select("content_item_version_id, topic_code, skill_code, topic_title, unit_number")
        .in("content_item_version_id", versionIds),
    ]);

  if (
    criteriaResult.error || assetResult.error || visualResult.error ||
    choicesResult.error || packageResult.error || resolutionResult.error
  ) {
    return { ok: false, error: "item_details_failed" };
  }

  const resolutionRows = (resolutionResult.data ?? []) as TopicResolutionRow[];
  const cellByVersion = buildResolvedCells(rows, resolutionRows);

  const criteriaByVersion = new Map<string, LearnerFacingCriterion[]>();
  for (const row of (criteriaResult.data ?? []) as LearnerFacingCriterion[]) {
    const list = criteriaByVersion.get(row.content_item_version_id) ?? [];
    list.push(row);
    criteriaByVersion.set(row.content_item_version_id, list);
  }

  const choicesByVersion = new Map<string, McqChoice[]>();
  for (
    const row of (choicesResult.data ?? []) as Array<
      McqChoice & { content_item_version_id: string }
    >
  ) {
    const list = choicesByVersion.get(row.content_item_version_id) ?? [];
    list.push({ choice_key: row.choice_key, choice_text: row.choice_text });
    choicesByVersion.set(row.content_item_version_id, list);
  }

  const assetByKey = indexAssets(
    (assetResult.data ?? []) as AssetMetadata[],
  );

  const visualByVersion = new Map<string, VisualRequirement>();
  for (const row of (visualResult.data ?? []) as VisualRequirement[]) {
    visualByVersion.set(row.content_item_version_id, row);
  }

  const packageByVersion = new Map<string, ItemPackagePayload>();
  for (
    const row of (packageResult.data ?? []) as Array<
      { id: string; item_package_payload: ItemPackagePayload | null }
    >
  ) {
    if (row.item_package_payload) {
      packageByVersion.set(row.id, row.item_package_payload);
    }
  }

  // TASK-0047 Workstream E -- dual-read adapter. A no-op against every
  // published item today (all have complete legacy rows); backfills stem/
  // stimulus/mcq choices from item_package_payload only when the legacy
  // columns for that version came back empty. See student-item-delivery.ts
  // for the shape-handling and scope notes.
  const fallback = applyItemPackageFallback(
    rows,
    choicesByVersion,
    packageByVersion,
  );
  const rowsWithFallback = fallback.rows;
  const choicesByVersionWithFallback = fallback.choicesByVersion;

  const { deliverable, omitted } = partitionDeliverable(
    rowsWithFallback,
    assetByKey,
    qaMode,
    visualByVersion,
  );

  const pathsToSign = Array.from(
    new Set(
      deliverable
        .map((d) => d.asset?.storage_path)
        .filter((p): p is string => Boolean(p)),
    ),
  );

  const signedByPath = new Map<string, string>();
  if (pathsToSign.length) {
    const { data: signedUrls, error: signError } = await service.storage
      .from(STIMULUS_IMAGE_BUCKET)
      .createSignedUrls(pathsToSign, SIGNED_URL_TTL_SECONDS);

    if (signError) {
      return { ok: false, error: "stimulus_image_sign_failed" };
    }
    for (const entry of signedUrls ?? []) {
      if (entry?.path && entry.signedUrl && !entry.error) {
        signedByPath.set(entry.path, entry.signedUrl);
      }
    }
  }

  const items: RenderItem[] = [];
  for (const { row, asset } of deliverable) {
    const choices =
      choicesByVersionWithFallback.get(row.content_item_version_id) ?? null;
    if (row.item_type === "mcq" && (!choices || choices.length === 0)) {
      // An MCQ without choices cannot be answered. Fail closed per item rather
      // than rendering an empty choice set or failing the whole mixed queue.
      omitted.push({
        content_key: row.content_key,
        reason: "choices_missing",
      });
      continue;
    }
    const item = buildRenderItem(
      row,
      asset,
      asset ? signedByPath.get(asset.storage_path) ?? null : null,
      expiresAt,
      criteriaByVersion.get(row.content_item_version_id) ?? [],
      choices,
      cellByVersion.get(row.content_item_version_id) ?? null,
    );
    if (!item) {
      // Survived the gates but could not be signed. Still a missing required
      // visual -- omit rather than ship an unanswerable item. This is the
      // selection-time half of the fail-closed rule.
      omitted.push({
        content_key: row.content_key,
        reason: "asset_sign_failed",
      });
      continue;
    }
    items.push(item);
  }

  return { ok: true, items, omitted, expiresAt };
}

export async function handleStudentSessionItems(
  req: Request,
  deps: StudentSessionItemsDeps = {},
): Promise<Response> {
  const authenticate = deps.requireProfile ?? requireProfile;
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
  const input = body as Record<string, unknown>;

  const learningSessionId = asUuid(
    input.learning_session_id ?? input.learningSessionId,
  );
  if (!learningSessionId) {
    return respond(
      { error: "missing_required_fields", required: ["learning_session_id"] },
      { status: 400 },
    );
  }
  const limit = asPositiveInt(input.limit, MAX_ITEMS);

  // "unit_gated" additionally serves mcq/quantitative alongside frq, scoped by
  // the student's real course-position unit via select_unit_gated_practice_items
  // (TASK-0025). "hand_drawn_pilot" (TASK-0038) serves ONLY items explicitly
  // promoted to human_graded_pilot_approved via select_hand_drawn_pilot_items
  // -- a caller must ask for this mode by name, it is never blended into the
  // ordinary queue. "cell_scoped" (CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md
  // Phase 2) serves every published MCQ for the session's exam pack version,
  // mirroring the Lovable client's retired buildPublishedMcqQuery filters
  // exactly (item_type = 'mcq', item + version status = 'published') --
  // subject-agnostic in the backend; today only the AP Statistics pilot asks
  // for it by name. Deliberately not capped to a small queue window: the
  // caller (use-session.ts) holds the whole pool in memory and re-scopes/
  // reorders it locally, so a partial slice would silently corrupt that
  // client-side logic. Default "frq_only" keeps the original TASK-0021
  // behaviour (select_practice_frqs) unchanged for existing callers. The
  // confirm-transfer branch ignores mode entirely -- it always serves one
  // same-cell item.
  const ordinaryMode = input.mode === "unit_gated"
    ? "unit_gated" as const
    : input.mode === "hand_drawn_pilot"
    ? "hand_drawn_pilot" as const
    : input.mode === "cell_scoped"
    ? "cell_scoped" as const
    : "frq_only" as const;
  const itemTypeFilter = typeof input.item_type === "string"
    ? input.item_type
    : null;

  // Confirm-transfer is requested by a nested object so the ordinary contract is
  // byte-for-byte unchanged for callers that never send it.
  const confirmTransfer = input.confirm_transfer ?? input.confirmTransfer;
  const confirmTransferRequested = confirmTransfer != null;
  const sourceContentItemVersionId = confirmTransferRequested
    ? asUuid(
      (confirmTransfer as Record<string, unknown>)
        ?.source_content_item_version_id ??
        (confirmTransfer as Record<string, unknown>)
          ?.sourceContentItemVersionId,
    )
    : null;
  if (confirmTransferRequested && !sourceContentItemVersionId) {
    return respond(
      {
        error: "missing_required_fields",
        required: ["confirm_transfer.source_content_item_version_id"],
      },
      { status: 400 },
    );
  }

  const profileResult = await authenticate(req);
  if (!profileResult) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }
  const { user, profile } = profileResult;

  const service = deps.service ?? createServiceClient();

  try {
    // ── Gate 1: session eligibility ─────────────────────────────────────────
    const { data: session, error: sessionError } = await service
      .schema("app")
      .from("learning_sessions")
      .select(
        "id, user_id, exam_pack_version_id, practice_format, status, exam_pack_version:exam_pack_versions!inner(exam_pack:exam_packs!inner(exam_code))",
      )
      .eq("id", learningSessionId)
      .maybeSingle();

    if (sessionError || !session) {
      return respond({ error: "session_not_found" }, { status: 404 });
    }
    // Ownership. Admin may inspect another user's session for support/QA;
    // every other role -- including staff -- may only read its own.
    if (session.user_id !== user.id && profile.role !== "admin") {
      return respond({ error: "forbidden" }, { status: 403 });
    }
    if (session.status !== "active") {
      return respond({ error: "session_not_active" }, { status: 409 });
    }

    const qaMode = isStaffQaRole(profile.role);
    const embeddedPackVersion = Array.isArray(session.exam_pack_version)
      ? session.exam_pack_version[0]
      : session.exam_pack_version;
    const embeddedPack = Array.isArray(embeddedPackVersion?.exam_pack)
      ? embeddedPackVersion.exam_pack[0]
      : embeddedPackVersion?.exam_pack;
    const sessionExamCode = typeof embeddedPack?.exam_code === "string"
      ? embeddedPack.exam_code
      : null;

    // ── Confirm-transfer branch (Course Mode §7.1) ──────────────────────────
    if (confirmTransferRequested) {
      // The source must exist and belong to THIS session's exam pack, or a
      // client could pull a transfer item from an unrelated pack. Same
      // exam-pack scoping the ordinary path and attempt-response enforce.
      const { data: sourceVersion, error: sourceError } = await service
        .schema("app")
        .from("content_item_versions")
        .select("id, content_items!inner(exam_pack_version_id)")
        .eq("id", sourceContentItemVersionId)
        .maybeSingle();
      if (sourceError || !sourceVersion) {
        return respond({ error: "source_item_not_found" }, { status: 404 });
      }
      const sourceItem = Array.isArray(sourceVersion.content_items)
        ? sourceVersion.content_items[0]
        : sourceVersion.content_items;
      if (
        !sourceItem ||
        sourceItem.exam_pack_version_id !== session.exam_pack_version_id
      ) {
        return respond({ error: "session_content_mismatch" }, { status: 409 });
      }

      const { data: selected, error: selectError } = await service
        .schema("app")
        .rpc("select_confirm_transfer_item", {
          _exam_pack_version_id: session.exam_pack_version_id,
          _source_content_item_version_id: sourceContentItemVersionId,
        });
      if (selectError) {
        return respond({ error: "item_selection_failed" }, { status: 500 });
      }

      // select_confirm_transfer_item only ever returns MCQs (item_type='mcq'
      // filter in the RPC); tag them so the delivery layer marks them mcq and
      // the client renders answer choices rather than an FRQ textarea.
      const rows = withHandDrawnFlag(
        (selected ?? []) as SelectedRow[],
      ).map((r) => ({
        ...r,
        item_type: "mcq",
      }));
      // Fail-closed: no valid parallel item (no same-cell approved MCQ, a
      // numeric-answer cell that is excluded, or an untagged source).
      if (!rows.length) {
        return respond({
          status: "ok",
          function: "student-session-items",
          result: {
            mode: "confirm_transfer",
            source_content_item_version_id: sourceContentItemVersionId,
            item: null,
            reason: "no_parallel_item",
            omitted: [],
          },
        });
      }

      const delivered = await deliverRows(service, rows, qaMode);
      if (!delivered.ok) {
        return respond({ error: delivered.error }, { status: 500 });
      }
      // A candidate withheld by the media gate is also fail-closed: return no
      // item (+ the omission reason) rather than an unanswerable transfer.
      const item = delivered.items[0] ?? null;
      return respond({
        status: "ok",
        function: "student-session-items",
        result: {
          mode: "confirm_transfer",
          source_content_item_version_id: sourceContentItemVersionId,
          item,
          reason: item ? null : "no_parallel_item",
          signed_url_ttl_seconds: SIGNED_URL_TTL_SECONDS,
          omitted: delivered.omitted,
        },
      });
    }

    // ── Ordinary queue path ─────────────────────────────────────────────────
    let selected: unknown[] | null;
    let selectError: { message: string } | null;

    if (ordinaryMode === "unit_gated") {
      // Real course position drives real unit-gating. A student who has never
      // set one (unit_id null, source 'unknown') defaults to unit 1 -- the
      // conservative "start from the beginning" reading -- rather than passing
      // null and letting the RPC's not-null requirement surface as an opaque
      // 500.
      const { data: positionRow, error: positionError } = await service
        .schema("app")
        .from("student_course_positions")
        .select("unit_id")
        .eq("user_id", session.user_id)
        .eq("exam_pack_version_id", session.exam_pack_version_id)
        .maybeSingle();
      if (positionError) {
        return respond({ error: "course_position_lookup_failed" }, {
          status: 500,
        });
      }
      const currentUnit = positionRow?.unit_id ?? 1;

      ({ data: selected, error: selectError } = await service.rpc(
        "select_unit_gated_practice_items",
        {
          _exam_pack_version_id: session.exam_pack_version_id,
          _current_unit: currentUnit,
          _practice_format: session.practice_format ?? null,
          _item_type: itemTypeFilter,
          _limit: limit,
        },
      ));
    } else if (ordinaryMode === "cell_scoped") {
      // Mirrors buildPublishedMcqQuery's filters (src/lib/use-published-mcq.ts,
      // Lovable "New Cramapple App"): published MCQ content_items joined to
      // their published content_item_versions, scoped to this session's exam
      // pack version. No practice_format requirement -- MCQs on this path
      // were never gated by it (targeted_drill/full_exam_frq is an FRQ-only
      // concept). Two queries instead of one RPC: content_key/title/frq_form/
      // practice_format live on app.content_items, stem/stimulus/prompt_json
      // live on app.content_item_versions, and PostgREST embedding across
      // schemas from the service client is more brittle than a plain in()
      // fetch here.
      const { data: parentRows, error: parentError } = await service
        .schema("app")
        .from("content_items")
        .select("id, content_key, title, frq_form, practice_format")
        .eq("exam_pack_version_id", session.exam_pack_version_id)
        .eq("item_type", "mcq")
        .eq("status", "published");
      if (parentError) {
        selected = null;
        selectError = parentError;
      } else {
        const parentIds = (parentRows ?? []).map((r) => r.id as string);
        if (!parentIds.length) {
          selected = [];
          selectError = null;
        } else {
          const { data: versionRows, error: versionError } = await service
            .schema("app")
            .from("content_item_versions")
            .select(
              "id, content_item_id, stem, stimulus, stimulus_image_path, prompt_json, published_at",
            )
            .in("content_item_id", parentIds)
            .eq("status", "published")
            .order("published_at", { ascending: true });
          if (versionError) {
            selected = null;
            selectError = versionError;
          } else {
            const parentById = new Map(
              (parentRows ?? []).map((
                r,
              ) => [r.id as string, r as {
                id: string;
                content_key: string;
                title: string;
                frq_form: string | null;
                practice_format: string | null;
              }]),
            );
            selected = ((versionRows ?? []) as Array<{
              id: string;
              content_item_id: string;
              stem: string;
              stimulus: string | null;
              stimulus_image_path: string | null;
              prompt_json: unknown;
              published_at: string | null;
            }>)
              .map((v) => {
                const parent = parentById.get(v.content_item_id);
                if (!parent) return null;
                return {
                  content_item_version_id: v.id,
                  content_item_id: v.content_item_id,
                  content_key: parent.content_key,
                  title: parent.title,
                  stem: v.stem,
                  stimulus: v.stimulus,
                  stimulus_image_path: v.stimulus_image_path,
                  prompt_json: v.prompt_json,
                  frq_form: parent.frq_form,
                  practice_format: parent.practice_format,
                  item_type: "mcq",
                };
              })
              .filter((r): r is NonNullable<typeof r> => r !== null)
              .slice(0, limit);
            selectError = null;
          }
        }
      }
    } else if (ordinaryMode === "hand_drawn_pilot") {
      // No practice_format requirement -- pilot items aren't tied to the
      // targeted_drill/full_exam_frq model (APBIO-HDG-2026-GRAPH-002 carries
      // practice_format=null). select_hand_drawn_pilot_items does its own
      // complete filtering (published, hand_drawn, promoted label_status).
      ({ data: selected, error: selectError } = await service.rpc(
        "select_hand_drawn_pilot_items",
        {
          _exam_pack_version_id: session.exam_pack_version_id,
          _limit: limit,
        },
      ));
    } else {
      // select_practice_frqs has no NULL fallback by design. Mirror that here
      // rather than substituting a default -- a session with no format must
      // serve nothing, not quietly serve targeted drills.
      if (!session.practice_format) {
        return respond({
          status: "ok",
          function: "student-session-items",
          result: {
            learning_session_id: learningSessionId,
            items: [],
            omitted: [],
            reason: "session_practice_format_unset",
          },
        });
      }

      if (
        sessionExamCode === "ap_biology" &&
        session.practice_format === "targeted_drill"
      ) {
        ({ data: selected, error: selectError } = await service
          .schema("app")
          .rpc("select_biology_practice_items", {
            _exam_pack_version_id: session.exam_pack_version_id,
            _practice_format: session.practice_format,
            _selection_seed: learningSessionId,
            _limit: limit,
          }));
      } else if (
        sessionExamCode === "ap_statistics" &&
        (
          session.practice_format === "targeted_drill" ||
          session.practice_format === "mcq"
        )
      ) {
        ({ data: selected, error: selectError } = await service
          .schema("app")
          .rpc("select_ordinary_combined_practice_items", {
            _exam_pack_version_id: session.exam_pack_version_id,
            _practice_format: session.practice_format,
            _selection_seed: learningSessionId,
            _limit: limit,
          }));
      } else {
        ({ data: selected, error: selectError } = await service.rpc(
          "select_practice_frqs",
          {
            _exam_pack_version_id: session.exam_pack_version_id,
            _practice_format: session.practice_format,
            _limit: limit,
          },
        ));
      }
    }
    if (selectError) {
      return respond({ error: "item_selection_failed" }, { status: 500 });
    }

    const rows = withHandDrawnFlag((selected ?? []) as SelectedRow[]);
    const delivered = await deliverRows(service, rows, qaMode);
    if (!delivered.ok) {
      return respond({ error: delivered.error }, { status: 500 });
    }

    // FF-15: an empty queue used to report `status: ok, items: []` with no
    // indication of why -- indistinguishable from "you finished everything."
    // Distinguish the two ways it can happen: the selector RPC had nothing
    // matching this pool/unit/format (no_matching_content), versus it
    // returned candidates that the media/answerability gates then withheld
    // (all_items_omitted, detail in `omitted`). A non-empty result never
    // needs a reason.
    const emptyQueueReason: EmptyQueueReason | null = delivered.items.length > 0
      ? null
      : rows.length === 0
      ? "no_matching_content"
      : "all_items_omitted";

    // TASK-0051 / DECISION-0086. Mark items whose answer key this student has
    // already seen in Open Hand. Deliberately a MARK, not a filter: dropping
    // them would make an excluded item look like one that does not exist, and
    // the client needs to show the student why it cannot be scored.
    const annotatedItems = await annotateOpenHandExclusions(
      service,
      user.id,
      delivered.items,
    );

    return respond({
      status: "ok",
      function: "student-session-items",
      result: {
        learning_session_id: learningSessionId,
        practice_format: session.practice_format,
        qa_mode: qaMode,
        signed_url_ttl_seconds: SIGNED_URL_TTL_SECONDS,
        items: annotatedItems,
        omitted: delivered.omitted,
        reason: emptyQueueReason,
      },
    });
  } catch (error) {
    console.error("student-session-items", error);
    return respond({ error: "student_session_items_failed" }, { status: 500 });
  }
}

if (import.meta.main) {
  Deno.serve((req) => handleStudentSessionItems(req));
}
