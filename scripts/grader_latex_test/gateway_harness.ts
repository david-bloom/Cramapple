// TEMPORARY Dev-only harness for TASK-0074. Delete after the run.
// Builds the production criterion-grader request (prompt text, schema and body copied verbatim from
// supabase/functions/_shared/grading-contract.ts) and makes exactly ONE OpenAI call per request, no retry.
// Reads no database, writes nothing. Returns only the model output, usage and timing.
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const criterionGradingSchema = {
  type: "object",
  additionalProperties: false,
  properties: {
    criterion_key: { type: "string" },
    status: { type: "string", enum: ["earned", "partially_earned", "not_yet_earned", "unable_to_determine", "not_applicable"] },
    points_awarded: { type: "integer" },
    evidence_quote: { type: ["string", "null"] },
    decision_explanation: { type: ["string", "null"] },
    minimum_fix: { type: ["string", "null"] },
    confidence: { type: "string", enum: ["high", "medium", "low"] },
  },
  required: ["criterion_key", "status", "points_awarded", "evidence_quote", "decision_explanation", "minimum_fix", "confidence"],
} as const;

function buildCriterionSystemPrompt(examName: string) {
  return [
    `You are Cramapple's production criterion-based grader for ${examName}.`,
    "You are grading exactly ONE criterion of a free-response question.",
    "Use only the provided released content, rubric, and student response.",
    "Do not invent evidence.",
    "Judge only the criterion given below. Do not withhold its points because of a fault that belongs to a different criterion.",
    "A criterion worth more than one point may be awarded part of its points: use partially_earned with the number of points genuinely evidenced.",
    "Use earned only for the criterion's full points, and not_yet_earned only when nothing creditable is present.",
    "Error carry forward: when this criterion uses a value the student computed incorrectly earlier, judge the method and reasoning shown here and do not withhold points solely because that inherited value is wrong.",
    "When the response is ambiguous or unsupported, mark the criterion unable_to_determine rather than guessing.",
    "evidence_quote must be an exact substring of the student response, or null.",
    "Return only the JSON object that matches the schema.",
  ].join(" ");
}

type Row = { criterion_key: string; learner_facing_text: string; points_possible: number; evidence_requirements: string | null; minimum_fix: string | null; accepted_variants: unknown };

function buildCriterionGradingPrompt(input: { operation: string; promptVersion: string; examName: string; itemTitle: string; itemType: string; stem: string; stimulus: string | null; responseText: string | null; responseParts: unknown; criteria: Row[]; criterion: Row }) {
  const criterion = input.criterion;
  const siblings = input.criteria
    .filter((row) => row.criterion_key !== criterion.criterion_key)
    .map((row) => `- ${row.criterion_key} (${row.points_possible} pt): ${row.learner_facing_text}`);
  const contract = [
    `  criterion_key: ${criterion.criterion_key}`,
    `  points_possible: ${criterion.points_possible}`,
    `  learner_facing_text: ${criterion.learner_facing_text}`,
  ];
  if (criterion.evidence_requirements) contract.push(`  evidence_requirements: ${criterion.evidence_requirements}`);
  if (criterion.minimum_fix) contract.push(`  minimum_fix (rubric-authored): ${criterion.minimum_fix}`);
  if (criterion.accepted_variants) contract.push(`  accepted_variants: ${JSON.stringify(criterion.accepted_variants)}`);
  if (criterion.points_possible > 1) contract.push(`  award: any whole number of points from 0 to ${criterion.points_possible}; use partially_earned for anything in between`);
  return [
    `You are Cramapple's production grader for ${input.examName}.`,
    `Use only the released content and criterion contract provided below.`,
    `Do not invent facts, claims, or criteria that are not present in the contract.`,
    `points_awarded must match the status: equal to points_possible for earned, strictly between 0 and points_possible for partially_earned, and 0 otherwise.`,
    `The operation is ${input.operation}.`,
    `Prompt version: ${input.promptVersion}.`,
    `Item title: ${input.itemTitle}.`,
    `Item type: ${input.itemType}.`,
    `Stem: ${input.stem}`,
    input.stimulus ? `Stimulus: ${input.stimulus}` : "Stimulus: none",
    `Criterion contract (grade THIS criterion only):`,
    contract.join("\n"),
    siblings.length > 0
      ? [
        `The other criteria on this item, for context only — do NOT grade them and do NOT report on them:`,
        siblings.join("\n"),
        `Use them only to judge whether the response's treatment of YOUR criterion is complete, rather than assuming any relevant statement it makes was aimed at your criterion.`,
      ].join("\n")
      : `This item has no other criteria.`,
    `Student response text:`,
    input.responseText ?? "",
    `Student response parts JSON:`,
    JSON.stringify(input.responseParts ?? {}, null, 2),
    `Return JSON matching the schema exactly, with criterion_key set to ${criterion.criterion_key}.`,
  ].filter(Boolean).join("\n\n");
}

function supportsReasoningEffort(modelId: string) {
  const m = modelId.toLowerCase().replace(/^openai\//, "");
  return /^(o\d|gpt-5)/.test(m);
}

function buildCriterionRequestBody(input: { modelId: string; maxOutputTokens: number; systemPrompt: string; userPrompt: string; userIdHash: string }) {
  const reasoning = supportsReasoningEffort(input.modelId) ? { reasoning: { effort: "high" } } : {};
  return {
    model: input.modelId,
    input: [
      { role: "system", content: [{ type: "input_text", text: input.systemPrompt }] },
      { role: "user", content: [{ type: "input_text", text: input.userPrompt }] },
    ],
    store: false,
    ...reasoning,
    max_output_tokens: input.maxOutputTokens,
    text: { format: { type: "json_schema", name: "criterion_grading_result", strict: true, schema: criterionGradingSchema } },
    user: input.userIdHash.slice(0, 64),
  };
}

function extractOutputText(raw: Record<string, unknown>) {
  const direct = raw.output_text;
  if (typeof direct === "string" && direct.length > 0) return direct;
  const output = raw.output;
  if (Array.isArray(output)) {
    for (const item of output) {
      if (!item || typeof item !== "object") continue;
      const content = (item as Record<string, unknown>).content;
      if (!Array.isArray(content)) continue;
      for (const piece of content) {
        if (!piece || typeof piece !== "object") continue;
        const text = (piece as Record<string, unknown>).text;
        if (typeof text === "string" && text.length > 0) return text;
      }
    }
  }
  return null;
}

const json = (body: unknown, status = 200) => new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });


import fixtures from "./fixtures.json" with { type: "json" };
const QA_USER_ID = "__QA_USER_ID__";
const MODEL = "openai/gpt-5.4-mini";
const trials: Array<{rep:number;item:string;response:'correct'|'wrong'|'vague';form:'plain'|'latex'}> = [];
for (let rep=1; rep<=3; rep++) for (const item of fixtures.items)
  for (const response of ["correct","wrong","vague"] as const) for (const form of ["plain","latex"] as const)
    trials.push({rep,item:item.id,response,form});
Deno.serve(async (req: Request) => {
  if (req.method !== "POST") return json({error:"POST only"},405);
  const authorization=req.headers.get("Authorization") ?? "";
  const identity=await fetch(Deno.env.get("SUPABASE_URL")+"/auth/v1/user",{
    headers:{Authorization:authorization,apikey:Deno.env.get("SUPABASE_ANON_KEY")??""}
  });
  const user=await identity.json().catch(()=>null);
  if(!identity.ok || user?.id!==QA_USER_ID) return json({error:"qa_account_required"},403);
  const body=await req.json().catch(()=>null);
  const key=Deno.env.get("AI_GATEWAY_API_KEY");
  if(body?.ping) return json({ok:true,has_gateway_key:Boolean(key),model:MODEL,max_output_tokens:3000,reasoning_effort:"high"});
  if(!key) return json({error:"missing_gateway_key"},500);
  if(!Number.isInteger(body?.trialIndex)||body.trialIndex<0||body.trialIndex>=trials.length)
    return json({error:"invalid_trial"},400);
  const trial=trials[body.trialIndex];
  const item=fixtures.items.find(i=>i.id===trial.item)!;
  const criteria=item.criteria[trial.form as "plain"|"latex"].map(c=>({...c,
    evidence_requirements:null,minimum_fix:null,accepted_variants:null}));
  const criterion=criteria.find(c=>c.criterion_key===item.target)!;
  const promptVersion="v1.0.0";
  const userPrompt=buildCriterionGradingPrompt({
    operation:"grade_initial_attempt",promptVersion,examName:fixtures.exam_name,itemTitle:item.title,
    itemType:"frq",stem:item.stem,stimulus:null,responseText:item.responses[trial.response as "correct"|"wrong"|"vague"],
    responseParts:{},criteria,criterion
  });
  const requestBody={
    ...buildCriterionRequestBody({modelId:MODEL,maxOutputTokens:3000,
      systemPrompt:buildCriterionSystemPrompt(fixtures.exam_name),userPrompt,userIdHash:"tmp-latex-grader-test"}),
    providerOptions:{gateway:{only:["openai"],order:["openai"]}}
  };
  const started=Date.now();
  let response:Response;
  try{
    response=await fetch("https://ai-gateway.vercel.sh/v1/responses",{
      method:"POST",headers:{Authorization:"Bearer "+key,"Content-Type":"application/json"},
      body:JSON.stringify(requestBody),signal:AbortSignal.timeout(110000)
    });
  }catch{return json({error:"gateway_fetch_failed",elapsed_ms:Date.now()-started},502)}
  const raw=await response.json().catch(()=>null);
  if(!response.ok) return json({error:"gateway_http_"+response.status,
    message:raw?.error?.message??null,elapsed_ms:Date.now()-started},502);
  const text=extractOutputText(raw??{});
  let parsed=null;
  try{parsed=text?JSON.parse(text):null}catch{}
  return json({ok:Boolean(parsed),model:MODEL,returned_model:raw?.model??null,
    response_status:raw?.status??null,generation_id:raw?.id??null,elapsed_ms:Date.now()-started,
    parsed,raw_text:text,usage:raw?.usage??null,user_prompt:userPrompt});
});
