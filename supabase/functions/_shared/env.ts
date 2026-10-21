// Importing this module reads nothing. Call sites retain their existing
// fail-fast or lazy evaluation point and their existing empty-value behavior.
export function requireEnv(name: string): string {
  const value = Deno.env.get(name);
  if (!value) throw new Error(`Missing required environment variable: ${name}`);
  return value;
}
