#!/usr/bin/env python3
"""Blind-solve every item in a package's items.json with two non-Claude models and report disagreements with the key.
Usage: python3 blind_solve.py <items.json> "<subject>" [workers]   (needs AI_GATEWAY_API_KEY or scripts/vercel-gateway-check/.env.local)"""
import json,re,sys,urllib.request,concurrent.futures as cf,time,os,subprocess
MODELS=["deepseek/deepseek-v4-pro","moonshotai/kimi-k3.1-pro"]
ROOT=os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)),"..","..",".."))
def key():
    k=os.environ.get("AI_GATEWAY_API_KEY")
    if k: return k
    p=os.path.join(ROOT,"scripts","vercel-gateway-check",".env.local")
    if not os.path.exists(p): p=os.path.join(subprocess.check_output(["git","-C",ROOT,"rev-parse","--git-common-dir"],text=True).strip(),"..","scripts","vercel-gateway-check",".env.local")
    for l in open(p):
        m=re.match(r'\s*AI_GATEWAY_API_KEY\s*=\s*"?([^"\s]+)',l)
        if m: return m.group(1)
    sys.exit("no key")
def main():
    rows=json.load(open(sys.argv[1])); subj=sys.argv[2]; workers=int(sys.argv[3]) if len(sys.argv)>3 else 16; K=key()
    def prompt(r):
        ch="\n".join(f"{c['label']}. {c['text']}" for c in r["choices"])
        return (f"You are an expert {subj} teacher solving a multiple-choice question independently. Work it out carefully (compute numbers exactly, check every choice), then reply with ONLY a JSON object: "
                '{"answer":"<A|B|C|D>","work":"<one or two sentences>"}\n\n'+r["stem"]+"\n\n"+ch)
    def call(a):
        model,r=a; body=json.dumps({"model":model,"messages":[{"role":"user","content":prompt(r)}],"max_tokens":8000}).encode(); err=""
        for _ in range(3):
            try:
                req=urllib.request.Request("https://ai-gateway.vercel.sh/v1/chat/completions",data=body,headers={"Authorization":"Bearer "+K,"Content-Type":"application/json"})
                t=json.load(urllib.request.urlopen(req,timeout=240))["choices"][0]["message"]["content"] or ""
                m=re.search(r'"answer"\s*:\s*"([A-D])"',t)
                if m: return m.group(1),t[-250:]
            except Exception as e: err=str(e)[:100]; time.sleep(3)
        return None,"ERR "+err
    jobs=[(m,r) for m in MODELS for r in rows]
    with cf.ThreadPoolExecutor(workers) as ex: out=list(ex.map(call,jobs))
    bad=0
    for m in MODELS:
        res=[o for (mm,_),o in zip(jobs,out) if mm==m]; ok=sum(1 for o,r in zip(res,rows) if o[0]==r["key"]); print(m,"agree",ok,"of",len(rows)); 
    for (m,r),o in zip(jobs,out):
        if o[0]!=r["key"]: bad+=1; print("DISAGREE",m,r["content_key"],"model",o[0],"key",r["key"],o[1][-160:].replace("\n"," "))
    return 1 if bad else 0
if __name__=="__main__": sys.exit(main())
