/**
 * Course Mode — LOCAL cell-state loop proof (offline, zero Dev writes).
 *
 * Drives the REAL deployed rule engine
 *   supabase/functions/_shared/cell-state.ts       (nextCellState / applyAttempt / classifySameSession)
 *   supabase/functions/_shared/cell-state-signals.ts (deriveCellEvent / deriveChangedSurface / paramsHash)
 * using each of the 10 pilot cells' REAL Dev provenance (fixtures.json), reproducing
 * exactly the compute chain in cell-state-persist.ts::applyToCell (minus the DB read/write).
 *
 * For each cell it runs the two grading outcomes the pilot must prove:
 *   [1] serve -> CORRECT (independent, changed surface) -> cell PROMOTES unseen->independent
 *   [2] serve -> WRONG   (a later session)              -> fragile=true, tier UNCHANGED (INV-6)
 *
 * SCOPE: this proves the promotion engine (the graded-result -> cell-state transition),
 * which is identical regardless of grading path. The grading path itself
 * (MCQ choice-match vs deterministic verifier) and the DB write live in the deployed
 * evaluate-attempt edge function — exercised by the end-to-end HTTP harness
 * (run_e2e_harness.ts), which needs network access to the Dev Supabase host.
 *
 * Run:  bun run scripts/course_mode_loop_proof/run_local_engine_proof.ts
 * Exit: non-zero if any cell fails an expected invariant.
 */
import {
  applyAttempt,
  type CellEvent,
  type CellState,
  classifySameSession,
  initialCellState,
} from "../../supabase/functions/_shared/cell-state.ts";
import {
  deriveCellEvent,
  deriveChangedSurface,
  paramsHash,
} from "../../supabase/functions/_shared/cell-state-signals.ts";

type Instance = { civ_id: string; seed: number; params: unknown };
type Cell = {
  template_id: string;
  topic_code: string;
  skill_code: string;
  taxonomy_source_version: string;
  instances: Instance[];
};
type Fixtures = { exam_pack_version_id: string; cells: Cell[] };

// Mirror of the persisted-row fields applyToCell reads back to compute the next
// changed-surface / same-session signals. Starts empty (a cold, unseen cell).
type PriorRow = {
  last_template_id: string | null;
  last_params_hash: string | null;
  last_session_id: string | null;
  last_attempt_at: string | null;
};

// Reproduces cell-state-persist.ts::applyToCell's per-attempt compute exactly:
// derive (changedSurface, sameSession) from the prior row + this item's provenance,
// then call the real applyAttempt. Returns the new state + the row it would persist.
async function applyOneAttempt(args: {
  priorState: CellState;
  priorRow: PriorRow;
  instance: Instance;
  templateId: string;
  event: CellEvent;
  assisted: boolean;
  sessionId: string | null;
  now: Date;
}): Promise<{ state: CellState; weight: number; changedSurface: boolean; sameSession: boolean; nextRow: PriorRow }> {
  const { priorState, priorRow, instance, templateId, event, assisted, sessionId, now } = args;

  // provenance -> (templateId, paramsHash), with the same civ-id fallback applyToCell uses.
  const versionIdentity = `civ:${instance.civ_id}`;
  const currentTemplateId = templateId ?? versionIdentity;
  const currentParamsHash = (await paramsHash(instance.params, instance.seed)) ?? versionIdentity;

  const changedSurface = deriveChangedSurface(
    { templateId: priorRow.last_template_id, paramsHash: priorRow.last_params_hash },
    { templateId: currentTemplateId, paramsHash: currentParamsHash },
  );
  const sameSession = classifySameSession(
    sessionId,
    priorRow.last_session_id,
    now,
    priorRow.last_attempt_at ? new Date(priorRow.last_attempt_at) : null,
  );

  const { state, weight } = applyAttempt(
    priorState,
    event,
    { assisted, uncertain: event === "content_uncertain", changedSurface, sameSession },
    now,
  );

  // F6: an uncertain attempt does not move the surface reference; graded ones do.
  const uncertain = event === "content_uncertain";
  const nextRow: PriorRow = {
    last_template_id: uncertain ? priorRow.last_template_id : currentTemplateId,
    last_params_hash: uncertain ? priorRow.last_params_hash : currentParamsHash,
    last_session_id: sessionId,
    last_attempt_at: state.last_attempt_at,
  };
  return { state, weight, changedSurface, sameSession, nextRow };
}

function assert(cond: boolean, msg: string, failures: string[]) {
  if (!cond) failures.push(msg);
}

const HERE = new URL(".", import.meta.url).pathname;
const fixtures = JSON.parse(await Deno_readTextFile(`${HERE}fixtures.json`)) as Fixtures;

// Bun/Node have no Deno global; tiny shim so the file reads the same in both.
function Deno_readTextFile(path: string): Promise<string> {
  // @ts-ignore - Bun global
  if (typeof Bun !== "undefined") return Bun.file(path).text();
  // Node fallback
  return import("node:fs/promises").then((fs) => fs.readFile(path, "utf8"));
}

const T0 = new Date("2026-08-26T15:00:00.000Z"); // first (correct) attempt
const T1 = new Date("2026-08-28T15:00:00.000Z"); // miss, 2 days later => a different session

const rows: string[] = [];
const allFailures: string[] = [];
rows.push(
  [
    "cell (topic×skill)".padEnd(22),
    "template".padEnd(26),
    "correct→".padEnd(9),
    "w".padEnd(5),
    "then miss→".padEnd(11),
    "fragile".padEnd(8),
    "verdict",
  ].join(" | "),
);

for (const cell of fixtures.cells) {
  const label = `${cell.topic_code}×${cell.skill_code}`;
  const failures: string[] = [];
  const [instA, instB] = cell.instances;

  // ── [1] cold serve -> CORRECT (independent) -> promotion ──────────────────
  const cold = initialCellState();
  const coldRow: PriorRow = { last_template_id: null, last_params_hash: null, last_session_id: null, last_attempt_at: null };
  const correctEvent = deriveCellEvent({ finalStatus: "graded", pointsEarned: 1, pointsAvailable: 1 });
  const r1 = await applyOneAttempt({
    priorState: cold, priorRow: coldRow, instance: instA, templateId: cell.template_id,
    event: correctEvent, assisted: false, sessionId: `sess-${cell.template_id}-A`, now: T0,
  });
  assert(correctEvent === "correct", `${label}: full-marks MCQ must derive 'correct' (got ${correctEvent})`, failures);
  assert(r1.state.tier === "independent", `${label}: correct independent attempt must promote unseen->independent (got ${r1.state.tier})`, failures);
  assert(r1.state.fragile === false, `${label}: a correct attempt must clear fragile`, failures);
  assert(r1.weight >= 1.0, `${label}: cold, changed-surface, independent success must weigh 1.0 (got ${r1.weight})`, failures);
  assert(r1.state.due_reason === "decay", `${label}: promotion must schedule a decay re-test (got ${r1.state.due_reason})`, failures);

  // ── [2] later serve -> WRONG -> fragile + tier UNCHANGED (INV-6) ──────────
  const missEvent = deriveCellEvent({ finalStatus: "graded", pointsEarned: 0, pointsAvailable: 1 });
  const r2 = await applyOneAttempt({
    priorState: r1.state, priorRow: r1.nextRow, instance: instB, templateId: cell.template_id,
    event: missEvent, assisted: false, sessionId: `sess-${cell.template_id}-B`, now: T1,
  });
  assert(missEvent === "incorrect", `${label}: zero-marks MCQ must derive 'incorrect' (got ${missEvent})`, failures);
  assert(r2.state.fragile === true, `${label}: a miss must set fragile`, failures);
  assert(r2.state.tier === r1.state.tier, `${label}: a miss must NOT lower the tier (INV-6): ${r1.state.tier}->${r2.state.tier}`, failures);
  assert(r2.state.due_reason === "direct_miss", `${label}: a miss must schedule a direct-miss recheck (got ${r2.state.due_reason})`, failures);

  const verdict = failures.length === 0 ? "PASS" : "FAIL";
  rows.push(
    [
      label.padEnd(22),
      cell.template_id.padEnd(26),
      r1.state.tier.padEnd(9),
      String(r1.weight).padEnd(5),
      r2.state.tier.padEnd(11),
      String(r2.state.fragile).padEnd(8),
      verdict,
    ].join(" | "),
  );
  allFailures.push(...failures);
}

console.log("\nCourse Mode — LOCAL cell-state loop proof (real cell-state-1.0 engine, 10 pilot cells)\n");
console.log(rows.join("\n"));
console.log("");

if (allFailures.length) {
  console.error(`FAILED — ${allFailures.length} assertion(s):`);
  for (const f of allFailures) console.error("  - " + f);
  process.exit(1);
}
console.log(`OK — all ${fixtures.cells.length} cells: serve→correct promotes unseen→independent; serve→miss sets fragile with tier unchanged (INV-6).`);
console.log("Engine version exercised: cell-state-1.0 (supabase/functions/_shared/cell-state.ts).");
