import Ajv2020Module from "npm:ajv@8.17.1/dist/2020.js";
import addFormatsModule from "npm:ajv-formats@3.0.1";
import type { ErrorObject, ValidateFunction } from "npm:ajv@8.17.1";
import { basename, extname, fromFileUrl, join } from "jsr:@std/path@1.1.2";

const scriptDir = fromFileUrl(new URL(".", import.meta.url));
const repoRoot = join(scriptDir, "..", "..");
const schemaDir = join(repoRoot, "schemas", "subject-onboarding");

export type ContractKind = "subject-package" | "item-package";

type AjvInstance = { compile(schema: object): ValidateFunction };
const Ajv2020 = Ajv2020Module as unknown as new (
  options: Record<string, unknown>,
) => AjvInstance;
const addFormats = addFormatsModule as unknown as (ajv: AjvInstance) => void;

export async function validateContract(
  kind: ContractKind,
  value: unknown,
): Promise<{ valid: boolean; errors: string[] }> {
  const schema = JSON.parse(
    await Deno.readTextFile(join(schemaDir, `${kind}.schema.json`)),
  );
  const ajv = new Ajv2020({ allErrors: true, strict: true });
  addFormats(ajv);
  const validate = ajv.compile(schema);
  const valid = validate(value);
  return {
    valid,
    errors: (validate.errors ?? []).map((error: ErrorObject) =>
      `${error.instancePath || "/"} ${error.message ?? "is invalid"}`
    ),
  };
}

function inferKind(path: string): ContractKind {
  const name = basename(path, extname(path));
  if (name.endsWith(".subject-package")) return "subject-package";
  if (name.endsWith(".item-package")) return "item-package";
  throw new Error(`cannot infer contract kind from ${path}`);
}

if (import.meta.main) {
  if (Deno.args.length === 0) {
    console.error(
      "usage: deno run --allow-read scripts/subject-harness/validate-contracts.ts <contract.json> [...]",
    );
    Deno.exit(2);
  }

  let failed = false;
  for (const path of Deno.args) {
    const value = JSON.parse(await Deno.readTextFile(path));
    const result = await validateContract(inferKind(path), value);
    if (result.valid) {
      console.log(`PASS ${path}`);
    } else {
      failed = true;
      console.error(`FAIL ${path}`);
      for (const error of result.errors) console.error(`  ${error}`);
    }
  }
  if (failed) Deno.exit(1);
}
