import { withCors } from "./cors.ts";

export function jsonResponse(
  body: unknown,
  init: ResponseInit = {},
  req?: Request,
) {
  const headers = new Headers(init.headers ?? {});
  headers.set("Content-Type", "application/json; charset=utf-8");

  const merged = withCors(headers, req);
  const responseHeaders = new Headers();
  for (const [key, value] of merged.entries()) {
    responseHeaders.set(key, value);
  }

  return new Response(JSON.stringify(body), {
    ...init,
    headers: responseHeaders,
  });
}

export async function readJsonBody(req: Request) {
  try {
    return await req.json();
  } catch {
    return null;
  }
}
