// Fact pack <-> taxonomy consistency check.
//
// Why this exists: on 2026-09-29 the AP Calculus fact pack said "Euler's method
// and logistic differential equations are shared AB/BC content" while the SAME
// document's Unit 7 exclusion note correctly called both BC-only. The taxonomy
// tables agreed with the exclusion note — app.taxonomy_topics has never
// registered 7.5 or 7.9 for ap_calculus_ab. The contradiction sat in the
// database the whole time and nobody compared the two. It licensed three
// published apcalcab-* items on BC-only content, which a prior audit had
// explicitly concluded did not exist.
//
// This compares the TOPIC CODE SET each fact pack asserts in prose against the
// set app.taxonomy_topics registers for that subject. Codes, not titles: a code
// set is exact and is what catches scope errors, whereas fuzzy-matching prose
// titles produces noise that gets ignored, which is how a check dies.
//
// Database-free by design, same as the labelling scripts. The DB side is a JSON
// file produced by this query through the Supabase MCP tool:
//
//   select jsonb_object_agg(subject_key, codes) from (
//     select tsv.subject_key,
//            jsonb_agg(t.topic_code order by t.unit_number, t.topic_code) codes
//     from app.taxonomy_topics t
//     join app.taxonomy_source_versions tsv
//       on tsv.taxonomy_source_version = t.taxonomy_source_version
//     group by tsv.subject_key) z;
//
// Usage:
//   node check_fact_pack_topics.mjs --db=db_topics.json [--docs=docs/product] [--json]
// Exit code 1 if any subject mismatches, so it can gate CI.

import fs from "node:fs";
import path from "node:path";

const arg = (n, d = null) => {
  const h = process.argv.find((a) => a.startsWith(`--${n}=`));
  return h ? h.slice(n.length + 3) : d;
};
const DB_FILE = arg("db");
const DOCS = arg("docs", "docs/product");
const AS_JSON = process.argv.includes("--json");

// Fact pack file stem -> taxonomy subject_key. Kept explicit rather than
// derived: AP_STATISTICS_2027 -> ap_statistics is not a mechanical mapping, and
// a silent mis-derivation would make a subject look consistent by comparing it
// against nothing.
const PACKS = {
  AP_BIOLOGY: "ap_biology",
  AP_CHEMISTRY: "ap_chemistry",
  AP_PHYSICS_1: "ap_physics_1",
  AP_PHYSICS_2: "ap_physics_2",
  AP_PHYSICS_C_MECHANICS: "ap_physics_c_mechanics",
  AP_PHYSICS_C_EM: "ap_physics_c_em",
  AP_STATISTICS_2027: "ap_statistics",
  AP_PRECALCULUS: "ap_precalculus",
  // One pack covers two subjects. AB is the subset; BC adds Units 9-10 plus the
  // six BC-only topics inside Units 1-8. A single pack cannot be diffed against
  // both as an equality, so AB is checked as a SUBSET of what the pack lists and
  // BC as the full set. See compare().
  AP_CALCULUS_AB_BC: ["ap_calculus_ab", "ap_calculus_bc"],
};

// The nine packs use four different layouts for the same information:
//   "### Unit 1 - Name"  then  "1.1 Title; 1.2 Title; ..."     (Calculus, Chemistry, Precalculus)
//   "### Unit 1 — Name"  then  "- 1.1 Title"                    (Biology)
//   "| Topic | Title | Skills |" markdown table                 (Statistics)
//   "Unit 1 (Name): 1.1 Title, 1.2 Title, ..."                  (Physics)
// Rather than four parsers, extract every topic code that begins an ENTRY: a code
// that follows a line start or an entry separator. The separator requirement is
// what distinguishes a scope claim from a decimal mentioned mid-prose.
//
// Each clause below was added because a real pack needed it, and removing any one
// silently drops a whole subject:
//   ':'          Physics — "Unit 1 (Kinematics): 1.1 Scalars and Vectors"
//   '|'          Statistics — markdown table rows, "| 1.1 | Introducing ..."
//   [A-Za-z(|]   Chemistry — titles that begin lowercase, "8.2 pH and pOH of ..."
//                and table cells where the code is followed by ' |' not a title.
// The first version of this check required an uppercase title and no ':' or table
// support, and reported 5 subjects broken that were fine — a false-positive rate
// that would have got the check switched off within a week.
const ENTRY = /(?:^|[-–—;,|:]\s*|\s{2,})(\d{1,2}\.\d{1,2})\s*(?=[A-Za-z(|])/gm;

function topicSection(text) {
  // Take from the topic-map heading to the next same-or-higher heading. Without
  // this bound, later sections (Learning Objectives, deep-tier detail, authoring
  // guidance) contribute codes that are references, not scope claims.
  const lines = text.split("\n");
  const start = lines.findIndex((l) => /^#{2,3}\s.*\btopic map\b/i.test(l));
  if (start < 0) return null;
  const level = (lines[start].match(/^#+/) || ["##"])[0].length;
  let end = lines.length;
  for (let i = start + 1; i < lines.length; i++) {
    const m = lines[i].match(/^(#+)\s/);
    if (m && m[1].length <= level) { end = i; break; }
  }
  return lines.slice(start, end).join("\n");
}

function packCodes(file) {
  const text = fs.readFileSync(file, "utf8");
  const section = topicSection(text);
  if (section === null) return { error: "no '## Topic map' heading found" };
  // Strip markdown emphasis first. AP Physics C writes
  // "**Unit 1 (Kinematics):** 1.1 Scalars and Vectors", where the '*' sits
  // between the separator and the code and would otherwise hide every X.1.
  const flat = section.replace(/\*+/g, "");
  const codes = new Set();
  let m;
  ENTRY.lastIndex = 0;
  while ((m = ENTRY.exec(flat)) !== null) codes.add(m[1]);
  return { codes };
}

const sortCodes = (a) =>
  [...a].sort((x, y) => {
    const [xu, xt] = x.split(".").map(Number);
    const [yu, yt] = y.split(".").map(Number);
    return xu - yu || xt - yt;
  });

function compare(packName, subject, packCodeSet, dbCodes, mode) {
  const db = new Set(dbCodes);
  const inDbNotPack = sortCodes([...db].filter((c) => !packCodeSet.has(c)));
  const inPackNotDb = sortCodes([...packCodeSet].filter((c) => !db.has(c)));
  // A shared pack legitimately lists topics its subset subject excludes, so for
  // the subset only "registered in the DB but absent from the pack" is a fault.
  const subsetMode = mode === "subset";
  const violations = subsetMode ? inDbNotPack : [...inDbNotPack, ...inPackNotDb];
  return {
    pack: packName, subject, mode: mode || "exact",
    pack_topics: packCodeSet.size, db_topics: db.size,
    in_db_not_in_pack: inDbNotPack,
    in_pack_not_in_db: subsetMode ? [] : inPackNotDb,
    extra_in_pack_expected_for_subset: subsetMode ? inPackNotDb.length : undefined,
    ok: violations.length === 0,
  };
}

function main() {
  if (!DB_FILE) { console.error("--db=<db_topics.json> is required"); process.exit(2); }
  const db = JSON.parse(fs.readFileSync(path.resolve(DB_FILE), "utf8"));
  const results = [];

  for (const [stem, subjects] of Object.entries(PACKS)) {
    const file = path.resolve(DOCS, `${stem}_CED_FACT_PACK.md`);
    if (!fs.existsSync(file)) {
      results.push({ pack: stem, subject: null, ok: false, error: "fact pack file not found" });
      continue;
    }
    const parsed = packCodes(file);
    if (parsed.error) {
      results.push({ pack: stem, subject: null, ok: false, error: parsed.error });
      continue;
    }
    const list = Array.isArray(subjects) ? subjects : [subjects];
    for (const subject of list) {
      if (!db[subject]) {
        results.push({ pack: stem, subject, ok: false, error: "subject absent from the DB snapshot" });
        continue;
      }
      // For a shared pack, the LARGER subject is the exact match and the smaller
      // one is a subset. Decided by DB size rather than hardcoding AB/BC, so this
      // keeps working if another shared pack is added.
      const sizes = list.map((s) => (db[s] || []).length);
      const isLargest = (db[subject] || []).length === Math.max(...sizes);
      const mode = list.length > 1 && !isLargest ? "subset" : "exact";
      results.push(compare(stem, subject, parsed.codes, db[subject], mode));
    }
  }

  if (AS_JSON) { console.log(JSON.stringify(results, null, 2)); }
  else {
    for (const r of results) {
      const tag = r.ok ? "OK  " : "FAIL";
      if (r.error) { console.log(`${tag} ${r.pack} — ${r.error}`); continue; }
      console.log(`${tag} ${r.subject.padEnd(24)} pack=${String(r.pack_topics).padStart(3)} db=${String(r.db_topics).padStart(3)} (${r.mode})`);
      if (r.in_db_not_in_pack.length) console.log(`       registered in the taxonomy but MISSING from the fact pack: ${r.in_db_not_in_pack.join(", ")}`);
      if (r.in_pack_not_in_db.length) console.log(`       claimed by the fact pack but NOT registered: ${r.in_pack_not_in_db.join(", ")}`);
    }
    const bad = results.filter((r) => !r.ok).length;
    console.log("");
    console.log(bad ? `${bad} subject(s) inconsistent` : `all ${results.length} subject checks consistent`);
  }
  process.exit(results.some((r) => !r.ok) ? 1 : 0);
}

main();
