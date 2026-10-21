import "./_test_setup.ts";
import { assertEquals } from "jsr:@std/assert@1";
import { handleStorageSignUrl } from "./index.ts";

const user = "11111111-1111-4111-8111-111111111111";
function fixture(kind: string, role = "student", completionFails = false) {
  let signed = 0, deleted = 0, claims = 0;
  const service = {
    schema: () => ({
      rpc: (name: string) => {
        if (name === "claim_operation_replay") {
          const outcome = claims++ > 0 && kind === "claimed" ? "pending" : kind;
          return Promise.resolve({
            data: {
              kind: outcome,
              claim_token: user,
              result: { deleted: true },
            },
            error: null,
          });
        }
        return Promise.resolve({
          data: null,
          error: completionFails ? { message: "audit down" } : null,
        });
      },
    }),
    storage: {
      from: () => ({
        createSignedUrl: () =>
          Promise.resolve({
            data: { signedUrl: `download-${++signed}` },
            error: null,
          }),
        createSignedUploadUrl: () =>
          Promise.resolve({
            data: { signedUrl: `upload-${++signed}`, token: "fixture-token" },
            error: null,
          }),
        remove: () => {
          deleted++;
          return Promise.resolve({ error: null });
        },
      }),
    },
  };
  const run = (mode = "sign_download", path = `${user}/fixture.png`) =>
    handleStorageSignUrl(
      new Request("https://fixture/storage", {
        method: "POST",
        body: JSON.stringify({
          mode,
          bucket: "learner-uploads",
          path,
          idempotency_key: "fixture-key",
        }),
      }),
      {
        // deno-lint-ignore no-explicit-any
        service: service as any,
        // deno-lint-ignore no-explicit-any
        requireProfile: () =>
          Promise.resolve({ user: { id: user }, profile: { role } } as any),
      },
    );
  return {
    run,
    signed: () => signed,
    deleted: () => deleted,
    claims: () => claims,
  };
}
for (const mode of ["sign_upload", "sign_download"]) {
  Deno.test(`storage: ${mode} replay reauthorizes and returns a fresh URL`, async () => {
    const f = fixture("replay");
    const first = await (await f.run(mode)).json();
    const second = await (await f.run(mode)).json();
    assertEquals(typeof first.result.signed_url, "string");
    assertEquals(first.result.signed_url === second.result.signed_url, false);
  });
}
for (const role of ["student", "admin"]) {
  Deno.test(`storage: ${role} cannot use a conflicting claim`, async () => {
    const f = fixture("conflict", role);
    assertEquals((await f.run()).status, 409);
    assertEquals(f.signed(), 0);
  });
}
Deno.test("storage: ownership refusal precedes claim and signing", async () => {
  const f = fixture("replay");
  assertEquals(
    (await f.run("sign_upload", "other-user/private.png")).status,
    403,
  );
  assertEquals(f.claims(), 0);
  assertEquals(f.signed(), 0);
});
Deno.test("storage: delete replay never deletes twice", async () => {
  const f = fixture("replay", "admin");
  assertEquals((await f.run("sign_delete")).status, 200);
  assertEquals(f.deleted(), 0);
});
Deno.test("storage: audit failure after delete never retries the action", async () => {
  const f = fixture("claimed", "admin", true);
  assertEquals((await f.run("sign_delete")).status, 409);
  assertEquals((await f.run("sign_delete")).status, 409);
  assertEquals(f.deleted(), 1);
});
