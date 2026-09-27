// open-hand-item — gated "face-up" content read for the Open Hand teaching
// templates (Plate loop).
//
// Open Hand deliberately shows the full answer key: the correct MCQ choice and
// per-choice rationale, and the FRQ rubric criteria plus the credited-response
// segments. The regular practice serving path (student-session-items) NEVER
// returns any of that — it is stripped so a student practising can't read the
// answer. This function is the ONE place that answer content is exposed to a
// student, and only:
//   1. to an authenticated user (requireProfile), and
//   2. who holds an active entitlement for the item's subject (or is staff/QA).
// Practice/exam grading never calls this function, so the answer key cannot
// leak into a graded attempt.
//
// It does NOT grade, does NOT create attempts, and writes nothing.

import { requireProfile } from "../_shared/auth.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";

type ServiceClient = ReturnType<typeof createServiceClient>;

// Mirrors app.STAFF_QA_ROLES in _shared/student-item-delivery.ts. Inlined to
// keep this function's dependency tree minimal (it only needs the one set).
const STAFF_QA_ROLES: ReadonlySet<string> = new Set([
  "admin",
  "content_author",
  "tutor",
  "reader",
  "validator",
]);

function isStaffQaRole(role: string): boolean {
  return STAFF_QA_ROLES.has(role);
}

export interface OpenHandItemDeps {
  requireProfile?: typeof requireProfile;
  service?: ServiceClient;
}

const DEFAULT_LIMIT = 20;
const MAX_LIMIT = 50;

function norm(value: unknown): string | null {
  return typeof value === "string" && value.trim()
    ? value.trim().toLowerCase()
    : null;
}

// Stable bias: items whose primary topic/cell matches the target move to the
// front in their original order; nothing is filtered or dropped.
function biasByTopic<T extends { topic_code: string | null; cell_code: string | null }>(
  items: T[],
  topic: string | null,
  cell: string | null,
): T[] {
  const t = norm(topic);
  const c = norm(cell);
  if (!t && !c) return items;
  const hits: T[] = [];
  const rest: T[] = [];
  for (const item of items) {
    const match =
      (c && norm(item.cell_code) === c) || (t && norm(item.topic_code) === t);
    (match ? hits : rest).push(item);
  }
  return [...hits, ...rest];
}

export async function handleOpenHandItem(
  req: Request,
  deps: OpenHandItemDeps = {},
): Promise<Response> {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") {
    return respond({ ok: true }, { status: 200 });
  }
  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const authenticate = deps.requireProfile ?? requireProfile;
  const profileResult = await authenticate(req);
  if (!profileResult) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }
  const { user, profile } = profileResult;

  const body = (await readJsonBody(req)) as Record<string, unknown> | null;
  if (!body) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }
  const examPackVersionId =
    typeof body.exam_pack_version_id === "string"
      ? body.exam_pack_version_id
      : null;
  if (!examPackVersionId) {
    return respond({ error: "exam_pack_version_id_required" }, { status: 400 });
  }
  const itemType = body.item_type === "frq" ? "frq" : "mcq";
  const targetTopic = typeof body.topic === "string" ? body.topic : null;
  const targetCell = typeof body.cell === "string" ? body.cell : null;
  const limit = Math.min(
    MAX_LIMIT,
    Math.max(1, Number.isFinite(body.limit) ? Number(body.limit) : DEFAULT_LIMIT),
  );

  const service = deps.service ?? createServiceClient();

  // --- Resolve the subject that owns this exam pack version -----------------
  const { data: epv, error: epvError } = await service
    .schema("app")
    .from("exam_pack_versions")
    .select(
      "id, status, exam_pack:exam_packs!inner(id, subject_id, subject:subjects!inner(id, subject_key, status))",
    )
    .eq("id", examPackVersionId)
    .maybeSingle();

  if (epvError) {
    return respond({ error: "exam_pack_lookup_failed" }, { status: 500 });
  }
  if (!epv) {
    return respond({ error: "exam_pack_version_not_found" }, { status: 404 });
  }
  if (epv.status !== "published") {
    return respond({ error: "exam_pack_version_not_published" }, { status: 409 });
  }
  const pack = Array.isArray(epv.exam_pack) ? epv.exam_pack[0] : epv.exam_pack;
  const subject = pack && (Array.isArray(pack.subject) ? pack.subject[0] : pack.subject);
  const subjectId: string | null = subject?.id ?? null;
  const subjectKey: string | null = subject?.subject_key ?? null;
  if (!subjectId || !subjectKey) {
    return respond({ error: "subject_not_found" }, { status: 404 });
  }

  // --- Entitlement gate (answer keys are exposed here) ----------------------
  // Staff/QA roles bypass, mirroring the serving path. Every other user must
  // hold an active entitlement for this subject (or an all-subjects grant),
  // valid in its start/end window.
  const staff = isStaffQaRole(profile.role);
  if (!staff) {
    const nowIso = new Date().toISOString();
    const { data: ents, error: entError } = await service
      .schema("app")
      .from("subject_entitlements")
      .select("id, subject_id, all_subjects, status, starts_at, ends_at")
      .eq("user_id", user.id)
      .eq("status", "active");
    if (entError) {
      return respond({ error: "entitlement_lookup_failed" }, { status: 500 });
    }
    const entitled = (ents ?? []).some((e) => {
      const subjectOk = e.all_subjects === true || e.subject_id === subjectId;
      const started = !e.starts_at || e.starts_at <= nowIso;
      const notEnded = !e.ends_at || e.ends_at > nowIso;
      return subjectOk && started && notEnded;
    });
    if (!entitled) {
      return respond({ error: "entitlement_required" }, { status: 403 });
    }
  }

  // --- Select published items of this type for the subject ------------------
  const { data: versionRows, error: versionError } = await service
    .schema("app")
    .from("content_item_versions")
    .select(
      "id, content_item_id, stem, stimulus, stimulus_image_path, prompt_json, canonical_answer_1, canonical_answer_2, published_at, content_items!inner(id, item_type, content_key, title, exam_pack_version_id, status)",
    )
    .eq("status", "published")
    .eq("content_items.exam_pack_version_id", examPackVersionId)
    .eq("content_items.item_type", itemType)
    .eq("content_items.status", "published")
    .order("published_at", { ascending: true })
    .limit(MAX_LIMIT);

  if (versionError) {
    return respond({ error: "content_lookup_failed" }, { status: 500 });
  }
  const versions = (versionRows ?? []) as Array<Record<string, unknown>>;
  if (versions.length === 0) {
    return respond(
      { subject_key: subjectKey, item_type: itemType, items: [], reference: {}, deep_dive: {} },
      { status: 200 },
    );
  }
  const versionIds = versions.map((v) => v.id as string);

  // --- Primary topic/cell per item (for taxonomy + biasing) -----------------
  const { data: cellRows } = await service
    .schema("app")
    .from("content_item_cells")
    .select("content_item_version_id, topic_code, skill_code, is_primary")
    .in("content_item_version_id", versionIds);
  const topicByVersion = new Map<string, { topic_code: string | null; skill_code: string | null }>();
  for (const row of (cellRows ?? []) as Array<Record<string, unknown>>) {
    const vid = row.content_item_version_id as string;
    // Prefer the primary assignment; otherwise take the first seen.
    if (row.is_primary === true || !topicByVersion.has(vid)) {
      topicByVersion.set(vid, {
        topic_code: (row.topic_code as string) ?? null,
        skill_code: (row.skill_code as string) ?? null,
      });
    }
  }

  // --- Face-up answer content, batched --------------------------------------
  const choicesByVersion = new Map<string, Array<Record<string, unknown>>>();
  const criteriaByVersion = new Map<string, Array<Record<string, unknown>>>();
  const spansByVersion = new Map<string, Array<Record<string, unknown>>>();

  if (itemType === "mcq") {
    const { data: choiceRows, error: choiceError } = await service
      .schema("app")
      .from("mcq_choices")
      .select("content_item_version_id, choice_key, choice_text, is_correct, rationale")
      .in("content_item_version_id", versionIds);
    if (choiceError) {
      return respond({ error: "choices_lookup_failed" }, { status: 500 });
    }
    for (const row of (choiceRows ?? []) as Array<Record<string, unknown>>) {
      const vid = row.content_item_version_id as string;
      const list = choicesByVersion.get(vid) ?? [];
      list.push(row);
      choicesByVersion.set(vid, list);
    }
  } else {
    const [{ data: critRows, error: critError }, { data: spanRows, error: spanError }] =
      await Promise.all([
        service
          .schema("app")
          .from("frq_criteria")
          .select(
            "content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants",
          )
          .in("content_item_version_id", versionIds),
        service
          .schema("app")
          .from("canonical_answer_spans")
          .select(
            "content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys",
          )
          .in("content_item_version_id", versionIds)
          .order("span_ordinal", { ascending: true }),
      ]);
    if (critError) return respond({ error: "criteria_lookup_failed" }, { status: 500 });
    if (spanError) return respond({ error: "spans_lookup_failed" }, { status: 500 });
    for (const row of (critRows ?? []) as Array<Record<string, unknown>>) {
      const vid = row.content_item_version_id as string;
      const list = criteriaByVersion.get(vid) ?? [];
      list.push(row);
      criteriaByVersion.set(vid, list);
    }
    for (const row of (spanRows ?? []) as Array<Record<string, unknown>>) {
      const vid = row.content_item_version_id as string;
      const list = spansByVersion.get(vid) ?? [];
      list.push(row);
      spansByVersion.set(vid, list);
    }
  }

  // --- Reference (topic_explainers) + Deep Dive (topic_point_briefs) --------
  const topicCodes = Array.from(
    new Set(
      Array.from(topicByVersion.values())
        .map((t) => t.topic_code)
        .filter((c): c is string => Boolean(c)),
    ),
  );
  const reference: Record<string, unknown> = {};
  const deepDive: Record<string, unknown> = {};
  if (topicCodes.length > 0) {
    const [{ data: explainers }, { data: briefs }] = await Promise.all([
      service
        .schema("app")
        .from("topic_explainers")
        .select("*")
        .eq("subject_key", subjectKey)
        .eq("status", "published")
        .in("topic_code", topicCodes),
      service
        .schema("app")
        .from("topic_point_briefs")
        .select("*")
        .eq("subject_key", subjectKey)
        .eq("status", "published")
        .in("topic_code", topicCodes),
    ]);
    for (const row of (explainers ?? []) as Array<Record<string, unknown>>) {
      reference[row.topic_code as string] = row;
    }
    for (const row of (briefs ?? []) as Array<Record<string, unknown>>) {
      deepDive[row.topic_code as string] = row;
    }
  }

  // --- Assemble the ordered, biased item list -------------------------------
  const assembled = versions.map((v) => {
    const vid = v.id as string;
    const ci = (Array.isArray(v.content_items) ? v.content_items[0] : v.content_items) as
      | Record<string, unknown>
      | undefined;
    const topic = topicByVersion.get(vid) ?? { topic_code: null, skill_code: null };
    const base = {
      content_item_version_id: vid,
      content_item_id: v.content_item_id as string,
      item_type: itemType,
      content_key: (ci?.content_key as string) ?? null,
      title: (ci?.title as string) ?? null,
      stem: v.stem ?? null,
      stimulus: v.stimulus ?? null,
      stimulus_image_path: v.stimulus_image_path ?? null,
      prompt_json: v.prompt_json ?? null,
      topic_code: topic.topic_code,
      cell_code: topic.skill_code,
    };
    if (itemType === "mcq") {
      return {
        ...base,
        choices: (choicesByVersion.get(vid) ?? []).map((c) => ({
          choice_key: c.choice_key,
          choice_text: c.choice_text,
          is_correct: c.is_correct === true,
          rationale: c.rationale ?? null,
        })),
      };
    }
    return {
      ...base,
      canonical_answer_1: v.canonical_answer_1 ?? null,
      canonical_answer_2: v.canonical_answer_2 ?? null,
      criteria: (criteriaByVersion.get(vid) ?? []).map((c) => ({
        criterion_key: c.criterion_key,
        learner_facing_text: c.learner_facing_text,
        points_possible: c.points_possible,
        evidence_requirements: c.evidence_requirements ?? null,
        minimum_fix: c.minimum_fix ?? null,
        accepted_variants: c.accepted_variants ?? null,
      })),
      credited_response_spans: (spansByVersion.get(vid) ?? []).map((s) => ({
        answer_field: s.answer_field,
        span_ordinal: s.span_ordinal,
        span_text: s.span_text,
        criterion_keys: s.criterion_keys ?? null,
      })),
    };
  });

  const biased = biasByTopic(assembled, targetTopic, targetCell).slice(0, limit);

  return respond(
    {
      subject_key: subjectKey,
      item_type: itemType,
      items: biased,
      reference,
      deep_dive: deepDive,
    },
    { status: 200 },
  );
}

Deno.serve((req) => handleOpenHandItem(req));
