// Tests for the pure signal derivation feeding the live cell-state write hook
// (cell-state-persist.ts). Determinism (INV-4): every function here is a pure
// function of its inputs, so these assertions fully pin the behavior the DB hook
// relies on. The DB orchestration itself (persistCellState) needs the Supabase
// client, which cannot be resolved offline, so it is exercised in Dev, not here
// -- the same staged posture as grading-memory.ts.

import {
  attemptIdempotency,
  canonicalJson,
  deriveCellEvent,
  deriveChangedSurface,
  paramsHash,
  readProvenance,
  rowToCellState,
} from "./cell-state-signals.ts";
import { applyAttempt, initialCellState } from "./cell-state.ts";

function assert(cond: boolean, msg: string) {
  if (!cond) throw new Error(msg);
}

// --- deriveCellEvent -------------------------------------------------------

Deno.test("deriveCellEvent: full marks on a graded item is correct", () => {
  assert(
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: 1,
      pointsAvailable: 1,
    }) ===
      "correct",
    "full marks should be correct",
  );
  assert(
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: 3,
      pointsAvailable: 3,
    }) ===
      "correct",
    "full multi-point marks should be correct",
  );
});

Deno.test("deriveCellEvent: partial or zero marks on a graded item is a direct miss", () => {
  assert(
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: 0,
      pointsAvailable: 1,
    }) ===
      "incorrect",
    "zero of one should be incorrect",
  );
  assert(
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: 2,
      pointsAvailable: 3,
    }) ===
      "incorrect",
    "partial credit should be a miss (a cell needs full independent success)",
  );
});

Deno.test("deriveCellEvent: a non-graded status writes no evidence (content_uncertain)", () => {
  assert(
    deriveCellEvent({
      finalStatus: "uncertain",
      pointsEarned: 0,
      pointsAvailable: 1,
    }) ===
      "content_uncertain",
    "uncertain -> content_uncertain",
  );
  assert(
    deriveCellEvent({
      finalStatus: "failed",
      pointsEarned: 1,
      pointsAvailable: 1,
    }) ===
      "content_uncertain",
    "failed -> content_uncertain even at full points",
  );
});

Deno.test("deriveCellEvent: a zero-point item cannot be judged (content_uncertain)", () => {
  assert(
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: 0,
      pointsAvailable: 0,
    }) ===
      "content_uncertain",
    "no available points -> no trustworthy signal",
  );
});

// --- deriveChangedSurface --------------------------------------------------

Deno.test("deriveChangedSurface: identical (template, params) is NOT a changed surface", () => {
  assert(
    deriveChangedSurface(
      { templateId: "lsrl_predict", paramsHash: "abc" },
      { templateId: "lsrl_predict", paramsHash: "abc" },
    ) === false,
    "same template AND same params = same item",
  );
});

Deno.test("deriveChangedSurface: same template, different params IS changed", () => {
  assert(
    deriveChangedSurface(
      { templateId: "lsrl_predict", paramsHash: "abc" },
      { templateId: "lsrl_predict", paramsHash: "xyz" },
    ) === true,
    "same template + different params = varied surface (F3 pin)",
  );
});

Deno.test("deriveChangedSurface: a different template is changed", () => {
  assert(
    deriveChangedSurface(
      { templateId: "lsrl_predict", paramsHash: "abc" },
      { templateId: "normal_prob", paramsHash: "abc" },
    ) === true,
    "different template = varied",
  );
});

Deno.test("deriveChangedSurface: first attempt / missing provenance counts as changed", () => {
  assert(
    deriveChangedSurface(
      { templateId: null, paramsHash: null },
      { templateId: "lsrl_predict", paramsHash: "abc" },
    ) === true,
    "no prior attempt -> novel",
  );
  assert(
    deriveChangedSurface(
      { templateId: "lsrl_predict", paramsHash: "abc" },
      { templateId: null, paramsHash: null },
    ) === true,
    "unknown current provenance is never treated as the identical prior item",
  );
});

// --- canonicalJson / paramsHash -------------------------------------------

Deno.test("canonicalJson is key-order independent", () => {
  assert(
    canonicalJson({ a: 1, b: 2 }) === canonicalJson({ b: 2, a: 1 }),
    "object key order must not change the canonical form",
  );
  assert(
    canonicalJson({ x: { p: 1, q: 2 } }) ===
      canonicalJson({ x: { q: 2, p: 1 } }),
    "nested key order must not matter",
  );
  assert(
    canonicalJson([1, 2, 3]) !== canonicalJson([3, 2, 1]),
    "array order IS significant",
  );
});

Deno.test("paramsHash: stable, order-independent, and distinct per params", async () => {
  const h1 = await paramsHash({ n: 30, x: 12 }, 5000);
  const h2 = await paramsHash({ x: 12, n: 30 }, 5000);
  const h3 = await paramsHash({ n: 31, x: 12 }, 5001);
  assert(h1 === h2, "same params (any key order) -> same hash");
  assert(h1 !== h3, "different params -> different hash");
  assert(
    typeof h1 === "string" && h1!.length === 64,
    "sha-256 hex is 64 chars",
  );
});

Deno.test("paramsHash: falls back to seed, then null", async () => {
  assert(
    (await paramsHash(null, 42)) === "seed:42",
    "seed fallback when no params",
  );
  assert(
    (await paramsHash(undefined, undefined)) === null,
    "nothing to hash -> null",
  );
});

// --- readProvenance --------------------------------------------------------

Deno.test("readProvenance extracts template_id / params / seed", () => {
  const prov = readProvenance({
    provenance: { template_id: "lsrl_predict", params: { n: 30 }, seed: 5000 },
    other: "ignored",
  });
  assert(prov.templateId === "lsrl_predict", "template_id read");
  assert(
    JSON.stringify(prov.params) === JSON.stringify({ n: 30 }),
    "params read",
  );
  assert(prov.seed === 5000, "seed read");
});

Deno.test("readProvenance tolerates absent / malformed payloads", () => {
  for (const bad of [null, undefined, "str", 3, [], { provenance: null }, {}]) {
    const prov = readProvenance(bad);
    assert(prov.templateId === null, "no template -> null");
    assert(prov.params === null, "no params -> null");
    assert(prov.seed === null, "no seed -> null");
  }
});

// --- rowToCellState --------------------------------------------------------

Deno.test("rowToCellState maps a stored row and defaults an empty one", () => {
  const s = rowToCellState({
    tier: "independent",
    fragile: true,
    weighted_evidence: 1.65,
    last_independent_success_at: "2026-03-01T09:00:00Z",
    last_attempt_at: "2026-03-02T09:00:00Z",
    last_exposure_at: null,
    next_due_at: "2026-03-12T09:00:00Z",
    due_reason: "decay",
  });
  assert(s.tier === "independent", "tier mapped");
  assert(s.fragile === true, "fragile mapped");
  assert(s.weighted_evidence === 1.65, "evidence mapped");
  assert(s.due_reason === "decay", "due_reason mapped");

  const empty = rowToCellState({});
  assert(empty.tier === "unseen", "missing tier defaults unseen");
  assert(empty.weighted_evidence === 0, "missing evidence defaults 0");
  assert(empty.fragile === false, "missing fragile defaults false");
});

// --- integration: signals -> engine ---------------------------------------
// Proves the derived signals drive the pure engine to the tiers the write hook
// depends on (the hook itself is just: derive signals -> applyAttempt -> upsert).

Deno.test("signals -> engine: fresh independent success reaches `independent`, then `confirmed` after a delay", () => {
  const t0 = new Date("2026-03-01T09:00:00Z");
  const t1 = new Date("2026-03-05T09:00:00Z"); // 4 days later, different session

  // First cold, varied, unassisted success on a novel cell.
  const first = applyAttempt(
    initialCellState(),
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: 1,
      pointsAvailable: 1,
    }),
    {
      assisted: false,
      uncertain: false,
      changedSurface: true,
      sameSession: false,
    },
    t0,
  );
  assert(first.weight === 1.0, "cold varied unassisted success = weight 1.0");
  assert(
    first.state.tier === "independent",
    "first independent success -> independent",
  );

  // A second cold, varied success after a delay confirms.
  const second = applyAttempt(
    first.state,
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: 1,
      pointsAvailable: 1,
    }),
    {
      assisted: false,
      uncertain: false,
      changedSurface: true,
      sameSession: false,
    },
    t1,
  );
  assert(
    second.state.tier === "confirmed",
    "delayed second independent success -> confirmed",
  );
});

Deno.test("signals -> engine: an assisted success is provisional (`supported`), not independent", () => {
  const t0 = new Date("2026-03-01T09:00:00Z");
  const r = applyAttempt(
    initialCellState(),
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: 1,
      pointsAvailable: 1,
    }),
    {
      assisted: true,
      uncertain: false,
      changedSurface: true,
      sameSession: false,
    },
    t0,
  );
  assert(r.weight === 0, "assisted success carries no independent evidence");
  assert(
    r.state.tier === "supported",
    "assisted success only reaches supported (INV-5)",
  );
});

Deno.test("signals -> engine: a graded miss reopens (fragile) without lowering the tier (INV-6)", () => {
  const t0 = new Date("2026-03-01T09:00:00Z");
  const t1 = new Date("2026-03-05T09:00:00Z");
  const up = applyAttempt(
    initialCellState(),
    "correct",
    {
      assisted: false,
      uncertain: false,
      changedSurface: true,
      sameSession: false,
    },
    t0,
  );
  const miss = applyAttempt(
    up.state,
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: 0,
      pointsAvailable: 1,
    }),
    {
      assisted: false,
      uncertain: false,
      changedSurface: true,
      sameSession: false,
    },
    t1,
  );
  assert(miss.state.fragile === true, "a miss marks the cell fragile");
  assert(
    miss.state.tier === "independent",
    "a miss does NOT lower the tier (INV-6)",
  );
});

Deno.test("signals -> engine: an uncertain grade records no evidence and no tier change", () => {
  const t0 = new Date("2026-03-01T09:00:00Z");
  const t1 = new Date("2026-03-05T09:00:00Z");
  const up = applyAttempt(
    initialCellState(),
    "correct",
    {
      assisted: false,
      uncertain: false,
      changedSurface: true,
      sameSession: false,
    },
    t0,
  );
  const evidenceBefore = up.state.weighted_evidence;
  const uncertain = applyAttempt(
    up.state,
    deriveCellEvent({
      finalStatus: "uncertain",
      pointsEarned: 0,
      pointsAvailable: 1,
    }),
    {
      assisted: false,
      uncertain: true,
      changedSurface: true,
      sameSession: false,
    },
    t1,
  );
  assert(
    uncertain.state.tier === up.state.tier,
    "uncertain grade leaves the tier unchanged",
  );
  assert(
    uncertain.state.weighted_evidence === evidenceBefore,
    "uncertain grade adds no evidence",
  );
});

// --- Fable QA remediation coverage (PR #101) -------------------------------

Deno.test("deriveCellEvent: non-finite or negative scores never fabricate a correct/miss", () => {
  // NaN/Infinity -> content_uncertain (F11 hardening), not a silent "incorrect".
  assert(
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: NaN,
      pointsAvailable: 1,
    }) ===
      "content_uncertain",
    "NaN earned -> content_uncertain",
  );
  assert(
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: 1,
      pointsAvailable: NaN,
    }) ===
      "content_uncertain",
    "NaN available -> content_uncertain",
  );
  assert(
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: Infinity,
      pointsAvailable: 1,
    }) ===
      "content_uncertain",
    "Infinity earned -> content_uncertain",
  );
  // A negative earned is a (real) miss; over-full (earned > available) is correct.
  assert(
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: -1,
      pointsAvailable: 2,
    }) ===
      "incorrect",
    "negative earned -> incorrect",
  );
  assert(
    deriveCellEvent({
      finalStatus: "graded",
      pointsEarned: 2,
      pointsAvailable: 1,
    }) ===
      "correct",
    "earned above available -> correct",
  );
});

Deno.test("deriveChangedSurface: template known but params unknown counts as changed (partial provenance)", () => {
  // The pure contract: only a positive match on BOTH ids is "not changed".
  assert(
    deriveChangedSurface(
      { templateId: "T", paramsHash: "p" },
      { templateId: "T", paramsHash: null },
    ) === true,
    "same template, unknown current params -> changed (never the identical item)",
  );
});

// --- attemptIdempotency (re-QA finding 2) ---------------------------------

Deno.test("attemptIdempotency: a re-grade of the same attempt is skipped, whatever the event", () => {
  for (const event of ["correct", "incorrect", "content_uncertain"] as const) {
    const r = attemptIdempotency({
      priorAttemptId: "A",
      attemptId: "A",
      event,
    });
    assert(r.skip === true, `same attempt (${event}) -> skip`);
  }
});

Deno.test("attemptIdempotency: an evidence-bearing grade stamps the attempt id", () => {
  for (const event of ["correct", "incorrect"] as const) {
    const r = attemptIdempotency({
      priorAttemptId: null,
      attemptId: "A",
      event,
    });
    assert(r.skip === false, "new attempt -> not skipped");
    assert(r.stampAttemptId === "A", `${event} stamps its attempt id`);
  }
});

Deno.test("attemptIdempotency: an uncertain write does NOT consume the idempotency budget (the New-2 fix)", () => {
  // Uncertain-first: preserves the prior stamp (null here) so a later graded
  // re-grade of the SAME attempt is NOT skipped and its mastery write lands.
  const uncertain = attemptIdempotency({
    priorAttemptId: null,
    attemptId: "A",
    event: "content_uncertain",
  });
  assert(uncertain.skip === false, "first uncertain is written");
  assert(
    uncertain.stampAttemptId === null,
    "uncertain preserves the prior stamp (null)",
  );

  // The graded re-grade of the same attempt now proceeds (prior stamp is still
  // null because the uncertain write didn't claim it).
  const graded = attemptIdempotency({
    priorAttemptId: uncertain.stampAttemptId,
    attemptId: "A",
    event: "correct",
  });
  assert(graded.skip === false, "uncertain-then-graded upgrade is NOT skipped");
  assert(graded.stampAttemptId === "A", "the graded write claims the attempt");
});

Deno.test("attemptIdempotency: an uncertain re-grade of an already-graded attempt is skipped (no clobber)", () => {
  // Graded A stamped last_attempt_id=A; a later uncertain re-grade of A must not
  // overwrite the good evidence.
  const r = attemptIdempotency({
    priorAttemptId: "A",
    attemptId: "A",
    event: "content_uncertain",
  });
  assert(r.skip === true, "uncertain re-grade of a claimed attempt -> skip");
});

Deno.test("signals -> engine: a SAME-surface repeat never reaches `independent`/`confirmed` (F3)", () => {
  // The exact property Findings 3 & 6 break: repeating the byte-identical item
  // (changedSurface=false -> weight 0.35) caps the cell at `supported`, forever.
  let state = initialCellState();
  let t = new Date("2026-03-01T09:00:00Z");
  for (let i = 0; i < 5; i++) {
    const r = applyAttempt(
      state,
      deriveCellEvent({
        finalStatus: "graded",
        pointsEarned: 1,
        pointsAvailable: 1,
      }),
      {
        assisted: false,
        uncertain: false,
        changedSurface: false,
        sameSession: false,
      },
      t,
    );
    assert(r.weight === 0.35, "same-surface success = weight 0.35");
    assert(
      r.state.tier === "supported",
      "a same-item repeat never advances past supported, however many times",
    );
    state = r.state;
    t = new Date(t.getTime() + 5 * 86_400_000);
  }
});
