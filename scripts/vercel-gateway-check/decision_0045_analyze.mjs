// Computes the three DECISION-0045 verification numbers for the Engine 4
// real-photo gold corpus:
//   1. Per-criterion and overall agreement of each verifier vs. the existing
//      (Claude-written) gold.
//   2. Unanimity rate between the two verifiers with each other (independent
//      of the existing gold).
//   3. Every case where both verifiers unanimously disagree with the
//      existing gold label -- flagged as candidate corrections, never
//      auto-applied.
//
// Reads the two raw verifier JSONL files (append-only, produced by
// decision_0045_verify_run.mjs / retry_failed.mjs) and the existing gold
// JSON. Writes a JSON summary + a discrepancy list. Does not modify the
// existing gold file or the raw verifier output files.

import fs from 'node:fs';
import path from 'node:path';

const ROOT = '/Users/davidbloom/Documents/Cramapple.nosync';
const BENCH_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const VERIFY_DIR = path.join(BENCH_DIR, 'decision_0045_verification_2026_08_19');
const GOLD_JSON = path.join(BENCH_DIR, 'gold', 'real_photo_gold_labels_2026_08_18.json');

const GEMINI_JSONL = path.join(VERIFY_DIR, 'runs', 'verifier_gemini25flash_results.jsonl');
const QWEN_JSONL = path.join(VERIFY_DIR, 'runs', 'verifier_qwen3vl_results.jsonl');

function loadJsonl(p) {
  return fs.readFileSync(p, 'utf8').split('\n').filter(Boolean).map((l) => JSON.parse(l));
}

// Later records win (retries appended after original failures). Keyed by
// (item_id, file_name) since the gold corpus has 2 packet copies of some
// item_ids with the same response_index but different packets.
function latestByPhoto(records) {
  const byKey = new Map();
  for (const r of records) {
    const key = `${r.item_id}::${r.file_name || r.file_path}`;
    byKey.set(key, r); // last write wins -- retries appended later overwrite originals
  }
  return byKey;
}

function loadGold() {
  const records = JSON.parse(fs.readFileSync(GOLD_JSON, 'utf8'));
  const byFilePath = new Map();
  for (const r of records) byFilePath.set(path.resolve(r.file_path), r);
  return byFilePath;
}

function main() {
  const gemini = loadJsonl(GEMINI_JSONL);
  const qwen = loadJsonl(QWEN_JSONL);
  const geminiByKey = latestByPhoto(gemini);
  const qwenByKey = latestByPhoto(qwen);
  const gold = loadGold();

  console.log(`gemini records: ${gemini.length} raw, ${geminiByKey.size} unique photos`);
  console.log(`qwen records: ${qwen.length} raw, ${qwenByKey.size} unique photos`);
  console.log(`gold records: ${gold.size}`);

  // Build a common photo list keyed by absolute file_path, present in gold
  // AND with an ok:true record from BOTH verifiers.
  const rows = [];
  for (const [goldFilePath, goldRec] of gold) {
    // Find matching gemini/qwen record by file_path (resolve both ways --
    // verifier records store file_path directly).
    let g = null, q = null;
    for (const r of geminiByKey.values()) {
      if (r.file_path && path.resolve(r.file_path) === goldFilePath) { g = r; break; }
    }
    for (const r of qwenByKey.values()) {
      if (r.file_path && path.resolve(r.file_path) === goldFilePath) { q = r; break; }
    }
    rows.push({ goldFilePath, goldRec, gemini: g, qwen: q });
  }

  const missingGemini = rows.filter((r) => !r.gemini || r.gemini.ok === false);
  const missingQwen = rows.filter((r) => !r.qwen || r.qwen.ok === false);
  console.log(`photos missing/failed gemini (API/parse error): ${missingGemini.length}`);
  console.log(`photos missing/failed qwen (API/parse error): ${missingQwen.length}`);
  if (missingGemini.length) console.log('  gemini gaps:', missingGemini.map((r) => path.basename(r.goldFilePath)).join(', '));
  if (missingQwen.length) console.log('  qwen gaps:', missingQwen.map((r) => path.basename(r.goldFilePath)).join(', '));

  // IMPORTANT reliability finding: alibaba/qwen3-vl-235b-a22b-instruct returns
  // ok:true (the API call succeeded and the empty array validates against the
  // zod schema) but an EMPTY criterion_statuses array -- no judgment at all --
  // for every photo of the continuous_relationship_graph_derived_estimate
  // (EST) archetype. schema_valid:false catches this (it requires every gold
  // criterion_id to be present in the prediction). These are excluded from
  // "usable" below as a qwen non-response, NOT counted as qwen disagreeing
  // with the photo's content -- conflating the two would understate qwen's
  // per-criterion agreement on the archetypes it actually attempts.
  const qwenEmptyResponses = rows.filter((r) => r.qwen && r.qwen.ok !== false && r.qwen.schema_valid === false);
  const geminiEmptyResponses = rows.filter((r) => r.gemini && r.gemini.ok !== false && r.gemini.schema_valid === false);
  console.log(`qwen ok:true but schema_valid:false (empty/partial judgment): ${qwenEmptyResponses.length}`);
  console.log(`gemini ok:true but schema_valid:false (empty/partial judgment): ${geminiEmptyResponses.length}`);
  const qwenEmptyByArchetype = {};
  for (const r of qwenEmptyResponses) {
    const archetype = r.qwen.archetype || 'unknown';
    qwenEmptyByArchetype[archetype] = (qwenEmptyByArchetype[archetype] || 0) + 1;
  }
  console.log('  qwen empty-response breakdown by archetype:', JSON.stringify(qwenEmptyByArchetype));

  const usable = rows.filter(
    (r) => r.gemini && r.gemini.ok !== false && r.gemini.schema_valid !== false
      && r.qwen && r.qwen.ok !== false && r.qwen.schema_valid !== false,
  );
  console.log(`usable photos (both verifiers ok AND schema_valid -- i.e. both actually returned a full judgment): ${usable.length} / ${rows.length}`);

  // --- Metric 1: per-criterion and overall agreement, each verifier vs gold ---
  function agreementVsGold(verifierKey) {
    let totalCriteria = 0, agree = 0;
    let exactMatchPhotos = 0;
    const perCriterion = {}; // criterion_id -> {total, agree}
    for (const row of usable) {
      const verifierRec = row[verifierKey];
      const goldMap = row.goldRec.criterion_statuses;
      const predMap = verifierRec.criterion_statuses || {};
      let photoAllAgree = true;
      for (const [cid, goldStatus] of Object.entries(goldMap)) {
        totalCriteria += 1;
        perCriterion[cid] = perCriterion[cid] || { total: 0, agree: 0 };
        perCriterion[cid].total += 1;
        const predStatus = predMap[cid];
        const matches = predStatus === goldStatus;
        if (matches) { agree += 1; perCriterion[cid].agree += 1; }
        else photoAllAgree = false;
      }
      if (photoAllAgree) exactMatchPhotos += 1;
    }
    return {
      overallAgreementRate: totalCriteria ? agree / totalCriteria : null,
      totalCriteriaJudgments: totalCriteria,
      agreeCount: agree,
      exactMatchPhotoRate: usable.length ? exactMatchPhotos / usable.length : null,
      exactMatchPhotos,
      perCriterion: Object.fromEntries(
        Object.entries(perCriterion).map(([cid, v]) => [cid, { ...v, rate: v.total ? v.agree / v.total : null }]),
      ),
    };
  }

  const geminiVsGold = agreementVsGold('gemini');
  const qwenVsGold = agreementVsGold('qwen');

  // --- Metric 2: unanimity rate between the two verifiers (independent of gold) ---
  let totalCriteria2 = 0, verifierAgree = 0, exactMatchPhotos2 = 0;
  const perCriterionVerifierAgreement = {};
  for (const row of usable) {
    const gMap = row.gemini.criterion_statuses || {};
    const qMap = row.qwen.criterion_statuses || {};
    const criteriaIds = Object.keys(row.goldRec.criterion_statuses);
    let photoAllAgree = true;
    for (const cid of criteriaIds) {
      totalCriteria2 += 1;
      perCriterionVerifierAgreement[cid] = perCriterionVerifierAgreement[cid] || { total: 0, agree: 0 };
      perCriterionVerifierAgreement[cid].total += 1;
      const matches = gMap[cid] === qMap[cid] && gMap[cid] !== undefined;
      if (matches) { verifierAgree += 1; perCriterionVerifierAgreement[cid].agree += 1; }
      else photoAllAgree = false;
    }
    if (photoAllAgree) exactMatchPhotos2 += 1;
  }
  const verifierUnanimity = {
    overallUnanimityRate: totalCriteria2 ? verifierAgree / totalCriteria2 : null,
    totalCriteriaJudgments: totalCriteria2,
    agreeCount: verifierAgree,
    exactMatchPhotoRate: usable.length ? exactMatchPhotos2 / usable.length : null,
    exactMatchPhotos: exactMatchPhotos2,
    perCriterion: Object.fromEntries(
      Object.entries(perCriterionVerifierAgreement).map(([cid, v]) => [cid, { ...v, rate: v.total ? v.agree / v.total : null }]),
    ),
  };

  // --- Metric 3: cases where both verifiers unanimously disagree with gold ---
  const discrepancies = [];
  for (const row of usable) {
    const gMap = row.gemini.criterion_statuses || {};
    const qMap = row.qwen.criterion_statuses || {};
    const goldMap = row.goldRec.criterion_statuses;
    for (const [cid, goldStatus] of Object.entries(goldMap)) {
      const gStatus = gMap[cid];
      const qStatus = qMap[cid];
      // "Both verifiers unanimously disagree with gold": both verifiers
      // agree with EACH OTHER on a status that differs from gold.
      if (gStatus !== undefined && gStatus === qStatus && gStatus !== goldStatus) {
        discrepancies.push({
          item_id: row.goldRec.item_id,
          file_path: row.goldFilePath,
          file_name: path.relative(path.join(ROOT, 'docs', 'hand drawn samples'), row.goldFilePath),
          criterion_id: cid,
          gold_status: goldStatus,
          gold_rationale: row.goldRec.rationale,
          verifier_status: gStatus,
          gemini_rationale: row.gemini.rationale,
          qwen_rationale: row.qwen.rationale,
        });
      }
    }
  }

  const summary = {
    generated_at: new Date().toISOString(),
    corpus: {
      gold_total_photos: gold.size,
      usable_photos_both_verifiers_full_judgment: usable.length,
      gemini_api_or_parse_failures: missingGemini.length,
      qwen_api_or_parse_failures: missingQwen.length,
      qwen_empty_or_partial_judgment_ok_true_schema_invalid: qwenEmptyResponses.length,
      qwen_empty_response_by_archetype: qwenEmptyByArchetype,
      gemini_empty_or_partial_judgment_ok_true_schema_invalid: geminiEmptyResponses.length,
    },
    verifier_vs_gold: {
      'google/gemini-2.5-flash': geminiVsGold,
      'alibaba/qwen3-vl-235b-a22b-instruct': qwenVsGold,
    },
    verifier_vs_verifier_unanimity: verifierUnanimity,
    discrepancy_count: discrepancies.length,
  };

  fs.writeFileSync(path.join(VERIFY_DIR, 'analysis_summary.json'), JSON.stringify(summary, null, 2));
  fs.writeFileSync(path.join(VERIFY_DIR, 'flagged_discrepancies.json'), JSON.stringify(discrepancies, null, 2));

  console.log('\n=== SUMMARY ===');
  console.log(JSON.stringify(summary, null, 2));
  console.log(`\nwrote ${path.join(VERIFY_DIR, 'analysis_summary.json')}`);
  console.log(`wrote ${path.join(VERIFY_DIR, 'flagged_discrepancies.json')} (${discrepancies.length} flagged)`);
}

main();
