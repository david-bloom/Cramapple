import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

type AllowedOperation =
  | "create_draft"
  | "update_draft"
  | "publish"
  | "retire"
  | "unpublish"
  | "bulk_import";

type LegacyChoice = {
  choice_key: string;
  choice_text: string;
  is_correct?: boolean;
  rationale?: string | null;
};

type LegacyCriterion = {
  criterion_key: string;
  learner_facing_text: string;
  points_possible: number;
  evidence_requirements?: string | null;
  minimum_fix?: string | null;
  accepted_variants?: unknown;
};

type CompatibilityProjection = {
  exam_pack_version_id?: string;
  content_key?: string;
  item_type?: "mcq" | "frq" | "quantitative";
  frq_form?: "short" | "long";
  canonical_answer?: string | null;
  ingest_row_id?: string;
  title?: string;
  stem?: string;
  stimulus?: string | null;
  prompt_json?: Record<string, unknown>;
  explanation?: string | null;
  help_text?: string | null;
  content_labels?: string[];
  mcq_choices?: LegacyChoice[];
  frq_criteria?: LegacyCriterion[];
};

const allowedOperations = new Set<AllowedOperation>([
  "create_draft",
  "update_draft",
  "publish",
  "retire",
  "unpublish",
  "bulk_import",
]);

function asRecord(value: unknown) {
  return value && typeof value === "object" && !Array.isArray(value)
    ? value as Record<string, unknown>
    : null;
}

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value : null;
}

function asStringArray(value: unknown) {
  return Array.isArray(value)
    ? value.filter((item) => typeof item === "string") as string[]
    : [];
}

function asObjectArray<T extends Record<string, unknown>>(value: unknown) {
  return Array.isArray(value)
    ? value.filter((item) =>
      item && typeof item === "object" && !Array.isArray(item)
    ) as T[]
    : [];
}

async function sha256Hex(value: string) {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

function normalizePublishedState(operation: AllowedOperation) {
  switch (operation) {
    case "retire":
      return "retired";
    case "unpublish":
      return "withdrawn";
    case "publish":
      return "published";
    default:
      return "draft";
  }
}

async function loadProfile(req: Request) {
  const profileResult = await requireProfile(req);
  if (!profileResult) {
    return null;
  }

  const role = profileResult.profile.role as string;
  if (role !== "admin" && role !== "content_author") {
    return null;
  }

  return profileResult;
}

function canPerformOperation(role: string, operation: AllowedOperation) {
  if (role === "admin") {
    return true;
  }

  if (role !== "content_author") {
    return false;
  }

  return operation === "create_draft" || operation === "update_draft" ||
    operation === "bulk_import";
}

function requireGate(
  value: unknown,
  fieldName: string,
  allowedValues: string[],
) {
  const gate = asString(value);
  if (!gate) {
    throw new Error(`missing_${fieldName}`);
  }
  if (!allowedValues.includes(gate)) {
    throw new Error(`invalid_${fieldName}`);
  }
  return gate;
}

// Publish must fail closed. A gate value the client supplied is not yet a
// trusted assertion — until we resolve gates from validation_runs /
// review_decisions server-side, we at minimum require that the client say
// every gate already passed (or, where allowed, is explicitly not applicable).
//
// TODO(task-0012-trusted-gates): replace this with a server-side resolution
// pass that reads validation_runs, review_decisions, and rights_records for
// the artifact_version_id and rejects publish unless those records show the
// gate as passed. This stub keeps publish fail-closed against client-asserted
// "pending" or "failed" values, but does not yet defend against a client
// asserting "passed" when no validator actually approved.
function enforceGatePolicy(gates: {
  source_gate: string;
  rights_gate: string;
  teaching_gate: string;
  grading_gate: string;
  security_privacy_gate: string;
  release_gate: string;
}) {
  const mustPass: Array<keyof typeof gates> = [
    "source_gate",
    "rights_gate",
    "release_gate",
  ];
  for (const field of mustPass) {
    if (gates[field] !== "passed") {
      throw new Error(`gate_not_passed_${field}`);
    }
  }

  const mayBeNotApplicable: Array<keyof typeof gates> = [
    "teaching_gate",
    "grading_gate",
    "security_privacy_gate",
  ];
  for (const field of mayBeNotApplicable) {
    const value = gates[field];
    if (value !== "passed" && value !== "not_applicable") {
      throw new Error(`gate_not_passed_${field}`);
    }
  }
}

async function nextArtifactVersionSequence(
  service: ReturnType<typeof createServiceClient>,
  artifactId: string,
) {
  const { data, error } = await service.schema("app").rpc(
    "reserve_artifact_version_sequence",
    {
      p_artifact_id: artifactId,
    },
  );

  if (error || typeof data !== "number") {
    throw new Error("artifact_sequence_reservation_failed");
  }

  return data;
}

async function ensureLegacyProjection(
  service: ReturnType<typeof createServiceClient>,
  payload: CompatibilityProjection,
  artifact: Record<string, unknown>,
  artifactVersionId: string,
  createdBy: string,
  status: string,
) {
  if (
    !payload.exam_pack_version_id || !payload.content_key ||
    !payload.item_type || !payload.title
  ) {
    return null;
  }

  const { data: item } = await service.schema("app")
    .from("content_items")
    .select("id")
    .eq("exam_pack_version_id", payload.exam_pack_version_id)
    .eq("content_key", payload.content_key)
    .maybeSingle();

  let contentItemId = item?.id as string | undefined;
  if (!contentItemId) {
    const { data: insertedItem, error } = await service.schema("app")
      .from("content_items")
      .insert({
        exam_pack_version_id: payload.exam_pack_version_id,
        content_key: payload.content_key,
        item_type: payload.item_type,
        frq_form: payload.item_type === "frq" ? (payload.frq_form ?? null) : null,
        title: payload.title,
        status,
        created_by: createdBy,
      })
      .select("id")
      .maybeSingle();

    if (error || !insertedItem) {
      throw new Error("compatibility_content_item_failed");
    }

    contentItemId = insertedItem.id as string;
  } else {
    await service.schema("app")
      .from("content_items")
      .update({
        item_type: payload.item_type,
        title: payload.title,
        status,
      })
      .eq("id", contentItemId);
  }

  const { data: latestVersion } = await service.schema("app")
    .from("content_item_versions")
    .select("version_num")
    .eq("content_item_id", contentItemId)
    .order("version_num", { ascending: false })
    .limit(1)
    .maybeSingle();

  const nextVersionNum = latestVersion?.version_num
    ? Number(latestVersion.version_num) + 1
    : 1;

  const payloadHash = await sha256Hex(JSON.stringify(artifact));
  const { data: insertedVersion, error: versionError } = await service.schema(
    "app",
  )
    .from("content_item_versions")
    .insert({
      content_item_id: contentItemId,
      version_num: nextVersionNum,
      stem: payload.stem ?? payload.title,
      stimulus: payload.stimulus ?? null,
      prompt_json: payload.prompt_json ?? {},
      explanation: payload.explanation ?? null,
      help_text: payload.help_text ?? null,
      content_hash: payloadHash,
      canonical_answer: payload.canonical_answer ?? null,
      status,
      published_at: status === "published" ? new Date().toISOString() : null,
      created_by: createdBy,
    })
    .select("id")
    .maybeSingle();

  if (versionError || !insertedVersion) {
    throw new Error("compatibility_content_version_failed");
  }

  if (payload.item_type === "mcq" && Array.isArray(payload.mcq_choices)) {
    await service.schema("app").from("mcq_choices").insert(
      payload.mcq_choices.map((choice) => ({
        content_item_version_id: insertedVersion.id,
        choice_key: choice.choice_key,
        choice_text: choice.choice_text,
        is_correct: Boolean(choice.is_correct),
        rationale: choice.rationale ?? null,
      })),
    );
  }

  if (payload.item_type === "frq") {
    if (!Array.isArray(payload.frq_criteria) || payload.frq_criteria.length === 0) {
      throw new Error("frq_item_requires_criteria");
    }
  }

  if (payload.item_type === "frq" && Array.isArray(payload.frq_criteria)) {
    await service.schema("app").from("frq_criteria").insert(
      payload.frq_criteria.map((criterion) => ({
        content_item_version_id: insertedVersion.id,
        criterion_key: criterion.criterion_key,
        learner_facing_text: criterion.learner_facing_text,
        points_possible: criterion.points_possible,
        evidence_requirements: criterion.evidence_requirements ?? null,
        minimum_fix: criterion.minimum_fix ?? null,
        accepted_variants: criterion.accepted_variants ?? [],
      })),
    );
  }

  if (
    Array.isArray(payload.content_labels) && payload.content_labels.length > 0
  ) {
    const { data: examPackVersion } = await service.schema("app")
      .from("exam_pack_versions")
      .select("exam_pack_id")
      .eq("id", payload.exam_pack_version_id)
      .maybeSingle();

    const examPackId = examPackVersion?.exam_pack_id as string | undefined;
    const { data: labels } = examPackId
      ? await service.schema("app")
        .from("content_labels")
        .select("id, label_key")
        .eq("exam_pack_id", examPackId)
      : { data: [] as Array<{ id: string; label_key: string }> };

    const labelIdByKey = new Map(
      (labels ?? []).map((
        label,
      ) => [label.label_key as string, label.id as string]),
    );

    const links = payload.content_labels
      .map((labelKey) => labelIdByKey.get(labelKey))
      .filter((labelId): labelId is string => Boolean(labelId))
      .map((labelId) => ({
        content_item_id: contentItemId,
        content_label_id: labelId,
      }));

    if (links.length > 0) {
      await service.schema("app").from("content_item_labels").upsert(links, {
        onConflict: "content_item_id,content_label_id",
      });

      const artifactLinks = links.map((link) => ({
        artifact_version_id: artifactVersionId,
        content_label_id: link.content_label_id,
        created_by: createdBy,
      }));

      await service.schema("app").from("artifact_label_assignments").upsert(
        artifactLinks,
        {
          onConflict: "artifact_version_id,content_label_id",
        },
      );
    }
  }

  const contentItemVersionId = insertedVersion.id as string;

  // If this content was ingested via the staging pipeline, backfill the
  // content_item_version_id on any assignment that was created against that
  // ingest row so the assignment stays live after promotion.
  if (payload.ingest_row_id) {
    const { error: backfillError } = await service.schema("app")
      .from("content_review_assignments")
      .update({ content_item_version_id: contentItemVersionId })
      .eq("ingest_row_id", payload.ingest_row_id)
      .is("content_item_version_id", null);

    if (backfillError) {
      throw new Error("assignment_backfill_failed");
    }
  }

  return {
    content_item_id: contentItemId,
    content_item_version_id: contentItemVersionId,
    compatibility_status: status,
  };
}

async function createArtifactDraft(
  service: ReturnType<typeof createServiceClient>,
  profileId: string,
  body: Record<string, unknown>,
  operation: AllowedOperation,
) {
  const artifact = asRecord(body.artifact) ?? {};
  const sourceRecord = asRecord(body.source_record);
  const rightsRecord = asRecord(body.rights_record);
  const compatibility = asRecord(body.compatibility) as
    | CompatibilityProjection
    | null;
  const stateReasonCode = asString(body.reason_code) ??
    `${operation}_requested`;

  const artifactId = asString(artifact.artifact_id) ?? crypto.randomUUID();
  const artifactVersionId = crypto.randomUUID();
  const versionSequence = await nextArtifactVersionSequence(
    service,
    artifactId,
  );
  const payload = asRecord(artifact.payload) ?? artifact;
  const payloadHash = await sha256Hex(JSON.stringify(payload));

  if (sourceRecord) {
    const { error: sourceError } = await service.schema("app").from(
      "source_records",
    ).insert({
      source_id: sourceRecord.source_id ?? crypto.randomUUID(),
      version_sequence: Number(sourceRecord.version_sequence ?? 1),
      title: asString(sourceRecord.title) ?? "Untitled source",
      publisher: asString(sourceRecord.publisher) ?? "Cramapple",
      authors: Array.isArray(sourceRecord.authors) ? sourceRecord.authors : [],
      source_type: asString(sourceRecord.source_type) ?? "cramapple_authored",
      canonical_uri: sourceRecord.canonical_uri ?? null,
      publication_date: sourceRecord.publication_date ?? null,
      source_update_date: sourceRecord.source_update_date ?? null,
      retrieved_at: sourceRecord.retrieved_at ?? new Date().toISOString(),
      effective_from: sourceRecord.effective_from ?? null,
      effective_to: sourceRecord.effective_to ?? null,
      exam_id: sourceRecord.exam_id ?? null,
      school_year: sourceRecord.school_year ?? null,
      scope_statement: asString(sourceRecord.scope_statement) ??
        "Draft content source",
      source_excerpt_locator: sourceRecord.source_excerpt_locator ?? null,
      stored_object_id: sourceRecord.stored_object_id ?? null,
      content_sha256: asString(sourceRecord.content_sha256) ?? payloadHash,
      authority_tier: Number(sourceRecord.authority_tier ?? 3),
      refresh_class: asString(sourceRecord.refresh_class) ?? "SCIENCE_STABLE",
      next_refresh_due_at: sourceRecord.next_refresh_due_at ??
        new Date().toISOString(),
      supersedes_source_version_id: sourceRecord.supersedes_source_version_id ??
        null,
      provenance_status: asString(sourceRecord.provenance_status) ?? "draft",
      created_by: profileId,
    });
    if (sourceError) {
      throw new Error("source_record_insert_failed");
    }
  }

  if (rightsRecord) {
    const { error: rightsError } = await service.schema("app").from(
      "rights_records",
    ).insert({
      source_version_id: rightsRecord.source_version_id,
      rights_status: asString(rightsRecord.rights_status) ?? "unknown",
      permitted_uses: asStringArray(rightsRecord.permitted_uses),
      prohibited_uses: asStringArray(rightsRecord.prohibited_uses),
      territory: asStringArray(rightsRecord.territory),
      audience_restrictions: asStringArray(rightsRecord.audience_restrictions),
      license_or_permission_id: rightsRecord.license_or_permission_id ?? null,
      license_effective_at: rightsRecord.license_effective_at ?? null,
      license_expires_at: rightsRecord.license_expires_at ?? null,
      attribution_required: Boolean(rightsRecord.attribution_required),
      attribution_text: rightsRecord.attribution_text ?? null,
      reviewed_by: rightsRecord.reviewed_by ?? profileId,
      reviewed_at: rightsRecord.reviewed_at ?? new Date().toISOString(),
      legal_approval_required: Boolean(rightsRecord.legal_approval_required),
      legal_approval_id: rightsRecord.legal_approval_id ?? null,
      next_review_due_at: rightsRecord.next_review_due_at ??
        new Date().toISOString(),
      notes: rightsRecord.notes ?? null,
      created_by: profileId,
    });
    if (rightsError) {
      throw new Error("rights_record_insert_failed");
    }
  }

  const { data: insertedArtifact, error: artifactError } = await service.schema(
    "app",
  )
    .from("artifact_versions")
    .insert({
      artifact_id: artifactId,
      artifact_type: asString(artifact.artifact_type) ?? "question",
      exam_id: artifact.exam_id ?? body.exam_id ?? null,
      school_year: asString(artifact.school_year) ??
        asString(body.school_year) ?? "unknown",
      version_sequence: versionSequence,
      semantic_version: asString(artifact.semantic_version) ?? "1.0.0",
      language: asString(artifact.language) ?? "en-US",
      payload_schema_version: asString(artifact.payload_schema_version) ??
        "1.0.0",
      payload,
      payload_sha256: payloadHash,
      risk_class: asString(artifact.risk_class) ?? "R1",
      change_class: asString(artifact.change_class) ?? "C1",
      change_summary: asString(artifact.change_summary) ?? "Draft created",
      change_rationale: asString(artifact.change_rationale) ??
        "Initial draft created through admin workflow",
      authored_by: [profileId],
      predecessor_version_id: artifact.predecessor_version_id ?? null,
      created_by: profileId,
    })
    .select("artifact_version_id")
    .maybeSingle();

  if (artifactError || !insertedArtifact) {
    throw new Error("artifact_insert_failed");
  }

  const { error: stateError } = await service.schema("app").from(
    "artifact_state_events",
  ).insert({
    artifact_version_id: insertedArtifact.artifact_version_id,
    prior_state: null,
    new_state: "draft",
    reason_code: stateReasonCode,
    evidence_record_ids: [],
    changed_by: profileId,
    created_by: profileId,
  });
  if (stateError) {
    throw new Error("artifact_state_event_insert_failed");
  }

  if (compatibility) {
    await ensureLegacyProjection(
      service,
      compatibility,
      {
        artifact_type: artifact.artifact_type ?? "question",
        exam_id: artifact.exam_id ?? body.exam_id ?? null,
      },
      insertedArtifact.artifact_version_id as string,
      profileId,
      "draft",
    );
  }

  return {
    artifact_id: artifactId,
    artifact_version_id: insertedArtifact.artifact_version_id,
  };
}

async function changeArtifactState(
  service: ReturnType<typeof createServiceClient>,
  profileId: string,
  body: Record<string, unknown>,
  operation: AllowedOperation,
) {
  const artifactVersionId = asString(body.artifact_version_id);
  const artifactId = asString(body.artifact_id);
  const reasonCode = asString(body.reason_code) ?? `${operation}_requested`;
  const targetState = normalizePublishedState(operation);
  const compatibility = asRecord(body.compatibility) as
    | CompatibilityProjection
    | null;

  if (!artifactVersionId && !artifactId) {
    throw new Error("missing_artifact_identifier");
  }

  let currentVersionId: string | null = artifactVersionId;
  if (!currentVersionId && artifactId) {
    const { data } = await service.schema("app")
      .from("artifact_versions")
      .select("artifact_version_id")
      .eq("artifact_id", artifactId)
      .order("version_sequence", { ascending: false })
      .limit(1)
      .maybeSingle();
    currentVersionId = (data?.artifact_version_id as string | undefined) ??
      null;
  }

  if (!currentVersionId) {
    throw new Error("artifact_not_found");
  }

  const { data: currentState } = await service.schema("app").rpc(
    "project_artifact_state",
    {
      p_artifact_version_id: currentVersionId,
    },
  );
  const priorState = asString(currentState) ?? "draft";

  const { error: stateError } = await service.schema("app").from(
    "artifact_state_events",
  ).insert({
    artifact_version_id: currentVersionId,
    prior_state: priorState,
    new_state: targetState,
    reason_code: reasonCode,
    evidence_record_ids: body.evidence_record_ids ?? [],
    changed_by: profileId,
    created_by: profileId,
  });
  if (stateError) {
    throw new Error("artifact_state_event_insert_failed");
  }

  if (compatibility?.exam_pack_version_id && compatibility.content_key) {
    const { data: legacyItem } = await service.schema("app")
      .from("content_items")
      .select("id")
      .eq("exam_pack_version_id", compatibility.exam_pack_version_id)
      .eq("content_key", compatibility.content_key)
      .maybeSingle();

    if (legacyItem?.id) {
      await service.schema("app").from("content_items").update({
        status: targetState === "published" ? "published" : "retired",
        title: compatibility.title ?? undefined,
      }).eq("id", legacyItem.id);

      const { data: latestVersion } = await service.schema("app")
        .from("content_item_versions")
        .select("id")
        .eq("content_item_id", legacyItem.id)
        .order("version_num", { ascending: false })
        .limit(1)
        .maybeSingle();

      if (latestVersion?.id) {
        await service.schema("app").from("content_item_versions").update({
          status: targetState === "published" ? "published" : "retired",
          published_at: targetState === "published"
            ? new Date().toISOString()
            : null,
        }).eq("id", latestVersion.id);
      }
    }
  }

  if (targetState === "published") {
    const releaseCandidate = asRecord(body.release_candidate);
    const manifest = asRecord(body.manifest);
    if (!releaseCandidate || !manifest) {
      throw new Error("missing_release_manifest");
    }

    {
      const releaseClass = asString(releaseCandidate.release_class) ?? "minor";
      if (!["patch", "minor", "major", "emergency"].includes(releaseClass)) {
        throw new Error("invalid_release_class");
      }

      const sourceGate = requireGate(
        releaseCandidate.source_gate,
        "source_gate",
        ["pending", "passed", "failed"],
      );
      const rightsGate = requireGate(
        releaseCandidate.rights_gate,
        "rights_gate",
        ["pending", "passed", "failed"],
      );
      const teachingGate = requireGate(
        releaseCandidate.teaching_gate,
        "teaching_gate",
        ["pending", "passed", "failed", "not_applicable"],
      );
      const gradingGate = requireGate(
        releaseCandidate.grading_gate,
        "grading_gate",
        ["pending", "passed", "failed", "not_applicable"],
      );
      const securityPrivacyGate = requireGate(
        releaseCandidate.security_privacy_gate,
        "security_privacy_gate",
        ["pending", "passed", "failed", "not_applicable"],
      );
      const releaseGate = requireGate(
        releaseCandidate.release_gate,
        "release_gate",
        ["pending", "passed", "failed"],
      );

      enforceGatePolicy({
        source_gate: sourceGate,
        rights_gate: rightsGate,
        teaching_gate: teachingGate,
        grading_gate: gradingGate,
        security_privacy_gate: securityPrivacyGate,
        release_gate: releaseGate,
      });

      const { data: releaseRow, error: releaseError } = await service.schema(
        "app",
      )
        .from("release_candidates")
        .insert({
          exam_id: releaseCandidate.exam_id ?? body.exam_id ?? null,
          school_year: asString(releaseCandidate.school_year) ??
            asString(body.school_year) ?? "unknown",
          proposed_version: asString(releaseCandidate.proposed_version) ??
            "1.0.0",
          release_class: releaseClass,
          source_gate: sourceGate,
          rights_gate: rightsGate,
          teaching_gate: teachingGate,
          grading_gate: gradingGate,
          security_privacy_gate: securityPrivacyGate,
          release_gate: releaseGate,
          blocking_findings: releaseCandidate.blocking_findings ?? [],
          created_by: profileId,
        })
        .select("release_candidate_id")
        .maybeSingle();

      if (releaseError) {
        throw new Error("release_candidate_insert_failed");
      }

      if (releaseRow) {
        const { data: manifestRow, error: manifestError } = await service
          .schema("app")
          .from("exam_pack_manifests")
          .insert({
            exam_id: manifest.exam_id ?? body.exam_id ?? null,
            school_year: asString(manifest.school_year) ??
              asString(body.school_year) ?? "unknown",
            exam_pack_version: asString(manifest.exam_pack_version) ?? "1.0.0",
            artifact_version_ids: manifest.artifact_version_ids ??
              [currentVersionId],
            source_version_ids: manifest.source_version_ids ?? [],
            rights_record_ids: manifest.rights_record_ids ?? [],
            validator_policy_version_id: manifest.validator_policy_version_id ??
              crypto.randomUUID(),
            teaching_policy_version_id: manifest.teaching_policy_version_id ??
              crypto.randomUUID(),
            grading_policy_version_id: manifest.grading_policy_version_id ??
              crypto.randomUUID(),
            prompt_version_ids: manifest.prompt_version_ids ?? [],
            model_configuration_version_ids:
              manifest.model_configuration_version_ids ?? [],
            validation_run_ids: manifest.validation_run_ids ?? [],
            qualification_rule_version_ids:
              manifest.qualification_rule_version_ids ?? [],
            manifest_sha256: asString(manifest.manifest_sha256) ??
              await sha256Hex(JSON.stringify(manifest)),
            created_by: profileId,
          })
          .select("manifest_id")
          .maybeSingle();

        if (manifestError) {
          throw new Error("manifest_insert_failed");
        }

        if (manifestRow) {
          const { error: publicationError } = await service.schema("app").from(
            "publication_events",
          ).insert({
            release_candidate_id: releaseRow.release_candidate_id,
            manifest_id: manifestRow.manifest_id,
            environment: asString(body.environment) ?? "production",
            action: "publish",
            approved_by: body.approved_by ?? [profileId],
            executed_by: profileId,
            transaction_id: asString(body.transaction_id) ??
              crypto.randomUUID(),
            smoke_test_run_id: body.smoke_test_run_id ?? null,
            outcome: "succeeded",
            created_by: profileId,
          });
          if (publicationError) {
            throw new Error("publication_event_insert_failed");
          }
        }
      }
    }
  }

  return {
    artifact_version_id: currentVersionId,
    state: targetState,
  };
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
  if (!body || typeof body !== "object") {
    return respond({ error: "invalid_json" }, { status: 400 });
  }

  const operation = asString((body as Record<string, unknown>).operation);
  if (!operation || !allowedOperations.has(operation as AllowedOperation)) {
    return respond({ error: "invalid_operation" }, { status: 400 });
  }

  const idempotencyKey = asString(
    (body as Record<string, unknown>).idempotency_key ??
      (body as Record<string, unknown>).idempotencyKey ??
      (body as Record<string, unknown>).request_id ??
      (body as Record<string, unknown>).requestId,
  );

  if (!idempotencyKey) {
    return respond({ error: "missing_idempotency_key" }, { status: 400 });
  }

  const profileResult = await loadProfile(req);
  if (!profileResult) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  if (
    !canPerformOperation(
      profileResult.profile.role as string,
      operation as AllowedOperation,
    )
  ) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const service = createServiceClient();
  const profileId = profileResult.user.id;

  const payloadHash = await sha256Hex(JSON.stringify(body));

  try {
    // Scope the lookup to (request_id, reason_code) to match the composite
    // unique index added in migration 202606210001. reason_code at insert
    // time is the operation (see audit_events insert below). Same request_id
    // reused for a different operation is a separate audit row, not a conflict.
    const existing = await service.schema("app")
      .from("audit_events")
      .select("audit_event_id, metadata, request_id")
      .eq("request_id", idempotencyKey)
      .eq("reason_code", operation)
      .maybeSingle();

    if (existing.error) {
      throw existing.error;
    }

    if (
      existing.data && existing.data.metadata &&
      typeof existing.data.metadata === "object"
    ) {
      const metadata = existing.data.metadata as Record<string, unknown>;
      if (
        metadata.request_hash === payloadHash &&
        metadata.operation === operation
      ) {
        return respond(
          {
            status: "ok",
            function: "admin-content",
            operation,
            result: metadata.result ?? null,
          },
          { status: 200 },
        );
      }
      return respond({ error: "idempotency_conflict" }, { status: 409 });
    }

    let result: Record<string, unknown>;
    if (operation === "bulk_import") {
      const items = asObjectArray<Record<string, unknown>>(
        (body as Record<string, unknown>).items,
      );
      const imported: unknown[] = [];
      for (const item of items) {
        const created = await createArtifactDraft(
          service,
          profileId,
          {
            ...item,
            source_record: item.source_record ??
              (body as Record<string, unknown>).source_record ?? null,
            rights_record: item.rights_record ??
              (body as Record<string, unknown>).rights_record ?? null,
            compatibility: item.compatibility ??
              (body as Record<string, unknown>).compatibility ?? null,
          },
          "create_draft",
        );
        imported.push(created);
      }
      result = { imported };
    } else if (operation === "create_draft" || operation === "update_draft") {
      result = await createArtifactDraft(
        service,
        profileId,
        body as Record<string, unknown>,
        operation,
      );
    } else {
      result = await changeArtifactState(
        service,
        profileId,
        body as Record<string, unknown>,
        operation as AllowedOperation,
      );
    }

    // reason_code is canonical to the operation here so it aligns with the
    // composite unique on (request_id, reason_code) and the dedup query
    // above. Client-supplied reason text is preserved in metadata.
    await service.schema("app").from("audit_events").insert({
      audit_event_id: crypto.randomUUID(),
      occurred_at: new Date().toISOString(),
      actor_type: "human",
      actor_id: profileId,
      action: `admin_content.${operation}`,
      object_type: "artifact",
      object_id: asString(result.artifact_version_id) ??
        asString(result.artifact_id) ?? crypto.randomUUID(),
      request_id: idempotencyKey,
      reason_code: operation,
      metadata: {
        operation,
        request_hash: payloadHash,
        client_reason_code:
          asString((body as Record<string, unknown>).reason_code) ?? null,
        result,
      },
      event_sha256: await sha256Hex(
        JSON.stringify({ operation, requestHash: payloadHash, result }),
      ),
      created_at: new Date().toISOString(),
    });

    return respond(
      {
        status: "ok",
        function: "admin-content",
        operation,
        result,
      },
      { status: 200 },
    );
  } catch (error) {
    const message = error instanceof Error
      ? error.message
      : "admin_content_failed";
    const clientErrors = new Set([
      "invalid_json",
      "invalid_operation",
      "missing_idempotency_key",
      "forbidden",
      "frq_item_requires_criteria",
      "assignment_backfill_failed",
      "missing_artifact_identifier",
      "artifact_not_found",
      "artifact_sequence_reservation_failed",
      "missing_release_manifest",
      "invalid_release_class",
      "missing_source_gate",
      "missing_rights_gate",
      "missing_teaching_gate",
      "missing_grading_gate",
      "missing_security_privacy_gate",
      "missing_release_gate",
      "invalid_source_gate",
      "invalid_rights_gate",
      "invalid_teaching_gate",
      "invalid_grading_gate",
      "invalid_security_privacy_gate",
      "invalid_release_gate",
      "gate_not_passed_source_gate",
      "gate_not_passed_rights_gate",
      "gate_not_passed_teaching_gate",
      "gate_not_passed_grading_gate",
      "gate_not_passed_security_privacy_gate",
      "gate_not_passed_release_gate",
    ]);

    return respond(
      {
        status: "failed",
        function: "admin-content",
        operation,
        error: clientErrors.has(message) ? message : "admin_content_failed",
      },
      { status: clientErrors.has(message) ? 400 : 500 },
    );
  }
});
