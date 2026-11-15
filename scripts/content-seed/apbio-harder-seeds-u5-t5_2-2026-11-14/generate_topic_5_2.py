"""Author Biology 5.2 meiosis and genetic diversity seed families."""
from pathlib import Path
import json

H=Path(__file__).resolve().parent
out=["# AP Biology Unit 5 topic 5.2 — Meiosis and Genetic Diversity", "DRAFT. Author-in-session 2026-11-14. CED 5.2.A.1–3."]
def add(family,skill,cases):
    assert len(cases)==4
    for i,(stem,choices,check,wrong) in enumerate(cases):
        assert len(choices)==4 and len(wrong)==3
        ident=f"N-5.2-{family}"
        if i==0:out.extend(["---",f"## Seed {ident} (new) — Topic 5.2 Meiosis and Genetic Diversity",f"**Skill:** {skill}","",stem,""])
        else:out.extend(["",f"**{ident}-v{i}.** {stem}",""])
        out.extend([f"- **A. {choices[0]}**",*[f"- {z}. {v}" for z,v in zip("BCD",choices[1:])],"",f"Check: {check}","Rationales: "+" ".join(f"{z}: {v}" for z,v in zip("BCD",wrong))])

cases=[]
for n in (3,4,5,6):
    possibilities=2**n
    stem=f"An organism has {n} homologous chromosome pairs. Ignore crossing over and assume each pair orients independently at meiosis I. What is the chance that one gamete gets a specified maternal-or-paternal homolog from every pair, and which meiotic event creates these possible combinations?"
    choices=[f"1/{possibilities}; random orientation of homologous pairs at metaphase I creates {possibilities} equiprobable whole-chromosome assortments.",f"1/{n}; sister chromatids separate at anaphase II to create {n} equiprobable assortments.",f"1/{possibilities*2}; random fertilization doubles the possible homolog assortments within one gamete.",f"1/{possibilities}; crossing over in prophase I is required to create the {possibilities} whole-chromosome assortments."]
    check=f"Each of the {n} pairs has two independent maternal/paternal choices, giving 2^{n}={possibilities} combinations and probability (1/2)^{n}=1/{possibilities} for one specified combination. The source of these whole-chromosome combinations is independent assortment at meiosis I; crossing over is excluded."
    wrong=["Meiosis II separates sisters; the number of whole-homolog configurations is exponential in homolog-pair count, not equal to that count.","Fertilization combines two gametes but does not change the probability for a specified assortment in one gamete.","The numerical probability is right, but the mechanism is wrong: independent orientation creates these combinations without crossing over."]
    cases.append((stem,choices,check,wrong))
add('A','combine independent assortment probability with its cellular mechanism',cases)

cases=[]
for upper,lower in (('AB','ab'),('CD','cd'),('EF','ef'),('GH','gh')):
    rec1=upper[0]+lower[1];rec2=lower[0]+upper[1]
    stem=f"Two linked markers are on one homolog as {upper} and on the other as {lower}. After meiosis, a researcher identifies gametes with {upper}, {lower}, {rec1}, and {rec2}. Which gametes require an exchange between nonsister chromatids in the interval between the markers, and when can that exchange occur?"
    choices=[f"{rec1} and {rec2}; crossing over between nonsister chromatids during prophase I can create these new combinations.",f"{upper} and {lower}; crossing over during prophase I is required to preserve the original combinations.",f"{rec1} and {rec2}; separation of sister chromatids during meiosis II creates the new combinations without exchange.",f"All four gamete classes; random fertilization creates their allele combinations inside a single gamete."]
    check=f"The original chromosome arrangements are {upper} and {lower}. A crossover between the loci on nonsister chromatids during prophase I can exchange the second marker, producing {rec1} and {rec2}. Independent separation alone preserves the linked arrangements."
    wrong=["Those are the parental marker combinations, which can be inherited without recombination.","Sister-chromatid separation sorts existing chromatids; it does not exchange linked alleles between homologs.","Fertilization combines already formed gametes and cannot create new allele arrangements inside one gamete."]
    cases.append((stem,choices,check,wrong))
add('B','infer recombination products and meiotic stage from linked markers',cases)

cases=[]
for n,event in ((4,'I'),(6,'II'),(8,'I'),(10,'II')):
    if n==10:
        stem="A diploid organism normally makes gametes with n=10 chromosomes. One abnormal meiosis produced gametes with 10, 10, 11, and 9 chromosomes. If each gamete separately fuses with a normal 10-chromosome gamete, which zygote chromosome counts result, and which division most likely had one nondisjunction event?"
        choices=["20, 20, 21, and 19; a meiosis II sister-chromatid nondisjunction leaves two normal gametes and one n+1/n−1 pair.","20, 20, 21, and 19; a meiosis I homolog nondisjunction leaves two normal gametes.","10, 10, 11, and 9; fertilization does not change chromosome number.","21, 21, 19, and 19; meiosis II nondisjunction makes all four gametes abnormal."]
        check="Normal fertilization adds 10 chromosomes to each gamete, yielding 20, 20, 21, and 19. The two normal gametes and one high/low pair identify nondisjunction of sister chromatids in one meiosis II cell, not failure of homologs in meiosis I."
        wrong=["The zygote counts are right, but meiosis I nondisjunction would make all four gametes abnormal.","The normal partner contributes 10 more chromosomes to each zygote.","The two normal gametes rule out a single meiosis I nondisjunction and yield two normal 20-chromosome zygotes."]
        cases.append((stem,choices,check,wrong))
        continue
    if event=='I':
        counts=f"{n+1}, {n+1}, {n-1}, and {n-1}"
        correct=f"Nondisjunction of one homologous pair in meiosis I; all four gametes are abnormal, two n+1 and two n−1."
        alt=f"Nondisjunction of sister chromatids in meiosis II; two gametes should still have {n} chromosomes."
        check=f"Failure of homologs to separate in meiosis I puts both homologs in one daughter cell and neither in the other. Normal meiosis II then yields two {n+1}-chromosome and two {n-1}-chromosome gametes, matching all four observations."
        wrong=["Meiosis II nondisjunction leaves two normal gametes, which are absent here.","Crossing over changes allele combinations, not the number of chromosomes in each gamete.","Normal meiosis gives four n-chromosome gametes, not the observed two high and two low counts."]
    else:
        counts=f"{n}, {n}, {n+1}, and {n-1}"
        correct=f"Nondisjunction of sister chromatids in meiosis II; two gametes are normal and the others are n+1 and n−1."
        alt=f"Nondisjunction of homologous chromosomes in meiosis I; all four gametes should have abnormal counts."
        check=f"Normal homolog separation in meiosis I creates two n-chromosome cells. If sister chromatids fail to separate in one meiosis II cell, its gametes are {n+1} and {n-1}; the other cell produces two normal {n}-chromosome gametes."
        wrong=["Meiosis I nondisjunction produces no normal gametes from that meiosis, but two are observed.","Crossing over changes genetic combinations without this n±1 chromosome-count pattern.","Normal meiosis gives four n-chromosome gametes, not one high and one low count."]
    stem=f"A diploid cell normally makes gametes with n={n} chromosomes. Four gametes from one meiosis have chromosome counts {counts}. Assuming a single nondisjunction event, which division failed, and how does the pattern support the inference?"
    choices=[correct,alt,"Crossing over in prophase I; exchanging chromosome segments creates the count differences.","Normal independent assortment; random orientation of homologs creates the count differences."]
    cases.append((stem,choices,check,wrong))
add('C','diagnose division-specific nondisjunction from all four gamete counts',cases)

(H/'source_draft.md').write_text('\n\n'.join(out)+'\n')
json.dump({f'N-5.2-{k}':{'skill':v} for k,v in (('A','independent assortment probability'),('B','linked-marker crossover inference'),('C','division-specific nondisjunction'))},open(H/'seed_map.json','w'),indent=2)
json.dump({'retire':[]},open(H/'retire_keys.json','w'),indent=2)
print('wrote 12 meiosis-diversity questions')
