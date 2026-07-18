# Calculus subject-onboarding harnesses

The canonical harness inputs are:

- `content/subject-packages/ap-calculus-ab.subject-package.json`
- `content/subject-packages/ap-calculus-bc.subject-package.json`
- `content/subject-packages/ap-precalculus.subject-package.json`
- the 36 ItemPackages in each matching `content/item-packages/<subject>/`

Regenerate and validate the authored corpus:

```sh
deno run --allow-read --allow-write scripts/calculus-content/generate.ts
deno run --allow-read scripts/calculus-content/verify.ts
deno test --allow-read scripts/calculus-content/math-regression_test.ts
```

Run the 108-row atomic adoption regression only against a disposable database
that already has the TASK-0017 migration stack:

```sh
deno run --allow-read --allow-run \
  scripts/calculus-content/harness-db-regression.ts \
  postgresql://localhost:55447/postgres
```

Environment application uses `scripts/subject-harness/subject-harness.ts` and
requires an explicit environment. Dev and Production additionally require an
exact recorded approval ID; Production also requires the `--production`
confirmation flag. Subject onboarding does not publish content or create Tutor
assignments.
