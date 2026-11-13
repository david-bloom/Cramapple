import json,sys,re
# usage: build.py N  -> reads uN.txt, writes proposed_uN.json
F={'c':'core_idea','w':'what_students_need_to_understand','h':'how_this_becomes_points','a':'point_attaining_answer'}
n=sys.argv[1]; out={}; cur=None
for line in open(f'u{n}.txt').read().split('\n'):
    m=re.match(r'^@@ (\S+) ([cwha])$',line)
    if m: cur=(m.group(1),F[m.group(2)]); out.setdefault(cur[0],{})[cur[1]]=[]; continue
    if cur: out[cur[0]][cur[1]].append(line)
for k in out:
    for f in out[k]: out[k][f]='\n'.join(out[k][f]).strip('\n')
json.dump(out,open(f'proposed_u{n}.json','w'),indent=1,ensure_ascii=False)
