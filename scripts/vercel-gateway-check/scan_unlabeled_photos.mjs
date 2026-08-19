// Scans every hand-drawn-sample photo whose FILENAME doesn't already carry
// an item code (see /tmp/all_images.txt's "unlabeled" list) and tries to
// read the visible item ID off the page itself via local OCR (free, ~300ms/
// photo). Cross-checks each detected ID against every known canonical-data
// source found this session:
//   - Biology P1 corpus (docs/research/hand_drawn_graph_corpus_2026_06_29)
//   - Biology P2 corpus (docs/research/hand_drawn_graph_corpus_2026_06_30)
//   - Statistics corpus (docs/research/apstats_hdg_graph_corpus_2026_08_18)
//   - Calc/Chem formula items.json (docs/research/trace_image_set_chemistry_calculus_2026_07_10)
// Produces a manifest: matched (real canonical data exists), format-known-
// but-unmatched (looks like a real ID but no canonical data found -- e.g.
// item numbers like "108" that don't exist in any known corpus), and
// unreadable (OCR found nothing ID-shaped -- needs manual review).

import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import os from 'node:os';
import sharp from 'sharp';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const SAMPLES_ROOT = '/Users/davidbloom/Documents/Cramapple.nosync/docs/hand drawn samples';
const OCR_BINARY = path.join(ROOT, 'scripts', 'vercel-gateway-check', 'vision_ocr');
const OUT_PATH = path.join(ROOT, 'docs', 'research', 'hand_drawn_samples_item_id_manifest_2026_08_18.json');

function loadKnownIds() {
  const known = new Set();
  const p1 = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29', 'hand_drawn_graph_questions_2026_06_29.jsonl');
  const p2 = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_30', 'hand_drawn_graph_questions_2026_06_30.jsonl');
  const stats = path.join(ROOT, 'docs', 'research', 'apstats_hdg_graph_corpus_2026_08_18', 'apstats_hdg_graph_questions_2026_08_18.jsonl');
  for (const f of [p1, p2, stats]) {
    if (!fs.existsSync(f)) continue;
    for (const line of fs.readFileSync(f, 'utf8').trim().split('\n').filter(Boolean)) {
      known.add(JSON.parse(line).item_id.toUpperCase());
    }
  }
  const formulaPath = path.join(ROOT, 'docs', 'research', 'trace_image_set_chemistry_calculus_2026_07_10', 'items.json');
  if (fs.existsSync(formulaPath)) {
    const items = JSON.parse(fs.readFileSync(formulaPath, 'utf8')).items;
    for (const it of items) known.add(it.item_id.toUpperCase());
  }
  return known;
}

function findUnlabeled() {
  const results = [];
  function walk(dir) {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) { walk(full); continue; }
      if (!/\.(jpe?g|png)$/i.test(entry.name)) continue;
      if (/HDG-2026|CALC-E|CALC-H|CHEM-E|CHEM-H|APSTATS|APBIO/i.test(entry.name)) continue; // already labeled
      results.push(full);
    }
  }
  walk(SAMPLES_ROOT);
  return results.sort();
}

async function runOcr(filePath) {
  const normalizedPath = path.join(os.tmpdir(), `scan_${Date.now()}_${Math.random().toString(36).slice(2)}.jpg`);
  await sharp(filePath).rotate().jpeg({ quality: 90 }).toFile(normalizedPath);
  try {
    const raw = execFileSync(OCR_BINARY, [normalizedPath], { maxBuffer: 10 * 1024 * 1024 }).toString('utf8');
    return JSON.parse(raw);
  } catch (e) {
    return [];
  } finally {
    fs.unlinkSync(normalizedPath);
  }
}

// Candidate ID patterns, forgiving of real OCR noise confirmed on actual
// samples this session: variable spacing/dashes around every separator
// ("HDG - 2026 - P1- EsT -00l" for "HDG-2026-P1-EST-001" -- note space-
// dash-space is common, not just a single optional dash), digit-lookalike
// substitution (trailing "1" read as lowercase "l"), and G<->A confusion
// ("HDA" for "HDG"). SEP matches any run of spaces/dashes (including none).
// DIGIT matches a real digit OR a common 1-lookalike (l/I), normalized to
// '1' when reconstructing the canonical ID.
const SEP = '[\\s-]*';
function normDigits(s) {
  return s.replace(/[lIL]/g, '1');
}

function extractCandidateIds(ocrItems) {
  const fullText = ocrItems.map((it) => it.text).join(' ');
  const candidates = [];
  let m;

  // Anchor on "2026-P[12]-ARCHETYPE-NNN" -- NOT on the "HDG" prefix, which
  // turned out to be unreliable across repeated OCR runs on the SAME photo
  // (observed "HDA", "HDO" for the same printed "HDG" -- Vision's text
  // recognition is not fully deterministic run-to-run). The numeric/
  // archetype core is much more stable.
  const bioRe = new RegExp(`\\b2026${SEP}(P[12])${SEP}(CAT|SER|EST)${SEP}([\\dlIL]{2,3})\\b`, 'gi');
  while ((m = bioRe.exec(fullText)) !== null) {
    candidates.push(`HDG-2026-${m[1].toUpperCase()}-${m[2].toUpperCase()}-${normDigits(m[3]).padStart(3, '0')}`);
  }

  // GRAPH-NNN is the reliable anchor for both APBIO/APSTATS; disambiguate
  // by whether "BIO" or "STAT" appears ANYWHERE in the photo's OCR text
  // (not necessarily adjacent -- label text is often split across lines/
  // OCR items), not by requiring the full literal prefix to read cleanly.
  const graphRe = new RegExp(`\\bGRAPH${SEP}([\\dlIL]{2,3})\\b`, 'gi');
  const hasBio = /\bBIO\b/i.test(fullText);
  const hasStats = /\bSTATS?\b/i.test(fullText);
  while ((m = graphRe.exec(fullText)) !== null) {
    const num = normDigits(m[1]).padStart(3, '0');
    if (hasBio) candidates.push(`APBIO-HDG-2026-GRAPH-${num}`);
    if (hasStats) candidates.push(`APSTATS-HDG-2026-GRAPH-${num}`);
    if (!hasBio && !hasStats) candidates.push(`UNKNOWN-SUBJECT-GRAPH-${num}`); // flagged, not a real canonical id
  }

  const calcRe = new RegExp(`\\bCALC${SEP}([EH][\\dlIL]{1,2})\\b`, 'gi');
  while ((m = calcRe.exec(fullText)) !== null) candidates.push(`CALC-${normDigits(m[1]).toUpperCase()}`);

  const chemRe = new RegExp(`\\bCHEM${SEP}([EH][\\dlIL]{1,2})\\b`, 'gi');
  while ((m = chemRe.exec(fullText)) !== null) candidates.push(`CHEM-${normDigits(m[1]).toUpperCase()}`);

  return [...new Set(candidates)];
}

async function main() {
  const knownIds = loadKnownIds();
  const files = findUnlabeled();
  console.log(`${files.length} unlabeled files to scan, ${knownIds.size} known canonical item_ids loaded\n`);

  const manifest = [];
  let done = 0;
  for (const filePath of files) {
    // Vision OCR isn't fully deterministic run-to-run on the same photo
    // (confirmed: same file read "HDA" then "HDO" for a printed "HDG" on
    // separate calls) -- retry up to 3 total attempts if nothing ID-shaped
    // is found before giving up, since it's free/local/fast.
    let candidates = [];
    for (let attempt = 0; attempt < 3 && candidates.length === 0; attempt += 1) {
      const ocrItems = await runOcr(filePath);
      candidates = extractCandidateIds(ocrItems);
    }
    // Fallback for GRAPH-NNN matches where OCR never surfaced "BIO"/"STATS"
    // text to disambiguate the subject: use the folder path as a strong
    // prior (e.g. everything under Stats-HRD-2/ is Statistics) rather than
    // leaving a real, resolvable ID as "unknown."
    const folderLower = filePath.toLowerCase();
    candidates = candidates.map((c) => {
      if (!c.startsWith('UNKNOWN-SUBJECT-GRAPH-')) return c;
      const num = c.replace('UNKNOWN-SUBJECT-GRAPH-', '');
      if (folderLower.includes('stat')) return `APSTATS-HDG-2026-GRAPH-${num}`;
      if (folderLower.includes('bio')) return `APBIO-HDG-2026-GRAPH-${num}`;
      return c;
    });
    const matched = candidates.filter((c) => knownIds.has(c));
    const unmatched = candidates.filter((c) => !knownIds.has(c));
    const relPath = path.relative(SAMPLES_ROOT, filePath);
    manifest.push({
      file_path: filePath,
      rel_path: relPath,
      candidates,
      matched_ids: matched,
      unmatched_looks_like_ids: unmatched,
      status: matched.length > 0 ? 'matched' : (unmatched.length > 0 ? 'format_known_no_canonical_data' : 'unreadable'),
    });
    done += 1;
    process.stdout.write(`[${done}/${files.length}] ${relPath} -> ${matched.length ? matched.join(',') : (unmatched.length ? 'UNMATCHED:' + unmatched.join(',') : 'no ID found')}\n`);
  }

  fs.writeFileSync(OUT_PATH, JSON.stringify(manifest, null, 1));

  const counts = { matched: 0, format_known_no_canonical_data: 0, unreadable: 0 };
  for (const m of manifest) counts[m.status] += 1;
  console.log(`\n=== Summary ===`);
  console.log(`matched (real canonical data found): ${counts.matched}`);
  console.log(`format-known but NO canonical data exists: ${counts.format_known_no_canonical_data}`);
  console.log(`unreadable (no ID pattern detected, needs manual review): ${counts.unreadable}`);
  console.log(`wrote ${OUT_PATH}`);
}

main().catch((e) => { console.error(e); process.exit(1); });
