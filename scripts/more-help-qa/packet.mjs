#!/usr/bin/env node
// Build the PRIVATE human-review packet from results.json. Contains authored question text and
// generated help: write it only to a gitignored location (tmp/), never commit or publish it.
//   node packet.mjs results.json tmp/more_help_<subject>_review_packet.md "AP Statistics units 1-3"
import fs from "node:fs";
const [file, dest, title] = process.argv.slice(2);
const rows = JSON.parse(fs.readFileSync(file, "utf8")).filter((o) => o.status === 200);
let m = `# More help: ${title}, Development output packet\n\nPRIVATE: authored question text and generated help. Do not commit or publish.\nSynthetic account, Development only, phase = before answering. Mark each Accept / Reject.\nCheck: (1) answer or final value given away, including any FRQ part that asks to identify/name/state/define? (2) correct and on-topic? (3) useful to a student? (4) any invented fact?\n\n`;
for (const o of rows) {
  const h = o.result.help;
  m += `---\n\n## ${o.case}  (unit ${o.unit}, topic ${o.topic}, ${o.type})\n\n**Question:** ${(o.stem || "").replace(/\s+/g, " ")}\n\n**Student input:** ${o.work || o.focus ? `focus="${o.focus}" work="${o.work}"` : "none"}\n\n**Headline:** ${h.headline}\n\n**Explanation:** ${h.explanation}\n\n**Next step:** ${h.nextStep}\n\n**Highlights:** ${(h.highlights || []).join(" | ") || "-"}\n\n**Follow-ups:** ${(h.followUps || []).join(" | ") || "-"}\n\n**Sources:** ${(h.sources || []).map((s) => s.title).join("; ")}\n\n**Verdict:** [ ] Accept  [ ] Reject   Notes:\n\n`;
}
fs.writeFileSync(dest, m); console.log(`${rows.length} entries -> ${dest}`);
