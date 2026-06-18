# Provider Settings Review

**Status:** Spike provider settings documented; Product Owner transmission approval recorded
**Owner:** Product Owner
**Created Date:** 2026-06-17
**Related Protocol:** `docs/research/BIO_REFERENCE_LAYER_PDF_SPIKE_PROTOCOL.md`

## 1. Purpose

This document records the provider data-handling settings relevant to the
biology reference-layer PDF spike and later learner-facing reference-card
grading.

It separates:

- official OpenAI platform behavior documented publicly;
- Cramapple's spike decision about temporary PDF-derived cards;
- account-specific settings that must be verified in the dashboard or by
  account owner confirmation before live API calls.

## 2. Official OpenAI Platform Notes

Source: OpenAI Platform data controls guide:
`https://platform.openai.com/docs/guides/your-data`

Observed guidance:

- OpenAI states that API data is not used to train or improve OpenAI models
  unless the customer explicitly opts in.
- By default, abuse-monitoring logs may contain prompts, responses, and
  derived metadata, and are retained for up to 30 days unless a longer period
  is legally or safety required.
- `/v1/responses` and `/v1/chat/completions` are listed as not used for
  training, with 30-day abuse-monitoring retention by default.
- Zero Data Retention and Modified Abuse Monitoring are prior-approval
  controls; eligible customers can configure them at organization or project
  level after approval.
- For `/v1/responses`, default application-state retention may apply when the
  `store` parameter is `true`; with Zero Data Retention enabled, `store` is
  treated as `false`.

Source: OpenAI Platform prompt caching guide:
`https://platform.openai.com/docs/guides/prompt-caching`

Observed guidance:

- Prompt caching is automatic for recent models and has no extra fee.
- Cache hits appear in `usage.prompt_tokens_details.cached_tokens`.
- Cache hits require exact prompt-prefix matches.
- Prompt caches are not shared between organizations.
- Extended prompt caching may store key/value tensors derived from customer
  content for a limited period, up to 24 hours.

Source: OpenAI Platform pricing page:
`https://platform.openai.com/docs/pricing`

Use the current pricing page as the pricing source for the measurement harness.
Do not hard-code stale token prices into documentation.

## 3. Spike Provider Decision

| Question | Current status |
| --- | --- |
| May temporary PDF-derived cards be sent to the model provider for this internal spike? | Product Owner approved for this internal spike only |
| May the PDF text or PDF-derived cards be committed to the repository? | No |
| May PDF-derived cards become product reference cards? | No |
| May aggregate spike results be committed? | Yes |
| Must the request use `store: false` or equivalent where available? | Yes |
| Must prompt hash, cached tokens, and token usage be recorded? | Yes |

Approval recorded 2026-06-17:

```text
Product Owner confirms that, under the selected OpenAI account/project settings,
temporary PDF-derived reference cards may be sent to the chosen model endpoint
for this internal spike only, using store:false where available, with no
repository commit or product use of PDF-derived text.
```

## 4. Account-Specific Confirmation

Product Owner confirmation in Section 3 satisfies the account-specific
provider-setting gate for this internal spike. The confirmed scope covers:

- organization/project data retention setting;
- whether training opt-in is disabled;
- whether Modified Abuse Monitoring or Zero Data Retention is enabled;
- selected endpoint and model ID;
- whether the endpoint uses prompt caching and how cached tokens are reported;
- whether regional processing or data residency applies;
- whether any project-specific logging, tracing, eval, or dashboard setting
  stores request content beyond the model-provider default.

## 5. Production-Gating Note

This review is sufficient only to document the spike provider posture. Before
learner-facing reference-card grading, Cramapple must complete a separate
production provider review covering:

- real student response text;
- Cramapple reference cards;
- rubrics;
- prompts;
- grading outputs;
- deletion and retention behavior;
- minor-data and consent implications.

## 6. Current Readiness

```text
spike provider settings: documented from official OpenAI docs
account-specific provider confirmation: Product Owner confirmed for spike
PDF-derived text transmission approval: Product Owner approved for spike only
production provider approval: not started
```
