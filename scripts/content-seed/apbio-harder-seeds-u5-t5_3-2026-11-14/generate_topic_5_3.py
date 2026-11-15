"""Author Biology 5.3 Mendelian genetics seed families."""
from pathlib import Path
import json

H=Path(__file__).resolve().parent
out=["# AP Biology Unit 5 topic 5.3 — Mendelian Genetics", "DRAFT. Author-in-session 2026-11-14. CED 5.3.A.1–2."]
def add(family,skill,cases):
    assert len(cases)==4
    for i,(stem,choices,check,wrong) in enumerate(cases):
        assert len(choices)==4 and len(wrong)==3
        ident=f'N-5.3-{family}'
        if i==0:out.extend(['---',f'## Seed {ident} (new) — Topic 5.3 Mendelian Genetics',f'**Skill:** {skill}','',stem,''])
        else:out.extend(['',f'**{ident}-v{i}.** {stem}',''])
        out.extend([f'- **A. {choices[0]}**',*[f'- {z}. {v}' for z,v in zip('BCD',choices[1:])],'',f'Check: {check}','Rationales: '+' '.join(f'{z}: {v}' for z,v in zip('BCD',wrong))])

add('A','condition genotype probability on a dominant phenotype at two unlinked loci',[
('Two genes A/a and B/b are on different chromosomes. In an AaBb × AaBb cross, an offspring has both dominant phenotypes (A_B_). What is the probability that this offspring is AaBb?',
 ['4/9; among the 9/16 offspring with both dominant phenotypes, 4/16 are AaBb.','1/4; the unconditional probability of AaBb is 1/4.','9/16; this is the probability of the observed phenotype, not the conditional genotype.','1/9; each dominant phenotype forces a homozygous dominant genotype.'],
 'Independent segregation gives P(AaBb)=1/2×1/2=1/4=4/16 and P(A_B_)=3/4×3/4=9/16. Conditioning yields (4/16)/(9/16)=4/9.',
 ['This ignores the information that the offspring is already known to have both dominant phenotypes.','This is the frequency of the conditioning phenotype rather than the requested genotype given that phenotype.','Dominant phenotypes include both homozygotes and heterozygotes; they do not force homozygosity.']),
('Genes A/a and B/b segregate independently. In an AaBb × Aabb cross, a randomly selected offspring has phenotype A_bb. What is the probability that the offspring genotype is Aabb?',
 ['2/3; among A_ offspring, two thirds are Aa, and bb is already specified.','1/2; half of all offspring are Aa before conditioning on the A_ phenotype.','1/4; this treats the A and B genotypes as two independent heterozygote probabilities after conditioning.','1/3; this counts the AA share among A_ offspring instead of the Aa share.'],
 'At A, Aa×Aa gives AA:Aa:aa=1:2:1, so P(Aa|A_)=2/3. At B, Bb×bb can yield bb, and the observed bb phenotype fixes that genotype. Thus P(Aabb|A_bb)=2/3.',
 ['The unconditional Aa frequency must be divided by the 3/4 chance of A_.','The given recessive b phenotype fixes bb, so another factor of 1/2 should not be applied.','Only one of the three dominant-A genotype parts is AA; two are Aa.']),
('Two independently assorting genes are crossed as AaBb × aaBb. An offspring has phenotype A_B_. What is the conditional probability that it is AaBb?',
 ['2/3; A_ forces Aa in this cross, while two of the three B_ genotype parts are Bb.','1/2; this uses the unconditional probability of Bb.','1/3; this selects BB rather than Bb among B_ offspring.','1/4; this multiplies two unconditional heterozygote probabilities.'],
 'At A, the aa parent contributes a, so an A_ offspring must be Aa. At B, Bb×Bb gives BB:Bb:bb=1:2:1, and P(Bb|B_)=2/3. Therefore P(AaBb|A_B_)=2/3.',
 ['B_ is known, so its Bb probability is 2/3 rather than the unconditional 1/2.','One third of B_ offspring are BB; the requested genotype has Bb.','Conditioning makes A_ deterministically Aa here, so an extra 1/2 factor is wrong.']),
('Two genes assort independently in an AaBb × AaBb cross. Among offspring that show both dominant phenotypes (A_B_), what fraction has genotype AABb?',
 ['2/9; P(AABb)=1/4×1/2=2/16 and P(A_B_)=9/16.','1/8; this is the unconditional chance of AABb.','4/9; this is the conditional chance of AaBb, a different genotype.','1/9; this assumes that both dominant phenotypes force AA and BB.'],
 'P(AABb)=P(AA)P(Bb)=1/4×1/2=1/8=2/16. The observed A_B_ phenotype occurs 9/16 of the time, so P(AABb|A_B_)=2/9.',
 ['The phenotype has been observed, so divide the unconditional genotype chance by 9/16.','AaBb has twice as many heterozygote possibilities as the requested AABb genotype.','A dominant phenotype does not uniquely identify a homozygous dominant genotype.'])])

cases=[]
for counts,total,chi,decision in [((30,20,27,23),100,'2.32','fail to reject'),((40,10,30,20),100,'20.0','reject'),((24,16,22,18),80,'2.00','fail to reject'),((36,4,30,10),80,'35.6','reject')]:
    exp=total//4
    direction='below' if decision=='fail to reject' else 'above'
    stem=f'A dihybrid testcross for two genes on different chromosomes predicts four equally frequent phenotypes. Observed counts are {", ".join(map(str,counts))} (total {total}). At α=0.05, the chi-square critical value with 3 degrees of freedom is 7.815. Which calculation and conclusion are justified?'
    opposite='reject' if decision=='fail to reject' else 'fail to reject'
    choices=[f'χ²={chi}, {direction} 7.815; {decision} the 1:1:1:1 null model.','χ²=7.815 by definition; the data prove that the genes assort independently.',f'χ²={chi}, {direction} 7.815; {opposite} the 1:1:1:1 null model.','The four observed counts must be exactly equal or Mendel’s segregation law is disproved.']
    check=f'Expected count per class is {total}/4={exp}. Sum (observed−{exp})²/{exp} over the four classes to get χ²={chi}. This is {direction} the given 3-df critical value 7.815, so {decision} the equal-classes null model; this test does not prove a particular biological cause.'
    wrong=['The critical value is a threshold, not a statistic computed from these observations; failure to reject cannot prove a model.', 'The numerical statistic is correct, but the decision direction is reversed relative to the critical value.', 'Sampling variation can create unequal observed counts even when the 1:1:1:1 model is true.']
    cases.append((stem,choices,check,wrong))
add('B','calculate chi-square and interpret a Mendelian testcross',cases)

cases=[]
for event,p,wrong1,wrong2 in [('exactly one affected','3/8','1/4','1/2'),('both affected','1/16','1/4','1/8'),('neither affected','9/16','3/4','1/2'),('at least one affected','7/16','1/4','3/8')]:
    stem=f'For a fully penetrant autosomal trait, two unaffected parents have an affected child. Assume no new mutation and independent outcomes for later births. What is the probability that, among their next two children, {event}? Explain the parents’ inferred genotypes.'
    choices=[f'{p}; both parents must be heterozygous carriers (Aa × Aa), so each birth has a 1/4 affected chance.',f'{wrong1}; only one birth needs to be considered despite the question asking about two.',f'{wrong2}; the affected child shows that one parent must be homozygous recessive.','0; two unaffected parents cannot have a child with a recessive trait.']
    check=f'Unaffected parents of an affected aa child must both carry a: Aa×Aa. Each later child independently has P(affected)=1/4 and P(unaffected)=3/4. For {event} among two children, the binomial/complement calculation gives {p}.'
    wrong=['This uses a one-child probability or drops one of the possible two-child orders.', 'The parents are unaffected, so neither can be aa under complete penetrance; both are Aa.', 'Recessive inheritance allows unaffected carriers to have affected offspring.']
    cases.append((stem,choices,check,wrong))
add('C','infer carrier parents and calculate a two-child pedigree probability',cases)

(H/'source_draft.md').write_text('\n\n'.join(out)+'\n')
json.dump({f'N-5.3-{k}':{'skill':v} for k,v in (('A','conditional two-locus genotype probability'),('B','testcross chi-square decision'),('C','pedigree two-child probability'))},open(H/'seed_map.json','w'),indent=2)
json.dump({'retire':[]},open(H/'retire_keys.json','w'),indent=2)
print('wrote 12 Mendelian genetics questions')
