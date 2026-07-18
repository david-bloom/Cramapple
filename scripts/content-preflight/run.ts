#!/usr/bin/env -S deno run --allow-read
// CLI wrapper around the content completeness preflight
// (supabase/functions/_shared/content-preflight.ts).
//
// Run it on any content JSON before it is ingested (bulk-import payloads,
// authoring output) and in CI. Exits non-zero if any BLOCKING finding exists
// (or any finding with --strict), so an incomplete package cannot pass.
//
//   deno run --allow-read scripts/content-preflight/run.ts <file.json> [more.json ...] [--strict] [--json]
//
// Accepts either a bare array of items, or an object with an `items` array, and
// tolerates the bulk-import payload shape (FRQ criteria under `rubric`, MCQ
// choices under `choices`) as well as the subject-harness item-package shape
// (MCQ choices under `mcq_choices`, as authored in content/item-packages/).
// Items are located recursively by `item_type`.

import {
  type ContentItemPackage,
  preflightBatch,
} from "../../supabase/functions/_shared/content-preflight.ts";

// deno-lint-ignore no-explicit-any
function collectItems(node: any, out: any[]): void {
  if (node == null) return;
  if (Array.isArray(node)) {
    for (const v of node) collectItems(v, out);
    return;
  }
  if (typeof node === "object") {
    if (node.item_type === "mcq" || node.item_type === "frq") {
      out.push(node); // items do not nest — treat as a leaf to avoid double-collection
      return;
    }
    for (const v of Object.values(node)) collectItems(v, out);
  }
}

// deno-lint-ignore no-explicit-any
function adapt(raw: any): ContentItemPackage {
  const criteria = Array.isArray(raw.criteria)
    ? raw.criteria
    : Array.isArray(raw.rubric)
    ? raw.rubric
    : Array.isArray(raw?.prompt_json?.criteria)
    ? raw.prompt_json.criteria
    : undefined;
  return {
    content_key: raw.content_key ?? null,
    item_type: raw.item_type,
    status: raw.status ?? null,
    canonical_answer_1: raw.canonical_answer_1 ?? raw.canonical_answer ?? null,
    explanation: raw.explanation ?? raw?.prompt_json?.explanation ?? null,
    criteria,
    choices: Array.isArray(raw.choices)
      ? raw.choices
      : Array.isArray(raw.mcq_choices)
      ? raw.mcq_choices
      : undefined,
  };
}

function main() {
  const args = [...Deno.args];
  const strict = args.includes("--strict");
  const asJson = args.includes("--json");
  const files = args.filter((a) => !a.startsWith("--"));
  if (files.length === 0) {
    console.error("usage: run.ts <file.json> [...] [--strict] [--json]");
    Deno.exit(2);
  }

  const raw: unknown[] = [];
  for (const f of files) {
    const parsed = JSON.parse(Deno.readTextFileSync(f));
    collectItems(parsed, raw as unknown[]);
  }
  if (raw.length === 0) {
    console.error("No items with item_type mcq|frq found in input.");
    Deno.exit(2);
  }

  const pkgs = raw.map(adapt);
  const res = preflightBatch(pkgs, { strict });

  if (asJson) {
    console.log(JSON.stringify(res, null, 2));
  } else {
    console.log(`Preflight: ${pkgs.length} item(s) — ${res.blocking} blocking, ${res.warnings} warning(s).`);
    for (const f of res.findings) {
      console.log(`  [${f.severity}] ${f.content_key} ${f.location} ${f.code}: ${f.message}`);
    }
    console.log(res.ok ? "PASS" : "FAIL");
  }
  Deno.exit(res.ok ? 0 : 1);
}

main();
