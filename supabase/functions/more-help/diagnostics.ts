export function rpcFailure(rpc: string, code: unknown) {
  console.warn("[more-help] rpc failed", {
    rpc,
    code: typeof code === "string" && /^[0-9A-Z]{5}$/.test(code)
      ? code
      : "unknown",
  });
}
