// Offline transport tests. Every fetch is replaced; no provider call is possible.
import { mkdtempSync, writeFileSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { spawnSync } from "node:child_process";
import assert from "node:assert/strict";
const dir = mkdtempSync(join(tmpdir(), "grader-gateway-offline-"));
const runner = new URL("./run_gateway.mjs", import.meta.url);
const code = readFileSync(runner, "utf8");
const cap = Number(code.match(/const CAP = (\d+)/)[1]);
const hook = join(dir, "mock.mjs");
writeFileSync(hook, `
globalThis.fetch = async (url, options) => {
  const body = JSON.parse(options.body);
  if (body.ping) return Response.json({has_gateway_key:true,model:"openai/gpt-5.4-mini",max_output_tokens:3000,reasoning_effort:"high"});
  if (!url.endsWith("/tmp-latex-grader-test")) throw new Error("unexpected URL; network disabled");
  if (process.env.TEST_FAIL === "1") return Response.json({error:"mock_failure"},{status:502});
  return Response.json({parsed:{criterion_key:"c1",status:"earned",points_awarded:1},mockTrialIndex:body.trialIndex});
};`);
const failed = n => ({rep:1,item:"mech",resp:"correct",form:"plain",n,result:{error:"prior_failure"}});
const run = (name, rows, limit, fail = false) => {
  const path = join(dir, name + ".jsonl");
  writeFileSync(path, rows.map(JSON.stringify).join("\n") + "\n");
  const result = spawnSync(process.execPath, [runner.pathname, path, String(limit)], {
    encoding:"utf8", env:{...process.env,NODE_OPTIONS:"--import " + hook,TEST_FAIL:fail?"1":"0"},
  });
  return { result, rows:readFileSync(path,"utf8").trim().split("\n").map(JSON.parse) };
};
try {
  let test = run("missing", [failed(1)], 1);
  assert.equal(test.result.status, 0, test.result.stderr);
  assert.equal(test.rows.length, 2);
  assert.equal(test.rows[1].result.mockTrialIndex, 0, "retry missing observation, rather than skip failed trial");
  test = run("cap", Array.from({length:cap-1},(_,i)=>failed(i+1)), 3);
  assert.equal(test.result.status, 0, test.result.stderr);
  assert.equal(test.rows.length, cap, "failures count against the hard cap");
  test = run("failure", [failed(1)], 3, true);
  assert.equal(test.rows.length, 2, "stop at the first failure");
  assert.equal(test.rows[1].result.error, "mock_failure");
  test = run("reserved", [{...failed(1),result:{state:"reserved"}}], 1);
  assert.notEqual(test.result.status, 0);
  assert.equal(test.rows.length, 1, "unknown request outcome cannot silently consume another call");
  console.log("4 offline Gateway counter/recovery checks passed; 0 provider calls");
} finally { rmSync(dir,{recursive:true,force:true}); }
