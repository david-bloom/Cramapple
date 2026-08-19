// Shared OCR -> criterion-verdict decider (Experiment 0 + building block for
// Experiment 1 in docs/research/OCR_VALUE_ASSESSMENT_EXPERIMENT_DESIGN_2026_08_18.md).
//
// Replaces the old fixed left/bottom position heuristic (confirmed broken --
// see the full-scale OCR probe reproduction in
// HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md) with orientation-
// invariant clustering: an axis's tick labels are collinear (share one
// coordinate closely) regardless of which edge of the photo they're on, so
// find the largest such aligned cluster along each coordinate instead of
// assuming a fixed edge.
//
// Only decides the OCR-answerable criterion subset per §0 of the experiment
// design doc: {X,Y}_SCALE, {X,Y}_UNIT, and EST's ESTIMATE_VALUE. Everything
// else (REPRESENTATION_TYPE, CATEGORY_IDENTITY, PLOT_VALUES,
// UNCERTAINTY_MARKS, POINT_CONNECTION, BEST_FIT_RELATIONSHIP,
// ZERO_INTERCEPT_ANNOTATION) always needs vision -- this decider returns no
// verdict for those, callers must not fabricate one.

import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import sharp from 'sharp';

const OCR_ANSWERABLE_CRITERIA = new Set([
  'X_SCALE', 'Y_SCALE', 'X_UNIT', 'Y_UNIT', 'ESTIMATE_VALUE',
]);

export async function runOcr(filePath, ocrBinary) {
  const normalizedPath = path.join(os.tmpdir(), `ocr_normalized_${Date.now()}_${Math.random().toString(36).slice(2)}.jpg`);
  await sharp(filePath).rotate().jpeg({ quality: 95 }).toFile(normalizedPath);
  try {
    const raw = execFileSync(ocrBinary, [normalizedPath], { maxBuffer: 10 * 1024 * 1024 }).toString('utf8');
    return JSON.parse(raw);
  } finally {
    fs.unlinkSync(normalizedPath);
  }
}

function normalizeNumericText(text) {
  let s = text.trim();
  const isNegative = /^-/.test(s) || /^\s*-/.test(s);
  s = s.replace(/^-\s*/, '');
  s = s.replace(/•/g, '.');
  s = s.replace(/(\d)\s*-\s*(\d)/g, '$1.$2');
  s = s.replace(/\s+/g, '');
  const num = Number(s);
  if (!Number.isFinite(num)) return null;
  return isNegative ? -Math.abs(num) : num;
}

function tokenCenter(item) {
  return { x: item.x + (item.w || 0) / 2, y: item.y + (item.h || 0) / 2 };
}

function extractNumericTokens(ocrItems) {
  const out = [];
  for (const item of ocrItems) {
    const value = normalizeNumericText(item.text);
    if (value !== null) {
      const c = tokenCenter(item);
      out.push({ value, x: c.x, y: c.y, confidence: item.confidence, rawText: item.text });
    }
  }
  return out;
}

// Largest cluster of tokens whose `coordKey` values fall within `tol` of
// each other (a sliding window over the sorted coordinate) -- finds an
// axis's constant-coordinate tick line wherever it actually is, instead of
// assuming a fixed edge.
function largestAlignedCluster(tokens, coordKey, tol) {
  const sorted = [...tokens].sort((a, b) => a[coordKey] - b[coordKey]);
  let best = [];
  for (let i = 0; i < sorted.length; i += 1) {
    const anchor = sorted[i][coordKey];
    const cluster = sorted.filter((t) => Math.abs(t[coordKey] - anchor) <= tol);
    if (cluster.length > best.length) best = cluster;
  }
  return best;
}

// A real axis tick sequence spans a real range along the OTHER coordinate
// (ticks are spread out along the axis, not bunched together). Filters out
// spurious small clusters (e.g. two unrelated numbers that happen to share
// an x-coordinate by chance).
function otherCoordSpan(cluster, otherKey) {
  if (cluster.length < 2) return 0;
  const vals = cluster.map((t) => t[otherKey]);
  return Math.max(...vals) - Math.min(...vals);
}

const X_TOL = 0.06;
const Y_TOL = 0.06;
const MIN_SPAN = 0.15; // normalized-coordinate span an axis must cover to count as real
const MIN_CLUSTER = 2;

// Returns { yAxisTokens, xAxisTokens, ok } -- orientation-invariant: does
// not assume which edge each axis is on, only that each axis's tick labels
// are mutually collinear and span a real range.
function findAxisClusters(numericTokens) {
  if (numericTokens.length < 4) return { yAxisTokens: [], xAxisTokens: [], ok: false };

  // Candidate 1: vertical-line cluster (constant x, spread in y) = y-axis.
  const xAligned = largestAlignedCluster(numericTokens, 'x', X_TOL);
  const xAlignedSpan = otherCoordSpan(xAligned, 'y');
  const yAxisTokens = xAligned.length >= MIN_CLUSTER && xAlignedSpan >= MIN_SPAN ? xAligned : [];

  const remaining = numericTokens.filter((t) => !yAxisTokens.includes(t));
  // Candidate 2: horizontal-line cluster (constant y, spread in x) = x-axis.
  const yAligned = largestAlignedCluster(remaining, 'y', Y_TOL);
  const yAlignedSpan = otherCoordSpan(yAligned, 'x');
  const xAxisTokens = yAligned.length >= MIN_CLUSTER && yAlignedSpan >= MIN_SPAN ? yAligned : [];

  return {
    yAxisTokens,
    xAxisTokens,
    yOk: yAxisTokens.length >= MIN_CLUSTER,
    xOk: xAxisTokens.length >= MIN_CLUSTER,
    // Retained for callers that want "both axes found" (non-categorical
    // archetypes need both); per-criterion decisions below use yOk/xOk
    // independently so a categorical item (no numeric x-axis at all) isn't
    // penalized for lacking an x-axis cluster it was never going to have.
    ok: yAxisTokens.length >= MIN_CLUSTER && xAxisTokens.length >= MIN_CLUSTER,
  };
}

function scaleVerdict(axisTokens, trueMin, trueMax) {
  if (axisTokens.length < MIN_CLUSTER) return 'unable_to_determine';
  const detectedMin = Math.min(...axisTokens.map((t) => t.value));
  const detectedMax = Math.max(...axisTokens.map((t) => t.value));
  const margin = 0.35;
  const span = Math.max(trueMax - trueMin, 1e-6);
  const ok = detectedMin <= trueMin + margin * span && detectedMax >= trueMax - margin * span;
  return ok ? 'earned' : 'not_earned';
}

function unitSubstring(axisLabel) {
  const match = axisLabel.match(/\(([^)]+)\)/);
  return match ? match[1] : null;
}

function unitVerdict(ocrItems, axisLabel) {
  if (ocrItems.length < 2) return 'unable_to_determine'; // OCR barely read anything at all
  const unit = unitSubstring(axisLabel);
  if (!unit) return 'unable_to_determine'; // corpus didn't specify a checkable unit token
  const allText = ocrItems.map((it) => it.text).join(' ').toLowerCase();
  const unitNorm = unit.toLowerCase().replace(/\s+/g, '');
  const textNorm = allText.replace(/\s+/g, '');
  const found = textNorm.includes(unitNorm) || allText.includes(unit.toLowerCase());
  return found ? 'earned' : 'not_earned';
}

function estimateVerdict(ocrItems, expectedEstimate) {
  const estimateItem = ocrItems.find((it) => /estimate/i.test(it.text));
  if (!estimateItem) return 'unable_to_determine';
  const match = estimateItem.text.match(/-?[\d.]+/g);
  if (!match) return 'unable_to_determine';
  const last = match[match.length - 1];
  const parsed = normalizeNumericText(last);
  if (parsed === null) return 'unable_to_determine';
  const ok = Math.abs(parsed - expectedEstimate) / Math.max(Math.abs(expectedEstimate), 1e-6) <= 0.25;
  return ok ? 'earned' : 'not_earned';
}

function tableAxisValues(corpusRecord) {
  const table = corpusRecord.display_table;
  const yKey = Object.keys(table[0]).find((k) => k.toLowerCase().includes('mean') || k.toLowerCase().includes('percent') || k.toLowerCase().includes(corpusRecord.expected_graph_spec.y_axis.toLowerCase().split(' ')[0]));
  const xKey = Object.keys(table[0]).find((k) => k !== yKey && !k.toLowerCase().includes('sem'));
  const xValues = table.map((row) => row[xKey]);
  const yValues = table.map((row) => row[yKey]);
  return {
    xMin: Math.min(...xValues), xMax: Math.max(...xValues),
    yMin: Math.min(...yValues), yMax: Math.max(...yValues),
  };
}

// Main entry: OCR raw items + corpus record -> per-OCR-answerable-criterion
// verdict. Only returns keys for criteria this archetype actually has AND
// this decider can address -- callers should treat any criterion not in
// the returned object as "OCR has no opinion," not "not_earned."
export function decideCriteria(ocrItems, corpusRecord) {
  const archetype = corpusRecord.archetype;
  const criteriaIds = new Set(corpusRecord.criterion_definitions.map((c) => c.criterion_id));
  const numericTokens = extractNumericTokens(ocrItems);
  const clusters = findAxisClusters(numericTokens);
  const verdicts = {};

  const categorical = archetype === 'categorical_comparison_supplied_uncertainty';

  if (criteriaIds.has('Y_SCALE') || (criteriaIds.has('X_SCALE') && !categorical)) {
    const { xMin, xMax, yMin, yMax } = tableAxisValues(corpusRecord);
    if (criteriaIds.has('Y_SCALE')) {
      verdicts.Y_SCALE = clusters.yOk ? scaleVerdict(clusters.yAxisTokens, yMin, yMax) : 'unable_to_determine';
    }
    if (criteriaIds.has('X_SCALE') && !categorical) {
      verdicts.X_SCALE = clusters.xOk ? scaleVerdict(clusters.xAxisTokens, xMin, xMax) : 'unable_to_determine';
    }
  }

  if (criteriaIds.has('Y_UNIT')) {
    verdicts.Y_UNIT = unitVerdict(ocrItems, corpusRecord.expected_graph_spec.y_axis);
  }
  if (criteriaIds.has('X_UNIT') && !categorical) {
    verdicts.X_UNIT = unitVerdict(ocrItems, corpusRecord.expected_graph_spec.x_axis);
  }

  if (criteriaIds.has('ESTIMATE_VALUE')) {
    verdicts.ESTIMATE_VALUE = estimateVerdict(ocrItems, corpusRecord.expected_graph_spec.expected_estimate_approx);
  }

  return { verdicts, clusters, numericTokenCount: numericTokens.length, totalOcrItemCount: ocrItems.length };
}

export { OCR_ANSWERABLE_CRITERIA };
