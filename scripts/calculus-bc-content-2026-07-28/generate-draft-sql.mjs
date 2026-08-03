import { readFile } from "node:fs/promises";

// The AB and BC batches share the same governed package and database contract.
// Reuse the already-verified fail-closed AB loader generator, changing only the
// subject identifiers, paths, and advisory-lock name. Keeping one loader
// implementation prevents the two calculus subjects from drifting.
const ROOT = new URL("../../", import.meta.url).pathname;
const TEMPLATE = `${ROOT}scripts/calculus-ab-content-2026-07-27/generate-draft-sql.mjs`;
let source = await readFile(TEMPLATE,"utf8");

source = source
  .replace(
    'const ROOT = new URL("../../", import.meta.url).pathname;',
    `const ROOT = ${JSON.stringify(ROOT)};`
  )
  .replaceAll("calculus-ab-content-2026-07-27","calculus-bc-content-2026-07-28")
  .replaceAll("2026-07-27","2026-07-28")
  .replaceAll("ap-calculus-ab","ap-calculus-bc")
  .replaceAll("apcalcab","apcalcbc")
  .replaceAll("ap_calculus_ab","ap_calculus_bc")
  .replaceAll("cramapple-ap-calculus-ab-draft-load-20260728","cramapple-ap-calculus-bc-draft-load-20260728")
  .replaceAll("AP Calculus AB","AP Calculus BC");

if (
  source.includes("apcalcab")
  || source.includes("ap_calculus_ab")
  || source.includes("ap-calculus-ab")
  || !source.includes("apcalcbc")
  || !source.includes("ap_calculus_bc")
) {
  throw new Error("The shared draft-loader template did not transform cleanly.");
}

await import(`data:text/javascript;base64,${Buffer.from(source).toString("base64")}`);
