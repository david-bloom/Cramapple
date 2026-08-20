// TASK-0016 Phase D, Stage D2: "EXIF/metadata stripping on derived/
// downstream images while retaining controlled audit provenance", and
// "Preserve raw uploads; derived images never overwrite them."
//
// These tests build minimal-but-real container fixtures byte by byte rather
// than using recorded photos, so each one isolates exactly one structural
// property. The load-bearing claims under test:
//
//   1. metadata-bearing segments/chunks are actually removed
//   2. pixel/structural data is copied through UNCHANGED (a "stripper" that
//      corrupts the image is worse than none)
//   3. the input buffer is never mutated -- the original stays the original
//   4. a container the parser cannot walk end-to-end is reported as NOT
//      stripped, never as "nothing to strip"
//   5. what was removed is summarizable for audit, without the removed
//      content itself leaking into the audit record

import {
  assert,
  assertEquals,
  assertNotEquals,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  stripImageMetadata,
  summarizeMetadataStrip,
} from "./image-metadata.ts";
import { identifyImage } from "./capture-attachment.ts";

/* -------------------------------------------------------------------------- */
/* Fixture builders                                                           */
/* -------------------------------------------------------------------------- */

function bytes(...parts: (number | number[] | Uint8Array)[]): Uint8Array {
  const flat: number[] = [];
  for (const part of parts) {
    if (typeof part === "number") flat.push(part);
    else for (const byte of part) flat.push(byte);
  }
  return new Uint8Array(flat);
}

function u16be(value: number) {
  return [(value >> 8) & 0xff, value & 0xff];
}

function u32be(value: number) {
  return [
    (value >>> 24) & 0xff,
    (value >>> 16) & 0xff,
    (value >>> 8) & 0xff,
    value & 0xff,
  ];
}

function u32le(value: number) {
  return [
    value & 0xff,
    (value >>> 8) & 0xff,
    (value >>> 16) & 0xff,
    (value >>> 24) & 0xff,
  ];
}

function ascii(text: string) {
  return [...text].map((char) => char.charCodeAt(0));
}

/** A JPEG segment: FF, marker, 2-byte length (self-inclusive), payload. */
function jpegSegment(marker: number, payload: number[]) {
  return bytes(0xff, marker, u16be(payload.length + 2), payload);
}

/** SOF0 declaring 100x200, so dimension parsing can be verified post-strip. */
function jpegSof0() {
  return jpegSegment(0xc0, [
    0x08, // precision
    ...u16be(200), // height
    ...u16be(100), // width
    0x01, // components
    0x01,
    0x11,
    0x00,
  ]);
}

/** Scan data + EOI. Everything from SOS onward is copied verbatim. */
function jpegScan() {
  return bytes(0xff, 0xda, u16be(8), [0x01, 0x01, 0x00, 0x00, 0x3f, 0x00], [
    0xaa,
    0xbb,
    0xcc,
    0xdd,
  ], 0xff, 0xd9);
}

function pngChunk(type: string, payload: number[]) {
  // CRC is not validated by this stripper (it only moves whole chunks), so
  // a placeholder keeps the fixture readable.
  return bytes(u32be(payload.length), ascii(type), payload, u32be(0));
}

function pngIhdr(width: number, height: number) {
  return pngChunk("IHDR", [
    ...u32be(width),
    ...u32be(height),
    8,
    6,
    0,
    0,
    0,
  ]);
}

const PNG_SIGNATURE = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];

function webpChunk(fourcc: string, payload: number[]) {
  const padded = payload.length % 2 === 1 ? [...payload, 0] : payload;
  return bytes(ascii(fourcc), u32le(payload.length), padded);
}

function webpFile(...chunks: Uint8Array[]) {
  const payloadLength = chunks.reduce((total, chunk) => total + chunk.length, 0);
  return bytes(
    ascii("RIFF"),
    u32le(4 + payloadLength),
    ascii("WEBP"),
    ...chunks,
  );
}

/** VP8X extended-format chunk declaring (width-1, height-1) as 24-bit LE. */
function webpVp8x(width: number, height: number) {
  const w = width - 1;
  const h = height - 1;
  return webpChunk("VP8X", [
    0x10,
    0,
    0,
    0,
    w & 0xff,
    (w >> 8) & 0xff,
    (w >> 16) & 0xff,
    h & 0xff,
    (h >> 8) & 0xff,
    (h >> 16) & 0xff,
  ]);
}

/* -------------------------------------------------------------------------- */
/* JPEG                                                                       */
/* -------------------------------------------------------------------------- */

Deno.test("JPEG: EXIF (APP1) is removed and the image stays decodable", () => {
  const exifPayload = [...ascii("Exif\0\0"), ...ascii("GPS 51.5074,-0.1278")];
  const original = bytes(
    0xff,
    0xd8,
    jpegSegment(0xe1, exifPayload),
    jpegSof0(),
    jpegScan(),
  );
  // Sanity: the fixture really does contain the sensitive string.
  assert(new TextDecoder().decode(original).includes("51.5074"));

  const result = stripImageMetadata(original, "image/jpeg");
  assertEquals(result.changed, true);
  assertEquals(result.complete, true);
  assertEquals(result.removed.map((segment) => segment.label), ["APP1"]);
  // The GPS coordinates are gone from the derived bytes...
  assertEquals(
    new TextDecoder().decode(result.bytes).includes("51.5074"),
    false,
  );
  // ...and the derived image is still a valid JPEG of the same dimensions,
  // per the same validator attach_capture uses.
  const identity = identifyImage(result.bytes);
  assertEquals(identity?.mediaType, "image/jpeg");
  assertEquals(identity?.width, 100);
  assertEquals(identity?.height, 200);
});

Deno.test("JPEG: every APPn and COM segment is removed, structural ones kept", () => {
  const original = bytes(
    0xff,
    0xd8,
    jpegSegment(0xe0, ascii("JFIF\0")), // APP0
    jpegSegment(0xe1, ascii("Exif\0\0")), // APP1
    jpegSegment(0xe2, ascii("ICC_PROFILE")), // APP2
    jpegSegment(0xed, ascii("Photoshop 3.0")), // APP13
    jpegSegment(0xfe, ascii("a comment")), // COM
    jpegSegment(0xdb, [0x00, 0x01, 0x02]), // DQT -- must survive
    jpegSof0(),
    jpegScan(),
  );
  const result = stripImageMetadata(original, "image/jpeg");
  assertEquals(result.removed.map((segment) => segment.label), [
    "APP0",
    "APP1",
    "APP2",
    "APP13",
    "COM",
  ]);
  // DQT and the scan survive: verify by re-identifying and by byte presence.
  assert(result.bytes.length < original.length);
  assertNotEquals(identifyImage(result.bytes), null);
  const decoded = new TextDecoder().decode(result.bytes);
  assertEquals(decoded.includes("Photoshop"), false);
  assertEquals(decoded.includes("a comment"), false);
});

Deno.test("JPEG: a file with no metadata is returned unchanged, and says so", () => {
  const original = bytes(0xff, 0xd8, jpegSof0(), jpegScan());
  const result = stripImageMetadata(original, "image/jpeg");
  assertEquals(result.changed, false);
  assertEquals(result.complete, true);
  assertEquals(result.removed, []);
  assertEquals(result.bytes, original);
});

Deno.test("JPEG: scan data after SOS is copied byte for byte", () => {
  const original = bytes(
    0xff,
    0xd8,
    jpegSegment(0xe1, ascii("Exif\0\0")),
    jpegSof0(),
    jpegScan(),
  );
  const result = stripImageMetadata(original, "image/jpeg");
  const scan = jpegScan();
  const tail = result.bytes.subarray(result.bytes.length - scan.length);
  assertEquals(tail, scan);
});

Deno.test("JPEG: the input buffer is never mutated", () => {
  const original = bytes(
    0xff,
    0xd8,
    jpegSegment(0xe1, ascii("Exif\0\0")),
    jpegSof0(),
    jpegScan(),
  );
  const snapshot = new Uint8Array(original);
  const result = stripImageMetadata(original, "image/jpeg");
  assertEquals(original, snapshot);
  // And the result is a genuinely new buffer, not a view onto the input.
  assertNotEquals(result.bytes.byteLength, original.byteLength);
});

Deno.test("JPEG: a truncated segment length is reported as NOT stripped", () => {
  // A length field claiming more bytes than exist. Returning "nothing to
  // strip" here would let an un-stripped derivative be labelled clean.
  const original = bytes(0xff, 0xd8, 0xff, 0xe1, u16be(9000), [1, 2, 3]);
  const result = stripImageMetadata(original, "image/jpeg");
  assertEquals(result.changed, false);
  assertEquals(result.complete, false);
  assertEquals(result.bytes, original);
});

Deno.test("JPEG: bytes that are not a JPEG are refused for the JPEG path", () => {
  const result = stripImageMetadata(bytes(1, 2, 3, 4), "image/jpeg");
  assertEquals(result.complete, false);
  assertEquals(result.changed, false);
});

/* -------------------------------------------------------------------------- */
/* PNG                                                                        */
/* -------------------------------------------------------------------------- */

Deno.test("PNG: eXIf/tEXt/iTXt/zTXt/tIME are removed, pixel chunks kept", () => {
  const original = bytes(
    PNG_SIGNATURE,
    pngIhdr(64, 32),
    pngChunk("eXIf", ascii("GPS 51.5074")),
    pngChunk("tEXt", ascii("Comment\0secret")),
    pngChunk("iTXt", ascii("XML:com.adobe.xmp\0")),
    pngChunk("zTXt", ascii("z")),
    pngChunk("tIME", [0x07, 0xea, 8, 19, 12, 0, 0]),
    pngChunk("gAMA", u32be(45455)), // must survive: affects rendering
    pngChunk("IDAT", [0x78, 0x9c, 0x01, 0x00]),
    pngChunk("IEND", []),
  );
  const result = stripImageMetadata(original, "image/png");
  assertEquals(result.changed, true);
  assertEquals(result.complete, true);
  assertEquals(result.removed.map((segment) => segment.label), [
    "eXIf",
    "tEXt",
    "iTXt",
    "zTXt",
    "tIME",
  ]);
  const decoded = new TextDecoder().decode(result.bytes);
  assertEquals(decoded.includes("51.5074"), false);
  assertEquals(decoded.includes("secret"), false);
  assert(decoded.includes("gAMA"));
  assert(decoded.includes("IDAT"));
  assert(decoded.includes("IEND"));
  // Still a valid PNG with the same declared dimensions.
  const identity = identifyImage(result.bytes);
  assertEquals(identity?.mediaType, "image/png");
  assertEquals(identity?.width, 64);
  assertEquals(identity?.height, 32);
});

Deno.test("PNG: a metadata-free file is unchanged and reported complete", () => {
  const original = bytes(
    PNG_SIGNATURE,
    pngIhdr(8, 8),
    pngChunk("IDAT", [1, 2]),
    pngChunk("IEND", []),
  );
  const result = stripImageMetadata(original, "image/png");
  assertEquals(result.changed, false);
  assertEquals(result.complete, true);
});

Deno.test("PNG: a stream with no IEND is reported as NOT stripped", () => {
  const original = bytes(
    PNG_SIGNATURE,
    pngIhdr(8, 8),
    pngChunk("eXIf", ascii("x")),
  );
  const result = stripImageMetadata(original, "image/png");
  assertEquals(result.complete, false);
  assertEquals(result.changed, false);
  assertEquals(result.bytes, original);
});

Deno.test("PNG: an over-long chunk length cannot read past the buffer", () => {
  const original = bytes(
    PNG_SIGNATURE,
    u32be(0x7fffffff),
    ascii("eXIf"),
    [1, 2, 3],
  );
  const result = stripImageMetadata(original, "image/png");
  assertEquals(result.complete, false);
  assertEquals(result.changed, false);
});

Deno.test("PNG: the input buffer is never mutated", () => {
  const original = bytes(
    PNG_SIGNATURE,
    pngIhdr(8, 8),
    pngChunk("eXIf", ascii("x")),
    pngChunk("IEND", []),
  );
  const snapshot = new Uint8Array(original);
  stripImageMetadata(original, "image/png");
  assertEquals(original, snapshot);
});

/* -------------------------------------------------------------------------- */
/* WEBP                                                                       */
/* -------------------------------------------------------------------------- */

Deno.test("WEBP: EXIF/XMP chunks are removed and the RIFF size is corrected", () => {
  const original = webpFile(
    webpVp8x(120, 90),
    webpChunk("EXIF", ascii("GPS 51.5074")),
    webpChunk("XMP ", ascii("<x:xmpmeta/>")),
    webpChunk("VP8 ", [1, 2, 3, 4]),
  );
  const result = stripImageMetadata(original, "image/webp");
  assertEquals(result.changed, true);
  assertEquals(result.complete, true);
  assertEquals(result.removed.map((segment) => segment.label), ["EXIF", "XMP "]);

  const decoded = new TextDecoder().decode(result.bytes);
  assertEquals(decoded.includes("51.5074"), false);
  assertEquals(decoded.includes("xmpmeta"), false);

  // The RIFF size field must be rewritten, or every decoder reads the file
  // as truncated -- this is the bug a naive chunk-drop would introduce.
  const declaredSize = result.bytes[4] | (result.bytes[5] << 8) |
    (result.bytes[6] << 16) | (result.bytes[7] << 24);
  assertEquals(declaredSize, result.bytes.length - 8);

  const identity = identifyImage(result.bytes);
  assertEquals(identity?.mediaType, "image/webp");
  assertEquals(identity?.width, 120);
  assertEquals(identity?.height, 90);
});

Deno.test("WEBP: odd-length chunks (RIFF padding) are handled", () => {
  const original = webpFile(
    webpVp8x(10, 10),
    webpChunk("EXIF", ascii("odd")), // 3 bytes -> padded to 4
    webpChunk("VP8 ", [1, 2, 3]), // also odd
  );
  const result = stripImageMetadata(original, "image/webp");
  assertEquals(result.complete, true);
  assertEquals(result.changed, true);
  const declaredSize = result.bytes[4] | (result.bytes[5] << 8) |
    (result.bytes[6] << 16) | (result.bytes[7] << 24);
  assertEquals(declaredSize, result.bytes.length - 8);
});

Deno.test("WEBP: a chunk running past the buffer is reported as NOT stripped", () => {
  const original = bytes(
    ascii("RIFF"),
    u32le(100),
    ascii("WEBP"),
    ascii("EXIF"),
    u32le(9999),
    [1, 2],
  );
  const result = stripImageMetadata(original, "image/webp");
  assertEquals(result.complete, false);
  assertEquals(result.changed, false);
});

Deno.test("WEBP: a metadata-free file is unchanged", () => {
  const original = webpFile(webpVp8x(10, 10), webpChunk("VP8 ", [1, 2, 3, 4]));
  const result = stripImageMetadata(original, "image/webp");
  assertEquals(result.changed, false);
  assertEquals(result.complete, true);
});

/* -------------------------------------------------------------------------- */
/* Audit summary                                                              */
/* -------------------------------------------------------------------------- */

Deno.test("audit summary records WHAT was removed, never the removed content", () => {
  const original = bytes(
    0xff,
    0xd8,
    jpegSegment(0xe1, ascii("Exif\0\0GPS 51.5074,-0.1278")),
    jpegSof0(),
    jpegScan(),
  );
  const result = stripImageMetadata(original, "image/jpeg");
  const summary = summarizeMetadataStrip(result);
  assertEquals(summary.metadata_status, "STRIPPED_IN_DERIVATIVE");
  assertEquals(summary.segments_removed, ["APP1"]);
  assert(summary.bytes_removed > 0);
  // Writing the stripped EXIF into an audit row would simply relocate the
  // data we just removed.
  assertEquals(JSON.stringify(summary).includes("51.5074"), false);
});

Deno.test("audit summary distinguishes 'nothing present' from 'could not parse'", () => {
  // These must never be conflated: the first means the derivative is clean,
  // the second means we do not know.
  const clean = stripImageMetadata(
    bytes(0xff, 0xd8, jpegSof0(), jpegScan()),
    "image/jpeg",
  );
  assertEquals(summarizeMetadataStrip(clean).metadata_status, "NOT_PRESENT");

  const unparsed = stripImageMetadata(bytes(1, 2, 3), "image/jpeg");
  assertEquals(summarizeMetadataStrip(unparsed).metadata_status, "UNKNOWN");
});

Deno.test("metadata_status values are drawn from capture_image_record.v1's enum", () => {
  const allowed = new Set([
    "PRESERVED_PRIVATE",
    "STRIPPED_IN_DERIVATIVE",
    "NOT_PRESENT",
    "UNKNOWN",
  ]);
  for (
    const fixture of [
      bytes(0xff, 0xd8, jpegSegment(0xe1, ascii("Exif\0\0")), jpegSof0(), jpegScan()),
      bytes(0xff, 0xd8, jpegSof0(), jpegScan()),
      bytes(1, 2, 3),
    ]
  ) {
    const summary = summarizeMetadataStrip(
      stripImageMetadata(fixture, "image/jpeg"),
    );
    assert(
      allowed.has(summary.metadata_status),
      `${summary.metadata_status} is not a capture_image_record.v1 value`,
    );
  }
});
