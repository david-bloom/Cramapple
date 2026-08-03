import { createHash } from "node:crypto";
import { readFile, readdir, writeFile } from "node:fs/promises";

const ROOT = new URL("../../", import.meta.url).pathname;
const DIR = `${ROOT}content/item-packages/ap-precalculus`;
const CED = `${ROOT}docs/teaching/ap-precalculus-course-and-exam-description.pdf`;
const REPORT = `${ROOT}docs/research/AP_PRECALCULUS_CONTENT_VALIDATION_2026_07_27.json`;
const errors = [];
const warnings = [];
const assert = (condition, message) => { if (!condition) errors.push(message); };
const sha = data => createHash("sha256").update(data).digest("hex");
const batchPattern = /^apprecalc-(mcq-(02[1-9]|0[3-4][0-9]|050)|frq-(01[7-9]|02[0-9]|03[0-6]))\.json$/;
const names = (await readdir(DIR)).filter(name => batchPattern.test(name)).sort();
const items = await Promise.all(names.map(async name => JSON.parse(await readFile(`${DIR}/${name}`,"utf8"))));
const mcq = items.filter(item => item.item_type === "mcq");
const frq = items.filter(item => item.item_type === "frq");

assert(items.length===50,`Expected 50 batch packages; found ${items.length}.`);
assert(mcq.length===30,`Expected 30 MCQs; found ${mcq.length}.`);
assert(frq.length===20,`Expected 20 FRQs; found ${frq.length}.`);
assert(new Set(items.map(x=>x.package_id)).size===50,"Package IDs are not unique.");

for (const item of items) {
  assert(item.schema_version==="1.0.0",`${item.package_id}: wrong schema version.`);
  assert(item.package_id===item.content_key,`${item.package_id}: content key mismatch.`);
  assert(item.exam_pack_ref?.exam_code==="ap_precalculus",`${item.package_id}: wrong exam code.`);
  assert(item.exam_pack_ref?.school_year==="2026-27",`${item.package_id}: wrong school year.`);
  assert(item.taxonomy_refs?.length===3,`${item.package_id}: expected unit, topic, and practice taxonomy refs.`);
  assert(item.parts?.length>0,`${item.package_id}: no parts.`);
  assert(item.review_notes?.originality_statement?.includes("no released, secure"),`${item.package_id}: missing originality statement.`);
  assert(item.review_notes?.teaching_explanation,`${item.package_id}: missing teaching explanation.`);
  assert(item.review_notes?.minimum_fix,`${item.package_id}: missing minimum fix.`);
  assert(item.review_notes?.transfer_candidate,`${item.package_id}: missing transfer candidate.`);
  assert(item.review_notes?.delayed_retrieval_candidate,`${item.package_id}: missing delayed-retrieval candidate.`);
  const copy=structuredClone(item); const stored=copy.provenance?.content_sha256; delete copy.provenance.content_sha256;
  assert(stored===sha(JSON.stringify(copy)),`${item.package_id}: content hash mismatch.`);
}

const unitOf = item => item.taxonomy_refs[0].node_key.match(/^unit-(\d)/)?.[1];
const topicOf = item => item.taxonomy_refs[1].node_key.replace("topic-","");
const practiceOf = item => item.taxonomy_refs[2].node_key.match(/^practice-(\d)/)?.[1];
const countBy = (array,fn,keys) => Object.fromEntries(keys.map(key=>[key,array.filter(x=>fn(x)===key).length]));
const mcqUnits=countBy(mcq,unitOf,["1","2","3","4"]);
const mcqModes=countBy(mcq,x=>x.stimuli[0].payload.calculator_mode,["calculator","no-calculator"]);
const mcqPractices=countBy(mcq,practiceOf,["1","2","3"]);
assert(JSON.stringify(mcqUnits)===JSON.stringify({"1":11,"2":9,"3":10,"4":0}),`MCQ unit distribution mismatch: ${JSON.stringify(mcqUnits)}.`);
assert(mcqModes.calculator===9&&mcqModes["no-calculator"]===21,`MCQ calculator split mismatch: ${JSON.stringify(mcqModes)}.`);
assert(mcqPractices["1"]>=11&&mcqPractices["1"]<=15,`Practice 1 should be 35–50%; found ${mcqPractices["1"]}/30.`);
assert(mcqPractices["2"]>=6&&mcqPractices["2"]<=9,`Practice 2 should be 20–30%; found ${mcqPractices["2"]}/30.`);
assert(mcqPractices["3"]>=9&&mcqPractices["3"]<=12,`Practice 3 should be 30–40%; found ${mcqPractices["3"]}/30.`);
const difficulties=["Easy","Medium","Hard","Very Hard"];
const mcqDifficulty=countBy(mcq,x=>x.difficulty,difficulties);
const frqDifficulty=countBy(frq,x=>x.difficulty,difficulties);
assert(JSON.stringify(mcqDifficulty)===JSON.stringify({"Easy":6,"Medium":9,"Hard":9,"Very Hard":6}),`MCQ difficulty distribution mismatch: ${JSON.stringify(mcqDifficulty)}.`);
assert(JSON.stringify(frqDifficulty)===JSON.stringify({"Easy":4,"Medium":6,"Hard":6,"Very Hard":4}),`FRQ difficulty distribution mismatch: ${JSON.stringify(frqDifficulty)}.`);
for (const unit of ["1","2","3"]) {
  const bands=new Set(items.filter(item=>unitOf(item)===unit).map(item=>item.difficulty));
  assert(bands.size===4,`Unit ${unit}: expected all four difficulty bands; found ${[...bands].join(", ")}.`);
}
const topicMax={"1":14,"2":15,"3":15};
for (const item of items) {
  const match=topicOf(item).match(/^(\d)\.(\d+)$/);
  assert(match&&match[1]===unitOf(item)&&Number(match[2])>=1&&Number(match[2])<=topicMax[match[1]],`${item.package_id}: invalid assessed topic ${topicOf(item)}.`);
}

const keyCounts=countBy(mcq,x=>x.canonical_answers[0],["A","B","C","D"]);
assert(Math.max(...Object.values(keyCounts))-Math.min(...Object.values(keyCounts))<=1,`MCQ key imbalance: ${JSON.stringify(keyCounts)}.`);
for (const item of mcq) {
  assert(item.mcq_choices?.length===4,`${item.package_id}: expected four choices.`);
  assert(new Set(item.mcq_choices.map(x=>x.choice_text)).size===4,`${item.package_id}: duplicate choice text.`);
  assert(item.mcq_choices.filter(x=>x.is_correct).length===1,`${item.package_id}: expected exactly one correct choice.`);
  const correct=item.mcq_choices.find(x=>x.is_correct);
  assert(correct.choice_key===item.canonical_answers[0],`${item.package_id}: key does not match correct choice.`);
  assert(item.mcq_choices.every(x=>x.rationale.length>=24),`${item.package_id}: rationale too short.`);
  const lens=item.mcq_choices.map(x=>x.choice_text.replace(/\s+/g,"").length);
  const correctIndex="ABCD".indexOf(item.canonical_answers[0]);
  const distractorMean=lens.filter((_,index)=>index!==correctIndex).reduce((a,b)=>a+b,0)/3;
  const ratio=lens[correctIndex]/distractorMean;
  const correctWordCount=item.mcq_choices[correctIndex].choice_text.trim().split(/\s+/).length;
  if (correctWordCount>=5&&ratio>=1.5) warnings.push(`${item.package_id}: prose correct answer length is ${ratio.toFixed(2)}× the distractor mean.`);
}

const taskOf = item => item.archetype_ref.archetype_key.replace("ap-precalculus-frq-","");
const taskCounts=countBy(frq,taskOf,["function-concepts","modeling-nonperiodic","modeling-periodic","symbolic-manipulations"]);
assert(Object.values(taskCounts).every(n=>n===5),`FRQ task distribution mismatch: ${JSON.stringify(taskCounts)}.`);
for (const item of frq) {
  const task=taskOf(item), unit=unitOf(item), mode=item.stimuli[0].payload.calculator_mode;
  assert(item.parts.length===3,`${item.package_id}: expected three parts.`);
  assert(item.parts.reduce((sum,p)=>sum+p.points,0)===6,`${item.package_id}: expected six total points.`);
  assert(item.scoring_contract?.total_points===6&&item.scoring_contract?.part_count===3&&item.scoring_contract?.points_per_part===2,`${item.package_id}: invalid scoring contract.`);
  for (const part of item.parts) {
    assert(part.points===2&&part.criteria.length===2,`${item.package_id} ${part.label}: expected two one-point criteria.`);
    assert(part.criteria.every(c=>c.points===1),`${item.package_id} ${part.label}: criterion is not one point.`);
    assert(part.criteria.every(c=>c.required_evidence?.length&&c.accepted_variants?.length&&c.insufficient_responses?.length&&c.contradictions?.length&&c.minimum_fix),`${item.package_id} ${part.label}: incomplete criterion boundary contract.`);
  }
  if (task==="function-concepts"||task==="modeling-nonperiodic") {
    assert(["1","2"].includes(unit),`${item.package_id}: task permits Units 1–2 only.`);
    assert(mode==="calculator",`${item.package_id}: task requires calculator.`);
  } else if (task==="modeling-periodic") {
    assert(unit==="3",`${item.package_id}: periodic task requires Unit 3.`);
    assert(mode==="no-calculator",`${item.package_id}: periodic task is no-calculator.`);
  } else {
    assert(["2","3"].includes(unit),`${item.package_id}: symbolic task permits Units 2–3 only.`);
    assert(mode==="no-calculator",`${item.package_id}: symbolic task is no-calculator.`);
  }
}

for (const item of items) {
  const assessedText=[...item.parts.map(p=>p.prompt),...(item.stimuli||[]).map(s=>s.payload?.text||"")].join(" ");
  assert(!/[∫]|dy\/dx|d\/dx|f[′']|\bderivative\b|\bdifferentiation\b/i.test(assessedText),`${item.package_id}: calculus notation or derivative language is outside AP Precalculus scope.`);
}

const normalized=items.map(item=>({id:item.package_id,text:[...(item.stimuli||[]).map(s=>s.payload?.text||""),...item.parts.map(p=>p.prompt)].join(" ").toLowerCase().replace(/[^a-z0-9 ]/g," ").replace(/\s+/g," ").trim()}));
for (let i=0;i<normalized.length;i++) for (let j=i+1;j<normalized.length;j++) {
  const a=new Set(normalized[i].text.split(" ")), b=new Set(normalized[j].text.split(" "));
  const overlap=[...a].filter(x=>b.has(x)).length/[...new Set([...a,...b])].length;
  if (overlap>0.72) warnings.push(`Possible prompt similarity ${normalized[i].id}/${normalized[j].id}: ${overlap.toFixed(2)}.`);
}

const cedHash=sha(await readFile(CED));
assert(cedHash==="5ef13ad6e4b39455330257e94d1b4750a833ef6e05ccf2f4a24141912345f04f","Local CED hash does not match the verified Drive source.");
const report={status:errors.length?"FAIL":"PASS",generated_at:"2026-07-28T00:00:00Z",ced_sha256:cedHash,counts:{packages:items.length,mcq:mcq.length,frq:frq.length},mcq:{units:mcqUnits,difficulty:mcqDifficulty,calculator_modes:mcqModes,practices:mcqPractices,answer_keys:keyCounts},frq:{task_models:taskCounts,difficulty:frqDifficulty},errors,warnings};
await writeFile(REPORT,`${JSON.stringify(report,null,2)}\n`);
console.log(JSON.stringify(report,null,2));
if (errors.length) process.exit(1);
