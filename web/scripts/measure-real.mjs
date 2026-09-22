import { chromium } from 'playwright';

const LAUNCH = process.env.PLAYWRIGHT_CHROMIUM
  ? { executablePath: process.env.PLAYWRIGHT_CHROMIUM }
  : {};
const BASE = process.env.BASE_URL || 'http://localhost:4173';
const OUT = process.env.OUT || 'screenshots/real';

const IDS = [
  'apprecalc-mcq-037', 'apprecalc-mcq-049', 'apphy1-mcq-005', 'apchem-mcq-016',
  'apcalcbc-mcq-032', 'apcalcab-mcq-021', 'apprecalc-mcq-046', 'apchem-mcq-001'
];

const browser = await chromium.launch(LAUNCH);
let bad = 0;

async function shot(mode, id, label) {
  const ctx = await browser.newContext({ viewport: { width: 1480, height: 960 } });
  const page = await ctx.newPage();
  const errs = [];
  page.on('pageerror', (e) => errs.push(String(e)));
  await page.goto(`${BASE}/#/${mode}/${id}`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(400);

  const r = await page.evaluate(() => {
    const plate = document.querySelector('#root > div');
    if (!plate) return null;
    const rect = plate.getBoundingClientRect();
    const panes = [...plate.querySelectorAll('section')].map((s) => {
      const track = s.children[s.children.length - 1];
      return {
        title: s.querySelector('h2')?.textContent || '(untitled)',
        overflow: track ? Math.round(track.scrollHeight - track.clientHeight) : 0
      };
    });
    const clipped = [...plate.querySelectorAll('button')]
      .filter((el) => el.getBoundingClientRect().bottom > rect.bottom + 1)
      .map((el) => el.textContent.trim().slice(0, 30));
    return { w: rect.width, h: rect.height, panes, clipped };
  });

  const over = r ? r.panes.filter((p) => p.overflow > 1) : [];
  const ok = r && r.w === 1440 && r.h === 900 && over.length === 0 && r.clipped.length === 0 && errs.length === 0;
  if (!ok) bad++;
  const detail = [
    over.map((p) => `${p.title} +${p.overflow}px`).join('; '),
    r?.clipped.length ? `clipped: ${r.clipped.join(', ')}` : '',
    errs.length ? `error: ${errs[0].slice(0, 80)}` : ''
  ].filter(Boolean).join(' | ');
  console.log(`${ok ? 'ok      ' : 'PROBLEM '} ${label.padEnd(34)} ${detail}`);

  await page.screenshot({ path: `${OUT}/${mode}-${id}.png` });
  await ctx.close();
}

for (const id of IDS) {
  await shot('open-hand', id, `Open Hand · ${id}`);
  await shot('practice', id, `Practice · ${id}`);
}

await browser.close();
console.log(`\n${bad} problem state(s) across ${IDS.length * 2} real-content plates`);
process.exit(bad ? 1 : 0);
