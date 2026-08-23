import {
  applyAttempt,
  classifySameSession,
  classifyWeight,
  initialCellState,
  nextCellState,
  type CellState,
  TUNABLES,
} from "./cell-state.ts";

function assert(cond: boolean, msg: string) {
  if (!cond) throw new Error(msg);
}

const T0 = new Date("2026-03-01T09:00:00Z");
const laterDays = (n: number) => new Date(T0.getTime() + n * 86_400_000);

// --- classifier weights (CM-D07) -------------------------------------------
Deno.test("classifyWeight covers the four evidence tiers", () => {
  assert(classifyWeight({ assisted: false, changedSurface: true, sameSession: false }) === 1.0, "varied+delayed");
  assert(classifyWeight({ assisted: false, changedSurface: true, sameSession: true }) === 0.65, "varied+same-session");
  assert(classifyWeight({ assisted: false, changedSurface: false, sameSession: false }) === 0.35, "same item");
  assert(classifyWeight({ assisted: true, changedSurface: true, sameSession: false }) === 0, "assisted -> 0");
  assert(classifyWeight({ assisted: false, uncertain: true, changedSurface: true, sameSession: false }) === 0, "uncertain -> 0");
});

Deno.test("classifySameSession: ids when present, else time window", () => {
  assert(classifySameSession("s1", "s1", T0, null) === true, "equal ids");
  assert(classifySameSession("s1", "s2", T0, null) === false, "different ids");
  // null session -> time window vs prior attempt
  const prior = new Date(T0.getTime() - 10 * 60_000); // 10 min ago
  assert(classifySameSession(null, null, T0, prior) === true, "within window");
  const old = new Date(T0.getTime() - 120 * 60_000); // 2h ago
  assert(classifySameSession(null, null, T0, old) === false, "outside window");
  assert(classifySameSession(null, null, T0, null) === false, "no prior attempt");
});

// --- new_exposure ----------------------------------------------------------
Deno.test("new_exposure moves unseen -> exposed_unverified, never downgrades", () => {
  const s = nextCellState(initialCellState(), { event: "new_exposure", weight: 0, now: T0 });
  assert(s.tier === "exposed_unverified", "unseen -> exposed");
  assert(s.due_reason === "new_exposure", "reason");
  const indep: CellState = { ...initialCellState(), tier: "independent" };
  const s2 = nextCellState(indep, { event: "new_exposure", weight: 0, now: T0 });
  assert(s2.tier === "independent", "does not downgrade a verified cell");
});

// --- direct miss (INV-6) ---------------------------------------------------
Deno.test("incorrect sets fragile and reopens WITHOUT lowering the tier (INV-6)", () => {
  for (const tier of ["exposed_unverified", "supported", "independent", "confirmed"] as const) {
    const prev: CellState = { ...initialCellState(), tier, weighted_evidence: 2 };
    const s = nextCellState(prev, { event: "incorrect", weight: 0, now: T0 });
    assert(s.tier === tier, `${tier}: tier unchanged`);
    assert(s.fragile === true, `${tier}: fragile set`);
    assert(s.due_reason === "direct_miss", `${tier}: reason`);
    assert(s.weighted_evidence < 2, `${tier}: evidence reduced, not zeroed`);
    assert(s.weighted_evidence >= 0, `${tier}: evidence not negative`);
  }
});

// --- correct: independent + varied advancement -----------------------------
Deno.test("correct varied success advances toward independent; clears fragile", () => {
  const prev: CellState = { ...initialCellState(), tier: "exposed_unverified", fragile: true };
  const s = nextCellState(prev, { event: "correct", weight: 1.0, now: T0 });
  assert(s.tier === "independent", "exposed -> independent");
  assert(s.fragile === false, "fragile cleared");
  assert(s.last_independent_success_at === T0.toISOString(), "stamps independent success");
  assert(s.due_reason === "decay", "decay-scheduled");
});

Deno.test("independent -> confirmed only on delayed, fully-informative (1.0) success (INV-5)", () => {
  // first independent success at T0
  const first = nextCellState({ ...initialCellState(), tier: "supported" }, { event: "correct", weight: 1.0, now: T0 });
  assert(first.tier === "independent", "reached independent");
  // same-session/again-soon success (weight 0.65) does NOT confirm
  const soon = nextCellState(first, { event: "correct", weight: 0.65, now: laterDays(0) });
  assert(soon.tier === "independent", "0.65 does not confirm");
  // delayed weight-1.0 success DOES confirm
  const confirmed = nextCellState(first, { event: "correct", weight: 1.0, now: laterDays(2) });
  assert(confirmed.tier === "confirmed", "delayed 1.0 -> confirmed");
  // an immediate 1.0 (not delayed enough) does NOT confirm
  const immediate = nextCellState(first, { event: "correct", weight: 1.0, now: T0 });
  assert(immediate.tier === "independent", "not-delayed 1.0 stays independent");
});

Deno.test("confirmed stays confirmed on refresh; decay is the long interval", () => {
  const prev: CellState = { ...initialCellState(), tier: "confirmed", last_independent_success_at: laterDays(-40).toISOString() };
  const s = nextCellState(prev, { event: "correct", weight: 1.0, now: T0 });
  assert(s.tier === "confirmed", "stays confirmed");
  const dueInDays = (new Date(s.next_due_at!).getTime() - T0.getTime()) / 86_400_000;
  assert(Math.abs(dueInDays - TUNABLES.decayDays.confirmed) < 1e-6, "confirmed decay interval");
});

// --- correct: supported (provisional) paths (INV-5) ------------------------
Deno.test("assisted or same-item success -> supported (provisional), never independent", () => {
  for (const weight of [0, 0.35]) {
    const s = nextCellState({ ...initialCellState(), tier: "exposed_unverified" }, { event: "correct", weight, now: T0 });
    assert(s.tier === "supported", `weight ${weight}: -> supported`);
    assert(s.due_reason === "provisional_confirm", `weight ${weight}: provisional re-test scheduled`);
  }
});

Deno.test("provisional success does not downgrade a higher tier", () => {
  const prev: CellState = { ...initialCellState(), tier: "confirmed" };
  const s = nextCellState(prev, { event: "correct", weight: 0.35, now: T0 });
  assert(s.tier === "confirmed", "stays confirmed, not demoted to supported");
});

// --- end-to-end sequence (F2 acceptance shape) -----------------------------
Deno.test("a full attempt sequence walks the ladder deterministically", () => {
  let st = initialCellState();
  // class teaches it
  st = applyAttempt(st, "new_exposure", { assisted: false, changedSurface: false, sameSession: false }, T0).state;
  assert(st.tier === "exposed_unverified", "1: exposed");
  // assisted correct -> supported
  st = applyAttempt(st, "correct", { assisted: true, changedSurface: true, sameSession: true }, laterDays(1)).state;
  assert(st.tier === "supported", "2: supported (assisted)");
  // cold, varied correct -> independent
  st = applyAttempt(st, "correct", { assisted: false, changedSurface: true, sameSession: false }, laterDays(3)).state;
  assert(st.tier === "independent", "3: independent");
  // delayed varied correct -> confirmed
  st = applyAttempt(st, "correct", { assisted: false, changedSurface: true, sameSession: false }, laterDays(6)).state;
  assert(st.tier === "confirmed", "4: confirmed");
  // a later miss -> fragile, still confirmed (INV-6)
  st = applyAttempt(st, "incorrect", { assisted: false, changedSurface: true, sameSession: false }, laterDays(30)).state;
  assert(st.tier === "confirmed" && st.fragile === true, "5: fragile but not demoted");
});

// --- determinism (INV-4) ---------------------------------------------------
Deno.test("nextCellState is a pure function of its inputs", () => {
  const prev: CellState = { ...initialCellState(), tier: "supported" };
  const a = nextCellState(prev, { event: "correct", weight: 1.0, now: T0 });
  const b = nextCellState(prev, { event: "correct", weight: 1.0, now: T0 });
  assert(JSON.stringify(a) === JSON.stringify(b), "same inputs -> same output");
});
