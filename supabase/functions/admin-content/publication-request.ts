type RpcResult = { data: unknown; error: unknown };

export type PublicationRpcClient = {
  schema(name: string): {
    rpc(
      name: string,
      args: Record<string, unknown>,
    ): PromiseLike<RpcResult>;
  };
};

function record(value: unknown): Record<string, unknown> | null {
  return value && typeof value === "object" && !Array.isArray(value)
    ? value as Record<string, unknown>
    : null;
}

function string(value: unknown): string | null {
  return typeof value === "string" && value.trim() ? value : null;
}

function stringArray(value: unknown): string[] {
  return Array.isArray(value) &&
      value.every((entry) => typeof entry === "string" && entry.trim())
    ? value as string[]
    : [];
}

function requiredArray(
  owner: Record<string, unknown>,
  key: string,
): string[] {
  const values = stringArray(owner[key]);
  if (values.length === 0) throw new Error(`missing_${key}`);
  return values;
}

function requiredString(
  owner: Record<string, unknown>,
  key: string,
): string {
  const value = string(owner[key]);
  if (!value) throw new Error(`missing_${key}`);
  return value;
}

export type AtomicPublicationInput = {
  body: Record<string, unknown>;
  profileId: string;
  artifactVersionId: string;
  contentItemVersionId: string;
  compatibility: Record<string, unknown>;
  reasonCode: string;
};

/**
 * Builds the only request shape admin-content may send to the atomic publish
 * RPC. Validation-run categories are separate at the Edge boundary and are
 * combined only after each required category is present. The RPC independently
 * resolves suite types, pass status, and exact target-version coverage.
 */
export function buildAtomicPublicationRequest(
  input: AtomicPublicationInput,
): Record<string, unknown> {
  const releaseCandidate = record(input.body.release_candidate);
  const manifest = record(input.body.manifest);
  if (!releaseCandidate || !manifest) {
    throw new Error("missing_release_manifest");
  }

  const sourceVersionIds = requiredArray(manifest, "source_version_ids");
  const rightsRecordIds = requiredArray(manifest, "rights_record_ids");
  const gradingCalibrationRunIds = requiredArray(
    manifest,
    "grading_calibration_validation_run_ids",
  );
  const securityPrivacyRunIds = requiredArray(
    manifest,
    "security_privacy_validation_run_ids",
  );
  const validationRunIds = [
    ...gradingCalibrationRunIds,
    ...securityPrivacyRunIds,
  ];
  if (new Set(validationRunIds).size !== validationRunIds.length) {
    throw new Error("duplicate_validation_run_id_across_gate_categories");
  }

  const approvedBy = input.body.approved_by === undefined
    ? [input.profileId]
    : stringArray(input.body.approved_by);
  if (approvedBy.length === 0) throw new Error("missing_approved_by");

  const schoolYear = string(manifest.school_year) ??
    string(releaseCandidate.school_year) ?? string(input.body.school_year);
  if (!schoolYear) throw new Error("missing_school_year");

  const examPackVersionId = requiredString(
    input.compatibility,
    "exam_pack_version_id",
  );
  const contentKey = requiredString(input.compatibility, "content_key");

  return {
    content_item_version_id: input.contentItemVersionId,
    artifact_version_id: input.artifactVersionId,
    actor_id: input.profileId,
    exam_pack_version_id: examPackVersionId,
    content_key: contentKey,
    title: string(input.compatibility.title),
    school_year: schoolYear,
    proposed_version: string(releaseCandidate.proposed_version),
    release_class: string(releaseCandidate.release_class) ?? "minor",
    exam_pack_version: string(manifest.exam_pack_version) ?? "1.0.0",
    source_version_ids: sourceVersionIds,
    rights_record_ids: rightsRecordIds,
    validator_policy_version_id: requiredString(
      manifest,
      "validator_policy_version_id",
    ),
    teaching_policy_version_id: requiredString(
      manifest,
      "teaching_policy_version_id",
    ),
    grading_policy_version_id: requiredString(
      manifest,
      "grading_policy_version_id",
    ),
    prompt_version_ids: stringArray(manifest.prompt_version_ids),
    model_configuration_version_ids: stringArray(
      manifest.model_configuration_version_ids,
    ),
    validation_run_ids: validationRunIds,
    qualification_rule_version_ids: stringArray(
      manifest.qualification_rule_version_ids,
    ),
    environment: string(input.body.environment) ?? "production",
    prior_manifest_id: input.body.prior_manifest_id ?? null,
    approved_by: approvedBy,
    transaction_id: string(input.body.transaction_id) ?? crypto.randomUUID(),
    smoke_test_run_id: input.body.smoke_test_run_id ?? null,
    reason_code: input.reasonCode,
  };
}

export async function invokeAtomicPublicationRpc(
  client: PublicationRpcClient,
  input: AtomicPublicationInput,
): Promise<RpcResult> {
  const pRequest = buildAtomicPublicationRequest(input);
  return await client.schema("app").rpc(
    "publish_content_item_version_atomic",
    { p_request: pRequest },
  );
}
