#!/usr/bin/env python3
"""F1 — AP Statistics skill taxonomy + cell registry (topic x skill).

Source of truth: docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md §3 (source-
verified 2026-08-02; Jill SME confirmation deferred, David is reviewer of record
per COURSE_MODE decision D2). Skill definitions from fact pack §4.

A CELL is (topic_code, skill_code) — the course-mode mastery unit
(COURSE_MODE_LEARNING_MODEL.md CM-D05). Practice is a roll-up parent of skill.
"""
from __future__ import annotations

from typing import Dict, List, Tuple

# Skill -> (practice_number, short label). Fact pack §4.
SKILLS: Dict[str, Tuple[int, str]] = {
    "1.A": (1, "Determine a valid investigative question requiring a statistical investigation"),
    "2.A": (2, "Identify information to answer a question or solve a problem"),
    "2.B": (2, "Justify an appropriate method for ethically gathering and representing data"),
    "2.C": (2, "Identify appropriate statistical inference methods"),
    "2.D": (2, "Identify types of errors and relationships among components in inference methods"),
    "2.E": (2, "Identify the null and alternative hypotheses"),
    "3.A": (3, "Construct tabular/graphical representations"),
    "3.B": (3, "Calculate summary statistics, relative positions, predicted responses"),
    "3.C": (3, "Calculate/estimate expected counts, percentages, probabilities, intervals"),
    "3.D": (3, "Calculate means, SDs, parameters for probability distributions"),
    "3.E": (3, "Calculate appropriate inference-method results"),
    "4.A": (4, "Describe/compare representations and summary statistics"),
    "4.B": (4, "Justify a claim from calculations/results"),
    "4.C": (4, "Describe distributions and compare relative positions"),
    "4.D": (4, "Interpret calculations/results to assess meaning or a claim"),
    "4.E": (4, "Justify a chosen inference method by verifying conditions"),
    "4.F": (4, "Interpret inference-method results"),
    "4.G": (4, "Justify a claim from inference-method results"),
}

PRACTICE_LABELS = {
    1: "Formulate Questions",
    2: "Collect Data",
    3: "Analyze Data",
    4: "Interpret Results",
}

# topic_code -> (title, [skills])  — verbatim from fact pack §3.
TOPICS: Dict[str, Tuple[str, List[str]]] = {
    # Unit 1
    "1.1": ("Introducing Statistics: What Can We Learn from Data?", ["1.A", "2.A"]),
    "1.2": ("Variables", ["2.A"]),
    "1.3": ("Tabular Representation and Summary Statistics for One Categorical Variable", ["3.A", "4.A"]),
    "1.4": ("Graphical Representations for One Categorical Variable", ["3.A", "4.A", "4.B"]),
    "1.5": ("Graphical Representations for One Quantitative Variable", ["3.A"]),
    "1.6": ("Descriptions for One Quantitative Variable Distributions", ["4.A", "4.B"]),
    "1.7": ("Summary Statistics for One Quantitative Variable", ["3.B", "4.A", "4.B"]),
    "1.8": ("Graphical Representations of Summary Statistics for One Quantitative Variable", ["3.A", "4.A"]),
    "1.9": ("Comparisons of the Distributions for One Quantitative Variable", ["3.B", "4.A", "4.B", "4.C"]),
    "1.10": ("The Investigative Question Revisited and Data Collection", ["1.A", "2.A", "2.B"]),
    "1.11": ("Random Sampling", ["2.A", "2.B"]),
    "1.12": ("Potential Problems with Sampling", ["2.A"]),
    "1.13": ("Experimental Design", ["2.A", "2.B"]),
    # Unit 2
    "2.1": ("Tabular and Graphical Representations for the Distributions of Two Categorical Variables", ["4.A", "4.B"]),
    "2.2": ("Summary Statistics for Two Categorical Variables", ["3.B", "4.A", "4.B"]),
    "2.3": ("Estimating Probabilities Using Simulation", ["3.C"]),
    "2.4": ("Introduction to Probability", ["3.C"]),
    "2.5": ("Mutually Exclusive Events", ["4.B"]),
    "2.6": ("Conditional Probability", ["3.C"]),
    "2.7": ("Independent Events and Unions of Events", ["3.C"]),
    "2.8": ("Introduction to Random Variables and Probability Distributions", ["3.A"]),
    "2.9": ("Parameters of Random Variables", ["3.B", "4.D"]),
    "2.10": ("The Binomial Distribution", ["3.C", "3.D", "4.B", "4.D"]),
    "2.11": ("The Normal Distribution", ["3.C", "3.D", "4.C"]),
    "2.12": ("Sampling Distributions and the Central Limit Theorem", ["4.C"]),
    # Unit 3
    "3.1": ("Estimators", ["3.D", "4.B"]),
    "3.2": ("Sampling Distributions for Sample Proportions", ["3.D", "4.D", "4.E"]),
    "3.3": ("Constructing a Confidence Interval for a Population Proportion", ["2.C", "3.E", "4.E"]),
    "3.4": ("Justifying a Claim Based on a Confidence Interval for a Population Proportion", ["2.D", "4.F", "4.G"]),
    "3.5": ("Setting Up a Test for a Population Proportion", ["2.C", "2.E", "4.E"]),
    "3.6": ("p-Values", ["4.F"]),
    "3.7": ("Carrying Out a Test for a Population Proportion", ["3.E", "4.G"]),
    "3.8": ("Potential Errors When Performing Tests", ["2.D", "3.C", "4.D"]),
    "3.9": ("Sampling Distributions for the Difference Between Sample Proportions", ["3.D", "4.D", "4.E"]),
    "3.10": ("Constructing a Confidence Interval for the Difference Between Two Population Proportions", ["2.C", "3.E", "4.E"]),
    "3.11": ("Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Proportions", ["4.F", "4.G"]),
    "3.12": ("Setting Up a Test for the Difference Between Two Population Proportions", ["2.C", "2.E", "4.E"]),
    "3.13": ("Carrying Out a Test for the Difference Between Two Population Proportions", ["3.E", "4.F", "4.G"]),
    "3.14": ("Setting Up a Chi-Square Test for Homogeneity or Independence", ["2.C", "2.E", "4.C", "4.E"]),
    "3.15": ("Carrying Out a Chi-Square Test for Homogeneity or Independence", ["3.C", "3.E", "4.F", "4.G"]),
    # Unit 4
    "4.1": ("Sampling Distributions for Sample Means", ["3.D", "4.D", "4.E"]),
    "4.2": ("Constructing a Confidence Interval for a Population Mean or Population Mean Difference", ["2.C", "3.E", "4.C", "4.E"]),
    "4.3": ("Justifying a Claim Based on a Confidence Interval for a Population Mean or Population Mean Difference", ["2.D", "4.F", "4.G"]),
    "4.4": ("Setting Up a Test for a Population Mean or Population Mean Difference", ["2.C", "2.E", "4.E"]),
    "4.5": ("Carrying Out a Test for a Population Mean or Population Mean Difference", ["3.E", "4.F", "4.G"]),
    "4.6": ("Sampling Distributions for the Difference Between Two Sample Means", ["3.D", "4.D", "4.E"]),
    "4.7": ("Constructing a Confidence Interval for the Difference Between Two Population Means", ["2.C", "3.E", "4.E"]),
    "4.8": ("Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Means", ["4.F", "4.G"]),
    "4.9": ("Setting Up a Test for the Difference Between Two Population Means", ["2.C", "2.E", "4.E"]),
    "4.10": ("Carrying Out a Test for the Difference Between Two Population Means", ["3.E", "4.F", "4.G"]),
    # Unit 5
    "5.1": ("Graphical Representations Between Two Quantitative Variables", ["3.A", "4.A", "4.B"]),
    "5.2": ("Correlation", ["4.D"]),
    "5.3": ("Linear Regression Models", ["3.B"]),
    "5.4": ("Residuals", ["3.B", "4.A", "4.D"]),
    "5.5": ("Least-Squares Regression", ["3.B", "4.D"]),
}


def unit_of(topic_code: str) -> int:
    return int(topic_code.split(".")[0])


def all_cells() -> List[Tuple[str, str]]:
    """Every (topic_code, skill_code) cell, in registry order."""
    cells: List[Tuple[str, str]] = []
    for topic, (_title, skills) in TOPICS.items():
        for sk in skills:
            cells.append((topic, sk))
    return cells


def practice_of(skill_code: str) -> int:
    return SKILLS[skill_code][0]


def self_check() -> Dict[str, object]:
    """Registry invariants (used by the build harness)."""
    cells = all_cells()
    per_practice: Dict[int, int] = {}
    for sk, (p, _l) in SKILLS.items():
        per_practice[p] = per_practice.get(p, 0) + 1
    per_unit_cells: Dict[int, int] = {}
    for topic, _sk in cells:
        u = unit_of(topic)
        per_unit_cells[u] = per_unit_cells.get(u, 0) + 1
    # every skill referenced by a topic must be defined
    undefined = sorted({sk for _t, sk in cells if sk not in SKILLS})
    return {
        "n_topics": len(TOPICS),
        "n_cells": len(cells),
        "skills_per_practice": per_practice,
        "cells_per_unit": per_unit_cells,
        "undefined_skills": undefined,
    }


if __name__ == "__main__":
    import json
    print(json.dumps(self_check(), indent=2))
