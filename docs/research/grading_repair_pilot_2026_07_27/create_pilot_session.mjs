#!/usr/bin/env node
//
// Creates the isolated synthetic student used by run_pilot.mjs and writes its
// session to disk. THE OWNER RUNS THIS, not the assistant: it creates an
// account and handles a password, which the assistant does not do.
//
// The 2026-07-27 pilot's synthetic user was removed by that run's cleanup, so
// a fresh one is needed for each pilot. Nothing here touches real users, real
// content, or any existing row.
//
// Usage:
//   node docs/research/grading_repair_pilot_2026_07_27/create_pilot_session.mjs
//
// Then tell the assistant it is done. It will confirm the address (Production
// requires email confirmation) and re-run this with --signin to capture the
// session, exactly as the 2026-07-27 run did.

import { writeFileSync, readFileSync, existsSync } from "node:fs";
import { randomBytes } from "node:crypto";

const PROJECT_URL = "https://pcntajvbdfqhbeewmdry.supabase.co";
const PUBLISHABLE_KEY = process.env.SUPABASE_PUBLISHABLE_KEY ??
  "sb_publishable_TlRLW6EOot2pzI4QYtuP7A_XcktZHFT";
const SESSION_FILE = "/tmp/cramapple_grading_pilot_session.json";
const CRED_FILE = "/tmp/cramapple_grading_pilot_cred.json";
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
  // new account. An earlier version used a date-stamped address, which made a
  // second run hit an already-registered email -- and Supabase answers that
  // with a DECOY success (anti-enumeration) that leaves the original password
  // untouched. The script then overwrote the credentials file with a password
  // that had never been applied, and sign-in failed with invalid_credentials
  // against an account whose real password was gone. Unique emails remove the
  // trap; the guard below catches it anyway if it ever reappears.
  const email = `grading-pilot-${STAMP}-${randomBytes(4).toString("hex")}+test@cramapple-internal.test`;
  const password = `${randomBytes(24).toString("base64url")}Aa1!`;
  const out = await auth("signup", { email, password });
  const userId = out.user?.id ?? out.id;

  // Supabase signals "this email already exists" by returning a user with an
  // empty identities array rather than an error. Never write credentials in
  // that case -- they would not be the account's real ones.
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
