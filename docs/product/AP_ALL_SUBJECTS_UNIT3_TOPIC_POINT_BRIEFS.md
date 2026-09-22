# AP All Subjects Unit 3 Topic Point Briefs

Status: Draft content system seed, pending QA.

Deployment state is deliberately NOT asserted here. The canonical record is
the migration
`supabase/migrations/20260821070000_all_subjects_unit3_topic_point_briefs_seed.sql`
plus follow-up addendum migrations, and the `app.topic_point_briefs` table in
each environment.

Purpose: preserve Cramapple-original topic point brief content for the third
unit of every currently seeded subject. For Physics 2 and Physics C:
Electricity and Magnetism, the official College Board numbering continues
from the physics sequence, so the third course unit is Unit 11 and Unit 10,
respectively.

Source basis: local CED fact packs in `docs/product/`, especially the Unit 3
deep-tier sections and topic maps. These are concise topic cards, not full
lessons; each row is designed to help a student connect the topic to the next
point-earning behavior.

## Coverage

| Subject | Seeded unit | Topics |
|---|---:|---:|
| AP Biology | 3 | 5 |
| AP Chemistry | 3 | 13 |
| AP Statistics | 3 | 15 |
| AP Precalculus | 3 | 15 |
| AP Calculus AB | 3 | 6 |
| AP Calculus BC | 3 | 6 |
| AP Physics 1 | 3 | 5 |
| AP Physics C: Mechanics | 3 | 5 |
| AP Physics 2 | 11 | 8 |
| AP Physics C: Electricity and Magnetism | 10 | 4 |

Original all-subject seed total: 80 topic point briefs.

AP Chemistry Unit 3 addendum:

- `supabase/migrations/20260825131525_ap_chemistry_unit3_photons_beer_lambert_topic_guides.sql`
  adds the two missing paired topic guides for 3.12 Properties of Photons and
  3.13 Beer-Lambert Law.
- Grounding is `docs/product/AP_CHEMISTRY_CED_FACT_PACK.md` Unit 3: photon
  energy via `c = lambda nu` and `E = h nu`, and Beer-Lambert
  `A = epsilon b c` with fixed-wavelength/path-length proportionality.
- After this addendum, AP Chemistry Unit 3 has full taxonomy coverage
  (13 topics) when the migration is applied.

## Content Rules

- No external links in student-facing brief fields.
- No copied third-party language.
- Keep each row topic-specific and point-behavior focused.
- Use official topic numbering from each subject's current CED-aligned fact
  pack.
- Preserve course boundaries: no calculus in AP Precalculus, no quantitative
  RC time modeling in AP Physics 2, no capacitor-series/parallel networks in
  AP Physics C: E&M Unit 10.
