// Computes the three DECISION-0045 verification numbers for the AP Statistics
// real-photo gold corpus (28 photos). Adapted from decision_0045_analyze.mjs
// (the Biology-corpus version) -- same three metrics:
//   1. Per-criterion and overall agreement of each verifier vs. the existing
//      gold.
//   2. Unanimity rate between the two verifiers with each other (independent
//      of the existing gold).
//   3. Every case where both verifiers unanimously disagree with the
//      existing gold label -- flagged as candidate corrections, never
//      auto-applied.
//
// Reads the two raw verifier JSONL files (produced by
// decision_0045_verify_run_apstats.mjs) and the existing gold JSON. Writes a
// JSON summary + a discrepancy list. Does not modify the existing gold file
// or the raw verifier output files.

import fs from 'node:fs';
import path from 'node:path';

const ROOT = '/Users/davidbloom/Documents/Cramapple.nosync';
const SMOKE_DIR = path.join(ROOT, 'docs', 'research', 'apstats_hdg_graph_real_photo_smoke_2026_08_19');
const VERIFY_DIR = path.join(SMOKE_DIR, 'decision_0045_verification_2026_08_19');
const GOLD_JSON = path.join(SMOKE_DIR, 'gold', 'apstats_smoke_gold_labels_2026_08_19.json');

const GEMINI_JSONL = path.join(VERIFY_DIR, 'runs', 'verifier_gemini25flash_results.jsonl');
const QWEN_JSONL = path.join(VERIFY_DIR, 'runs', 'verifier_qwen3vl_results.jsonl');

function loadJsonl(p) {
  return fs.readFileSync(p, 'utf8').split('\n').filter(Boolean).map((l) => JSON.parse(l));
}

// Later records win (in case of any retries appended after originals).
function latestByPhoto(records) {
  const byKey = new Map();
  for (const r of records) {
    byKey.set(r.item_id, r); // last write wins
  }
  return byKey;
}

function loadGold() {
  const records = JSON.parse(fs.readFileSync(GOLD_JSON, 'utf8'));
  const byItemId = new Map();
  for (const r of records) byItemId.set(r.item_id, r);
  return byItemId;
}

function main() {
  const gemini = loadJsonl(GEMINI_JSONL);
  const qwen = loadJsonl(QWEN_JSONL);
  const geminiByItem = latestByPhoto(gemini);
  const qwenByItem = latestByPhoto(qwen);
  const gold = loadGold();

  console.log(`gemini records: ${gemini.length} raw, ${geminiByItem.size} unique photos`);
  console.log(`qwen records: ${qwen.length} raw, ${qwenByItem.size} unique photos`);
  console.log(`gold records: ${gold.size}`);

  const rows = [];
  for (const [itemId, goldRec] of gold) {
    rows.push({ itemId, goldRec, gemini: geminiByItem.get(itemId) || null, qwen: qwenByItem.get(itemId) || null });
  }

  const missingGemini = rows.filter((r) => !r.gemini || r.gemini.ok === false);
  const missingQwen = rows.filter((r) => !r.qwen || r.qwen.ok === false);
  console.log(`photos missing/failed gemini (API/parse error): ${missingGemini.length}`);
  console.log(`photos missing/failed qwen (API/parse error): ${missingQwen.length}`);
  if (missingGemini.length) console.log('  gemini gaps:', missingGemini.map((r) => r.itemId).join(', '));
  if (missingQwen.length) console.log('  qwen gaps:', missingQwen.map((r) => r.itemId).join(', '));

  const qwenEmptyResponses = rows.filter((r) => r.qwen && r.qwen.ok !== false && r.qwen.schema_valid === false);
  const geminiEmptyResponses = rows.filter((r) => r.gemini && r.gemini.ok !== false && r.gemini.schema_valid === false);
  console.log(`qwen ok:true but schema_valid:false (empty/partial judgment): ${qwenEmptyResponses.length}`);
  console.log(`gemini ok:true but schema_valid:false (empty/partial judgment): ${geminiEmptyResponses.length}`);
  const qwenEmptyByArchetype = {};
  for (const r of qwenEmptyResponses) {
    const archetype = r.qwen.archetype || 'unknown';
    qwenEmptyByArchetype[archetype] = (qwenEmptyByArchetype[archetype] || 0) + 1;
  }
  if (qwenEmptyResponses.length) console.log('  qwen empty-response breakdown by archetype:', JSON.stringify(qwenEmptyByArchetype));

  const usable = rows.filter(
    (r) => r.gemini && r.gemini.ok !== false && r.gemini.schema_valid !== false
      && r.qwen && r.qwen.ok !== false && r.qwen.schema_valid !== false,
  );
  console.log(`usable photos (both verifiers ok AND schema_valid): ${usable.length} / ${rows.length}`);

  // --- Metric 1: per-criterion and overall agreement, each verifier vs gold ---
  function agreementVsGold(verifierKey) {
    let totalCriteria = 0, agree = 0;
    let exactMatchPhotos = 0;
    const perCriterion = {};
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
      if (gStatus !== undefined && gStatus === qStatus && gStatus !== goldStatus) {
        discrepancies.push({
          item_id: row.goldRec.item_id,
          file_path: row.goldRec.file_path,
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
