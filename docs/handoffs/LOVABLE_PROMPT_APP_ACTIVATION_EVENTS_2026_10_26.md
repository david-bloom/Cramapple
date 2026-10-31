# Lovable prompt — app activation events (2026-10-26)

**Project:** App `56cae479`. **Not sent.** Check the project's existing PostHog wrapper (`src/lib/posthog.ts`) and allow-list first.

```text
Add two PostHog events to the app using the existing capture() wrapper and its property allow-list. Do not change UI, copy or styling. Do not publish.

1. app_first_session: fire once per user, the first time an authenticated student reaches a practice session (guard with a localStorage flag keyed by user id; try/catch storage). Properties: subject_key only.
2. first_question_answered: fire once per user, on the first submitted answer (MCQ or FRQ) the user ever makes (same guard). Properties: subject_key and question_type ("mcq" | "frq"); add question_type to the allow-list.
3. Make sure identifyUser(userId) runs after login so these events join the marketing visit. Do not send email or name.
4. Respect the existing environment and route rules (no events on login/signup routes, production hosts only).
5. Tests: each event fires once and only once per user, carries only the listed properties, and nothing fires when storage is unavailable twice.

Reply with files changed and test results.
```
