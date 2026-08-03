// Extracted verbatim from sp1_pilot.mjs so the FRQ02 boundary diagnostic measures the
// boundary language that actually exists, rather than a fresh authoring pass.
// Do not edit here without also updating sp1_pilot.mjs.

export const CRITERIA = {
  'FRQ02-C1': {
    text: 'Identifies genetic drift as the mechanism (bottleneck effect is acceptable and more specific).',
    boundary: `FRQ02-C1 boundary table:

Earned:
- names genetic drift as the mechanism;
- names the bottleneck effect (a specific form of drift).

Not earned:
- names only natural selection, mutation, gene flow, or non-random mating as the mechanism;
- describes the population-size change without naming a mechanism.`,
  },
  'FRQ02-C2': {
    text: 'Explains that the construction event is random/non-selective with respect to flower-color fitness.',
    boundary: `FRQ02-C2 boundary table (v2 - revised after observing systematic under-credit on v1):

Earned - any of these satisfy the criterion:
- affirmatively states the construction destruction/survival event itself was random, by chance, or not based on which plants were fitter or better adapted (e.g. "randomly destroyed", "construction randomly killed plants", "random events like the construction");
- describes which plants survived as a random sample or random subset of the original population, stated affirmatively, not hedged (e.g. "the surviving population is a random sample"; "random survivors" WITHOUT a hedge like "not necessarily");
- affirmatively states the event was not natural selection.
A qualifying phrase needs to attach "random/by chance/randomly" to the destruction, survival, or selection ACT itself (who got destroyed or who survived), not only to the resulting allele-frequency number. Treat "the construction randomly destroyed/killed X" and "X were randomly selected/destroyed/survived" as earning credit even if the same sentence also mentions the frequency change.

Not earned:
- only says the population got smaller or allele frequencies changed, with no random/chance/non-selective language attached to the destruction or survival act anywhere in the response (e.g. "allele frequencies changed due to chance" or "changed randomly" with no mention of the construction/destruction/survival event being the random thing);
- only identifies bottleneck/genetic drift without explaining the construction event was random/non-selective;
- hedges with phrasing like "not necessarily the most fit" instead of affirmatively stating the event was non-selective;
- says construction selected the stronger/fitter/better-adapted flowers;
- says natural selection caused the allele-frequency change.

If you are uncertain whether "random/chance" modifies the destruction/survival act versus only the frequency outcome, prefer earned when the response also separately names the construction/destruction as the trigger in the same sentence or an adjacent one.`,
  },
  'FRQ02-C3': {
    text: 'Predicts reduced genetic diversity compared with the original population, addressing diversity over later generations, not only immediate mortality.',
    boundary: `FRQ02-C3 boundary table:

Earned:
- predicts genetic diversity will decrease/be reduced relative to the original population over subsequent generations.

Not earned:
- only describes the immediate population-size drop without a diversity prediction;
- predicts diversity stays the same or increases;
- predicts diversity will return to original levels via random mating alone (this is a distinct mechanism error, also not earned here).`,
  },
  'FRQ02-C4': {
    text: 'Explains that small isolated populations experience random allele-frequency change, allele loss/fixation, or reduced heterozygosity when no mutation or gene flow restores variation (random mating alone is insufficient).',
    boundary: `FRQ02-C4 boundary table:

Earned:
- explains random allele loss or fixation in a small population;
- explains reduced heterozygosity from drift in a small population;
- explains that without mutation or gene flow, lost variation cannot be restored.

Not earned:
- claims random mating alone restores or maintains original diversity;
- describes drift/bottleneck (covered by C1) without addressing allele loss, fixation, or heterozygosity consequences;
- omits the no-mutation/no-gene-flow condition when claiming diversity is permanently reduced.`,
  },
};
