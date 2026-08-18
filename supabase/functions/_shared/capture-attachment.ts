// Server-side validation for hand-drawn capture image attachments
// (TASK-0011 / TASK-0020 Program B).
//
// TASK-0020 found that a captured photo became a text placeholder string --
// no image was ever preserved, and nothing checked what a client claimed
// about an uploaded object. This module is the trust boundary: it re-derives
// media type, dimensions, byte size, and digest from the actual object
// bytes rather than believing client-supplied metadata, and it encodes the
// retake-lineage invariant from
// docs/research/HAND_DRAWN_CAPTURE_SESSION_CONTRACT_2026_08_03.md
// ("a capture-image original cannot be bound to two capture sessions" /
// every retake carries an explicit replaces_image_id).
//
// Pure functions only -- no Supabase client, no Deno.serve -- so they can be
// unit tested directly.

export type DetectedMediaType = "image/png" | "image/jpeg" | "image/webp";

export interface ImageDimensions {
  width: number | null;
  height: number | null;
}

export interface ImageIdentity extends ImageDimensions {
  mediaType: DetectedMediaType;
}

// Real phone-camera JPEGs from modern devices commonly land in the 2-12 MB
// range at full resolution; 20 MB gives headroom without accepting an
// unbounded upload. 1 KB floor rejects empty/truncated objects outright.
export const MIN_CAPTURE_BYTES = 1024;
export const MAX_CAPTURE_BYTES = 20 * 1024 * 1024;

// No real phone camera declares dimensions anywhere near this (a maxed-out
// modern sensor is ~10-15k px on its long edge). A declared width/height
// past this line is either a corrupt/crafted header or overflows the
// `pixel_width`/`pixel_height` `integer` (signed 32-bit, max 2147483647)
// columns on insert -- reject at validation time (422) rather than let a
// crafted header reach the database as an unhandled insert error (500).
export const MAX_DECLARED_DIMENSION_PX = 40_000;

const PNG_SIGNATURE = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];
const JPEG_SIGNATURE = [0xff, 0xd8, 0xff];
const RIFF = [0x52, 0x49, 0x46, 0x46]; // "RIFF"
const WEBP = [0x57, 0x45, 0x42, 0x50]; // "WEBP"

function startsWith(bytes: Uint8Array, signature: number[], offset = 0) {
  if (bytes.length < offset + signature.length) return false;
  for (let i = 0; i < signature.length; i++) {
    if (bytes[offset + i] !== signature[i]) return false;
  }
  return true;
}

function readUint32BE(bytes: Uint8Array, offset: number) {
  return (
    (bytes[offset] << 24) |
    (bytes[offset + 1] << 16) |
    (bytes[offset + 2] << 8) |
    bytes[offset + 3]
  ) >>> 0;
}

function readUint16BE(bytes: Uint8Array, offset: number) {
  return (bytes[offset] << 8) | bytes[offset + 1];
}

function parsePngDimensions(bytes: Uint8Array): ImageDimensions | null {
  // IHDR is always the first chunk, immediately after the 8-byte signature:
  // 4-byte length, 4-byte "IHDR", 4-byte width, 4-byte height (big-endian).
  // A signature match with no readable IHDR is a truncated/corrupt file,
  // not a valid PNG with unknown dimensions -- treat it as unidentified.
  if (bytes.length < 24 || !startsWith(bytes, [0x49, 0x48, 0x44, 0x52], 12)) {
    return null;
  }
  return {
    width: readUint32BE(bytes, 16),
    height: readUint32BE(bytes, 20),
  };
}

// SOF0-SOF3 (baseline/extended/progressive Huffman), SOF5-SOF7, SOF9-SOF11,
// SOF13-SOF15 all share the same height/width payload layout. DHT (0xC4),
// JPG (0xC8), and DAC (0xCC) are excluded even though they fall in the
// 0xC0-0xCF range.
const SOF_MARKERS = new Set([
  0xc0,
  0xc1,
  0xc2,
  0xc3,
  0xc5,
  0xc6,
  0xc7,
  0xc9,
  0xca,
  0xcb,
  0xcd,
  0xce,
  0xcf,
]);
const STANDALONE_MARKERS = new Set([0x01, 0xd8, 0xd9]);

function parseJpegDimensions(bytes: Uint8Array): ImageDimensions | null {
  let offset = 2; // past the FFD8 SOI marker
  // No separate iteration cap needed: offset strictly increases each pass
  // (by at least 1), so the loop is bounded by bytes.length regardless.
  while (offset + 1 < bytes.length) {
    if (bytes[offset] !== 0xff) {
      offset += 1;
      continue;
    }
    let marker = bytes[offset + 1];
    let cursor = offset + 2;
    // Skip fill bytes (0xFF padding between markers).
    while (marker === 0xff && cursor < bytes.length) {
      marker = bytes[cursor];
      cursor += 1;
    }
    if (marker === 0xd9 /* EOI */ || cursor >= bytes.length) break;
    if (STANDALONE_MARKERS.has(marker) || (marker >= 0xd0 && marker <= 0xd7)) {
      offset = cursor;
      continue;
    }
    if (cursor + 1 >= bytes.length) break;
    const segmentLength = readUint16BE(bytes, cursor);
    if (SOF_MARKERS.has(marker)) {
      const payload = cursor + 2;
      if (payload + 4 >= bytes.length) break;
      return {
        height: readUint16BE(bytes, payload + 1),
        width: readUint16BE(bytes, payload + 3),
      };
    }
    if (
      marker === 0xda /* SOS: entropy-coded data follows, no more markers */
    ) {
      break;
    }
    offset = cursor + segmentLength;
  }
  // No SOF marker found before EOI/SOS/truncation -- can't verify real
  // dimensions, so don't identify this as a valid capture.
  return null;
}

function parseWebpDimensions(bytes: Uint8Array): ImageDimensions | null {
  // Lossy (VP8 ) and lossless (VP8L) chunks encode dimensions differently;
  // extended-format (VP8X) canvas size is a third layout. Real phone
  // captures are essentially never WEBP, so only the layout we can verify
  // (VP8X) is accepted; anything else is treated as unidentified rather
  // than guessed at.
  if (bytes.length < 30) return null;
  const chunkId = String.fromCharCode(
    bytes[12],
    bytes[13],
    bytes[14],
    bytes[15],
  );
  if (chunkId === "VP8X") {
    // Bytes 24-26 / 27-29 store (width - 1) / (height - 1) as 24-bit LE.
    const width = (bytes[24] | (bytes[25] << 8) | (bytes[26] << 16)) + 1;
    const height = (bytes[27] | (bytes[28] << 8) | (bytes[29] << 16)) + 1;
    return { width, height };
  }
  return null;
}

export function identifyImage(bytes: Uint8Array): ImageIdentity | null {
  if (startsWith(bytes, PNG_SIGNATURE)) {
    const dims = parsePngDimensions(bytes);
    return dims ? { mediaType: "image/png", ...dims } : null;
  }
  if (startsWith(bytes, JPEG_SIGNATURE)) {
    const dims = parseJpegDimensions(bytes);
    return dims ? { mediaType: "image/jpeg", ...dims } : null;
  }
  if (startsWith(bytes, RIFF) && startsWith(bytes, WEBP, 8)) {
    const dims = parseWebpDimensions(bytes);
    return dims ? { mediaType: "image/webp", ...dims } : null;
  }
  return null;
}

export async function sha256HexOfBytes(bytes: Uint8Array) {
  // `bytes` may be view-backed by a SharedArrayBuffer-typed generic
  // (e.g. sliced from another Uint8Array) which TS's DOM lib doesn't accept
  // as BufferSource; copy into a fresh ArrayBuffer-backed view.
  const owned = new Uint8Array(bytes);
  const digest = await crypto.subtle.digest("SHA-256", owned);
  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

export type CaptureValidationResult =
  | {
    ok: true;
    mediaType: DetectedMediaType;
    width: number | null;
    height: number | null;
    byteSize: number;
    sha256: string;
  }
  | { ok: false; reason: string };

export async function validateCaptureObject(params: {
  bytes: Uint8Array;
  declaredMediaType?: string | null;
  declaredSha256?: string | null;
}): Promise<CaptureValidationResult> {
  const { bytes, declaredMediaType, declaredSha256 } = params;

  if (bytes.length < MIN_CAPTURE_BYTES) {
    return { ok: false, reason: "capture_too_small" };
  }
  if (bytes.length > MAX_CAPTURE_BYTES) {
    return { ok: false, reason: "capture_too_large" };
  }

  const identity = identifyImage(bytes);
  if (!identity) {
    return { ok: false, reason: "capture_signature_unrecognized" };
  }
  if (
    (identity.width !== null && identity.width > MAX_DECLARED_DIMENSION_PX) ||
    (identity.height !== null && identity.height > MAX_DECLARED_DIMENSION_PX)
  ) {
    return { ok: false, reason: "capture_dimensions_invalid" };
  }

  if (declaredMediaType && declaredMediaType !== identity.mediaType) {
    return { ok: false, reason: "capture_media_type_mismatch" };
  }

  const sha256 = await sha256HexOfBytes(bytes);
  if (declaredSha256 && declaredSha256.toLowerCase() !== sha256) {
    return { ok: false, reason: "capture_digest_mismatch" };
  }

  return {
    ok: true,
    mediaType: identity.mediaType,
    width: identity.width,
    height: identity.height,
    byteSize: bytes.length,
    sha256,
  };
}

export type AttachmentKind = "original" | "derived";

// Encodes the session-contract retake-lineage invariant purely in terms of
// what's already in the database: at most one current ORIGINAL per response
// version, and a retake must explicitly name the exact row it supersedes.
export function planAttachmentInsert(params: {
  kind: AttachmentKind;
  priorCurrentOriginalId: string | null;
  replacesAttachmentId: string | null;
}): { supersedesId: string | null } {
  const { kind, priorCurrentOriginalId, replacesAttachmentId } = params;

  if (kind !== "original") {
    if (replacesAttachmentId) {
      throw new Error("attach_capture:derived_cannot_replace");
    }
    return { supersedesId: null };
  }

  if (replacesAttachmentId) {
    if (!priorCurrentOriginalId) {
      throw new Error("attach_capture:no_current_original_to_replace");
    }
    if (priorCurrentOriginalId !== replacesAttachmentId) {
      throw new Error("attach_capture:stale_retake_target");
    }
    return { supersedesId: replacesAttachmentId };
  }

  if (priorCurrentOriginalId) {
    throw new Error("attach_capture:original_already_current");
  }
  return { supersedesId: null };
}
