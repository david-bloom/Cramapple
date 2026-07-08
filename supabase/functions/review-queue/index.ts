import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

type QueueAssignment = {
  content_review_assignment_id: string;
  ingest_row_id: string | null;
  content_item_version_id: string | null;
  review_stage: string;
  review_kind: string | null;
  reviewer_id: string;
  blind_group_id: string | null;
  due_at: string | null;
  status: string;
  created_at: string;
};

type ContentVersion = {
  id: string;
  content_item_id: string;
  version_num: number;
  stem: string;
  stimulus: string | null;
  explanation: string | null;
  frq_form: string | null;
  review_status: string | null;
  status: string;
};

type ContentItem = {
  id: string;
  content_key: string;
  item_type: string;
  title: string;
};

type McqChoice = {
  content_item_version_id: string;
  choice_key: string;
  choice_text: string;
  is_correct: boolean;
  rationale: string | null;
};

type FrqCriterion = {
  content_item_version_id: string;
  criterion_key: string;
  learner_facing_text: string;
  points_possible: number;
};

const OPEN_STATUSES = new Set([
  "assigned",
  "pending",
  "opened",
  "in_progress",
]);

async function loadProfile(req: Request) {
  const profileResult = await requireProfile(req);
  if (!profileResult) return null;
  const role = profileResult.profile.role as string;
  if (role !== "admin" && role !== "tutor" && role !== "reader") {
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

  if (req.method !== "GET") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const profileResult = await loadProfile(req);
  if (!profileResult) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const service = createServiceClient();
  const reviewerId = profileResult.user.id;
  const reviewerRole = profileResult.profile.role as string;
  const queueScope = typeof profileResult.profile.review_queue_scope === "string"
    ? profileResult.profile.review_queue_scope
    : "my_queue";
  const includeAllPending = queueScope === "all_pending";

  // ── Assignments ─────────────────────────────────────────────────────────────

  let assignmentQuery = service
    .schema("app")
    .from("content_review_assignments")
    .select(
      "content_review_assignment_id, ingest_row_id, content_item_version_id, review_stage, review_kind, reviewer_id, blind_group_id, due_at, status, created_at",
    );

  if (!includeAllPending) {
    assignmentQuery = assignmentQuery.eq("reviewer_id", reviewerId);
  }

  const { data: assignments, error: assignmentsError } = await assignmentQuery
    .order("due_at", { ascending: true, nullsFirst: false });

  if (assignmentsError) {
    return respond({ error: "queue_lookup_failed" }, { status: 500 });
  }

  const assignmentRows = ((assignments ?? []) as QueueAssignment[])
    .filter((assignment) => OPEN_STATUSES.has(assignment.status));
  const assignmentIds = assignmentRows.map(
    (r) => r.content_review_assignment_id,
  );
  const contentVersionIds = assignmentRows
    .map((r) => r.content_item_version_id)
    .filter((id): id is string => id !== null);

  if (assignmentRows.length === 0) {
    return respond(
      {
        status: "ok",
        function: "review-queue",
        reviewer: {
          reviewer_id: reviewerId,
          reviewer_role: reviewerRole,
          review_queue_scope: queueScope,
          can_see_all_pending: includeAllPending,
        },
        scope: includeAllPending ? "all_pending" : "mine",
        queue: [],
        counts: {},
      },
      { status: 200 },
    );
  }

  // ── Parallel fetch: decisions, content versions, labels ─────────────────────

  const [
    decisionResult,
    labelResult,
    contentVersionResult,
  ] = await Promise.all([
    service.schema("app").from("content_review_decisions")
      .select(
        "content_review_decision_id, content_review_assignment_id, content_item_version_id, review_stage, tutor_score, difficulty_label, concern_codes, note, answer_key, answer_approval, reader_decision, supersedes_id, submitted_at, created_at",
      )
      .in("content_review_assignment_id", assignmentIds),

    service.schema("app").from("content_review_assignment_labels")
      .select("content_review_assignment_id, content_label_id, created_at")
      .in("content_review_assignment_id", assignmentIds),

    contentVersionIds.length
      ? service.schema("app").from("content_item_versions")
        .select(
          "id, content_item_id, version_num, stem, stimulus, explanation, frq_form, review_status, status",
        )
        .in("id", contentVersionIds)
      : Promise.resolve({ data: [], error: null as null }),
  ]);

  if (decisionResult.error || labelResult.error || (contentVersionResult as { error?: unknown }).error) {
    return respond({ error: "queue_details_failed" }, { status: 500 });
  }

  const decisions = (decisionResult.data ?? []) as Array<Record<string, unknown>>;
  const reviewLabels = (labelResult.data ?? []) as Array<Record<string, unknown>>;
  const contentVersions = ((contentVersionResult as { data?: unknown[] }).data ?? []) as ContentVersion[];

  // ── Content items (for item_type, content_key, title) ───────────────────────

  const contentItemIds = contentVersions
    .map((v) => v.content_item_id)
    .filter(Boolean);

  const [contentItemResult, mcqChoiceResult, frqCriterionResult] =
    await Promise.all([
      contentItemIds.length
        ? service.schema("app").from("content_items")
          .select("id, content_key, item_type, title")
          .in("id", contentItemIds)
        : Promise.resolve({ data: [], error: null as null }),

      contentVersionIds.length
        ? service.schema("app").from("mcq_choices")
          .select(
            "content_item_version_id, choice_key, choice_text, is_correct, rationale",
          )
          .in("content_item_version_id", contentVersionIds)
          .order("choice_key", { ascending: true })
        : Promise.resolve({ data: [], error: null as null }),

      contentVersionIds.length
        ? service.schema("app").from("frq_criteria")
          .select(
            "content_item_version_id, criterion_key, learner_facing_text, points_possible",
          )
          .in("content_item_version_id", contentVersionIds)
          .order("criterion_key", { ascending: true })
        : Promise.resolve({ data: [], error: null as null }),
    ]);

  const contentItems = ((contentItemResult as { data?: unknown[] }).data ?? []) as ContentItem[];
  const mcqChoices = ((mcqChoiceResult as { data?: unknown[] }).data ?? []) as McqChoice[];
  const frqCriteria = ((frqCriterionResult as { data?: unknown[] }).data ?? []) as FrqCriterion[];
  const reviewerIds = [
    ...new Set(assignmentRows.map((assignment) => assignment.reviewer_id)),
  ];

  const reviewerProfilesResult = reviewerIds.length
    ? await service.schema("app")
      .from("profiles")
      .select("user_id, full_name, role")
      .in("user_id", reviewerIds)
    : { data: [] as Array<Record<string, unknown>>, error: null };
  const reviewerProfiles = Array.isArray(reviewerProfilesResult.data)
    ? reviewerProfilesResult.data
    : [];

  // ── Index lookups ────────────────────────────────────────────────────────────

  const versionById = new Map(contentVersions.map((v) => [v.id, v]));
  const itemById = new Map(contentItems.map((i) => [i.id, i]));
  const reviewerById = new Map(
    ((reviewerProfiles ?? []) as Array<Record<string, unknown>>).map((p) => [
      String(p.user_id),
      {
        user_id: String(p.user_id),
        full_name: typeof p.full_name === "string" ? p.full_name : null,
        role: typeof p.role === "string" ? p.role : null,
      },
    ]),
  );

  const choicesByVersion = mcqChoices.reduce(
    (acc, c) => {
      const list = acc.get(c.content_item_version_id) ?? [];
      list.push(c);
      acc.set(c.content_item_version_id, list);
      return acc;
    },
    new Map<string, McqChoice[]>(),
  );

  const criteriaByVersion = frqCriteria.reduce(
    (acc, c) => {
      const list = acc.get(c.content_item_version_id) ?? [];
      list.push(c);
      acc.set(c.content_item_version_id, list);
      return acc;
    },
    new Map<string, FrqCriterion[]>(),
  );

  // ── Build the queue ──────────────────────────────────────────────────────────

  const queue = assignmentRows.map((assignment) => {
    const versionId = assignment.content_item_version_id;
    const version = versionId ? versionById.get(versionId) : null;
    const item = version ? itemById.get(version.content_item_id) : null;
    const reviewerProfile = reviewerById.get(assignment.reviewer_id);

    const artifact = version
      ? {
        content_item_version_id: version.id,
        content_item_id: version.content_item_id,
        version_num: version.version_num,
        content_key: item?.content_key ?? null,
        item_type: item?.item_type ?? null,
        title: item?.title ?? null,
        stem: version.stem,
        stimulus: version.stimulus,
        explanation: version.explanation,
        frq_form: version.frq_form,
        review_status: version.review_status,
        mcq_choices: versionId
          ? (choicesByVersion.get(versionId) ?? [])
          : [],
        frq_criteria: versionId
          ? (criteriaByVersion.get(versionId) ?? [])
          : [],
      }
      : null;

    const assignmentDecisions = decisions.filter(
      (d) =>
        d.content_review_assignment_id ===
          assignment.content_review_assignment_id,
    );

    // For AP Reader assignments, expose the two locked tutor decisions from the
    // same blind group so the reader can see the evidence. Tutor-stage items
    // never expose sibling decisions (blindness enforced until both submit).
    let siblingDecisions: Array<Record<string, unknown>> = [];
    if (
      reviewerRole === "reader" &&
      assignment.review_stage === "reader_question" &&
      versionId
    ) {
      siblingDecisions = decisions.filter(
        (d) =>
          d.content_item_version_id === versionId &&
          d.review_stage === "tutor_question" &&
          d.content_review_assignment_id !==
            assignment.content_review_assignment_id,
      );
    }

    return {
      // Assignment fields
      content_review_assignment_id: assignment.content_review_assignment_id,
      assigned_role: reviewerProfile?.role ?? reviewerRole,
      reviewer_id: assignment.reviewer_id,
      reviewer_name: reviewerProfile?.full_name ?? null,
      reviewer_role: reviewerProfile?.role ?? null,
      review_stage: assignment.review_stage,
      review_kind: assignment.review_kind,
      blind_group_id: assignment.blind_group_id,
      due_at: assignment.due_at,
      status: assignment.status,
      created_at: assignment.created_at,
      // Content
      artifact,
      // Decisions
      decisions: assignmentDecisions,
      sibling_decisions: siblingDecisions,
      review_labels: reviewLabels.filter(
        (l) =>
          l.content_review_assignment_id ===
            assignment.content_review_assignment_id,
      ),
    };
  });

  const counts = queue.reduce(
    (acc, item) => {
      acc[item.review_stage] = (acc[item.review_stage] ?? 0) + 1;
      acc[item.status] = (acc[item.status] ?? 0) + 1;
      return acc;
    },
    {} as Record<string, number>,
  );

  return respond(
    {
      status: "ok",
      function: "review-queue",
      reviewer: {
        reviewer_id: reviewerId,
        reviewer_role: reviewerRole,
        reviewer_name: profileResult.profile.full_name,
        review_queue_scope: queueScope,
        can_see_all_pending: includeAllPending,
      },
      scope: includeAllPending ? "all_pending" : "mine",
      queue,
      counts,
    },
    { status: 200 },
  );
});
