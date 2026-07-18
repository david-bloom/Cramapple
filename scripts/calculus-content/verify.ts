import { compilePlan, canonicalJson, sha256 } from "../subject-harness/compiler.ts";
import { validateContract } from "../subject-harness/validate-contracts.ts";

const subjectKeys = ["ap-calculus-ab", "ap-calculus-bc", "ap-precalculus"];
const registry = JSON.parse(await Deno.readTextFile("schemas/subject-onboarding/platform-capabilities.v1.json"));
const globalKeys = new Set<string>();
const promptIndex: Array<{ key: string; text: string }> = [];
const results: unknown[] = [];

const words = (text: string) => new Set(text.toLowerCase().replaceAll(/[^a-z0-9]+/g, " ").split(/\s+/).filter((word) => word.length >= 4));
const similarity = (a: string, b: string) => {
  const aw = words(a), bw = words(b);
  const intersection = [...aw].filter((word) => bw.has(word)).length;
  const union = new Set([...aw, ...bw]).size;
  return union === 0 ? 0 : intersection / union;
};

for (const subjectKey of subjectKeys) {
  const subjectPath = `content/subject-packages/${subjectKey}.subject-package.json`;
  const subject = JSON.parse(await Deno.readTextFile(subjectPath));
  const subjectValidation = await validateContract("subject-package", subject);
  if (!subjectValidation.valid) throw new Error(`${subjectPath}: ${subjectValidation.errors.join("; ")}`);

  const dir = `content/item-packages/${subjectKey}`;
  const files: string[] = [];
  for await (const entry of Deno.readDir(dir)) if (entry.isFile && entry.name.endsWith(".json")) files.push(entry.name);
  files.sort();
  const items = [];
  for (const file of files) {
    const path = `${dir}/${file}`;
    const item = JSON.parse(await Deno.readTextFile(path));
    const validation = await validateContract("item-package", item);
    if (!validation.valid) throw new Error(`${path}: ${validation.errors.join("; ")}`);
    items.push(item);
  }

  const mcq = items.filter((item) => item.item_type === "mcq");
  const frq = items.filter((item) => item.item_type === "frq");
  if (mcq.length !== 20 || frq.length !== 16) throw new Error(`${subjectKey}: expected 20 MCQ and 16 FRQ, got ${mcq.length}/${frq.length}`);

  for (const item of items) {
    if (globalKeys.has(item.content_key)) throw new Error(`duplicate content_key ${item.content_key}`);
    globalKeys.add(item.content_key);
    const copy = structuredClone(item);
    delete copy.provenance.content_sha256;
    const actualHash = await sha256(canonicalJson(copy));
    if (actualHash !== item.provenance.content_sha256) throw new Error(`${item.content_key}: content hash mismatch`);
    const combinedPrompt = item.parts.map((part: any) => part.prompt).join(" ");
    if (/college board|released question|official scoring/i.test(combinedPrompt)) throw new Error(`${item.content_key}: prohibited source-language reference`);
    if (combinedPrompt.length < 25) throw new Error(`${item.content_key}: prompt too short`);
    promptIndex.push({ key: item.content_key, text: combinedPrompt });

    const unitRefs = item.taxonomy_refs.filter((ref: any) => ref.node_key.startsWith("unit-"));
    const practiceRefs = item.taxonomy_refs.filter((ref: any) => ref.node_key.startsWith("practice-"));
    if (unitRefs.length !== 1 || practiceRefs.length !== 1) throw new Error(`${item.content_key}: requires exactly one unit and one practice tag`);

    if (item.item_type === "mcq") {
      const correct = item.mcq_choices.filter((choice: any) => choice.is_correct);
      if (correct.length !== 1) throw new Error(`${item.content_key}: expected exactly one correct choice`);
      if (correct[0].choice_key !== item.canonical_answers[0]) throw new Error(`${item.content_key}: canonical key mismatch`);
      const checkKey = item.parts[0].criteria[0].deterministic_checks[0].parameters.correct_key;
      if (checkKey !== correct[0].choice_key) throw new Error(`${item.content_key}: deterministic key mismatch`);
      if (new Set(item.mcq_choices.map((choice: any) => choice.choice_text)).size !== 4) throw new Error(`${item.content_key}: duplicate choice text`);
    } else {
      const totalPoints = item.parts.reduce((sum: number, part: any) => sum + part.points, 0);
      const expectedPoints = subjectKey === "ap-precalculus" ? 6 : 3;
      if (totalPoints !== expectedPoints) throw new Error(`${item.content_key}: expected ${expectedPoints} rubric points, got ${totalPoints}`);
      for (const part of item.parts) {
        if (part.criteria.length === 0) throw new Error(`${item.content_key}/${part.part_key}: missing criteria`);
        for (const criterion of part.criteria) {
          if (criterion.required_evidence.length < 1) throw new Error(`${item.content_key}/${criterion.criterion_key}: missing evidence`);
          if (criterion.description.length < 8) throw new Error(`${item.content_key}/${criterion.criterion_key}: description too short`);
        }
      }
    }
  }

  const unitKeys = new Set(subject.taxonomy.nodes.filter((node: any) => node.node_type === "unit").map((node: any) => node.node_key));
  const unitCounts = Object.fromEntries([...unitKeys].map((key) => [key, items.filter((item) => item.taxonomy_refs.some((ref: any) => ref.node_key === key)).length]));
  if (Object.values(unitCounts).some((count) => count === 0)) throw new Error(`${subjectKey}: one or more units have no coverage`);
  const difficulty = Object.fromEntries(["Easy", "Medium", "Hard", "Very Hard"].map((level) => [level, items.filter((item) => item.difficulty === level).length]));
  if (Object.values(difficulty).some((count) => count < 2)) throw new Error(`${subjectKey}: each difficulty needs at least two items`);
  if (Math.max(...Object.values(difficulty)) > 18) throw new Error(`${subjectKey}: excessive difficulty concentration`);

  const plan = await compilePlan(subject, items, registry);
  results.push({ subject: subjectKey, mcq: mcq.length, frq: frq.length, unitCounts, difficulty, plan_sha256: plan.plan_sha256, advisories: plan.advisories });
}

for (let i = 0; i < promptIndex.length; i++) {
  for (let j = i + 1; j < promptIndex.length; j++) {
    if (words(promptIndex[i].text).size < 8 || words(promptIndex[j].text).size < 8) continue;
    const score = similarity(promptIndex[i].text, promptIndex[j].text);
    if (score >= 0.9) throw new Error(`near-duplicate prompts ${promptIndex[i].key}/${promptIndex[j].key}: ${score.toFixed(3)}`);
  }
}

console.log(JSON.stringify({ valid: true, totalContentKeys: globalKeys.size, subjects: results }, null, 2));
