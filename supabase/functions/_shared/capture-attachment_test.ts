// TASK-0011 / TASK-0020 Program B regression guard.
//
// TASK-0020 found that a hand-drawn capture became a text placeholder
// string with no image ever preserved, and that nothing validated what a
// client claimed about an uploaded object. These tests pin down the two
// load-bearing behaviors that close that gap: (1) media type/dimensions are
// re-derived from real bytes, not trusted from client metadata, and (2) the
// retake-lineage rule from HAND_DRAWN_CAPTURE_SESSION_CONTRACT_2026_08_03.md
// ("a capture-image original cannot be bound to two capture sessions") holds
// even under a stale/replayed client.

import {
  assertEquals,
  assertThrows,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  identifyImage,
  MAX_CAPTURE_BYTES,
  MAX_DECLARED_DIMENSION_PX,
  MIN_CAPTURE_BYTES,
  planAttachmentInsert,
  sha256HexOfBytes,
  validateCaptureObject,
} from "./capture-attachment.ts";

// Minimal but structurally real fixtures (built with Python's struct/zlib,
// no external image library): a 3x2 PNG, a 5x4 JPEG (SOF0 only, fabricated
// scan data), and a 7x6 WEBP VP8X container. Width and height are chosen
// unequal so a swapped-axis bug in the parser would fail these tests.
// Both fixtures are padded with trailing filler bytes (never parsed --
// identification only reads the header/marker structure) past the
// 1024-byte capture-size floor, so these exercise the same size path a
// real capture would.
const PNG_3X2 = Uint8Array.from(
  atob(
    "iVBORw0KGgoAAAANSUhEUgAAAAMAAAACCAIAAAASFvFNAAAAD0lEQVR4nGNg4BKBIjgLAAakALXcLc54AAAAAElFTkSuQmCCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
  ),
  (c) => c.charCodeAt(0),
);
const JPEG_5X4 = Uint8Array.from(
  atob(
    "/9j/4AAQSkZJRgABAQAAAQABAAD/wAARCAAEAAUDAREAAhEBAxEB/9oADAMBAAIRAxEAPwAAAAAAAAAAAP/ZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
  ),
  (c) => c.charCodeAt(0),
);
const WEBP_7X6 = Uint8Array.from(
  atob("UklGRhYAAABXRUJQVlA4WAoAAAAAAAAABgAABQAA"),
  (c) => c.charCodeAt(0),
);

Deno.test("identifyImage reads real PNG signature and IHDR dimensions", () => {
  const identity = identifyImage(PNG_3X2);
  assertEquals(identity, { mediaType: "image/png", width: 3, height: 2 });
});

Deno.test("identifyImage reads real JPEG signature and SOF0 dimensions", () => {
  const identity = identifyImage(JPEG_5X4);
  assertEquals(identity, { mediaType: "image/jpeg", width: 5, height: 4 });
});

Deno.test("identifyImage reads WEBP VP8X canvas dimensions", () => {
  const identity = identifyImage(WEBP_7X6);
  assertEquals(identity, { mediaType: "image/webp", width: 7, height: 6 });
});

Deno.test("identifyImage rejects a renamed non-image file (spoofed extension)", () => {
  const notAnImage = new TextEncoder().encode(
    "#!/bin/sh\necho this is not an image\n",
  );
  assertEquals(identifyImage(notAnImage), null);
});

Deno.test("identifyImage rejects a truncated PNG (signature only, no IHDR)", () => {
  assertEquals(identifyImage(PNG_3X2.slice(0, 8)), null);
});

Deno.test("identifyImage rejects a JPEG with no SOF marker before EOI", () => {
  const soiOnly = Uint8Array.from([0xff, 0xd8, 0xff, 0xd9]);
  assertEquals(identifyImage(soiOnly), null);
});

Deno.test("validateCaptureObject computes the real digest and dimensions", async () => {
  const expectedDigest = await sha256HexOfBytes(PNG_3X2);
  const result = await validateCaptureObject({ bytes: PNG_3X2 });
  assertEquals(result, {
    ok: true,
    mediaType: "image/png",
    width: 3,
    height: 2,
    byteSize: PNG_3X2.length,
    sha256: expectedDigest,
  });
});

Deno.test("validateCaptureObject rejects a client-declared media type that doesn't match the bytes", async () => {
  const result = await validateCaptureObject({
    bytes: PNG_3X2,
    declaredMediaType: "image/jpeg",
  });
  assertEquals(result, { ok: false, reason: "capture_media_type_mismatch" });
});

Deno.test("validateCaptureObject rejects a client-declared digest that doesn't match the bytes", async () => {
  const result = await validateCaptureObject({
    bytes: PNG_3X2,
    declaredSha256: "0".repeat(64),
  });
  assertEquals(result, { ok: false, reason: "capture_digest_mismatch" });
});

Deno.test("validateCaptureObject accepts a correct declared media type and digest", async () => {
  const digest = await sha256HexOfBytes(JPEG_5X4);
  const result = await validateCaptureObject({
    bytes: JPEG_5X4,
    declaredMediaType: "image/jpeg",
    declaredSha256: digest.toUpperCase(),
  });
  assertEquals(result.ok, true);
});

Deno.test("validateCaptureObject rejects undersized and oversized objects", async () => {
  const tiny = Uint8Array.from({ length: 10 }, () => 0);
  assertEquals(await validateCaptureObject({ bytes: tiny }), {
    ok: false,
    reason: "capture_too_small",
  });

  const huge = new Uint8Array(MAX_CAPTURE_BYTES + 1);
  huge.set(PNG_3X2.slice(0, 8));
  assertEquals(await validateCaptureObject({ bytes: huge }), {
    ok: false,
    reason: "capture_too_large",
  });
});

Deno.test("validateCaptureObject rejects a PNG with a declared width past the sane/integer-column ceiling", async () => {
  // A structurally valid PNG signature + IHDR whose declared width is
  // absurd (larger than any real camera, and larger than a Postgres
  // `integer` column can hold) -- padded with junk past MIN_CAPTURE_BYTES,
  // the same way a crafted-but-tiny attack file would be. Regression guard
  // for the finding that this used to sail through validation and crash
  // the DB insert with "integer out of range" instead of a clean 422.
  const bytes = new Uint8Array(MIN_CAPTURE_BYTES);
  bytes.set([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a], 0); // signature
  bytes.set([0x49, 0x48, 0x44, 0x52], 12); // "IHDR"
  const view = new DataView(bytes.buffer);
  view.setUint32(16, 0xffffffff); // declared width: 4294967295
  view.setUint32(20, 5); // declared height: 5 (plausible, isolates the width check)
  const result = await validateCaptureObject({ bytes });
  assertEquals(result, { ok: false, reason: "capture_dimensions_invalid" });
});

Deno.test("validateCaptureObject accepts a PNG at exactly the declared-dimension ceiling", async () => {
  const bytes = new Uint8Array(MIN_CAPTURE_BYTES);
  bytes.set([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a], 0);
  bytes.set([0x49, 0x48, 0x44, 0x52], 12);
  const view = new DataView(bytes.buffer);
  view.setUint32(16, MAX_DECLARED_DIMENSION_PX);
  view.setUint32(20, MAX_DECLARED_DIMENSION_PX);
  const result = await validateCaptureObject({ bytes });
  assertEquals(result.ok, true);
});

Deno.test("planAttachmentInsert allows a first original with no prior current row", () => {
  const plan = planAttachmentInsert({
    kind: "original",
    priorCurrentOriginalId: null,
    replacesAttachmentId: null,
  });
  assertEquals(plan, { supersedesId: null });
});

Deno.test("planAttachmentInsert rejects a second original that doesn't declare a retake target", () => {
  assertThrows(
    () =>
      planAttachmentInsert({
        kind: "original",
        priorCurrentOriginalId: "existing-id",
        replacesAttachmentId: null,
      }),
    Error,
    "original_already_current",
  );
});

Deno.test("planAttachmentInsert allows a retake that names the actual current original", () => {
  const plan = planAttachmentInsert({
    kind: "original",
    priorCurrentOriginalId: "existing-id",
    replacesAttachmentId: "existing-id",
  });
  assertEquals(plan, { supersedesId: "existing-id" });
});

Deno.test("planAttachmentInsert rejects a retake that names a stale/wrong target (replay/race guard)", () => {
  assertThrows(
    () =>
      planAttachmentInsert({
        kind: "original",
        priorCurrentOriginalId: "existing-id",
        replacesAttachmentId: "some-other-id",
      }),
    Error,
    "stale_retake_target",
  );
});

Deno.test("planAttachmentInsert rejects a retake target when nothing is currently bound", () => {
  assertThrows(
    () =>
      planAttachmentInsert({
        kind: "original",
        priorCurrentOriginalId: null,
        replacesAttachmentId: "existing-id",
      }),
    Error,
    "no_current_original_to_replace",
  );
});

Deno.test("planAttachmentInsert never sets supersedesId for a derived image", () => {
  const plan = planAttachmentInsert({
    kind: "derived",
    priorCurrentOriginalId: "existing-id",
    replacesAttachmentId: null,
  });
  assertEquals(plan, { supersedesId: null });
});

Deno.test("planAttachmentInsert rejects a derived image that claims to replace something", () => {
  assertThrows(
    () =>
      planAttachmentInsert({
        kind: "derived",
        priorCurrentOriginalId: "existing-id",
        replacesAttachmentId: "existing-id",
      }),
    Error,
    "derived_cannot_replace",
  );
});
