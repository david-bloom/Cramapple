export type FunctionStatus =
  | "draft"
  | "ok"
  | "invalid_json"
  | "invalid_operation"
  | "unauthorized"
  | "forbidden"
  | "not_found"
  | "rate_limited"
  | "budget_capped"
  | "conflict"
  | "temporary_failure";

export interface DraftFunctionEnvelope<T = Record<string, unknown>> {
  status: FunctionStatus;
  function: string;
  operation?: string;
  message?: string;
  data?: T;
}
