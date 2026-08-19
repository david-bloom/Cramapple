// Feasibility spike: can OCR's tick-label PIXEL positions (not just their
// read values) support fitting a pixel<->data-value transform per axis,
// precise enough to render the EXPECTED (known-correct) data points onto
// the actual photo? If the overlay lands close to where the student really
// drew their points, that's the seed of a much more direct PLOT_VALUES
// check than asking a VLM to find-and-read points cold: "is there ink near
// this specific expected pixel" instead of open-ended point detection.
//
// This is a one-off spike, not production code -- linear least-squares fit
// per axis (assumes no in-photo perspective skew, only the gross EXIF
// rotation already corrected by sharp().rotate()), single-marker overlay,
// meant to be visually judged, not scored automatically yet.

import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import sharp from 'sharp';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const GOLD_JSONL = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29', 'hand_drawn_graph_questions_2026_06_29.jsonl');
const REAL_GOLD_JSON = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18', 'gold', 'real_photo_gold_labels_2026_08_18.json');
const OCR_BINARY = path.join(ROOT, 'scripts', 'vercel-gateway-check', 'vision_ocr');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18', 'overlay_spike');

const TARGETS = process.argv.slice(2).length ? process.argv.slice(2) : ['HDG-2026-P1-SER-001', 'HDG-2026-P1-EST-016'];

function loadCorpusById() {
  const byId = new Map();
  for (const line of fs.readFileSync(GOLD_JSONL, 'utf8').split('\n').filter(Boolean)) {
    const r = JSON.parse(line);
    byId.set(r.item_id, r);
  }
  return byId;
}

function normalizeNumericText(text) {
  let s = text.trim();
  const isNegative = /^-/.test(s);
  s = s.replace(/^-\s*/, '');
  s = s.replace(/•/g, '.');
  s = s.replace(/(\d)\s*-\s*(\d)/g, '$1.$2');
  s = s.replace(/\s+/g, '');
  const num = Number(s);
  if (!Number.isFinite(num)) return null;
  return isNegative ? -Math.abs(num) : num;
}

async function runOcrRaw(normalizedPath) {
  const raw = execFileSync(OCR_BINARY, [normalizedPath], { maxBuffer: 10 * 1024 * 1024 }).toString('utf8');
  return JSON.parse(raw);
}

// Largest cluster of tokens whose coordKey values fall within tol -- same
// approach as ocr_criterion_decider.mjs's axis-role clustering.
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

// Ordinary least-squares fit: value = m * coord + b. Returns fit + R^2.
function linearFit(points, coordKey) {
  const n = points.length;
  const xs = points.map((p) => p[coordKey]);
  const ys = points.map((p) => p.value);
  const xMean = xs.reduce((a, b) => a + b, 0) / n;
  const yMean = ys.reduce((a, b) => a + b, 0) / n;
  let num = 0, den = 0;
  for (let i = 0; i < n; i += 1) { num += (xs[i] - xMean) * (ys[i] - yMean); den += (xs[i] - xMean) ** 2; }
  const m = den !== 0 ? num / den : 0;
  const b = yMean - m * xMean;
  let ssRes = 0, ssTot = 0;
  for (let i = 0; i < n; i += 1) {
    const pred = m * xs[i] + b;
    ssRes += (ys[i] - pred) ** 2;
    ssTot += (ys[i] - yMean) ** 2;
  }
  const r2 = ssTot !== 0 ? 1 - ssRes / ssTot : 1;
  return { m, b, r2, n };
}

function tableAxisKeys(corpusRecord) {
  const table = corpusRecord.display_table;
  const yKey = Object.keys(table[0]).find((k) => k.toLowerCase().includes('mean') || k.toLowerCase().includes('percent') || k.toLowerCase().includes(corpusRecord.expected_graph_spec.y_axis.toLowerCase().split(' ')[0]));
  const xKey = Object.keys(table[0]).find((k) => k !== yKey && !k.toLowerCase().includes('sem'));
  return { xKey, yKey };
}

async function processOne(itemId, corpusById, realGoldByItemId) {
  const corpusRecord = corpusById.get(itemId);
  const goldRow = realGoldByItemId.get(itemId);
  console.log(`\n=== ${itemId} (${corpusRecord.archetype}) ===`);

  const normalizedPath = path.join(os.tmpdir(), `overlay_spike_${Date.now()}_${Math.random().toString(36).slice(2)}.jpg`);
  await sharp(goldRow.file_path).rotate().jpeg({ quality: 95 }).toFile(normalizedPath);
  const meta = await sharp(normalizedPath).metadata();
  const { width, height } = meta;

  const ocrItems = await runOcrRaw(normalizedPath);
  const numericTokens = [];
  for (const item of ocrItems) {
    const value = normalizeNumericText(item.text);
    if (value !== null) {
      numericTokens.push({
        value, x: item.x + (item.w || 0) / 2, y: item.y + (item.h || 0) / 2, rawText: item.text,
        box: { left: item.x, right: item.x + (item.w || 0), bottom: item.y, top: item.y + (item.h || 0) },
      });
    }
  }

  // clusterVert varies in image-y (tokens share nearly the same x --
  // they're collinear along a vertical line); clusterHoriz varies in
  // image-x (share nearly the same y -- collinear along a horizontal
  // line). Which GRAPH axis (x_axis="temperature", y_axis="reaction rate")
  // each one represents is a SEPARATE question from which image dimension
  // it happens to vary in -- a photo's real-world orientation can point
  // either graph axis along either image dimension, so these must not be
  // conflated (that conflation was the bug in the first version of this
  // spike).
  const clusterVert = largestAlignedCluster(numericTokens, 'x', 0.06);
  const remaining = numericTokens.filter((t) => !clusterVert.includes(t));
  const clusterHoriz = largestAlignedCluster(remaining, 'y', 0.06);

  if (clusterVert.length < 2 || clusterHoriz.length < 2) {
    console.log('Could not find both axis clusters -- skipping overlay for this photo.');
    fs.unlinkSync(normalizedPath);
    return null;
  }

  function centroid(cluster) {
    return { x: cluster.reduce((s, t) => s + t.x, 0) / cluster.length, y: cluster.reduce((s, t) => s + t.y, 0) / cluster.length };
  }
  function findLabelPosition(axisText) {
    const keywords = axisText.toLowerCase().split(/[^a-z]+/).filter((w) => w.length >= 4);
    for (const keyword of keywords) {
      const hit = ocrItems.find((it) => it.text.toLowerCase().includes(keyword));
      if (hit) return { x: hit.x + (hit.w || 0) / 2, y: hit.y + (hit.h || 0) / 2 };
    }
    return null;
  }
  function dist(a, b) { return Math.hypot(a.x - b.x, a.y - b.y); }

  const centVert = centroid(clusterVert), centHoriz = centroid(clusterHoriz);
  const yLabelPos = findLabelPosition(corpusRecord.expected_graph_spec.y_axis);
  const xLabelPos = findLabelPosition(corpusRecord.expected_graph_spec.x_axis);

  // graphYCluster/graphXCluster: which cluster represents which GRAPH axis.
  let graphYCluster, graphXCluster;
  if (yLabelPos && xLabelPos) {
    const vertToY = dist(centVert, yLabelPos), horizToY = dist(centHoriz, yLabelPos);
    if (vertToY < horizToY) { graphYCluster = clusterVert; graphXCluster = clusterHoriz; } else { graphYCluster = clusterHoriz; graphXCluster = clusterVert; }
    console.log(`axis assignment via label proximity: y-label closer to ${vertToY < horizToY ? 'vertical' : 'horizontal'} cluster`);
  } else {
    console.log('WARNING: could not locate axis label text -- falling back to orientation guess (vertical=y, horizontal=x), less reliable.');
    graphYCluster = clusterVert; graphXCluster = clusterHoriz;
  }

  // A tick label sits NEXT TO its tick mark, not centered on it -- using
  // the box center produces a systematic, rotation-dependent offset
  // (confirmed visually on the first attempt: markers parallel to the true
  // curve, shifted by a constant amount). Correction: re-anchor each token
  // to the corner of its bounding box nearest the OTHER axis cluster's
  // centroid, since axis labels sit outside the plot area and the plot
  // area lies between the two axis label clusters -- the near corner
  // approximates the true tick-mark position much better than the center.
  function reanchor(cluster, towardCentroid) {
    return cluster.map((t) => {
      const corner = {
        x: Math.abs(towardCentroid.x - t.box.left) < Math.abs(towardCentroid.x - t.box.right) ? t.box.left : t.box.right,
        y: Math.abs(towardCentroid.y - t.box.bottom) < Math.abs(towardCentroid.y - t.box.top) ? t.box.bottom : t.box.top,
      };
      return { ...t, x: corner.x, y: corner.y };
    });
  }
  const graphYClusterAnchored = reanchor(graphYCluster, graphXCluster === clusterVert ? centVert : centHoriz);
  const graphXClusterAnchored = reanchor(graphXCluster, graphYCluster === clusterVert ? centVert : centHoriz);

  // Each cluster's fit must regress against the coordinate IT actually
  // varies in, not a fixed "y-axis always fits .y" assumption. clusterVert
  // (constant x, varies in y) -> fit against 'y'; clusterHoriz (constant y,
  // varies in x) -> fit against 'x'.
  const yFit = linearFit(graphYClusterAnchored, graphYCluster === clusterVert ? 'y' : 'x');
  const xFit = linearFit(graphXClusterAnchored, graphXCluster === clusterVert ? 'y' : 'x');
  console.log(`y-axis (graph) fit against image-${graphYCluster === clusterVert ? 'y' : 'x'}: value = ${yFit.m.toFixed(3)}*coord + ${yFit.b.toFixed(3)}  (R^2=${yFit.r2.toFixed(3)}, n=${yFit.n})`);
  console.log(`x-axis (graph) fit against image-${graphXCluster === clusterVert ? 'y' : 'x'}: value = ${xFit.m.toFixed(3)}*coord + ${xFit.b.toFixed(3)}  (R^2=${xFit.r2.toFixed(3)}, n=${xFit.n})`);

  const { xKey, yKey } = tableAxisKeys(corpusRecord);
  const table = corpusRecord.display_table;

  const markers = [];
  for (const row of table) {
    const xVal = row[xKey], yVal = row[yKey];
    // invert: y_norm = (value - b) / m
    // Each fit's inverse gives a normalized coordinate along whichever
    // image dimension IT was fit against -- not necessarily "y-axis value
    // -> image-y" -- combine whichever fit produced an image-x coordinate
    // with whichever produced an image-y coordinate.
    const yFitCoord = graphYCluster === clusterVert ? 'y' : 'x';
    const xFitCoord = graphXCluster === clusterVert ? 'y' : 'x';
    const yFitNorm = (yVal - yFit.b) / yFit.m;
    const xFitNorm = (xVal - xFit.b) / xFit.m;
    const imageXNorm = xFitCoord === 'x' ? xFitNorm : yFitNorm;
    const imageYNorm = xFitCoord === 'y' ? xFitNorm : yFitNorm;
    const pixelX = imageXNorm * width;
    const pixelY = (1 - imageYNorm) * height; // Vision y=0 is bottom; image y=0 is top
    markers.push({ xVal, yVal, pixelX, pixelY });
    console.log(`  expected point (${xKey}=${xVal}, ${yKey}=${yVal}) -> pixel (${pixelX.toFixed(0)}, ${pixelY.toFixed(0)}) of ${width}x${height}`);
  }

  const svgMarkers = markers.map((m, i) => `
    <circle cx="${m.pixelX}" cy="${m.pixelY}" r="14" fill="none" stroke="red" stroke-width="4"/>
    <line x1="${m.pixelX - 20}" y1="${m.pixelY}" x2="${m.pixelX + 20}" y2="${m.pixelY}" stroke="red" stroke-width="2"/>
    <line x1="${m.pixelX}" y1="${m.pixelY - 20}" x2="${m.pixelX}" y2="${m.pixelY + 20}" stroke="red" stroke-width="2"/>
    <text x="${m.pixelX + 18}" y="${m.pixelY - 18}" fill="red" font-size="26" font-family="sans-serif">${i + 1}</text>
  `).join('\n');
  const svg = `<svg width="${width}" height="${height}" xmlns="http://www.w3.org/2000/svg">${svgMarkers}</svg>`;

  fs.mkdirSync(OUT_DIR, { recursive: true });
  const outPath = path.join(OUT_DIR, `${itemId}_overlay.jpg`);
  await sharp(normalizedPath)
    .composite([{ input: Buffer.from(svg), top: 0, left: 0 }])
    .jpeg({ quality: 92 })
    .toFile(outPath);
  fs.unlinkSync(normalizedPath);
  console.log(`wrote ${outPath}`);
  return outPath;
}

async function main() {
  const corpusById = loadCorpusById();
  const realGoldByItemId = new Map();
  for (const r of JSON.parse(fs.readFileSync(REAL_GOLD_JSON, 'utf8'))) {
    if (!realGoldByItemId.has(r.item_id)) realGoldByItemId.set(r.item_id, r); // first photo per item_id for this spike
  }
  const outputs = [];
  for (const id of TARGETS) {
    const out = await processOne(id, corpusById, realGoldByItemId);
    if (out) outputs.push(out);
  }
  console.log(`\nDone. ${outputs.length} overlay image(s) written.`);
}

main().catch((e) => { console.error(e); process.exit(1); });
