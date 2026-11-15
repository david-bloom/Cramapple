"""Author Biology 5.4 non-Mendelian genetics seed families."""
from pathlib import Path
import json

H=Path(__file__).resolve().parent
out=["# AP Biology Unit 5 topic 5.4 — Non-Mendelian Genetics", "DRAFT. Author-in-session 2026-11-14. CED 5.4.A.1–4."]
def add(family,skill,cases):
    assert len(cases)==4
    for i,(stem,choices,check,wrong) in enumerate(cases):
        assert len(choices)==4 and len(wrong)==3
        ident=f'N-5.4-{family}'
        if i==0:out.extend(['---',f'## Seed {ident} (new) — Topic 5.4 Non-Mendelian Genetics',f'**Skill:** {skill}','',stem,''])
        else:out.extend(['',f'**{ident}-v{i}.** {stem}',''])
        out.extend([f'- **A. {choices[0]}**',*[f'- {z}. {v}' for z,v in zip('BCD',choices[1:])],'',f'Check: {check}','Rationales: '+' '.join(f'{z}: {v}' for z,v in zip('BCD',wrong))])

add('A','interpret linked-gene testcross data and recombination frequency',[
('A testcross of an AB/ab heterozygote yields 40 AB, 40 ab, 10 Ab, and 10 aB offspring. Which marker classes are recombinant, and what is the estimated map distance between A and B?',
 ['Ab and aB; (10+10)/100=20 map units.','AB and ab; (40+40)/100=80 map units.','Ab and aB; 10/100=10 map units because only one recombinant class counts.','All four classes; 100/100=100 map units.'],
 'The common parental arrangements are AB and ab. Recombinant classes are Ab and aB, totaling 20 of 100 offspring, so recombination frequency is 20% and estimated distance is 20 map units.',
 ['The frequent AB and ab classes are parental, not recombinant.','Both reciprocal recombinant classes contribute to the numerator.','Parental offspring are not counted as recombination products.']),
('In a testcross of CD/cd, counts are CD=70, cd=70, Cd=30, and cD=30. What is the recombination frequency, and which observation argues against independent assortment of these markers?',
 ['30%; the two parental classes total 140/200, substantially more than the 60/200 recombinant offspring.','70%; the parental classes are the recombinant categories.','50%; four phenotypic classes always imply independent assortment.','15%; only one of the two reciprocal recombinant classes should be counted.'],
 'The parental classes CD and cd are most frequent. Recombination frequency=(30+30)/200=30%. A 1:1:1:1 testcross would give 50% recombinant; here parental combinations predominate, consistent with linkage.',
 ['The 70% is the parental share, not the recombinant share.','Four classes can occur even for linked genes; their frequencies matter.','Both reciprocal recombinant classes must be included.']),
('Two linked genes are 10 map units apart. A testcross of EF/ef produces 400 offspring. If recombinant classes occur equally often and sampling matches expectation, how many Ef and eF offspring should be expected?',
 ['20 Ef and 20 eF; 10% of 400 is 40 recombinant offspring split evenly.','40 Ef and 40 eF; 10% applies separately to each class.','180 Ef and 180 eF; these are the parental class counts.','100 Ef and 100 eF; independent assortment is assumed despite the 10-map-unit distance.'],
 'Ten map units corresponds to 10% recombinant offspring: 0.10×400=40 total. The reciprocal recombinant classes Ef and eF are equal under the stated assumption, so each has 20.',
 ['This doubles the total recombinant fraction to 20%.','The common EF and ef parental classes together account for the other 360 offspring.','Independent assortment predicts 50% recombinants and conflicts with the stated 10-map-unit distance.']),
('A testcross of GH/gh yields 200 GH, 200 gh, 50 Gh, and 50 gH offspring. A student says the genes must assort independently because four classes appear. Which response uses the data correctly?',
 ['The recombinant share is 100/500=20%, corresponding to about 20 map units; the parental excess supports linkage.','The recombinant share is 400/500=80%, so the genes cannot be linked.','The four observed classes alone establish a 1:1:1:1 ratio and independent assortment.','Map distance is 50 units because there are 50 offspring in each rare class.'],
 'GH and gh are parental (400 total); Gh and gH are recombinant (100 total). Their fraction is 100/500=0.20, not the 0.50 expected for independently assorting markers in this testcross. Four classes do not imply equal frequencies.',
 ['This counts common parental classes as recombinants.','The class counts are 200:200:50:50, far from 1:1:1:1.','Map units reflect a percentage of total offspring, not the raw count in one class.'])])

add('B','distinguish codominance and incomplete dominance through crosses',[
('Pure-breeding red and white flowers produce uniformly pink F1 flowers. The F1 plants self-pollinate, and 200 F2 plants grow under identical conditions. Under a single-locus model, which pattern and mechanism predict the F2 phenotypes?',
 ['About 50 red, 100 pink, and 50 white; incomplete dominance makes the heterozygote intermediate.','About 150 red and 50 white; red is completely dominant.','About 50 red, 100 flowers showing distinct red and white patches, and 50 white; codominance is shown by pink blending.','About 100 red and 100 white; heterozygotes cannot occur in F2.'],
 'An intermediate pink F1 heterozygote indicates incomplete dominance. A heterozygote self-cross gives 1 RR:2 RW:1 WW, yielding 50 red:100 pink:50 white among 200 F2 plants.',
 ['Complete dominance would make F1 red, not pink.','Codominance expresses both parental phenotypes distinctly, rather than blending them into pink.','Selfing heterozygotes produces heterozygous F2 offspring.']),
('A fish has two alleles for a surface marker: M makes an M antigen and N makes an N antigen. MN fish show both antigens. Two MN fish mate. Which phenotype fraction and inheritance pattern are expected among offspring?',
 ['One half show both antigens; codominance gives MM:MN:NN=1:2:1.','Three quarters show only M antigen; M is completely dominant.','One half show an intermediate antigen rather than both; this is incomplete dominance.','All show both antigens because each parent expresses both.'],
 'Both parental antigens in MN demonstrate codominance. MN×MN yields MM, MN, MN, NN, so 2/4=1/2 display both antigens.',
 ['The heterozygote displays N as well, contradicting complete M dominance.','The stem says both distinct antigens are present, not one blended intermediate product.','Segregation creates MM and NN offspring as well as MN.']),
('In a plant, RR flowers are solid red, WW flowers are solid white, and RW flowers have separate red and white patches. If RW is crossed with WW, what offspring phenotypes and genetic explanation are expected?',
 ['Half patched and half white; the heterozygote separately expresses both alleles, showing codominance.','Half pink and half white; the two colors blend in the heterozygote, showing incomplete dominance.','All patched; the W allele cannot be inherited from two parents.','Three quarters patched and one quarter white; a heterozygote self-cross is being performed.'],
 'RW produces R and W gametes; WW produces only W. Offspring are half RW with both-color patches and half WW white. Distinct simultaneous expression is codominance.',
 ['Pink blending is not the observed RW phenotype.','Half the offspring receive W from both parents and are white.','RW×WW is a testcross-like cross, not RW×RW.']),
('An enzyme activity trait has one locus: HH individuals average 100 units, LL individuals 0 units, and HL individuals 50 units in the same environment. An HL individual is crossed with an LL individual. Which expectation and interpretation follow?',
 ['Half the offspring average 50 units and half 0 units; the heterozygote is intermediate, consistent with incomplete dominance.','All offspring average 50 units; all inherit H from the HL parent.','Half the offspring express separate 100-unit and 0-unit enzymes; the 50-unit measurement proves codominance.','Three quarters average 100 units and one quarter 0 units; H is completely dominant.'],
 'HL makes H and L gametes equally; LL makes L gametes. Offspring are half HL (50 units) and half LL (0 units). The intermediate heterozygote phenotype is the stated incomplete-dominance pattern.',
 ['An HL parent passes its L allele to half its offspring, making LL offspring rather than all HL.','The 50-unit aggregate phenotype is intermediate; the stem does not report separate simultaneous products.','This cross is HL×LL, which gives a 1:1 genotype ratio, not 3:1.'])])

add('C','infer maternal organelle inheritance from reciprocal crosses',[
('A beetle mother carries a mixture of normal and variant mitochondria. Her sons and daughters differ in flight ability, and measurements find different fractions of variant mitochondria among siblings. In the reciprocal cross, a variant-carrying father and a mother with only normal mitochondria produce offspring with only normal mitochondrial DNA. Which mechanism explains both the parent-of-origin pattern and the variable severity among the first mother’s offspring?',
 ['Mitochondria ordinarily enter through the egg, and random assortment of her mixed mitochondria can give offspring different variant fractions.','The father transmits mitochondria only to daughters, while independent assortment of nuclear chromosomes changes severity.','A single autosomal dominant allele from either parent is inherited by exactly half the offspring and directly sets each variant-mitochondria fraction.','Crossing over between homologous nuclear chromosomes creates the mitochondrial DNA fractions in eggs and sperm equally.'],
 'The absence of paternal variant mitochondrial DNA supports ordinary maternal organelle transmission. The mother is heteroplasmic, so random distribution of normal and variant mitochondria into eggs and early cells can produce siblings with different variant fractions and phenotypic severity.',
 ['The reciprocal cross shows no paternal variant transmission, and organelle assortment is not limited to daughters.','A nuclear allele does not account for the observed variable fractions of variant mitochondrial DNA and the lack of paternal transmission.','Nuclear crossing over changes linked nuclear alleles; it neither produces the observed mitochondrial fractions nor equal paternal transmission.']),
('A plant has a chloroplast DNA variant that makes seedlings pale. A pale seed parent is pollinated by a green plant; in a reciprocal cross, a green seed parent receives pollen from a pale plant. Assume chloroplasts enter the embryo through the ovule, not pollen. Which reciprocal outcome supports organelle inheritance?',
 ['Seedlings follow the seed parent: pale in the first cross and green in the reciprocal cross.','Seedlings follow the pollen parent: green first and pale in the reciprocal cross.','Both crosses give a 3:1 pale:green ratio expected for a dominant nuclear allele.','Every seedling is pale because either parent can supply chloroplasts equally.'],
 'The stated ovule-only chloroplast transmission makes the chloroplast genotype of the seed parent decisive. Reversing which plant supplies the ovule reverses the seedling phenotype.',
 ['Pollen is explicitly excluded as a chloroplast source in this model.','A 3:1 nuclear ratio is not predicted by ovule-only organelle transmission.','The two parents do not contribute chloroplasts equally under the stated mechanism.']),
('A homoplasmic mitochondrial variant in a mammal produces a measurable metabolic defect. An affected daughter of an affected mother mates with an unaffected male. Assume full penetrance and usual maternal organelle transmission. What is predicted for her children, and why does her affected brother have a different transmission risk?',
 ['Her children of either sex inherit the variant; her brother does not pass his mitochondrial DNA to offspring because sperm ordinarily do not transmit mitochondria.','Only her daughters inherit the variant, and her brother passes it to his sons.','Half her children inherit it by Mendelian segregation of one nuclear allele.','Her children are unaffected because the variant skips one generation.'],
 'A daughter receives the maternal variant and supplies mitochondria to her own eggs; under homoplasmy and full penetrance all her children inherit it regardless of sex. Her brother can inherit it but ordinarily does not transmit it through sperm.',
 ['Mitochondrial inheritance is maternal for sons and daughters, not mother-to-daughter only.','The modeled allele is mitochondrial rather than a segregating nuclear heterozygote.','The stated assumptions provide no generation-skipping mechanism.']),
('In reciprocal fish crosses, all daughters and sons of variant-carrying mothers show a mitochondrial trait, while no offspring of variant-carrying fathers do. A student proposes a fully penetrant X-linked dominant nuclear allele. Which observation most directly challenges that proposal?',
 ['Affected sons and daughters both track the mother, and affected fathers transmit to neither sex; maternal organelle transmission explains the reciprocal asymmetry.','All sons of affected mothers are affected; this alone rules out every X-linked model.','The phenotype appears in both sexes; any trait present in both sexes must be autosomal.','No affected father has an affected son; this proves an X-linked allele rather than an organelle allele.'],
 'The complete absence of paternal transmission to daughters as well as sons, together with transmission from variant-carrying mothers to both sexes, is the reciprocal-cross pattern expected for maternally inherited mitochondria. An affected father would transmit a fully penetrant X-linked dominant allele to every daughter, contradicting the observation.',
 ['Affected sons of mothers can occur under X-linked inheritance too, so that fact alone does not rule it out.','Sex-linked traits can appear in both sexes.','Father-to-son absence also occurs for X-linked traits, but the decisive pattern includes father-to-daughter absence and maternal transmission to both sexes.'])])

(H/'source_draft.md').write_text('\n\n'.join(out)+'\n')
json.dump({f'N-5.4-{k}':{'skill':v} for k,v in (('A','linked-gene recombination data'),('B','codominance and incomplete dominance'),('C','maternal organelle inheritance'))},open(H/'seed_map.json','w'),indent=2)
json.dump({'retire':[]},open(H/'retire_keys.json','w'),indent=2)
print('wrote 12 non-Mendelian genetics questions')
