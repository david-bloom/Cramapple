#!/usr/bin/env node
//
// Creates the isolated synthetic student used by run_pilot.mjs and writes its
// session to disk. THE OWNER RUNS THIS, not the assistant: it creates an
// account and handles a password, which the assistant does not do.
//
// Copied from docs/research/grading_repair_pilot_2026_07_27/create_pilot_session.mjs
// with pilot-specific file paths so the two pilots' synthetic identities and
// session files never collide if both are ever re-run.
//
// Usage:
//   node docs/research/exemplar_grading_pilot_2026_08/create_pilot_session.mjs
//
// Then tell the assistant it is done. It will confirm the address (Production
// requires email confirmation) and re-run this with --signin to capture the
// session.

import { writeFileSync, readFileSync, existsSync } from "node:fs";
import { randomBytes } from "node:crypto";

const PROJECT_URL = "https://pcntajvbdfqhbeewmdry.supabase.co";
const PUBLISHABLE_KEY = process.env.SUPABASE_PUBLISHABLE_KEY ??
  "sb_publishable_TlRLW6EOot2pzI4QYtuP7A_XcktZHFT";
const SESSION_FILE = "/tmp/cramapple_exemplar_pilot_session.json";
const CRED_FILE = "/tmp/cramapple_exemplar_pilot_cred.json";
const STAMP = new Date().toISOString().slice(0, 10).replace(/-/g, "");
const SIGNIN = process.argv.includes("--signin");

async function auth(path, body) {
  const res = await fetch(`${PROJECT_URL}/auth/v1/${path}`, {
    method: "POST",
    headers: { apikey: PUBLISHABLE_KEY, "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  const json = await res.json();
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${JSON.stringify(json)}`);
  return json;
}

if (!SIGNIN) {
  // A random throwaway password for a throwaway internal account. It is written
  // only to /tmp, never to the repo, and the account is deleted at cleanup.
  //
  // The email carries a random suffix so every invocation creates a genuinely
  // new account -- a date-stamped-only address would hit an already-registered
  // email on a second run, and Supabase answers that with a DECOY success
  // (anti-enumeration) that leaves the original password untouched (see the
  // 2026-07-27 pilot's script for the incident this guards against).
  const email = `exemplar-pilot-${STAMP}-${randomBytes(4).toString("hex")}+test@cramapple-internal.test`;
  const password = `${randomBytes(24).toString("base64url")}Aa1!`;
  const out = await auth("signup", { email, password });
  const userId = out.user?.id ?? out.id;

  const identities = out.user?.identities ?? out.identities;
  if (Array.isArray(identities) && identities.length === 0) {
    throw new Error(
      `Signup returned a decoy for ${email} — that address is already registered and its ` +
        `password was NOT changed. Credentials file left untouched.`,
    );
  }
  if (!userId) throw new Error(`Signup returned no user id: ${JSON.stringify(out).slice(0, 200)}`);

  writeFileSync(CRED_FILE, JSON.stringify({ email, password, user_id: userId }), { mode: 0o600 });

  console.log("\nSynthetic pilot account created.");
  console.log(`  user_id : ${userId}`);
  console.log(`  email   : ${email}`);
  console.log(`  session : ${out.access_token ? "issued immediately" : "NOT issued — needs email confirmation"}`);

  if (out.access_token) {
    writeFileSync(SESSION_FILE, JSON.stringify(out), { mode: 0o600 });
    console.log(`\nWrote ${SESSION_FILE}. Ready to run the pilot.`);
  } else {
    console.log(`\nCredentials written to ${CRED_FILE} (chmod 600, /tmp only).`);
    console.log("Next: tell the assistant the account exists. It will confirm the");
    console.log("address, then run this script again with --signin.");
  }
} else {
  if (!existsSync(CRED_FILE)) throw new Error(`missing ${CRED_FILE} — run without --signin first`);
  const { email, password } = JSON.parse(readFileSync(CRED_FILE, "utf8"));
  const out = await auth("token?grant_type=password", { email, password });
  writeFileSync(SESSION_FILE, JSON.stringify(out), { mode: 0o600 });
  console.log(`Signed in. Wrote ${SESSION_FILE}. user=${out.user?.id}`);
}
