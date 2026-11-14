import json, os, collections
HERE = os.path.dirname(os.path.abspath(__file__))
d = json.load(open(os.path.join(HERE, 'gap_items_u6plus.json'))); I = [i for i in d['items'] if i['f']['vstatus'] == 'published']
def miss(i):
    f = i['f']; m = []
    if not f['topic_validated']: m.append('topic')
    if f['serving'] != 'ok': m.append('serving')
    if not f['difficulty']: m.append('difficulty')
    if not f['skill_validated']: m.append('skill')
    return m
print('%-24s %2s %4s %5s | %4s %4s %5s %4s | anyCore' % ('subject','u','mcq','frq','topic','serv','diff','skill'))
tot = collections.Counter()
for sub in sorted(d['scope_units']):
    for u in d['scope_units'][sub]:
        it = [i for i in I if i['subject']==sub and i['f']['unit']==u and i['in_scope']]
        c = collections.Counter()
        for i in it:
            m = miss(i)
            for k in m: c[k]+=1
            if set(m)&{'topic','serving','difficulty'}: c['core']+=1
        print('%-24s %2d %4d %5d | %4d %4d %5d %4d | %d' % (sub,u,sum(i['item_type']=='mcq' for i in it),sum(i['item_type']=='frq' for i in it),c['topic'],c['serving'],c['difficulty'],c['skill'],c['core']))
        tot.update(c); tot['items']+=len(it)
print(dict(tot))
