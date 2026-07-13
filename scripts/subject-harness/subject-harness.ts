import { dirname, fromFileUrl, join } from "jsr:@std/path@1.1.2";
import { compilePlan } from "./compiler.ts";

const here = dirname(fromFileUrl(import.meta.url));
const registryPath = join(
  here,
  "..",
  "..",
  "schemas",
  "subject-onboarding",
  "platform-capabilities.v1.json",
);
async function json(path: string) {
  return JSON.parse(await Deno.readTextFile(path));
}
function option(args: string[], name: string): string | undefined {
  const i = args.indexOf(name);
  return i < 0 ? undefined : args[i + 1];
}
function sqlLiteral(value: string): string {
  return `'${value.replaceAll("'", "''")}'`;
}

export function assertExecutionAuthority(
  environment?: string,
  approvalId?: string,
  productionFlag = false,
) {
  if (!environment || !["local", "dev", "production"].includes(environment)) {
    throw new Error("environment must be explicit: local, dev, or production");
  }
  if (environment !== "local" && !approvalId) {
    throw new Error(`${environment} requires --approval-id`);
  }
  if (environment === "production" && !productionFlag) {
    throw new Error("production requires --production confirmation");
  }
}

async function build(args: string[]) {
  const subjectPath = option(args, "--subject");
  const itemPaths = args.flatMap((arg, index) =>
    arg === "--item" ? [args[index + 1]] : []
  ).filter(Boolean);
  if (!subjectPath) throw new Error("--subject is required");
  return await compilePlan(
    await json(subjectPath),
    await Promise.all(itemPaths.map(json)),
    await json(registryPath),
  );
}

if (import.meta.main) {
  const [command, ...args] = Deno.args;
  if (!["validate", "verify", "plan", "apply", "evidence"].includes(command)) {
    console.error(
      "usage: subject-harness <validate|verify|plan|apply|evidence> --subject file [--item file ...]",
    );
    Deno.exit(2);
  }
  try {
    if (command === "evidence") {
      const requestPath = option(args, "--request");
      if (!requestPath) throw new Error("evidence requires --request JSON");
      const databaseUrl = Deno.env.get("SUBJECT_HARNESS_DATABASE_URL");
      if (!databaseUrl) {
        throw new Error("SUBJECT_HARNESS_DATABASE_URL is required");
      }
      const request = await Deno.readTextFile(requestPath);
      const result = await new Deno.Command("psql", {
        args: [
          databaseUrl,
          "--set=ON_ERROR_STOP=1",
          "--no-psqlrc",
          "--tuples-only",
          "--command",
          `select app.content_publication_gate_status(${
            sqlLiteral(request)
          }::jsonb);`,
        ],
        stdout: "inherit",
        stderr: "inherit",
      }).output();
      if (!result.success) Deno.exit(result.code);
      Deno.exit(0);
    }
    const plan = await build(args);
    if (command === "validate") {
      console.log(
        JSON.stringify({ valid: true, plan_sha256: plan.plan_sha256 }),
      );
      Deno.exit(0);
    }
    if (command === "verify") {
      console.log(
        JSON.stringify(
          {
            valid: true,
            plan_sha256: plan.plan_sha256,
            verification: plan.subject_package.verification,
            release_gates: plan.subject_package.release_gates,
          },
          null,
          2,
        ),
      );
      Deno.exit(0);
    }
    if (command === "plan") {
      console.log(JSON.stringify(plan, null, 2));
      Deno.exit(0);
    }
    const environment = option(args, "--environment");
    const approvalId = option(args, "--approval-id");
    assertExecutionAuthority(
      environment,
      approvalId,
      args.includes("--production"),
    );
    const actorId = option(args, "--actor-id");
    if (!actorId) throw new Error("--actor-id is required");
    const databaseUrl = Deno.env.get("SUBJECT_HARNESS_DATABASE_URL");
    if (!databaseUrl) {
      throw new Error("SUBJECT_HARNESS_DATABASE_URL is required");
    }
    const query = `select app.apply_subject_package_atomic(${
      sqlLiteral(JSON.stringify(plan))
    }::jsonb,${sqlLiteral(actorId)}::uuid,${sqlLiteral(environment!)},${
      approvalId ? sqlLiteral(approvalId) : "null"
    });`;
    const result = await new Deno.Command("psql", {
      args: [
        databaseUrl,
        "--set=ON_ERROR_STOP=1",
        "--no-psqlrc",
        "--tuples-only",
        "--command",
        query,
      ],
      stdout: "inherit",
      stderr: "inherit",
    }).output();
    if (!result.success) Deno.exit(result.code);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    Deno.exit(1);
  }
}
