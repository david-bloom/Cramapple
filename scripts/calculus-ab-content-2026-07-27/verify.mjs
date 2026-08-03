import { createHash } from "node:crypto";
import { readFile, readdir, writeFile } from "node:fs/promises";

const ROOT = new URL("../../", import.meta.url).pathname;
const DIR = `${ROOT}content/item-packages/ap-calculus-ab`;
const CED = `${ROOT}docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf`;
const REPORT = `${ROOT}docs/research/AP_CALCULUS_AB_CONTENT_VALIDATION_2026_07_27.json`;
const GENERATED_AT = "2026-07-27T00:00:00Z";
const errors = [];
const warnings = [];
const assert = (condition,message) => { if (!condition) errors.push(message); };
const sha = value => createHash("sha256").update(value).digest("hex");
const pattern = /^apcalcab-(mcq-(02[1-9]|0[3-4][0-9]|050)|frq-(01[7-9]|02[0-9]|03[0-6]))\.json$/;
const names = (await readdir(DIR)).filter(name => pattern.test(name)).sort();
const items = await Promise.all(names.map(async name => JSON.parse(await readFile(`${DIR}/${name}`,"utf8"))));
const mcq = items.filter(item => item.item_type==="mcq");
const frq = items.filter(item => item.item_type==="frq");

assert(items.length===50,`Expected 50 packages; found ${items.length}.`);
assert(mcq.length===30,`Expected 30 MCQs; found ${mcq.length}.`);
assert(frq.length===20,`Expected 20 FRQs; found ${frq.length}.`);
assert(new Set(items.map(x=>x.package_id)).size===50,"Package identifiers are not unique.");

const unitOf = item => Number(item.taxonomy_refs.find(x=>x.node_key.startsWith("unit-"))?.node_key.match(/^unit-(\d+)/)?.[1]);
const topicOf = item => item.taxonomy_refs.find(x=>x.node_key.startsWith("topic-"))?.node_key.replace("topic-","");
const practiceOf = item => Number(item.taxonomy_refs.find(x=>x.node_key.startsWith("practice-"))?.node_key.match(/^practice-(\d+)/)?.[1]);
const countBy = (array,fn,keys) => Object.fromEntries(keys.map(key=>[key,array.filter(x=>fn(x)===key).length]));

for (const item of items) {
  assert(item.schema_version==="1.0.0",`${item.package_id}: schema version mismatch.`);
  assert(item.package_id===item.content_key,`${item.package_id}: content key mismatch.`);
  assert(item.exam_pack_ref?.exam_code==="ap_calculus_ab",`${item.package_id}: wrong exam code.`);
  assert(item.exam_pack_ref?.school_year==="2026-27",`${item.package_id}: wrong school year.`);
  assert(item.taxonomy_refs?.length===3,`${item.package_id}: expected unit, topic, and practice taxonomy references.`);
  assert(unitOf(item)>=1&&unitOf(item)<=8,`${item.package_id}: outside Calculus AB Units 1–8.`);
  assert(!["6.12","6.13"].includes(topicOf(item)),`${item.package_id}: uses BC-only Unit 6 content.`);
  assert(practiceOf(item)>=1&&practiceOf(item)<=4,`${item.package_id}: invalid mathematical practice.`);
  assert(item.review_notes?.originality_statement?.includes("no released, secure"),`${item.package_id}: missing originality statement.`);
  assert(item.review_notes?.teaching_explanation,`${item.package_id}: missing teaching explanation.`);
  assert(item.review_notes?.minimum_fix,`${item.package_id}: missing minimum fix.`);
  assert(item.review_notes?.transfer_candidate,`${item.package_id}: missing transfer candidate.`);
  assert(item.review_notes?.delayed_retrieval_candidate,`${item.package_id}: missing delayed-retrieval candidate.`);
  const copy=structuredClone(item);
  const stored=copy.provenance?.content_sha256;
  delete copy.provenance.content_sha256;
  assert(stored===sha(JSON.stringify(copy)),`${item.package_id}: content hash mismatch.`);
}

const mcqUnits=countBy(mcq,unitOf,[1,2,3,4,5,6,7,8]);
const expectedMcqUnits={1:4,2:4,3:2,4:4,5:5,6:5,7:2,8:4};
assert(JSON.stringify(mcqUnits)===JSON.stringify(expectedMcqUnits),`MCQ unit distribution mismatch: ${JSON.stringify(mcqUnits)}.`);
const mcqModes=countBy(mcq,x=>x.stimuli[0].payload.calculator_mode,["calculator","no-calculator"]);
assert(mcqModes.calculator===9&&mcqModes["no-calculator"]===21,`MCQ calculator split mismatch: ${JSON.stringify(mcqModes)}.`);
const mcqPractices=countBy(mcq,practiceOf,[1,2,3,4]);
assert(mcqPractices[1]===18&&mcqPractices[2]===7&&mcqPractices[3]===5&&mcqPractices[4]===0,`MCQ practice distribution mismatch: ${JSON.stringify(mcqPractices)}.`);
const keyCounts=countBy(mcq,x=>x.canonical_answers[0],["A","B","C","D"]);
assert(JSON.stringify(keyCounts)===JSON.stringify({A:8,B:8,C:7,D:7}),`MCQ answer balance mismatch: ${JSON.stringify(keyCounts)}.`);

for (const item of mcq) {
  assert(item.mcq_choices?.length===4,`${item.package_id}: expected exactly four choices.`);
  assert(new Set(item.mcq_choices.map(x=>x.choice_text)).size===4,`${item.package_id}: duplicate choice text.`);
  assert(item.mcq_choices.filter(x=>x.is_correct).length===1,`${item.package_id}: expected exactly one correct choice.`);
  const correct=item.mcq_choices.find(x=>x.is_correct);
  assert(correct?.choice_key===item.canonical_answers[0],`${item.package_id}: key does not match correct choice.`);
  assert(item.mcq_choices.every(x=>x.rationale.length>=24),`${item.package_id}: a rationale is too short.`);
  const lengths=item.mcq_choices.map(x=>x.choice_text.replace(/\s+/g,"").length);
  const correctIndex="ABCD".indexOf(item.canonical_answers[0]);
  const distractorMean=lengths.filter((_,i)=>i!==correctIndex).reduce((a,b)=>a+b,0)/3;
  const ratio=lengths[correctIndex]/distractorMean;
  if (ratio>=1.4) warnings.push(`${item.package_id}: correct-choice length is ${ratio.toFixed(2)}× distractor mean.`);
}

const frqUnits=countBy(frq,unitOf,[1,2,3,4,5,6,7,8]);
assert(JSON.stringify(frqUnits)===JSON.stringify({1:2,2:3,3:1,4:3,5:5,6:2,7:2,8:2}),`FRQ unit distribution mismatch: ${JSON.stringify(frqUnits)}.`);
const frqModes=countBy(frq,x=>x.stimuli[0].payload.calculator_mode,["calculator","no-calculator"]);
assert(frqModes.calculator===7&&frqModes["no-calculator"]===13,`FRQ calculator split mismatch: ${JSON.stringify(frqModes)}.`);
for (const item of frq) {
  const points=item.parts.reduce((sum,part)=>sum+part.points,0);
  assert(points===9,`${item.package_id}: expected exactly 9 points; found ${points}.`);
  assert(item.scoring_contract?.total_points===9,`${item.package_id}: scoring contract is not 9 points.`);
  assert(item.parts.length>=3&&item.parts.length<=4,`${item.package_id}: expected 3–4 parts.`);
  assert(item.scoring_contract?.part_count===item.parts.length,`${item.package_id}: part-count contract mismatch.`);
  for (const part of item.parts) {
    assert(part.points===part.criteria.length,`${item.package_id} ${part.label}: part points do not match criteria.`);
    assert(part.criteria.every(c=>c.points===1),`${item.package_id} ${part.label}: non-one-point criterion found.`);
    assert(part.criteria.every(c=>c.required_evidence?.length&&c.accepted_variants?.length&&c.insufficient_responses?.length&&c.contradictions?.length&&c.minimum_fix),`${item.package_id} ${part.label}: incomplete criterion boundary contract.`);
  }
}

const scratchPatterns = [/\bactually\b/i,/\bwait\b/i,/\bcorrection:/i,/\bTODO\b/i,/\bTBD\b/i,/\?\s*No;/i,/\.\.\./];
for (const item of items) {
  const text=JSON.stringify(item);
  for (const regex of scratchPatterns) assert(!regex.test(text),`${item.package_id}: possible scratch-work artifact ${regex}.`);
}

const normalized=items.map(item=>({
  id:item.package_id,
  text:[...(item.stimuli||[]).map(s=>s.payload?.text||""),...item.parts.map(p=>p.prompt)].join(" ").toLowerCase().replace(/[^a-z0-9 ]/g," ").replace(/\s+/g," ").trim()
}));
for (let i=0;i<normalized.length;i++) for (let j=i+1;j<normalized.length;j++) {
  const a=new Set(normalized[i].text.split(" "));
  const b=new Set(normalized[j].text.split(" "));
  const overlap=[...a].filter(x=>b.has(x)).length/new Set([...a,...b]).size;
  if (overlap>0.85) warnings.push(`Possible prompt similarity ${normalized[i].id}/${normalized[j].id}: ${overlap.toFixed(2)}.`);
}

const cedHash=sha(await readFile(CED));
assert(cedHash==="fd571cdc252c24d33a75ed556ee20d9261ef1ad3dbb718d0caf78acecc8253ca","Local Calculus CED hash differs from the verified fact-pack source.");
const report={
  status:errors.length?"FAIL":"PASS",
  generated_at:GENERATED_AT,
  ced_sha256:cedHash,
  counts:{packages:items.length,mcq:mcq.length,frq:frq.length},
  mcq:{units:mcqUnits,calculator_modes:mcqModes,practices:mcqPractices,answer_keys:keyCounts},
  frq:{units:frqUnits,calculator_modes:frqModes,all_nine_points:frq.every(x=>x.parts.reduce((s,p)=>s+p.points,0)===9)},
  errors,warnings
};
await writeFile(REPORT,`${JSON.stringify(report,null,2)}\n`);
console.log(JSON.stringify(report,null,2));
if (errors.length) process.exit(1);
