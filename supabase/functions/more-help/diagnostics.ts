export function rpcFailure(rpc: string, code: unknown) {
  console.warn("[more-help] rpc failed", {
    rpc,
    code: typeof code === "string" && /^[0-9A-Z]{5}$/.test(code)
      ? code
      : "unknown",
  });
}

// Never accept field values, output, identities or provider bodies as reasons.
const OUTPUT_REASONS = new Set([
  "response_json",
  "content_json",
  "source_ids",
  "explicit_answer",
  "conceptual_subpart",
  "continuity_statement_verdict",
  "identify_subpart",
  "direction_subpart",
  "value_subpart",
  "law_subpart",
  "runtime_check",
  "runtime_check_unavailable",
  "headline_type",
  "headline_empty",
  "headline_length",
  "explanation_type",
  "explanation_empty",
  "explanation_length",
  "next_step_type",
  "next_step_empty",
  "next_step_length",
  "follow_ups_type",
  "follow_ups_count",
  "follow_up_type_or_empty",
  "follow_up_length",
]);
export function outputFailure(reason: unknown) {
  console.warn("[more-help] output rejected", {
    reason: typeof reason === "string" && OUTPUT_REASONS.has(reason)
      ? reason
      : "unknown",
  });
}
