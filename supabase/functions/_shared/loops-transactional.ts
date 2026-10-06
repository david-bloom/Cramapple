export type TransactionalEmail = {
  transactionalId: string;
  email: string;
  dataVariables: Record<string, string | number>;
};

export function requireEmailConfig(name: string): string {
  const value = Deno.env.get(name)?.trim();
  if (!value) throw new Error(`missing_email_config:${name}`);
  return value;
}

export async function sendLoopsTransactional(
  input: TransactionalEmail,
  idempotencyKey: string,
): Promise<void> {
  const apiKey = requireEmailConfig("LOOPS_SECRET_KEY");
  if (
    !input.transactionalId || !input.email || !idempotencyKey ||
    idempotencyKey.length > 100
  ) {
    throw new Error("invalid_transactional_email");
  }
  const response = await fetch("https://app.loops.so/api/v1/transactional", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
      "Idempotency-Key": idempotencyKey,
    },
    body: JSON.stringify({ ...input, addToAudience: false }),
    signal: AbortSignal.timeout(4000),
  });
  // Never log the response body: it may contain recipient or token data.
  if (!response.ok) {
    throw new Error(`loops_transactional_http_${response.status}`);
  }
  const result = await response.json();
  if (result?.success !== true) throw new Error("loops_transactional_rejected");
}
