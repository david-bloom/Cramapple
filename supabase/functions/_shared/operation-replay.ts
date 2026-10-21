// Durable per-key claims prevent a collision or a lost audit acknowledgement
// from re-running an action. Pending claims NEVER expire automatically: the
// action may have committed even when its acknowledgement was lost.
export type ReplayClaim =
  | { kind: "claimed"; claimToken: string }
  | { kind: "replay"; result: unknown };

export class ReplayError extends Error {
  constructor(public code: string, public status = 409) {
    super(code);
  }
}

type Service = {
  schema(
    name: string,
  ): {
    rpc(
      name: string,
      args: Record<string, unknown>,
    ): PromiseLike<{ data: unknown; error: unknown }>;
  };
};

export async function claimReplay(service: Service, input: {
  actorId: string;
  requestId: string;
  requestHash: string;
  operation: string;
}): Promise<ReplayClaim> {
  const { data, error } = await service.schema("app").rpc(
    "claim_operation_replay",
    {
      p_actor_id: input.actorId,
      p_request_id: input.requestId,
      p_request_hash: input.requestHash,
      p_operation: input.operation,
    },
  );
  if (error || !data || typeof data !== "object") {
    throw new ReplayError("replay_unavailable", 503);
  }
  const value = data as Record<string, unknown>;
  if (value.kind === "conflict") throw new ReplayError("idempotency_conflict");
  if (value.kind === "pending") {
    throw new ReplayError("operation_outcome_pending");
  }
  if (value.kind === "replay") {
    return { kind: "replay", result: value.result ?? null };
  }
  if (
    value.kind === "claimed" && typeof value.claim_token === "string" &&
    value.claim_token
  ) {
    return { kind: "claimed", claimToken: value.claim_token };
  }
  throw new ReplayError("replay_unavailable", 503);
}

export async function completeReplay(
  service: Service,
  claimToken: string,
  event: Record<string, unknown>,
) {
  const { error } = await service.schema("app").rpc(
    "complete_operation_replay",
    {
      p_claim_token: claimToken,
      p_event: event,
    },
  );
  // Never release the claim on failure. The side effect may already exist.
  if (error) throw new ReplayError("operation_outcome_pending");
}
