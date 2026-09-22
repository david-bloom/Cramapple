import { chromium } from 'playwright';

// Chromium comes from PLAYWRIGHT_CHROMIUM (set it when the browser is not on the
// default path); otherwise Playwright's own download is used.
const LAUNCH = process.env.PLAYWRIGHT_CHROMIUM
  ? { executablePath: process.env.PLAYWRIGHT_CHROMIUM }
  : {};

const BASE = process.env.BASE_URL || 'http://localhost:4173';
const browser = await chromium.launch(LAUNCH);
const page = await browser.newPage({ viewport: { width: 1480, height: 960 } });

const ROUTES = [
  ['Home', '/#/'],
  ['Practice MCQ idle', '/#/practice/apstats-2-3-mcq-001'],
  ['Practice FRQ idle', '/#/practice/apstats-2-3-frq-001'],
  ['Open Hand FRQ', '/#/open-hand/apstats-2-3-frq-001'],
  ['Open Hand MCQ', '/#/open-hand/apstats-2-3-mcq-001'],
  ['Practice FRQ 2.2', '/#/practice/apstats-2-2-frq-001'],
  ['Practice MCQ 2.2', '/#/practice/apstats-2-2-mcq-001'],
  ['Practice MCQ 2.3b', '/#/practice/apstats-2-3-mcq-002'],
  ['Practice FRQ residual', '/#/practice/apstats-2-3-frq-002']
];

// Seed submitted states so the post-submit layouts get measured too.
await page.goto(`${BASE}/#/`);
await page.evaluate(() => localStorage.clear());

async function measure(label) {
  const r = await page.evaluate(() => {
    const plate = document.querySelector('#root > div');
    const pr = plate.getBoundingClientRect();
    const panes = [...plate.querySelectorAll('section')].map((s) => {
      const b = s.getBoundingClientRect();
      // The pane's own content region -- the div PaneShell puts children in.
      const track = s.children[s.children.length - 1];
      const overflow = track ? track.scrollHeight - track.clientHeight : 0;
      const title = s.querySelector('h2')?.textContent || '(untitled)';
      return { title, bottom: Math.round(b.bottom), overflow: Math.round(overflow) };
    });
    return { plateBottom: Math.round(pr.bottom), panes };
  });
  const bad = r.panes.filter((p) => p.overflow > 1);
  const line = bad.length
    ? bad.map((p) => `${p.title} overflows by ${p.overflow}px`).join('; ')
    : 'all panes fit';
  console.log(`${bad.length ? 'OVERFLOW' : 'ok      '}  ${label.padEnd(22)} ${line}`);
  return bad.length;
}

let total = 0;
for (const [label, path] of ROUTES) {
  await page.goto(BASE + path, { waitUntil: 'networkidle' });
  await page.waitForTimeout(250);
  total += await measure(label);
}

// Post-submit layouts
await page.goto(`${BASE}/#/practice/apstats-2-3-frq-001`, { waitUntil: 'networkidle' });
await page.locator('textarea').fill('Every extra hour of study will raise a score by 4.1 points on the final exam.');
await page.getByRole('button', { name: 'Submit answer' }).click();
await page.waitForTimeout(300);
total += await measure('Practice FRQ submitted');

await page.goto(`${BASE}/#/practice/apstats-2-3-mcq-001`, { waitUntil: 'networkidle' });
await page.getByRole('button', { name: 'Show me' }).click();
await page.getByRole('button', { name: 'Yes, show me' }).click();
await page.getByRole('radio').filter({ hasText: 'causes final exam scores' }).click();
await page.getByRole('button', { name: 'Submit answer' }).click();
await page.waitForTimeout(300);
total += await measure('Practice MCQ submitted');

await page.goto(`${BASE}/#/practice/apstats-2-2-frq-001`, { waitUntil: 'networkidle' });
await page.locator('textarea').fill('Strong positive linear association, with one unusual point.');
await page.getByRole('button', { name: 'Submit answer' }).click();
await page.waitForTimeout(300);
total += await measure('Practice FRQ 2.2 submitted');

await page.goto(`${BASE}/#/practice/apstats-2-3-frq-002`, { waitUntil: 'networkidle' });
await page.locator('textarea').fill('Predicted is 79.5, residual is -8.5, so the student is below the line.');
await page.getByRole('button', { name: 'Submit answer' }).click();
await page.waitForTimeout(300);
total += await measure('Practice FRQ residual submitted');

// Hint open states (the tallest scoring pane). Clear first, then reload, or the
// screens still render their submitted layout from the previous block.
await page.evaluate(() => localStorage.clear());
await page.goto(`${BASE}/#/practice/apstats-2-3-frq-001`, { waitUntil: 'networkidle' });
await page.reload({ waitUntil: 'networkidle' });
await page.getByRole('button', { name: 'Show me' }).click();
await page.getByRole('button', { name: 'Yes, show me' }).click();
await page.waitForTimeout(300);
total += await measure('FRQ rubric hint open');

await page.goto(`${BASE}/#/practice/apstats-2-2-frq-001`, { waitUntil: 'networkidle' });
await page.getByRole('button', { name: 'Show me' }).click();
await page.getByRole('button', { name: 'Yes, show me' }).click();
await page.waitForTimeout(300);
total += await measure('FRQ 2.2 rubric hint open');

await browser.close();
console.log(`\n${total} pane(s) overflowing`);
process.exit(total ? 1 : 0);
