# AP Statistics Packet Bundle - 2026-07-07

This bundle slices the AP Statistics FRQ pools into 4-FRQ grading test
packets, built per `docs/research/grading_test_packet_requirements.md` and
aligned with `docs/research/apbio_packet_bundle_2026_07_07/`'s structure
(same `packet_index.json` shape, same "concrete now / shell for the rest"
pattern where a pool falls short of the requested packet count).

**Status: AI-provisional, unapproved, draft.** Nothing in this bundle has
been reviewed by Learning Quality or approved for actual grading-test
execution. See "Approval status" below.

## What is included

- `packet_index.json`: machine-readable packet inventory (both modes).
- `frq_only_pool.json`: 40-item non-HDR FRQ pool (10 existing + 30 new).
- `hdr_frq_pool.json`: 40-item HDR-capable FRQ pool (12 existing + 28 new).
- `trace_pages/`: 28 printable trace pages + 1 combined PDF + manifest for
  the new HDR items that still need real hand-drawn responses.
- `scripts/`: the generator scripts and data files that produced everything
  above, for reproducibility.

## Counts

**FRQ-only (no hand-drawn response):**
- Source pools: 10 existing items (`docs/research/benchmark_corpus_2026_07_06/statistics_frq_*`,
  branch `claude/benchmark-corpus-2026-07-06`, PR #30) + 30 newly authored
  items (`APSTATS-FRQ-011` through `APSTATS-FRQ-040`) = 40 total.
- Full 4-FRQ packets: **10 of 10 requested** (`APSTATS-FRQ-PKT-01`
  through `-10`). No remainder -- the pool was sized exactly to fill the
  request.

**FRQ+HDR (with hand-drawn response):**
- Source pools: 12 existing items (`docs/research/ap_statistics_graph_response_seed_2026_07_02/`,
  all 12 with real photographed hand-drawn responses and proposed gold
  labels from `docs/research/ap_statistics_hdr_grading_experiment_2026_07_06/`)
  + 28 newly authored items (`APSTATS-HDG-2026-GRAPH-013` through `-040`)
  = 40 total.
- Full 4-FRQ packets: **10 of 10 requested** (`APSTATS-FRQ-HDR-PKT-01`
  through `-10`), but only **3 are concrete/graded** (packets 01-03, using
  the 12 existing items with real photographed responses). The remaining
  **7 are shells** (packets 04-10) -- the FRQ definitions, rubrics, and
  canonical answers are fully written and each has a printable trace page
  ready, but no real hand-drawn response exists yet. These 7 packets need
  David to draw and photograph 28 responses (one per trace page) before
  they're execution-ready, the same way the last HDR round was completed.

## How the FRQ+HDR shell packets become execution-ready

1. Print `trace_pages/apstats_hdr_trace_pages_2026_07_07.pdf` (28 pages, one
   per new item) or the individual PNGs in `trace_pages/pages/`.
2. For each page, trace/redraw the faint graph on paper and **write out the
   interpretive sentence the stem asks for** -- the previous HDR round found
   that 10 of 12 first-draft photos omitted this, so it's called out
   up front this time rather than discovered after the fact.
3. Photograph each page, keeping the item ID visible.
4. Hand the photos back for grading the same way the 2026-07-06 batch was
   processed (identify by item ID, grade against the criteria in
   `hdr_frq_pool.json`, propose labels, get them confirmed).

## Approval status

Per `grading_test_packet_requirements.md` and the same governance pattern
used throughout this project's research corpus:

- **The 10 existing non-HDR FRQs and 12 existing HDR FRQs** are already
  flagged `ai_provisional_unapproved` / "Staged for tutor review only" at
  their source -- unchanged by inclusion here.
- **The 30 new non-HDR FRQs and 28 new HDR FRQs** are freshly
  Claude-authored for this bundle and have not been reviewed by anyone.
- **The 12 HDR items' proposed gold labels** (45/48 points, see
  `docs/research/ap_statistics_hdr_grading_experiment_2026_07_06/`) are
  still `claude_proposed_pending_approval`, not confirmed gold.

Nothing in this bundle should be treated as a frozen, human-approved
grading test packet until that review happens.

## Source references

- [Grading packet requirements](/Users/davidbloom/Documents/Cramapple/docs/research/grading_test_packet_requirements.md)
- [AP Biology packet bundle (structural model for this bundle)](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_packet_bundle_2026_07_07/README.md)
- [Existing 10 non-HDR Statistics FRQs](/Users/davidbloom/Documents/Cramapple/docs/research/benchmark_corpus_2026_07_06/) (branch `claude/benchmark-corpus-2026-07-06`)
- [Existing 12 HDR Statistics FRQs + photographed responses](/Users/davidbloom/Documents/Cramapple/docs/research/ap_statistics_hdr_grading_experiment_2026_07_06/)
- [Original AP Statistics graph-response seed](/Users/davidbloom/Documents/Cramapple/docs/research/ap_statistics_graph_response_seed_2026_07_02/)
