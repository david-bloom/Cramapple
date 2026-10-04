"""Strip the duplicated A-D list from unchanged seeds; write stripped_items.json, strip_diff.txt, strip_check_items.json, strip_check_blind.json."""
import json,re,hashlib,difflib
S={c['key']:c for c in json.load(open('seeds_all.json'))['candidate_seeds']}
R=json.load(open('repaired_items.json'))
RX=r'\n\s*A[\.\)]\s[\s\S]*$'
OUT={};AUD=[];BL=[];D=[]
for k,s in S.items():
    if s['label_status']=='held' or k in R or not re.search(r'\n\s*A[\.\)]\s',s['stem']): continue
    new=re.sub(RX,'',s['stem']).rstrip()
    tail=s['stem'][len(new):].strip()
    assert tail=="\n".join(f"{c['choice_key']}. {c['choice_text']}" for c in s['choices']),(k,tail)
    assert len(new)>=12 and not new.endswith('\n')
    OUT[k]=dict(keyed=s['keyed_label'],old_md5=hashlib.md5(s['stem'].encode()).hexdigest(),stem=new)
    D.append(f"== {k}\n"+"\n".join(difflib.unified_diff(s['stem'].split('\n'),new.split('\n'),'old','new',lineterm='',n=0)))
    AUD.append(dict(key=k,kind='mcq',stem=new,choices=[dict(label=c['choice_key'],text=c['choice_text']) for c in s['choices']],keyed_label=s['keyed_label'],rationales={c['choice_key']:c['rationale'] for c in s['choices']}))
    BL.append(dict(content_key=k,item_type='mcq',body=new+"\n\nChoices:\n"+"\n".join(f"{c['choice_key']}. {c['choice_text']}" for c in s['choices'])))
json.dump(OUT,open('stripped_items.json','w'),indent=1,ensure_ascii=False)
json.dump(AUD,open('strip_check_items.json','w'),indent=1,ensure_ascii=False)
json.dump(BL,open('strip_check_blind.json','w'),indent=1,ensure_ascii=False)
open('strip_diff.txt','w').write("\n".join(D)+"\n")
print(len(OUT),sorted(k[12:] for k in OUT)); print(open('strip_diff.txt').read())
