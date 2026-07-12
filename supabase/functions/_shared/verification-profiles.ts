type VerificationProfile = {
  subject_key: string;
  display_name: string;
  profile_version: string;
  status: string;
  purpose: string;
  required_checks: Array<{
    check: string;
    owner: string;
    scope: string;
  }>;
  key_payload: {
    location: string;
    validated_by: string;
    items_keyed: string[];
    conceptual_only: string[];
    excluded_corpus_defect: string[];
  };
  tolerance_policy: {
    default_rel_tol: number;
  };
  open_boundary_contract_questions: string[];
};

const AP_STATISTICS_PROFILE: VerificationProfile = {
  subject_key: "ap-statistics",
  display_name: "AP Statistics",
  profile_version: "phase-b-2026-07-08",
  status:
    "development — keys authored + validated; not yet wired to production, not yet on an adjudicated gold set",
  purpose:
    "Declares the deterministic verification layer for AP Statistics grading and the per-item key/ECF payload it runs.",
  required_checks: [
    {
      check: "numeric_answer",
      owner: "deterministic",
      scope:
        "keyed computed values (CI bounds, test statistics, probabilities, r, slope) — result-presence within tolerance; 100% specificity on canonicals",
    },
    {
      check: "formula_setup_equivalence",
      owner: "deterministic",
      scope:
        "algebraic equivalence of formula setups before arithmetic; abstains on ambiguous typed notation",
    },
    {
      check: "error_carried_forward",
      owner: "deterministic",
      scope:
        "multi-part consistency points with guardrails for conceptual-collapse, coincidental-canonical, and naked-answer",
    },
    {
      check: "conceptual_reasoning",
      owner: "llm_grader",
      scope:
        "bias/confounding/causation, hypotheses statement, interpretation-in-context, reject/fail-to-reject decision",
    },
  ],
  key_payload: {
    location: "docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json",
    validated_by: "docs/research/statistics_phase_b_2026_07_08/validate_keys.py",
    items_keyed: ["APSTAT-MOD3-H001-INV", "APSTAT-MOD6-H001", "APSTAT-MOD7-H001"],
    conceptual_only: ["APSTAT-MOD5-H001-INV"],
    excluded_corpus_defect: ["APSTAT-MOD8-H001 (no dataset — value-specific claims isolated)"],
  },
  tolerance_policy: {
    default_rel_tol: 1e-3,
  },
  open_boundary_contract_questions: [],
};

// AP Calculus AB and AP Chemistry profiles. Unlike AP_STATISTICS_PROFILE,
// these have no published content_items in either environment yet (no
// subject/exam_pack rows in Production; Chemistry/Physics subjects exist in
// Dev only, per 202607070005_chemistry_physics_schema_instantiation, but
// still with zero content). Nothing routes to these profiles in production
// traffic today — they exist so Engine 3 (structured formula/ECF) has a
// per-subject key shape to author real content against once these subjects
// are actually authored and published. The key_payload location points at
// the trace-image bake-off packet (freshly authored, numerically verified
// this session), not an adjudicated gold set — same "development, not yet
// gold" caveat as AP Statistics, one step earlier.
const AP_CALCULUS_PROFILE: VerificationProfile = {
  subject_key: "ap-calculus-ab",
  display_name: "AP Calculus AB",
  profile_version: "dev-2026-07-10",
  status:
    "development — no published content_items yet in any environment; key shape seeded from a hand-drawn transcription bake-off packet, not an adjudicated gold set. Not wired to any live routing path.",
  purpose:
    "Declares the deterministic verification layer AP Calculus AB will use once content exists — structured-formula items (derivatives, antiderivatives, related rates, series) route to the symbolic + ECF verifier the same way AP Statistics quantitative items do.",
  required_checks: [
    {
      check: "expression_equivalence",
      owner: "deterministic",
      scope:
        "algebraic equivalence of derivative/related-rate expressions against a canonical form, accepting any equivalent form (matches AP's acceptance of unsimplified answers)",
    },
    {
      check: "antiderivative_check",
      owner: "deterministic",
      scope:
        "derivative-of-response equals canonical integrand AND an arbitrary constant is present; distinguishes derivative_mismatch from missing_constant",
    },
    {
      check: "multi_line_dependency",
      owner: "deterministic",
      scope:
        "does line n+1 correctly follow from line n in a multi-step derivation (quotient rule, chain rule, u-substitution, related rates)",
    },
    {
      check: "conceptual_reasoning",
      owner: "llm_grader",
      scope:
        "justification language (IVT/MVT/EVT), convergence-test reasoning, error-bound arguments, interpretation-in-context",
    },
  ],
  key_payload: {
    location:
      "docs/research/trace_image_set_chemistry_calculus_2026_07_10/items.json (CALC-E1..E3, CALC-H1..H5)",
    validated_by:
      "manual numeric verification against independent computation, 2026-07-10 (see items.json meta.scoring_note)",
    items_keyed: [
      "CALC-E1",
      "CALC-E2",
      "CALC-E3",
      "CALC-H1",
      "CALC-H2",
      "CALC-H3",
      "CALC-H4",
      "CALC-H5",
    ],
    conceptual_only: [],
    excluded_corpus_defect: [],
  },
  tolerance_policy: {
    default_rel_tol: 1e-3,
  },
  open_boundary_contract_questions: [
    "No real AP Calculus content_items exist yet in any environment — this profile has never graded a real student response.",
  ],
};

const AP_CHEMISTRY_PROFILE: VerificationProfile = {
  subject_key: "ap-chemistry",
  display_name: "AP Chemistry",
  profile_version: "dev-2026-07-10",
  status:
    "development — no published content_items yet in any environment; key shape seeded from a hand-drawn transcription bake-off packet, not an adjudicated gold set. Not wired to any live routing path.",
  purpose:
    "Declares the deterministic verification layer AP Chemistry will use once content exists — structured-formula items (equilibrium, kinetics, thermochemistry, acid-base) route to the symbolic + ECF verifier the same way AP Statistics quantitative items do.",
  required_checks: [
    {
      check: "numeric_answer",
      owner: "deterministic",
      scope:
        "keyed computed values (Kc/Ka expressions, pH, ICE-table equilibrium concentrations, rate constants, buffer pH) — result-presence within tolerance",
    },
    {
      check: "multi_line_dependency",
      owner: "deterministic",
      scope:
        "does line n+1 correctly follow from line n in a multi-step calculation (ICE table -> quadratic -> concentration; Hess's law summation; Arrhenius rearrangement)",
    },
    {
      check: "sign_and_unit_sensitivity",
      owner: "deterministic",
      scope:
        "sign-sensitive results (Hess's law addition/subtraction of a negative, exponent sign in Arrhenius/integrated rate law) flagged separately from magnitude errors",
    },
    {
      check: "conceptual_reasoning",
      owner: "llm_grader",
      scope:
        "mechanism/reasoning language, Le Chatelier qualitative predictions, interpretation-in-context",
    },
  ],
  key_payload: {
    location:
      "docs/research/trace_image_set_chemistry_calculus_2026_07_10/items.json (CHEM-E1..E3, CHEM-H1..H5)",
    validated_by:
      "manual numeric verification against independent computation, 2026-07-10 (see items.json meta.scoring_note)",
    items_keyed: [
      "CHEM-E1",
      "CHEM-E2",
      "CHEM-E3",
      "CHEM-H1",
      "CHEM-H2",
      "CHEM-H3",
      "CHEM-H4",
      "CHEM-H5",
    ],
    conceptual_only: [],
    excluded_corpus_defect: [],
  },
  tolerance_policy: {
    default_rel_tol: 1e-3,
  },
  open_boundary_contract_questions: [
    "No real AP Chemistry content_items exist yet in any environment — this profile has never graded a real student response.",
  ],
};

const VERIFICATION_PROFILES: VerificationProfile[] = [
  AP_STATISTICS_PROFILE,
  AP_CALCULUS_PROFILE,
  AP_CHEMISTRY_PROFILE,
];

export function getVerificationProfile(subjectKey: string | null | undefined) {
  if (!subjectKey) return null;
  return VERIFICATION_PROFILES.find((profile) =>
    profile.subject_key === subjectKey
  ) ?? null;
}

export function summarizeVerificationProfile(
  profile: ReturnType<typeof getVerificationProfile>,
) {
  if (!profile) return null;

  return {
    subject_key: profile.subject_key,
    profile_version: profile.profile_version,
    keyed_items: profile.key_payload.items_keyed,
    conceptual_items: profile.key_payload.conceptual_only,
    open_boundary_contract_questions: profile.open_boundary_contract_questions,
    required_checks: profile.required_checks.map((check) => ({
      check: check.check,
      owner: check.owner,
      scope: check.scope,
    })),
  };
}

export function formatVerificationProfileSummary(
  profile: ReturnType<typeof getVerificationProfile>,
) {
  if (!profile) return null;

  const checks = profile.required_checks.map((check) => check.check).join(", ");
  const keyedItems = profile.key_payload.items_keyed.join(", ");
  const conceptualOnly = profile.key_payload.conceptual_only.join(", ");

  return `${profile.display_name} verification profile ${profile.profile_version}. Checks: ${checks}. Keyed items: ${keyedItems}. Conceptual-only items: ${conceptualOnly}.`;
}
