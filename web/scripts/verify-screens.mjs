import { chromium } from 'playwright';

// Chromium comes from PLAYWRIGHT_CHROMIUM (set it when the browser is not on the
// default path); otherwise Playwright's own download is used.
const LAUNCH = process.env.PLAYWRIGHT_CHROMIUM
  ? { executablePath: process.env.PLAYWRIGHT_CHROMIUM }
  : {};

const BASE = process.env.BASE_URL || 'http://localhost:4173';
const OUT = process.env.OUT || 'screenshots';

const errors = [];
const checks = [];
function check(name, ok, detail = '') {
  checks.push({ name, ok, detail });
  console.log(`${ok ? 'PASS' : 'FAIL'}  ${name}${detail ? ' — ' + detail : ''}`);
}

const browser = await chromium.launch(LAUNCH);
const page = await browser.newPage({ viewport: { width: 1480, height: 960 } });
page.on('console', (m) => { if (m.type() === 'error') errors.push(m.text()); });
page.on('pageerror', (e) => errors.push(String(e)));

async function noWrappedActions(label) {
  // An action label that wraps to two lines means the pane is too tight for the
  // copy. The rule is to cut copy, so catch it here rather than in a screenshot.
  const wrapped = await page.evaluate(() => [...document.querySelectorAll('button')]
    .filter((el) => {
      const cs = getComputedStyle(el);
      const lines = el.getBoundingClientRect().height - parseFloat(cs.paddingTop) - parseFloat(cs.paddingBottom);
      return lines > parseFloat(cs.lineHeight) * 1.6;
    })
    .map((el) => el.textContent.trim().slice(0, 30)));
  check(`${label}: no action label wraps`, wrapped.length === 0, wrapped.join(', '));
}

async function plateFits(label) {
  const r = await page.evaluate(() => {
    const plate = document.querySelector('#root > div');
    if (!plate) return null;
    const rect = plate.getBoundingClientRect();
    // Anything inside the plate that scrolls is a product-rule violation.
    const scrollers = [...plate.querySelectorAll('*')]
      .filter((el) => el.scrollHeight - el.clientHeight > 2 && getComputedStyle(el).overflowY !== 'visible')
      .map((el) => el.tagName + '.' + (el.className || '').toString().slice(0, 30));
    // Anything rendered below the frame is clipped away from the student.
    const clipped = [...plate.querySelectorAll('button')]
      .filter((el) => el.getBoundingClientRect().bottom > rect.bottom + 1)
      .map((el) => el.textContent.trim().slice(0, 40));
    return { w: rect.width, h: rect.height, scrollers, clipped };
  });
  check(`${label}: plate is 1440x900`, r && r.w === 1440 && r.h === 900, r ? `${r.w}x${r.h}` : 'no plate');
  check(`${label}: nothing scrolls inside the plate`, r && r.scrollers.length === 0, (r?.scrollers || []).join(', '));
  check(`${label}: no action clipped below the frame`, r && r.clipped.length === 0, (r?.clipped || []).join(', '));
}

const text = () => page.evaluate(() => document.body.innerText);

// ---------- Home ----------
await page.goto(`${BASE}/#/`, { waitUntil: 'networkidle' });
await page.waitForTimeout(300);
await plateFits('Home');
await noWrappedActions('Home');
let t = await text();
check('Home: wordmark renders', t.includes('CramApple'));
check('Home: study map lists both topics', t.includes('Scatterplots & Correlation') && t.includes('Least-Squares Regression'));
check('Home: unit counter starts at 0 of 6', /0 of 6 questions done/.test(t));
await page.screenshot({ path: `${OUT}/01-home.png` });

// Study map overlay
await page.getByRole('button', { name: 'Study map' }).click();
await page.waitForTimeout(150);
check('Home: study map overlay opens', (await text()).includes('Close map'));
await page.keyboard.press('Escape');
await page.waitForTimeout(150);
check('Home: Escape closes the study map', !(await text()).includes('Close map'));

// ---------- Practice MCQ ----------
await page.goto(`${BASE}/#/practice/apstats-2-3-mcq-001`, { waitUntil: 'networkidle' });
await page.waitForTimeout(300);
await plateFits('Practice MCQ (idle)');
t = await text();
check('MCQ: hint is offered, not opened', t.includes('Rule out two choices') && !t.includes('Hint used'));
check('MCQ: primary action disabled before a pick',
  await page.getByRole('button', { name: 'Submit answer' }).isDisabled());

// Hint economy: idle -> asking -> back out -> asking -> open
await page.getByRole('button', { name: 'Show me' }).click();
await page.waitForTimeout(120);
t = await text();
check('MCQ: asking state surfaces the cost before disclosure',
  t.includes('Sure you need a hint?') && t.includes('listed on your feedback'));
await page.getByRole('button', { name: 'No, keep solving' }).click();
await page.waitForTimeout(120);
check('MCQ: backing out leaves no receipt', !(await text()).includes('Hint used'));

await page.getByRole('button', { name: 'Show me' }).click();
await page.getByRole('button', { name: 'Yes, show me' }).click();
await page.waitForTimeout(150);
t = await text();
check('MCQ: open state collapses to a receipt', /hint used/i.test(t));

const struck = await page.evaluate(() => [...document.querySelectorAll('[role="radio"]')]
  .filter((el) => el.getAttribute('aria-disabled') === 'true')
  .map((el) => el.textContent.trim()[0]));
check('MCQ: elimination hint strikes A and D', struck.join('') === 'AD', struck.join(''));

// Hide keeps the receipt standing
await page.getByRole('button', { name: 'Hide' }).click();
await page.waitForTimeout(120);
check('MCQ: Hide keeps the receipt', /hint used/i.test(await text()));
await page.screenshot({ path: `${OUT}/02-mcq-hint-open.png` });

// Pick a distractor and submit
await page.getByRole('radio').filter({ hasText: 'causes final exam scores' }).click();
await page.waitForTimeout(120);
check('MCQ: primary enables once a choice is picked',
  !(await page.getByRole('button', { name: 'Submit answer' }).isDisabled()));
await page.getByRole('button', { name: 'Submit answer' }).click();
await page.waitForTimeout(250);
await plateFits('Practice MCQ (submitted)');
await noWrappedActions('Practice MCQ (submitted)');
t = await text();
check('MCQ: verdict is one word', /\bincorrect\b/i.test(t) && !/great job|nice work|oops/i.test(t));
check('MCQ: coaching names the error', t.includes('You picked C') && t.includes('Next time:'));
check('MCQ: hints used strip carries the receipt', t.includes('HINTS USED'));
check('MCQ: answer key marks the picked row with revisit', t.includes('↻'));
check('MCQ: shrinks to credited + picked row', t.includes('options you did not pick are explained'));
await page.screenshot({ path: `${OUT}/03-mcq-feedback.png` });

// Deep dive
await page.getByRole('button', { name: 'Open the deep dive' }).click();
await page.waitForTimeout(150);
check('MCQ: deep dive opens full-frame', (await text()).includes('Back to the question'));
await page.keyboard.press('Escape');
await page.waitForTimeout(150);
check('MCQ: Escape closes the deep dive', !(await text()).includes('Back to the question'));

// ---------- Practice FRQ ----------
await page.goto(`${BASE}/#/practice/apstats-2-3-frq-001`, { waitUntil: 'networkidle' });
await page.waitForTimeout(300);
await plateFits('Practice FRQ (idle)');
check('FRQ: submit disabled with an empty answer',
  await page.getByRole('button', { name: 'Submit answer' }).isDisabled());

await page.locator('textarea').fill('Every extra hour of study will raise a score by 4.1 points on the final exam.');
await page.waitForTimeout(120);
await page.getByRole('button', { name: 'Submit answer' }).click();
await page.waitForTimeout(250);
await plateFits('Practice FRQ (submitted)');
await noWrappedActions('Practice FRQ (submitted)');
t = await text();
check('FRQ: partial score shown', /3 \/ 4/.test(t));
check('FRQ: coaching opens with Fix:', t.includes('Fix:'));
check('FRQ: missed point marked revisit not taken', t.includes('↻') && !t.includes('✕'));
check('FRQ: submitted work stays visible', t.includes('YOUR ANSWER') && t.includes('will raise a score'));
await page.screenshot({ path: `${OUT}/04-frq-feedback.png` });

// ---------- Open Hand FRQ ----------
await page.goto(`${BASE}/#/open-hand/apstats-2-3-frq-001`, { waitUntil: 'networkidle' });
await page.waitForTimeout(300);
await plateFits('Open Hand FRQ');
t = await text();
check('Open Hand FRQ: starts at full marks', /4 \/ 4/.test(t));
check('Open Hand FRQ: rubric is face-up', t.includes('Every point is face-up'));
await page.getByRole('switch').nth(2).click();
await page.waitForTimeout(150);
t = await text();
check('Open Hand FRQ: taking a point back moves the score', /3 \/ 4/.test(t));
check('Open Hand FRQ: uses the teacher mark', t.includes('✕'));
const strikeCount = await page.evaluate(() => [...document.querySelectorAll('span')]
  .filter((el) => getComputedStyle(el).textDecorationLine === 'line-through').length);
check('Open Hand FRQ: credited phrase strikes through', strikeCount > 0, `${strikeCount} struck`);
await page.screenshot({ path: `${OUT}/05-openhand-frq.png` });

// ---------- Open Hand MCQ ----------
await page.goto(`${BASE}/#/open-hand/apstats-2-3-mcq-001`, { waitUntil: 'networkidle' });
await page.waitForTimeout(300);
await plateFits('Open Hand MCQ');
t = await text();
check('Open Hand MCQ: key is face-up with verdicts', t.includes('Credited') && t.includes('Distractor'));
check('Open Hand MCQ: nothing is scored', t.includes('Not scored'));
const before = (await text()).match(/(\d) of 4 read/)[1];
await page.getByRole('radio').filter({ hasText: 'causes final exam scores' }).click();
await page.waitForTimeout(150);
const after = (await text()).match(/(\d) of 4 read/)[1];
check('Open Hand MCQ: read counter advances', Number(after) > Number(before), `${before} -> ${after}`);
await page.screenshot({ path: `${OUT}/06-openhand-mcq.png` });

// ---------- Progress feeds back to Home ----------
await page.goto(`${BASE}/#/`, { waitUntil: 'networkidle' });
await page.waitForTimeout(300);
t = await text();
check('Home: progress reflects the two Practice attempts', /2 of 6 questions done/.test(t), t.match(/\d of 6 questions done/)?.[0]);
check('Home: last attempt names the revisit', t.includes('↻'));
await plateFits('Home (with progress)');
await noWrappedActions('Home (with progress)');
await page.screenshot({ path: `${OUT}/07-home-progress.png` });

// ---------- Next-question navigation ----------
await page.goto(`${BASE}/#/practice/apstats-2-2-mcq-001`, { waitUntil: 'networkidle' });
await page.waitForTimeout(250);
await page.getByRole('button', { name: 'Skip for now' }).click();
await page.waitForTimeout(250);
check('Next advances across the unit', page.url().includes('apstats-2-2-frq-001'), page.url());

const appErrors = errors.filter((e) => !/ERR_CERT_AUTHORITY_INVALID|favicon|fonts\.googleapis|fonts\.gstatic|404 \(Not Found\)/i.test(e));
check('no console errors', appErrors.length === 0, appErrors.slice(0, 3).join(' | '));

await browser.close();

const failed = checks.filter((c) => !c.ok);
console.log(`\n${checks.length - failed.length}/${checks.length} checks passed`);
process.exit(failed.length ? 1 : 0);
