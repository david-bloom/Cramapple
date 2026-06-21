#!/usr/bin/env python3
"""Misattribution / wrong-entity-modifier checker, FRQ02-C2.

Deterministic, non-LLM second opinion on whether a response attaches
random/chance language to the construction destruction/survival event
(qualifying) versus only to the downstream allele-frequency/diversity
outcome (not qualifying). See docs/research/grader_speed_sp1_report.md
("Root-Cause Fix") for the diagnosis this implements.

Protocol: reads one JSON object per line from stdin (must have an
"answer_text" field), writes one JSON verdict per line to stdout. Loads
the spaCy model once at startup so per-check latency is just the parse,
not model load.
"""
import sys
import json
import spacy

TRIGGER_LEMMAS = {"random", "randomly", "chance"}
QUALIFYING_LEMMAS = {
    "destroy", "destruction", "kill", "survive", "survivor",
    "construction", "construct",
    "remove", "removal", "eliminate", "elimination", "sample",
}
# "select"/"selection" deliberately excluded: almost always appears as
# "natural selection" being negated ("not because of natural selection"),
# which is a disqualifying claim, not a qualifying one. Naive lemma
# co-occurrence can't tell "selected the survivors" (qualifying) from
# "not natural selection" (disqualifying) apart without negation scope -
# found via S028 producing a false "earned" at full-scale testing.
# "event" deliberately excluded too: "random events" in a sentence about
# allele loss/diversity (C4-adjacent content) caused a false "earned" on
# S020 that masked the correctly-detected hedge in an earlier sentence of
# the same response. Sentence-level lemma co-occurrence can't reliably
# tell which criterion's content a generic noun like "event" belongs to.
HEDGE_PHRASES = ["not necessarily", "not always", "not all", "not every"]
NEGATION_WINDOW_WORDS = {"not", "n't", "no"}


def is_negated_nearby(token, sent):
    """True if a negation word sits within 3 tokens before this token in the sentence."""
    start = max(sent.start, token.i - 3)
    window = sent.doc[start:token.i]
    return any(w.lower_ in NEGATION_WINDOW_WORDS or w.dep_ == "neg" for w in window)

nlp = spacy.load("en_core_web_sm", disable=["ner"])


def check_c2(answer_text):
    doc = nlp(answer_text)
    occurrences = []
    any_qualifying = False
    any_trigger = False

    for sent in doc.sents:
        sent_text_lower = sent.text.lower()
        triggers_in_sent = [t for t in sent if t.lemma_.lower() in TRIGGER_LEMMAS]
        if not triggers_in_sent:
            continue
        any_trigger = True
        qualifying_hits = {
            t.lemma_.lower() for t in sent
            if t.lemma_.lower() in QUALIFYING_LEMMAS and not is_negated_nearby(t, sent)
        }
        hedge_hit = any(phrase in sent_text_lower for phrase in HEDGE_PHRASES)
        qualifies = bool(qualifying_hits) and not hedge_hit
        if qualifies:
            any_qualifying = True
        occurrences.append({
            "sentence": sent.text.strip(),
            "trigger_words": [t.text for t in triggers_in_sent],
            "qualifying_lemmas_found": sorted(qualifying_hits),
            "hedge_detected": hedge_hit,
            "qualifies": qualifies,
        })

    if not any_trigger:
        verdict = "unable_to_determine"
    elif any_qualifying:
        verdict = "earned"
    else:
        verdict = "not_earned"

    return {
        "parser_status": verdict,
        "any_trigger_found": any_trigger,
        "any_qualifying_attachment": any_qualifying,
        "occurrences": occurrences,
    }


def main():
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        req = json.loads(line)
        result = check_c2(req.get("answer_text", ""))
        result["response_id"] = req.get("response_id", "")
        sys.stdout.write(json.dumps(result) + "\n")
        sys.stdout.flush()


if __name__ == "__main__":
    main()
