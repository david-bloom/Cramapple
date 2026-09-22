/**
 * Real MCQ items, loaded unmodified from `content/item-packages/`.
 *
 * Chosen as stress cases rather than friendly ones: the longest stem in the
 * library, the longest choice text, the heaviest rationales, one item carrying a
 * directions/calculator stimulus and one with none, across four subjects. If the
 * plate holds these it holds the library.
 *
 * Add an import here to put another package in front of the plates.
 */
import precalc037 from '@packages/ap-precalculus/apprecalc-mcq-037.json';
import precalc049 from '@packages/ap-precalculus/apprecalc-mcq-049.json';
import precalc046 from '@packages/ap-precalculus/apprecalc-mcq-046.json';
import phys1005 from '@packages/ap-physics-1/apphy1-mcq-005.json';
import chem016 from '@packages/ap-chemistry/apchem-mcq-016.json';
import chem001 from '@packages/ap-chemistry/apchem-mcq-001.json';
import calcab021 from '@packages/ap-calculus-ab/apcalcab-mcq-021.json';
import calcbc032 from '@packages/ap-calculus-bc/apcalcbc-mcq-032.json';

import { adaptItem } from './adapter.js';

const RAW = [
  { pkg: precalc037, why: 'Longest stem in the library — 346 characters' },
  { pkg: precalc049, why: 'Longest choice text — 74 characters' },
  { pkg: phys1005,   why: 'Heaviest rationales — 545 characters across four choices' },
  { pkg: chem016,    why: 'Second-heaviest rationales, short numeric choices' },
  { pkg: calcbc032,  why: 'Long stem, calculus notation' },
  { pkg: calcab021,  why: 'Carries a directions stimulus the plate has nowhere to put' },
  { pkg: precalc046, why: 'Typical item — terse math choices' },
  { pkg: chem001,    why: 'Typical item — no stimulus at all' }
];

export const REAL_ITEMS = RAW.map(({ pkg, why }) => ({ ...adaptItem(pkg), why }));
