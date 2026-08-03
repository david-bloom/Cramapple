// Tests for evidence grounding.
//
// Origin: the one Production FRQ grading that actually executed (2026-07-17)
// came back "failed 3 integrity check(s)". Measured against 2,973 real grader
// outputs, the raw `response.includes(quote)` rule flagged 10.19% of graded
// criteria, and ~64% of those were false alarms caused by nothing worse than a
// collapsed newline. A flag is not advisory -- it forces the criterion to
// unable_to_determine and zeroes its points -- so the brittle match was
// silently withholding earned credit.
//
// The check still has to REFUSE paraphrase and invention. Both directions are
// asserted below; loosening it until the second group passes would defeat the
// purpose of having it.

import { evidenceIsGrounded } from "./grading-feedback.ts";

const RESPONSE = [
  "(a) The four corners are the ones given: (V0, P0), (V0, 3P0), (2V0, 3P0).",
  "Over one full cycle the gas comes back to the exact same P and V,",
  "so it's the same state it began in and Delta U = 0.",
  "",
  "(b) f'(x) = 1 - 9x^-2 = 1 - 9/x^2",
  "Set f'(x) = 0: 1 = 9/x^2, so x^2 = 9, so x = 3 or x = -3.",
  "Only x = 3 is in the domain, so that's the one I use.",
].join("\n");

function ok(name: string, quote: string) {
  Deno.test(`grounded: ${name}`, () => {
    if (!evidenceIsGrounded(quote, RESPONSE)) {
      throw new Error(`expected grounded, was flagged: ${quote}`);
    }
  });
}

function rejected(name: string, quote: string) {
  Deno.test(`flagged: ${name}`, () => {
    if (evidenceIsGrounded(quote, RESPONSE)) {
      throw new Error(`expected flagged, was accepted: ${quote}`);
    }
  });
}

// --- must be accepted: real spans the model merely reformatted ------------
ok("exact substring", "Only x = 3 is in the domain");
ok(
  "span crossing a newline (the dominant false alarm)",
  "Over one full cycle the gas comes back to the exact same P and V, so it's the same state it began in",
);
ok("curly apostrophe for straight", "so it’s the same state it began in");
ok(
  "elided middle with ...",
  "f'(x) = 1 - 9x^-2 = 1 - 9/x^2 ... Only x = 3 is in the domain",
);
ok(
  "elided middle with bracketed [...]",
  "The four corners are the ones given [...] Delta U = 0.",
);
ok("unicode ellipsis character", "Set f'(x) = 0: 1 = 9/x^2 … Only x = 3 is in the domain");
ok("leading and trailing whitespace", "   Delta U = 0.   ");

// --- must still be flagged: the behaviour the check exists for ------------
rejected("outright invention", "The student correctly applied the Central Limit Theorem.");
rejected(
  "paraphrase of a real idea, not a quote",
  "the gas returns to its initial state so the change in internal energy is zero",
);
rejected("plausible but absent numbers", "x^2 = 16, so x = 4 or x = -4.");
rejected("empty quote", "");
rejected(
  "elision used to stitch fragments in the WRONG order",
  "Only x = 3 is in the domain ... The four corners are the ones given",
);

Deno.test("elision cannot be abused with trivially short fragments", () => {
  // "a ... b ... c" must not match merely because single characters occur.
  if (evidenceIsGrounded("a ... b ... c", RESPONSE)) {
    throw new Error("short fragments should not satisfy the elision path");
  }
});

Deno.test("fragments must not overlap when matched in order", () => {
  // Both fragments exist, but only as the SAME occurrence — the second must be
  // found strictly after the first, not re-matched on the same text.
  const text = "alpha beta gamma";
  if (evidenceIsGrounded("alpha beta gamma ... alpha beta gamma", text)) {
    throw new Error("the same span was reused to satisfy two fragments");
  }
});
