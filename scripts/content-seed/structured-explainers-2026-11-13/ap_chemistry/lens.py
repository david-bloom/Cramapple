import json,sys
CAPS={"core_idea":360,"what_students_need_to_understand":360,"how_this_becomes_points":320,"point_attaining_answer":520}
d=json.load(open(f'proposed_u{sys.argv[1]}.json'))
for k,v in d.items():
    for f,c in CAPS.items():
        if len(v[f])>c: print(k,f,len(v[f]),'over by',len(v[f])-c)
