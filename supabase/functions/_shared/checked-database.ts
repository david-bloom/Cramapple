/** A required operation failed; earlier independent writes may have committed. */
export class RequiredDatabaseError extends Error {
  constructor(public step: string, public code: string | null = null) {
    super("required_database_operation_failed");
  }
}

export async function checkedDatabase<R extends { error: unknown }>(
  query: PromiseLike<R>,
  step: string,
): Promise<R> {
  let result: R;
  try {
    result = await query;
  } catch {
    throw new RequiredDatabaseError(step, "transport_error");
  }
  if (result.error) {
    const error = result.error as { code?: unknown };
    throw new RequiredDatabaseError(
      step,
      typeof error.code === "string" ? error.code : null,
    );
  }
  return result;
}
