# AP All Subjects Unit 3 Topic Point Briefs

Status: Draft content system seed, pending QA.

Deployment state is deliberately NOT asserted here. The canonical record is
the migration
`supabase/migrations/20260821070000_all_subjects_unit3_topic_point_briefs_seed.sql`
and the `app.topic_point_briefs` table in each environment.

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
| AP Chemistry | 3 | 11 |
| AP Statistics | 3 | 15 |
| AP Precalculus | 3 | 15 |
| AP Calculus AB | 3 | 6 |
| AP Calculus BC | 3 | 6 |
| AP Physics 1 | 3 | 5 |
| AP Physics C: Mechanics | 3 | 5 |
| AP Physics 2 | 11 | 8 |
| AP Physics C: Electricity and Magnetism | 10 | 4 |

Total: 80 topic point briefs.

## Content Rules

- No external links in student-facing brief fields.
- No copied third-party language.
- Keep each row topic-specific and point-behavior focused.
- Use official topic numbering from each subject's current CED-aligned fact
  pack.
- Preserve course boundaries: no calculus in AP Precalculus, no quantitative
  RC time modeling in AP Physics 2, no capacitor-series/parallel networks in
  AP Physics C: E&M Unit 10.
