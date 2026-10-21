// Preserve the existing platform-header rule; do not import a feature module.
export function clientIp(req: Request): string | null {
  const cf = req.headers.get("cf-connecting-ip")?.trim();
  if (cf) return cf;
  return req.headers.get("x-forwarded-for")?.split(",")[0]?.trim() || null;
}
