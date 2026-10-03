import json
P='APSTATS-MCQ-'
M=json.load(open('math_items.json')); man=json.load(open('variants_manifest.json'))
drop={P+x for x in "057-v1 057-v3 009-v1 009-v2 009-v3 059-v1 059-v2 059-v3 066-v1 066-v2 066-v3 080-v2".split()}
drop={'u13-'+d for d in drop}
rat={ # (id, choice-text startswith) -> new rationale
('001-v3','Report either one'):"Here they differ by $85,000, and a mean well above the median indicates right skew; the two are close mainly when the distribution is roughly symmetric.",
('048-v2','0.95'):"This treats the problem as finding the chance of passing at least one exam with an addition-rule calculation. The question asks for passing both, which uses the multiplication rule: 0.80 × 0.75 = 0.60.",
('063-v1','0.05'):"0.05 is the significance level (the Type I error rate α), not the power. Power is the probability of rejecting H0 when p = 0.6, which is 1 − 0.32 = 0.68.",
('074-v2','P(passed | studied)P(passed)'):"This multiplies by P(passed) rather than dividing by it, so it does not equal P(studied | passed).",
('024-v2','The 15th ordered score alone'):"Using only the 15th value would be right only if the middle position (n + 1)/2 were exactly 15, which needs n = 29. With 30 values the median averages the 15th and 16th.",
('041-v1','The year'):"A year with no link to either swimming or ice cream sales does not influence both quantities, so it cannot explain the association and is not a confounder.",
('049-v3','$40'):"This is the expected claim cost, 2,000(0.02) = $40, not the expected profit. Profit also includes the $60 premium: 60 − 40 = $20.",
('021-v3','It increases by 4.5'):"Averaging 25 with 34 treats the new value as if it were half of the data. The old mean of 25 summarizes eight values and only one of them changed: the sum rises by 24, so the mean rises by 24/8 = 3.",
('046-v3','90/200'):"90/200 = 0.45 is the marginal probability of buying online. The question asks what fraction of online buyers are under 30, so the numerator must be the 50 under-30 online buyers, not all 90 buyers.",
('047-v3','Yes, because the 45 orders'):"A joint count is smaller than each single count for almost any two events, so this says nothing about independence; independence compares the joint probability with the product of the individual probabilities.",
}
def sub(s,pairs):
    for a,b in pairs: s=s.replace(a,b)
    return s
rep={'011-v1':[('(0.28, 0.36)','(0.29, 0.35)'),('0.28 to 0.36','0.29 to 0.35'),('28% and 36%','29% and 35%'),('0.28 and 0.36','0.29 and 0.35'),('4 percentage points','3 percentage points')],
 '011-v2':[('(0.52, 0.60)','(0.53, 0.59)'),('0.52 to 0.60','0.53 to 0.59')],
 '011-v3':[('(0.71, 0.79)','(0.72, 0.78)'),('0.71 and 0.79','0.72 and 0.78'),('0.71 to 0.79','0.72 to 0.78')],
 '061-v3':[('What is the standard error of the sample proportion of defective widgets?','What is the standard deviation of the sampling distribution of the sample proportion of defective widgets?')]}
n=0
for m in M:
    k=m['key'];s=k[4+len(P):] if False else k[len('u13-'+P):]
    for (i,pre),new in rat.items():
        if s==i:
            for c in m['choices']:
                if c['text'].startswith(pre): m['rationales'][c['label']]=new; n+=1
    if s in rep:
        m['stem']=sub(m['stem'],rep[s])
        for c in m['choices']: c['text']=sub(c['text'],rep[s])
        m['rationales']={l:sub(t,rep[s]) for l,t in m['rationales'].items()}; n+=1
print('patched',n)
M=[m for m in M if m['key'] not in drop]; man=[x for x in man if x['key'] not in drop]
json.dump(M,open('math_items.json','w'),indent=1,ensure_ascii=False); json.dump(man,open('variants_manifest.json','w'),indent=1,ensure_ascii=False)
json.dump(sorted(drop),open('dropped_variants.json','w'))
print(len(M),len(man))
