import { readFile } from "node:fs/promises";

// Reuse the verified fail-closed Calculus loader implementation because the
// canonical MCQ/FRQ package and database contracts are shared. The Precalculus
// transformation changes identifiers and the expected six-point FRQ rubric
// count while preserving all draft-isolation and child-record checks.
const ROOT = new URL("../../", import.meta.url).pathname;
const TEMPLATE = `${ROOT}scripts/calculus-ab-content-2026-07-27/generate-draft-sql.mjs`;
let source = await readFile(TEMPLATE,"utf8");

source = source
  .replace(
    'const ROOT = new URL("../../", import.meta.url).pathname;',
    `const ROOT = ${JSON.stringify(ROOT)};`
  )
  .replaceAll("calculus-ab-content-2026-07-27","precalculus-content-2026-07-27")
  .replaceAll("ap-calculus-ab","ap-precalculus")
  .replaceAll("apcalcab","apprecalc")
  .replaceAll("ap_calculus_ab","ap_precalculus")
  .replaceAll("cramapple-ap-calculus-ab-draft-load-20260728","cramapple-ap-precalculus-draft-load-20260728")
  .replaceAll("AP Calculus AB","AP Precalculus")
  .replace("(50,30,20,50,120,30,180,180)","(50,30,20,50,120,30,120,120)");

if (
  source.includes("apcalcab")
  || source.includes("ap_calculus_ab")
  || source.includes("ap-calculus-ab")
  || !source.includes("apprecalc")
  || !source.includes("ap_precalculus")
  || !source.includes("(50,30,20,50,120,30,120,120)")
) {
  throw new Error("The shared draft-loader template did not transform cleanly.");
}

await import(`data:text/javascript;base64,${Buffer.from(source).toString("base64")}`);
