import { assertEquals } from "jsr:@std/assert@1";
import { attachmentBindError, storageObjectFingerprint } from "./storage-primitives.ts";
Deno.test("attachment bind refusals keep both callers' status/error contract", () => {
  assertEquals(attachmentBindError("attach_capture:response_not_writable"), { status: 409, code: "response_already_submitted" });
  assertEquals(attachmentBindError("attach_capture:response_not_found"), { status: 404, code: "response_not_found" });
  assertEquals(attachmentBindError("attach_capture:stale_retake_target"), { status: 409, code: "attach_capture_stale_retake_target" });
  assertEquals(attachmentBindError(undefined), { status: 500, code: "attach_capture_failed" });
});
Deno.test("fingerprint uses exact basename and eTag before size, missing data fails closed", async () => {
  let data: Array<{ name: string; updated_at: string; metadata: { eTag?: string; size: number } }> | null = [
    { name: "other.png", updated_at: "wrong", metadata: { size: 1 } },
    { name: "a.png", updated_at: "stamp", metadata: { eTag: "tag", size: 10 } },
  ];
  const service = { storage: { from: (bucket: string) => ({ list: (folder: string, options: { search: string; limit: number }) => {
    assertEquals([bucket, folder, options.search, options.limit], ["learner-uploads", "user", "a.png", 100]);
    return Promise.resolve({ data, error: null });
  } }) } };
  assertEquals(await storageObjectFingerprint(service, "user/a.png"), "stamp:tag");
  data = [{ name: "a.png", updated_at: "stamp", metadata: { size: 10 } }];
  assertEquals(await storageObjectFingerprint(service, "user/a.png"), "stamp:10");
  data = null; assertEquals(await storageObjectFingerprint(service, "user/a.png"), null);
});
