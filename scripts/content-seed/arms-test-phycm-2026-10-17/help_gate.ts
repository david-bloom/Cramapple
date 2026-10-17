// Help-leak test for the arms experiment, using the real More help code (prompt, boundary, runtime check, rewrite note).
//   deno run -A help_gate.ts <in.json> <out.json> <gate|measure>
// gate:    stem + keyed answer only (no choices shown to the help model); one draft, one check, no rewrite.
// measure: a finished item with all choices; draft, check, and up to two reviewer-guided rewrites (as in production).
// Env: AI_GATEWAY_API_KEY, HELP_CALL_LOG (jsonl path for usage), REFS (path to the Production reference-entry export).
import { helpContext } from "../../../supabase/functions/more-help/contract.ts";
import { generateHelp, HELP_GATEWAY_MODEL } from "../../../supabase/functions/more-help/model.ts";
import { checkNoAnswerLeak, LeakError, revisionNote } from "../../../supabase/functions/more-help/verify.ts";
const [inPath, outPath, mode] = Deno.args;
const key = Deno.env.get("AI_GATEWAY_API_KEY")!;
const logPath = Deno.env.get("HELP_CALL_LOG");
const refsPath = Deno.env.get("REFS") || new URL("./refs_mech.json", import.meta.url).pathname;
const refs = JSON.parse(await Deno.readTextFile(refsPath));
const items = JSON.parse(await Deno.readTextFile(inPath));
let tag = "";
const logFetch: typeof fetch = async (u, init) => {
  const r = await fetch(u, init);
  if (logPath) {
    try {
      const j = await r.clone().json();
      const model = JSON.parse(String((init as RequestInit).body)).model;
      await Deno.writeTextFile(logPath, JSON.stringify({ at: new Date().toISOString(), tag, model, ok: r.ok, usage: { inputTokens: j.usage?.prompt_tokens ?? 0, outputTokens: j.usage?.completion_tokens ?? 0, cachedInputTokens: j.usage?.prompt_tokens_details?.cached_tokens ?? 0 } }) + "\n", { append: true });
    } catch { /* metering is best effort */ }
  }
  return r;
};
async function one(it: any) {
  const rec: any = { id: it.id, topic: it.topic_code };
  try {
    const mine = it.refs ?? refs.filter((e: any) => (e.topic_codes || []).includes(it.topic_code)).slice(0, 8);
    const vid = crypto.randomUUID();
    const input = { requestId: crypto.randomUUID(), sessionId: crypto.randomUUID(), questionId: vid, ordinal: 1, focus: "", work: "", phase: "before" as const };
    const choices: Array<{ k: string; t: string; c: boolean }> = it.choices ?? [{ k: "A", t: it.correct, c: true }];
    const raw = {
      session: { learningSessionId: input.sessionId }, counter: { index: 1 },
      item: { contentItemVersionId: vid, stem: it.stem, itemType: "mcq" },
      mcqChoices: it.choices ? choices.map((c) => ({ choiceKey: c.k, choiceText: c.t })) : [],
      topic: { subjectKey: it.subject_key || "ap-physics-c-mechanics", topicCode: it.topic_code },
      reference: { all: mine.map((e: any) => ({ id: e.id, kind: e.kind, title: e.title, body: e.body, items: e.items || [], caution: e.caution, memoryHooks: [], ownerTopicCode: e.owner_topic_code, topicCodes: e.topic_codes })) },
      grading: { status: "none" },
    };
    rec.facts = mine.length;
    const ctx = helpContext(raw, input);
    const ck = { stem: it.stem, choices: choices.map((c) => ({ key: c.k, text: c.t, correct: c.c })) };
    let revision: string | undefined; rec.revisions = 0; rec.first = "?";
    const maxRev = mode === "gate" ? 0 : 2;
    for (let a = 0; a <= maxRev; a++) {
      tag = `${it.id} help ${mode} a${a}`;
      const help: any = await generateHelp(ctx, key, HELP_GATEWAY_MODEL, logFetch, revision);
      tag = `${it.id} check ${mode} a${a}`;
      try {
        await checkNoAnswerLeak(ck, help, key, logFetch);
        if (rec.first === "?") rec.first = "CLEAN";
        rec.final = "DELIVERED"; rec.headline = help.headline; rec.expl = help.explanation; break;
      } catch (e: any) {
        if (e instanceof LeakError) {
          if (rec.first === "?") { rec.first = "FLAGGED"; rec.reason = e.reason; }
          if (a === maxRev) { rec.final = "REFUSED"; break; }
          rec.revisions++; revision = revisionNote(e.reason);
        } else { if (rec.first === "?") rec.first = "ERROR"; rec.final = "CHECK-ERROR " + e.code; break; }
      }
    }
  } catch (e: any) { rec.first = rec.first && rec.first !== "?" ? rec.first : "ERROR"; rec.final = "GEN-ERROR " + (e.code || String(e).slice(0, 80)); }
  return rec;
}
const out: any[] = []; const queue = [...items];
await Promise.all(Array.from({ length: Math.min(8, items.length) }, async () => { while (queue.length) out.push(await one(queue.shift())); }));
await Deno.writeTextFile(outPath, JSON.stringify(out, null, 1));
