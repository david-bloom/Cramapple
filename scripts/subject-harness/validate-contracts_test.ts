import { assert, assertEquals } from "jsr:@std/assert@1.0.14";
import { validateContract } from "./validate-contracts.ts";

const fixtureRoot = new URL(
  "../../schemas/subject-onboarding/fixtures/",
  import.meta.url,
);

async function readFixture(name: string): Promise<Record<string, unknown>> {
  return JSON.parse(await Deno.readTextFile(new URL(name, fixtureRoot)));
}

Deno.test("AP Statistics SubjectPackage and Q1-Q4 item packages validate", async () => {
  const fixtures: Array<["subject-package" | "item-package", string]> = [
    ["subject-package", "ap-statistics-2026-27.subject-package.json"],
    ["item-package", "ap-statistics-q1.item-package.json"],
    ["item-package", "ap-statistics-q2.item-package.json"],
    ["item-package", "ap-statistics-q3.item-package.json"],
    ["item-package", "ap-statistics-q4.item-package.json"],
  ];
  for (const [kind, name] of fixtures) {
    const result = await validateContract(kind, await readFixture(name));
    assert(result.valid, `${name}: ${result.errors.join("; ")}`);
  }
});

Deno.test("legacy calendar-year exam-pack value fails closed", async () => {
  const fixture = await readFixture(
    "ap-statistics-2026-27.subject-package.json",
  );
  const examPack = fixture.exam_pack as Record<string, unknown>;
  examPack.school_year = "2026";
  const result = await validateContract("subject-package", fixture);
  assertEquals(result.valid, false);
  assert(result.errors.some((error) => error.includes("school_year")));
});

Deno.test("item packages reject executable verifier fields", async () => {
  const fixture = await readFixture("ap-statistics-q1.item-package.json");
  fixture.verifier_code = "return true";
  const result = await validateContract("item-package", fixture);
  assertEquals(result.valid, false);
  assert(
    result.errors.some((error) => error.includes("additional properties")),
  );
});
