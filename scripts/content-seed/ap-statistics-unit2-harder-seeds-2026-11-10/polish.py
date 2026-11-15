import re
PAST={"gave":"gives","counted":"counts","treated":"treats","used":"uses","forgot":"forgets","added":"adds","ignored":"ignores","only removed":"only removes","multiplied":"multiplies","subtracted":"subtracts","assumed":"assumes","reported":"reports","kept":"keeps","divided":"divides","stopped":"stops","invents":"invents","confuses":"confuses","left":"leaves","reads":"reads"}
GEN={
"the complement.":"This is the probability of the complementary event, not of the event the question asks about.",
"with replacement.":"This treats the draws as if each item were replaced, but the draws are made without replacement, so the second draw has a different composition.",
"wrong tail.":"This is the area in the opposite tail from the one the question asks about.",
"doubled.":"This doubles a one-tail area into a two-sided area, but the question asks about one tail only.",
"increased.":"Larger samples give less variable sample means, so the standard deviation of the sample mean decreases rather than increases.",
"unchanged.":"The standard deviation of the sample mean is σ/√n, so it changes when n changes.",
"left the SD unscaled.":"Multiplying a random variable by a constant multiplies its standard deviation by that constant, so the SD does not stay unscaled.",
"product only.":"This multiplies the probabilities, which gives P(A and B), not P(A or B).",
"no overlap subtracted.":"This adds the two probabilities without subtracting the overlap, so the overlap is counted twice.",
"joint.":"This is the joint proportion of the whole group for both categories, not the proportion within the group the question names.",
"wrong sign.":None,
}
def r(src,frag):
    f=frag.strip()
    if f in GEN and GEN[f]: return GEN[f]
    m=re.match(r"^1 − ([\d.]+)\.$",f)
    if m: return f"This is the complement, 1 − {m.group(1)}, not the probability the question asks about."
    return None
