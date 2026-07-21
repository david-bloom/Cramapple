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
  review_status: string | null;
  status: string;
  stimulus_image_path: string | null;
  prompt_json: Record<string, unknown> | null;
};

const STIMULUS_IMAGE_BUCKET = "content-assets";
const STIMULUS_IMAGE_URL_TTL_SECONDS = 3600;

// Heuristic-only, soft-flag QA aid (not a publish gate): the text implies a
// figure/diagram/graph/photo the student must read, but there's neither an
// attached stimulus image nor the corpus's established text-substitute
// convention ("Figure 1 (described): ..." / "Figure 1 description: ...").
// False positives are expected and fine — this surfaces a warning in the
// review payload, it never blocks a tutor's decision. Hand-drawn
// student-response items are excluded: those describe data the STUDENT
// draws from, not a pre-supplied figure.
const FIGURE_REFERENCE_PATTERN =
  /(figure\s*\d|graph\s*(shown|shows|below)|diagram\s*(shown|shows|below)|image\s*(shown|shows|below)|picture\s*(shown|shows|below)|photograph\s*(shown|shows|below)|chart\s*(shown|shows|below)|the following\s*(figure|diagram|graph|image))/i;
const DESCRIBED_SUBSTITUTE_PATTERN = /figure\s*\d*\s*\(?descri(bed|ption)\)?[:.]?/i;

function looksLikeMissingStimulusImage(version: ContentVersion): boolean {
  if (version.stimulus_image_path) return false;
  const handDrawn = version.prompt_json?.hand_drawn === true ||
    version.prompt_json?.hand_drawn === "true";
  if (handDrawn) return false;

  const text = `${version.stem ?? ""} ${version.stimulus ?? ""}`;
  if (!FIGURE_REFERENCE_PATTERN.test(text)) return false;
  if (DESCRIBED_SUBSTITUTE_PATTERN.test(text)) return false;

  return true;
}

type ContentItem = {
  id: string;
  content_key: string;
  item_type: string;
  title: string;
  frq_form: string | null;
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

// Any of these .in() filters can carry hundreds of IDs once admin CC mode
// (all pending assignments across every reviewer) is in play — 711 pending
// assignments at last count. A single .in() with that many UUIDs blows past
// the PostgREST/gateway request-size limit and returns a plain error with no
// detail (surfaced to the client as "queue_details_failed" /
// "queue_lookup_failed"). Same failure class as the frontend's content
// inventory query hit at 818 content items — chunk every large .in() call.
const IN_CHUNK_SIZE = 150;

async function fetchInChunks<T>(
  ids: string[],
  runChunk: (
    chunk: string[],
  ) => PromiseLike<{ data: T[] | null; error: { message: string } | null }>,
): Promise<{ data: T[]; error: string | null }> {
  if (ids.length === 0) return { data: [], error: null };
  const out: T[] = [];
  for (let i = 0; i < ids.length; i += IN_CHUNK_SIZE) {
    const chunk = ids.slice(i, i + IN_CHUNK_SIZE);
    const { data, error } = await runChunk(chunk);
    if (error) return { data: out, error: error.message };
    out.push(...((data ?? []) as T[]));
  }
  return { data: out, error: null };
}

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
  const reviewQueueScope = profileResult.profile.review_queue_scope as
    | string
    | null;

  // Admin "CC" mode: an admin whose profile opts into review_queue_scope =
  // 'all_pending' sees every reviewer's pending assignments, not just their
  // own. This was already wired into the frontend (reviewer.index.tsx checks
  // scope === "all_pending" && reviewerRole === "admin") and into the
  // profiles table, but this function never actually implemented it — it
  // always filtered to the caller's own reviewer_id regardless of role.
  const isAdminCC = reviewerRole === "admin" && reviewQueueScope === "all_pending";
  const scope = isAdminCC ? "all_pending" : "mine";

  // ── Assignments ─────────────────────────────────────────────────────────────

  let assignmentQuery = service
    .schema("app")
    .from("content_review_assignments")
    .select(
      "content_review_assignment_id, ingest_row_id, content_item_version_id, review_stage, review_kind, reviewer_id, blind_group_id, due_at, status, created_at",
    );

  assignmentQuery = isAdminCC
    ? assignmentQuery.eq("status", "pending")
    : assignmentQuery
      .eq("reviewer_id", reviewerId)
      .in("status", ["pending", "in_progress"]);

  const { data: assignments, error: assignmentsError } = await assignmentQuery
    .order("due_at", { ascending: true, nullsFirst: false });

  if (assignmentsError) {
    return respond({ error: "queue_lookup_failed" }, { status: 500 });
  }

  const assignmentRows = (assignments ?? []) as QueueAssignment[];
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
          reviewer_name: profileResult.profile.full_name,
        },
        scope,
        queue: [],
        counts: {},
      },
      { status: 200 },
    );
  }

  // In CC mode the queue spans other reviewers, so fetch their names/roles
  // to label each card ("Owner: Jill Schmidlkofer · tutor").
  const otherReviewerIds = Array.from(
    new Set(assignmentRows.map((r) => r.reviewer_id)),
  );
  const reviewerProfileById = new Map<
    string,
    { full_name: string | null; role: string | null }
  >();
  if (isAdminCC && otherReviewerIds.length) {
    const { data: reviewerProfiles } = await service
      .schema("app")
      .from("profiles")
      .select("user_id, full_name, role")
      .in("user_id", otherReviewerIds);
    for (const p of reviewerProfiles ?? []) {
      reviewerProfileById.set(p.user_id as string, {
        full_name: p.full_name as string | null,
        role: p.role as string | null,
      });
    }
  }

  // ── Fetch: decisions, content versions, labels (chunked) ────────────────────

  const [decisionResult, labelResult, contentVersionResult] = await Promise.all([
    fetchInChunks<Record<string, unknown>>(assignmentIds, (chunk) =>
      service.schema("app").from("content_review_decisions")
        .select(
          "content_review_decision_id, content_review_assignment_id, content_item_version_id, review_stage, tutor_score, difficulty_label, concern_codes, note, answer_key, answer_approval, reader_decision, supersedes_id, submitted_at, created_at",
        )
        .in("content_review_assignment_id", chunk)),

    fetchInChunks<Record<string, unknown>>(assignmentIds, (chunk) =>
      service.schema("app").from("content_review_assignment_labels")
        .select("content_review_assignment_id, content_label_id, created_at")
        .in("content_review_assignment_id", chunk)),

    fetchInChunks<ContentVersion>(contentVersionIds, (chunk) =>
      service.schema("app").from("content_item_versions")
        .select(
          "id, content_item_id, version_num, stem, stimulus, explanation, review_status, status, stimulus_image_path, prompt_json",
        )
        .in("id", chunk)),
  ]);

  if (decisionResult.error || labelResult.error || contentVersionResult.error) {
    return respond({ error: "queue_details_failed" }, { status: 500 });
  }

  const decisions = decisionResult.data;
  const reviewLabels = labelResult.data;
  const contentVersions = contentVersionResult.data;

  // ── Content items (for item_type, content_key, title) ───────────────────────

  const contentItemIds = contentVersions
    .map((v) => v.content_item_id)
    .filter(Boolean);

  const [contentItemResult, mcqChoiceResult, frqCriterionResult] =
    await Promise.all([
      fetchInChunks<ContentItem>(contentItemIds, (chunk) =>
        service.schema("app").from("content_items")
          .select("id, content_key, item_type, title, frq_form")
          .in("id", chunk)),

      fetchInChunks<McqChoice>(contentVersionIds, (chunk) =>
        service.schema("app").from("mcq_choices")
          .select(
            "content_item_version_id, choice_key, choice_text, is_correct, rationale",
          )
          .in("content_item_version_id", chunk)
          .order("choice_key", { ascending: true })),

      fetchInChunks<FrqCriterion>(contentVersionIds, (chunk) =>
        service.schema("app").from("frq_criteria")
          .select(
            "content_item_version_id, criterion_key, learner_facing_text, points_possible",
          )
          .in("content_item_version_id", chunk)
          .order("criterion_key", { ascending: true })),
    ]);

  if (contentItemResult.error || mcqChoiceResult.error || frqCriterionResult.error) {
    return respond({ error: "queue_details_failed" }, { status: 500 });
  }

  const contentItems = contentItemResult.data;
  const mcqChoices = mcqChoiceResult.data;
  const frqCriteria = frqCriterionResult.data;

  // ── Signed URLs for stimulus images ─────────────────────────────────────────
  // content-assets is a private bucket (service_role only); reviewers never
  // call storage-sign-url themselves (their role isn't authorized for that
  // bucket) — this function signs on their behalf using its own service-role
  // client, scoped to just the images this reviewer's queue actually needs.

  const stimulusImagePaths = Array.from(
    new Set(
      contentVersions
        .map((v) => v.stimulus_image_path)
        .filter((path): path is string => Boolean(path)),
    ),
  );

  const imageUrlByPath = new Map<string, string>();
  if (stimulusImagePaths.length) {
    const { data: signedUrls, error: signError } = await service.storage
      .from(STIMULUS_IMAGE_BUCKET)
      .createSignedUrls(stimulusImagePaths, STIMULUS_IMAGE_URL_TTL_SECONDS);

    if (signError) {
      return respond({ error: "stimulus_image_sign_failed" }, { status: 500 });
    }

    for (const entry of signedUrls ?? []) {
      if (entry.path && entry.signedUrl && !entry.error) {
        imageUrlByPath.set(entry.path, entry.signedUrl);
      }
    }
  }

  // ── Index lookups ────────────────────────────────────────────────────────────

  const versionById = new Map(contentVersions.map((v) => [v.id, v]));
  const itemById = new Map(contentItems.map((i) => [i.id, i]));

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
        stimulus_image_path: version.stimulus_image_path,
        stimulus_image_url: version.stimulus_image_path
          ? imageUrlByPath.get(version.stimulus_image_path) ?? null
          : null,
        // Soft QA flag only — see looksLikeMissingStimulusImage. Never blocks
        // a decision; a tutor can approve right past this.
        content_flags: {
          possible_missing_stimulus_image: looksLikeMissingStimulusImage(
            version,
          ),
        },
        explanation: version.explanation,
        frq_form: item?.frq_form ?? null,
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
      assigned_role: reviewerRole,
      reviewer_id: assignment.reviewer_id,
      reviewer_name: reviewerProfileById.get(assignment.reviewer_id)?.full_name ??
        null,
      reviewer_role: reviewerProfileById.get(assignment.reviewer_id)?.role ??
        null,
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
      },
      scope,
      queue,
      counts,
    },
    { status: 200 },
  );
});
