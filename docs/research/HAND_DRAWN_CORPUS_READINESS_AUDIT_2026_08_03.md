# Hand-Drawn Corpus Readiness Audit

**Status:** Aggregate-only local audit; not approved for ingestion or model use
**Date:** 2026-08-03
**Related:** `TASK-0011`, `TASK-0016` Phase D

## Decision

The loose local hand-drawn sample corpus is **not ingestion-ready**. Its image
files are structurally readable, but it has no file-level consent/provenance
manifest, contains exact duplicates, and frequently contains embedded
ancillary metadata. It must not be copied into a governed corpus, uploaded,
or sent to an external provider based on folder placement alone.

## Privacy-preserving method

`scripts/drawn_response/prepare_capture_corpus.py audit` performed a read-only
scan of the local, untracked `docs/hand drawn samples/` directory. The durable
record contains aggregate counts only. No image, file name, relative path,
digest, embedded metadata value, or pixel content was copied into this branch.

The standard-library scanner:

- checks extension against PNG/JPEG signatures;
- reads dimensions without decoding or rendering pixels;
- computes SHA-256 locally to identify exact byte duplicates;
- flags the presence of JPEG APP1 or PNG eXIf/text chunks without reading or
  classifying their values; and
- compares files with an optional operator-supplied metadata declaration.

An embedded-metadata flag does not prove that a file contains personal data.
It means the file requires governed metadata inspection or an approved,
versioned stripping derivative before broader use.

## Aggregate result

| Check | Result |
| --- | ---: |
| Images scanned | 372 |
| Structurally unreadable supported images | 0 |
| JPEG | 322 |
| PNG | 50 |
| Total bytes | 887,554,954 (846.4 MiB) |
| Width range | 1,200–8,160 px |
| Height range | 1,745–6,197 px |
| Unique byte sequences | 294 |
| Exact-duplicate groups | 78 |
| Files participating in exact-duplicate groups | 156 |
| Excess exact copies | 78 |
| Files with detected ancillary metadata | 271 |
| Files with required metadata declarations | 0 of 372 |

Every duplicate group contains two byte-identical files. Exact duplication
does not establish which copy, if either, has the authoritative consent and
response identity.

## Required remediation

1. Obtain an authoritative file-by-file declaration covering response, item,
   exact content-item-version identity, provenance, consent basis, storage
   scope, and capture/ingestion timestamps. Do not infer these fields from
   directory or file names.
2. Resolve each duplicate group against that declaration. Preserve the
   governed original; do not silently select a copy by path order.
3. Decide, with privacy/security review, whether original ancillary metadata
   remains preserved in the private evidence object and which approved
   derivative strips it.
4. Run `prepare_capture_corpus.py build` only after the audit reports
   `ingestion_ready: true`. The builder fails closed on undeclared files,
   unknown declarations, exact duplicates, unreadable files, or invalid
   capture-image records.
5. Keep any resulting manifest private and partition real-response data before
   evaluation. External-provider transfer remains a separate Hard Gate.

## Tool verification

The builder was verified using the repository's synthetic local fixture
declaration and already-versioned PNG test assets. An undeclared corpus
returned nonzero under `--strict`; the fully declared fixture produced two
records that passed `validate_records.py capture_image`. No real hand-drawn
image was added to git or to the fixture set.
