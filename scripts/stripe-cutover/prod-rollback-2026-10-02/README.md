# Production Stripe functions — rollback copies (taken 2026-10-02, before APPROVAL-0070)

Downloaded read-only from Production (`pcntajvbdfqhbeewmdry`) with `supabase functions download --use-api`.
These are the **pre-cutover (August) sources** of the only two functions the cutover replaces:
`stripe-webhook` (Production v20, ezbr `e1651efe…`) and `create-checkout-session` (v21, ezbr `b4014c8a…`).
The other four functions did not exist in Production.

To roll back: `supabase functions deploy <name> --project-ref pcntajvbdfqhbeewmdry --no-verify-jwt --use-api --workdir <a dir containing supabase/functions/<name> and _shared copied from here>`.
Do not edit these files.

SHA-256 of each file:

```
d3c3655c07c0e7b0566ce6e8ca97b54cd80796182b67f8d668a0b2c9a7900eb8  ./_shared/auth.ts
41f7020827aee45f2746a7491af1e3d56b297488798212ecae6abfefbc9da033  ./_shared/cors.ts
d274c612fe57c66f75f1be49b339be21e34064e35ff09b4094ff537a87374002  ./_shared/growth-events.ts
208a80e949401f6575272307fcdd0a8bfbda23870e2a0f0a087fd64902b3f3a3  ./_shared/http.ts
e6ee6a45a4c7b7d841b4cf1502d619d17e32f5429eb95f4cbfc49f9930534a67  ./_shared/stripe-catalog.ts
570cd47166bd8a106d07d0d2b09ba22a460387fcc339f78b292dbd91e56e31c4  ./_shared/stripe.ts
abdacaf7af26a4f3a25286071bf307f8a797d19cc5521ff1f3c5e0b902e1511d  ./_shared/supabase.ts
d505ccc2d967ec2ec141de3c74af15fd45fac22dd0bfeeda2c20f4ab24d2934e  ./create-checkout-session/index.ts
204c6098896ddd8a510d773d249a0fec56d53a0487ee6aa5ef2961b601cf4eee  ./stripe-webhook/index.ts
```
