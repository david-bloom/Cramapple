// Explicit names preserve existing validation differences during extraction.
export function trimmedNonEmptyString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}
export function nonEmptyString(value: unknown) {
  return typeof value === "string" && value.trim() ? value : null;
}
export function stringOrNull(value: unknown) {
  return typeof value === "string" ? value : null;
}
export function trimmedStringOrEmpty(value: unknown) {
  return typeof value === "string" ? value.trim() : "";
}
const UUID_SHAPE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
export function uuidShape(value: unknown) {
  return typeof value === "string" && UUID_SHAPE.test(value) ? value : null;
}
// Compatibility only. Tightening this parser is a separate behavior change.
export function looseUuid(value: unknown) {
  return typeof value === "string" && /^[0-9a-fA-F-]{36}$/.test(value) ? value : null;
}
export function trimmedUuidShape(value: unknown) {
  return typeof value === "string" && UUID_SHAPE.test(value.trim()) ? value.trim() : null;
}
export function coercedInteger(value: unknown) {
  const parsed = Number(value);
  return Number.isInteger(parsed) ? parsed : null;
}
export function emailAddress(value: unknown) {
  const email = trimmedNonEmptyString(value);
  return email && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) ? email.toLowerCase() : null;
}
