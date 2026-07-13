import {
  assert,
  assertEquals,
  assertRejects,
  assertThrows,
} from "jsr:@std/assert@1.0.14";
import { compilePlan, HarnessValidationError } from "./compiler.ts";
import { assertExecutionAuthority } from "./subject-harness.ts";

const root = new URL("../../schemas/subject-onboarding/", import.meta.url);
async function fixture(name: string) {
  return JSON.parse(await Deno.readTextFile(new URL(`fixtures/${name}`, root)));
}
async function registry() {
  return JSON.parse(
    await Deno.readTextFile(new URL("platform-capabilities.v1.json", root)),
  );
}

Deno.test("AP Statistics H1 plan is deterministic and covers Q1-Q4", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  const items = await Promise.all(
    [1, 2, 3, 4].map((n) => fixture(`ap-statistics-q${n}.item-package.json`)),
  );
  const first = await compilePlan(subject, items, await registry());
  const second = await compilePlan(subject, items, await registry());
  assertEquals(first.plan_sha256, second.plan_sha256);
  assertEquals(first.items.length, 4);
});

Deno.test("capability preflight fails closed with machine-readable code", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  subject.capabilities.required_response_modalities.push("drawing");
  const item = await fixture("ap-statistics-q1.item-package.json");
  const capabilities = await registry();
  const error = await assertRejects(
    () => compilePlan(subject, [item], capabilities),
    HarnessValidationError,
  );
  assert(
    error.issues.some((issue) => issue.code === "capability.not_supported"),
  );
});

Deno.test("plugin-backed check fails closed until an approved version is registered", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  const item = await fixture("ap-statistics-q3.item-package.json");
  item.parts[0].criteria[0].deterministic_checks[0].check_type =
    "expression-equivalence";
  const capabilities = await registry();
  const error = await assertRejects(
    () => compilePlan(subject, [item], capabilities),
    HarnessValidationError,
  );
  assert(
    error.issues.some((issue) =>
      issue.code === "verifier.check_type_unsupported"
    ),
  );
});

Deno.test("item modality cannot bypass subject capability declaration", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  const item = await fixture("ap-statistics-q1.item-package.json");
  const capabilities = await registry();
  item.parts[0].response_modalities = ["drawing"];
  const error = await assertRejects(
    () => compilePlan(subject, [item], capabilities),
    HarnessValidationError,
  );
  assert(
    error.issues.some((issue) =>
      issue.code === "capability.item_modality_undeclared"
    ),
  );
  assert(
    error.issues.some((issue) =>
      issue.code === "capability.item_modality_not_supported"
    ),
  );
});

Deno.test("inventory archetype keys must resolve", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  const item = await fixture("ap-statistics-q1.item-package.json");
  const capabilities = await registry();
  subject.inventory.targets[1].archetype_key = "frq-does-not-exist";
  const error = await assertRejects(
    () => compilePlan(subject, [item], capabilities),
    HarnessValidationError,
  );
  assert(
    error.issues.some((issue) =>
      issue.code === "reference.inventory_archetype_not_found" &&
      issue.path === "/inventory/targets/1/archetype_key"
    ),
  );
});

Deno.test("inventory item types must agree with their archetypes", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  const item = await fixture("ap-statistics-q1.item-package.json");
  const capabilities = await registry();
  subject.inventory.targets[0].item_type = "frq";
  const error = await assertRejects(
    () => compilePlan(subject, [item], capabilities),
    HarnessValidationError,
  );
  assert(
    error.issues.some((issue) =>
      issue.code === "reference.inventory_item_type_mismatch" &&
      issue.path === "/inventory/targets/0"
    ),
  );
});

Deno.test("inventory must be able to fill one exam form", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  const item = await fixture("ap-statistics-q1.item-package.json");
  const capabilities = await registry();
  subject.inventory.targets.splice(1, 1);
  const error = await assertRejects(
    () => compilePlan(subject, [item], capabilities),
    HarnessValidationError,
  );
  assert(
    error.issues.some((issue) =>
      issue.code === "inventory.below_form_demand" &&
      issue.path === "/inventory/targets" &&
      issue.message === "item_type frq: inventory 3 < one form needs 4"
    ),
  );
});

Deno.test("authoring-bank inventory may exceed one exam form", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  const item = await fixture("ap-statistics-q1.item-package.json");
  subject.inventory.targets[0].target_count = 100;
  [14, 16, 22, 18].forEach((count, index) => {
    subject.inventory.targets[index + 1].target_count = count;
  });
  const plan = await compilePlan(subject, [item], await registry());
  assertEquals(plan.advisories, []);
});

Deno.test("mixed-type blueprint sections produce a non-fatal advisory", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  const item = await fixture("ap-statistics-q1.item-package.json");
  subject.blueprint.sections[0].item_types = ["mcq", "frq"];
  const plan = await compilePlan(subject, [item], await registry());
  assertEquals(plan.advisories, [
    {
      code: "blueprint.mixed_section_unreconciled",
      path: "/blueprint/sections/0",
      message:
        "section multiple-choice mixes item_types; counts not reconciled",
    },
  ]);
  assert(!("advisories" in JSON.parse(plan.plan_canonical_json)));
});

Deno.test("archetype modalities must be declared by the subject", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  const item = await fixture("ap-statistics-q1.item-package.json");
  const capabilities = await registry();
  subject.archetypes[0].response_modalities.push("graph");
  const error = await assertRejects(
    () => compilePlan(subject, [item], capabilities),
    HarnessValidationError,
  );
  assert(
    error.issues.some((issue) =>
      issue.code === "capability.archetype_modality_undeclared" &&
      issue.path === "/archetypes/0/response_modalities"
    ),
  );
});

Deno.test("part modalities must be permitted by the resolved archetype", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  const item = await fixture("ap-statistics-q1.item-package.json");
  const capabilities = await registry();
  item.parts[0].response_modalities = ["typed-math"];
  const error = await assertRejects(
    () => compilePlan(subject, [item], capabilities),
    HarnessValidationError,
  );
  assert(
    error.issues.some((issue) =>
      issue.code === "reference.part_modality_not_in_archetype" &&
      issue.path === "/items/0/parts/0/response_modalities"
    ),
  );
});

Deno.test("deterministic check parameters obey the registered contract", async () => {
  const subject = await fixture("ap-statistics-2026-27.subject-package.json");
  const item = await fixture("ap-statistics-q3.item-package.json");
  const capabilities = await registry();
  item.parts[0].criteria[0].deterministic_checks[0].parameters = {
    absolute: "not-a-number",
    script: "return true",
  };
  const error = await assertRejects(
    () => compilePlan(subject, [item], capabilities),
    HarnessValidationError,
  );
  assert(
    error.issues.some((issue) => issue.code === "verifier.parameter_type"),
  );
  assert(
    error.issues.some((issue) => issue.code === "verifier.parameter_unknown"),
  );
  assert(
    error.issues.some((issue) =>
      issue.code === "verifier.executable_field_rejected"
    ),
  );
});

Deno.test("environment authority fails closed", () => {
  assertThrows(
    () => assertExecutionAuthority("dev"),
    Error,
    "requires --approval-id",
  );
  assertThrows(
    () => assertExecutionAuthority("production", "APPROVAL-X"),
    Error,
    "requires --production",
  );
  assertExecutionAuthority("local");
});
