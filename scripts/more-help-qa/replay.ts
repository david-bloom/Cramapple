// Offline: replay saved outputs through the CURRENT validator. No model calls, no network.
//   deno run -A replay.ts results.json
import { validateHelp } from "../../supabase/functions/more-help/contract.ts";
const rows = JSON.parse(await Deno.readTextFile(Deno.args[0]));
for (const o of rows) {
  if (o.status !== 200) continue;
  const h = o.result.help;
  const raw = { headline: h.headline, explanation: h.explanation, next_step: h.nextStep, source_ids: h.sources.map((s: { id: string }) => s.id), highlights: h.highlights, follow_ups: h.followUps };
  let verdict = "PASS";
  try { validateHelp(raw, h.sources, o.stem, true, o.stem, String(o.type || "").toLowerCase()); }
  catch (e) { verdict = "REJECT " + (e as { diagnosticReason?: string }).diagnosticReason; }
  console.log(String(o.case).padEnd(32), String(o.type).padEnd(4), verdict);
}
