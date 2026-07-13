import {
  assert,
  assertEquals,
  assertRejects,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  type AtomicPublicationInput,
  invokeAtomicPublicationRpc,
  type PublicationRpcClient,
} from "./publication-request.ts";

const ids = {
  actor: "00000000-0000-0000-0000-000000000001",
  artifact: "00000000-0000-0000-0000-000000000002",
  contentVersion: "00000000-0000-0000-0000-000000000003",
  examPackVersion: "00000000-0000-0000-0000-000000000004",
  source: "00000000-0000-0000-0000-000000000005",
  rights: "00000000-0000-0000-0000-000000000006",
  gradingRun: "00000000-0000-0000-0000-000000000007",
  securityRun: "00000000-0000-0000-0000-000000000008",
  validatorPolicy: "00000000-0000-0000-0000-000000000009",
  teachingPolicy: "00000000-0000-0000-0000-000000000010",
  gradingPolicy: "00000000-0000-0000-0000-000000000011",
};

function validInput(): AtomicPublicationInput {
  return {
    profileId: ids.actor,
    artifactVersionId: ids.artifact,
    contentItemVersionId: ids.contentVersion,
    reasonCode: "publish_requested",
    compatibility: {
      exam_pack_version_id: ids.examPackVersion,
      content_item_version_id: ids.contentVersion,
      content_key: "task0017-integration",
      title: "TASK-0017 integration fixture",
    },
    body: {
      environment: "local",
      approved_by: [ids.actor],
      release_candidate: {
        school_year: "2098-99",
        proposed_version: "1.0.0",
        release_class: "minor",
      },
      manifest: {
        school_year: "2098-99",
        exam_pack_version: "1.0.0",
        source_version_ids: [ids.source],
        rights_record_ids: [ids.rights],
        grading_calibration_validation_run_ids: [ids.gradingRun],
        security_privacy_validation_run_ids: [ids.securityRun],
        validator_policy_version_id: ids.validatorPolicy,
        teaching_policy_version_id: ids.teachingPolicy,
        grading_policy_version_id: ids.gradingPolicy,
      },
    },
  };
}

Deno.test("admin-content invokes RPC with every required exact-version evidence ID", async () => {
  let capturedSchema: string | null = null;
  let capturedRpc: string | null = null;
  let capturedArgs: Record<string, unknown> | null = null;
  const client: PublicationRpcClient = {
    schema(name) {
      capturedSchema = name;
      return {
        rpc(rpcName, args) {
          capturedRpc = rpcName;
          capturedArgs = args;
          return Promise.resolve({ data: { state: "published" }, error: null });
        },
      };
    },
  };

  await invokeAtomicPublicationRpc(client, validInput());
  assert(capturedArgs);
  const request = (capturedArgs as Record<string, unknown>).p_request as Record<
    string,
    unknown
  >;

  assertEquals(capturedSchema, "app");
  assertEquals(capturedRpc, "publish_content_item_version_atomic");
  assertEquals(request.content_item_version_id, ids.contentVersion);
  assertEquals(request.exam_pack_version_id, ids.examPackVersion);
  assertEquals(request.source_version_ids, [ids.source]);
  assertEquals(request.rights_record_ids, [ids.rights]);
  assertEquals(request.validation_run_ids, [ids.gradingRun, ids.securityRun]);
  assertEquals(request.approved_by, [ids.actor]);
  assertEquals(request.validator_policy_version_id, ids.validatorPolicy);
  assertEquals(request.teaching_policy_version_id, ids.teachingPolicy);
  assertEquals(request.grading_policy_version_id, ids.gradingPolicy);
});

Deno.test("admin-content fails closed before RPC when a gate evidence category is absent", async () => {
  const requiredManifestFields = [
    "source_version_ids",
    "rights_record_ids",
    "grading_calibration_validation_run_ids",
    "security_privacy_validation_run_ids",
    "validator_policy_version_id",
    "teaching_policy_version_id",
    "grading_policy_version_id",
  ];

  for (const field of requiredManifestFields) {
    const input = validInput();
    const manifest = input.body.manifest as Record<string, unknown>;
    delete manifest[field];
    let invoked = false;
    const client: PublicationRpcClient = {
      schema() {
        return {
          rpc() {
            invoked = true;
            return Promise.resolve({ data: null, error: null });
          },
        };
      },
    };
    await assertRejects(
      () => invokeAtomicPublicationRpc(client, input),
      Error,
      `missing_${field}`,
    );
    assertEquals(invoked, false, `${field} reached RPC`);
  }
});

Deno.test("admin-content defaults approved_by to the authenticated admin", async () => {
  const input = validInput();
  delete input.body.approved_by;
  let capturedArgs: Record<string, unknown> | null = null;
  const client: PublicationRpcClient = {
    schema() {
      return {
        rpc(_name, args) {
          capturedArgs = args;
          return Promise.resolve({ data: {}, error: null });
        },
      };
    },
  };
  await invokeAtomicPublicationRpc(client, input);
  assert(capturedArgs);
  const request = (capturedArgs as Record<string, unknown>).p_request as Record<
    string,
    unknown
  >;
  assertEquals(request.approved_by, [ids.actor]);
});
