# Hand-Drawn Corpus Readiness — Groundwork (2026-08-19)

**Status:** Groundwork only. The corpus is still **not ingestion-ready**. Nothing in this
directory changes that conclusion or the decision recorded in
`docs/research/HAND_DRAWN_CORPUS_READINESS_AUDIT_2026_08_03.md`.

**Related:** `docs/research/HAND_DRAWN_CORPUS_READINESS_AUDIT_2026_08_03.md` (2026-08-03 audit,
`TASK-0011`, `TASK-0016` Phase D)

## What this is

This is a rerun of the 2026-08-03 audit against the current corpus, plus three pieces of
groundwork that do not require the blocked human declaration: a per-file duplicate/metadata
breakdown, a fillable provenance-declaration template, and a prototyped (not applied)
metadata-stripping script. No file under `docs/hand drawn samples/` was created, modified,
moved, deleted, or renamed by this work.

## 1. Current audit result — unchanged from 2026-08-03

`scripts/drawn_response/prepare_capture_corpus.py audit "docs/hand drawn samples" --show-paths`
was rerun today. The corpus directory now contains 382 total files (up from 372 at the
2026-08-03 audit), but the extra 10 are all outside the script's scope and outside the original
372-image count: 7 `.DS_Store`, 1 `.json`, and 2 `.pdf` files. The **image** corpus the script
scans (`.jpg`/`.jpeg`/`.png`) is exactly the same 372 files, and every audited number matches
the 2026-08-03 report exactly:

| Check | 2026-08-03 | 2026-08-19 (this run) |
| --- | ---: | ---: |
| Images scanned | 372 | 372 |
| Structurally unreadable | 0 | 0 |
| JPEG / PNG | 322 / 50 | 322 / 50 |
| Total bytes | 887,554,954 | 887,554,954 |
| Unique byte sequences | 294 | 294 |
| Exact-duplicate groups | 78 | 78 |
| Files in duplicate groups | 156 | 156 |
| Files with detected ancillary metadata | 271 | 271 |
| Files with required metadata declarations | 0 of 372 | 0 of 372 |
| `ingestion_ready` | false | false |

Conclusion: **nothing about the duplicate or metadata picture has changed** since the 2026-08-03
audit. The corpus grew only in non-image files that the ingestion pipeline never touches.

Full rerun output (aggregate + per-file lists, same read-only method as the original audit — SHA-256
digests and file paths only, no pixel content, no metadata values): `full_audit_report.json`.

## 2. Duplicate-group detail — `duplicate_groups.json`

All 78 exact-duplicate groups (156 files), each entry showing both (or all) file paths that
share a byte-identical SHA-256, not just the aggregate count the 2026-08-03 record kept. This is
the input a human will need for remediation item 2 (resolving duplicate groups against the
provenance declaration) — but per the audit, **no group should be resolved by path order alone**;
that still requires the declaration in item 3 below.

## 3. Metadata-flagged file detail — `metadata_flagged_files.json`

All 271 files where the scanner detected a JPEG APP1 segment or a PNG `eXIf`/`iTXt`/`tEXt`/`zTXt`
chunk. As with the 2026-08-03 audit, this flag only means the file *may* carry ancillary metadata
(e.g. EXIF) — the scanner does not read or classify the metadata's contents, so this is not proof
of what, if anything, personal is embedded.

## 4. Provenance-declaration template — ready for a human — `provenance_declaration_template.csv`

One row per image file (372 rows), pre-populated with `file_name` from the current corpus scan,
with empty columns for every field the audit's required declaration calls for
(`METADATA_REQUIRED` in `prepare_capture_corpus.py`):

`image_id, image_role, source_image_id, response_id, item_id, content_item_version_id,
transformation, metadata_status, provenance_status, consent_status, storage_scope, captured_at,
ingested_at`

All value columns are genuinely empty — nothing was inferred or guessed from directory names,
file names, or any other signal, per the audit's explicit instruction. A human with real
knowledge of who captured each photo and under what consent needs to fill this in; once filled,
it can be converted to the JSONL format `prepare_capture_corpus.py build --metadata` expects
(one JSON object per line, matching `METADATA_REQUIRED`).

## 5. Metadata-stripping prototype — demonstrated, NOT applied — `scripts/drawn_response/strip_capture_metadata.py`

A new standard-library-only script (matches `prepare_capture_corpus.py`'s no-third-party-dependency
constraint — confirmed by reading its imports: `argparse`, `hashlib`, `json`, `os`, `struct`,
`sys`, `tempfile`, `collections`, `dataclasses`, `pathlib`, `typing`, plus the local
`validate_records` module). It:

- opens the input file read-only and writes a stripped **copy** to a separate output path (refuses
  to overwrite an existing output without `--force`, and refuses if input and output paths match);
- for JPEG, copies every segment byte-for-byte except APP1 (0xFFE1), the segment type carrying
  Exif/XMP metadata;
- for PNG, copies the signature and every chunk byte-for-byte except `eXIf`, `iTXt`, `tEXt`,
  `zTXt` — the same four chunk types `prepare_capture_corpus.py`'s scanner flags;
- never reads or classifies the metadata's *value* — it only decides which segments/chunks to
  drop, consistent with the original audit's privacy-preserving method.

### Demo (3 files, not a full-corpus run)

Ran against 2 metadata-flagged JPEGs and 1 PNG (which had no flagged metadata, included to show
the script is a no-op pass-through when there's nothing to strip), output written to
`metadata_strip_demo/`:

| File | Original `embedded_metadata` | Stripped `embedded_metadata` | Dimensions preserved | Segments/chunks removed |
| --- | --- | --- | --- | --- |
| `Bio-HRD/IMG_1182.jpeg` | true | **false** | yes (4032×3024) | APP1 |
| `Bio-HRD/IMG_1183.jpeg` | true | **false** | yes (4032×3024) | APP1 |
| `HDG-2026-P1-EST-006__response-02.png` | false | false | yes (1608×2194) | none (nothing flagged) |

Verification method: reused `prepare_capture_corpus.py`'s own `inspect_image()` (same
signature/dimension/embedded-metadata detection logic the audit itself relies on) against both the
originals and the stripped copies. Both stripped JPEGs still parse as valid JPEGs with unchanged
pixel dimensions, and the same detector that originally flagged them now reports no embedded
metadata. The PNG demo confirms the script only strips what's actually flagged rather than
guessing.

Re-running the full corpus audit after the demo produced identical aggregate numbers (372 images,
78 duplicate groups, 271 metadata-flagged) to before the demo ran, confirming the demo did not
touch anything under `docs/hand drawn samples/`. The corpus directory is gitignored (see
`.gitignore:19`, `Hand Drawn Samples/`), so `git status`/`git diff` show nothing for it either way
— `git ls-files "docs/hand drawn samples"` returns 0 tracked files, and the pre/post audit-count
match is the practical confirmation available.

**This script is a prototype only.** Per the audit's remediation item 3, whether to strip
ancillary metadata at all, and which derivative is the "approved" one, is a privacy/security
review decision that has not been made. This script has not been run over the full corpus and
must not be treated as, or promoted to, an approved derivative without that review.

## What remains blocked — and why an AI agent cannot supply it

The audit's remediation item 1 requires an **authoritative human declaration** per file, covering
response identity, item identity, exact content-item-version identity, provenance, consent basis,
storage scope, and capture/ingestion timestamps — and explicitly forbids inferring these fields
from directory or file names. This requires real-world knowledge of who captured each photo, in
what context, and under what consent basis — none of which exists in any file, filename,
directory structure, or metadata value in this corpus today. No AI agent has access to that
information, and fabricating or guessing it (even as a "placeholder") would silently manufacture
consent/provenance data — exactly what the audit says not to do. Item 2 (resolving the 78
duplicate groups) explicitly depends on that declaration existing first, since it says not to
select a copy by path order. Item 3 (the metadata-stripping decision) requires a privacy/security
review that also has not happened; this session only prototyped and demonstrated one possible
mechanism for that review to evaluate.

## What a human needs to do next

1. Fill in `provenance_declaration_template.csv` (372 rows, all real, all sourced from actual
   knowledge of the capture — not inferred). This is the one blocking artifact; everything else
   in this directory is either already done (the audit rerun, the duplicate/metadata detail
   files) or ready to execute the moment the declaration exists (duplicate resolution using
   `duplicate_groups.json`, and a privacy/security decision on the stripping mechanism prototyped
   in `strip_capture_metadata.py`).
2. Once the declaration is complete, convert it to the JSONL format
   `prepare_capture_corpus.py build --metadata` expects and rerun `audit --strict` to confirm
   `ingestion_ready: true` before ever running `build`.
3. Separately, get a privacy/security review decision on whether/how to strip ancillary metadata,
   using `strip_capture_metadata.py` as a starting point if useful — it is not pre-approved.

## Files in this directory

- `README.md` — this file
- `full_audit_report.json` — full rerun of `prepare_capture_corpus.py audit --show-paths` against
  the current corpus (aggregate stats + all duplicate groups + all file errors/metadata gaps)
- `duplicate_groups.json` — all 78 exact-duplicate groups, full file paths on both/all sides
- `metadata_flagged_files.json` — all 271 files flagged with detected ancillary metadata
- `provenance_declaration_template.csv` — 372-row fillable template, one row per image file
- `metadata_strip_demo/` — 3 demo outputs from `strip_capture_metadata.py` (2 stripped JPEGs, 1
  pass-through PNG); small demonstration only, not a full-corpus run
