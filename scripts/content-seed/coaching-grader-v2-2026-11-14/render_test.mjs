import { chromium } from '/home/user/Cramapple/web/node_modules/playwright/index.mjs';
const BASE = 'http://localhost:5199';
const MCQ = ['apprecalc-mcq-037','apprecalc-mcq-049','apphy1-mcq-005','apchem-mcq-016','apcalcbc-mcq-032','apcalcab-mcq-021','apprecalc-mcq-046','apchem-mcq-001','apstats-2-3-mcq-001','apstats-2-3-mcq-002'];
const FRQ = ['apstats-2-2-frq-001','apstats-2-3-frq-001','apstats-2-3-frq-002','apstats-2-2-frq-001','apstats-2-3-frq-001','apstats-2-3-frq-002','apstats-2-2-frq-001','apstats-2-3-frq-001','apstats-2-3-frq-002','apstats-2-2-frq-001'];
const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium' });
const out = [];
async function once(kind, id) {
  const ctx = await browser.newContext({ viewport: { width: 1480, height: 960 } });
  const page = await ctx.newPage();
  await page.goto(`${BASE}/#/practice/${id}`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(300);
  if (kind === 'frq') {
    await page.locator('textarea').first().fill('The distribution is skewed right with a median near 12 and an outlier, so the median is a better center than the mean because it resists extreme values.');
  } else {
    // pick the last option row (usually a distractor)
    const rows = page.locator('[role="radio"], [role="option"], label').filter({ hasText: /\S/ });
    const n = await rows.count();
    await rows.nth(Math.max(0, n - 1)).click({ trial: false }).catch(() => {});
  }
  const btn = page.getByRole('button', { name: /^Submit/ }).first();
  await btn.waitFor();
  if (await btn.isDisabled()) { await ctx.close(); return { kind, id, error: 'submit_disabled' }; }
  const ms = await page.evaluate(async () => {
    const b = [...document.querySelectorAll('button')].find((x) => /^Submit/.test(x.textContent.trim()));
    const t0 = performance.now();
    b.click();
    await new Promise((res) => {
      const done = () => { if (![...document.querySelectorAll('button')].some((x) => /^Submit/.test(x.textContent.trim()))) { requestAnimationFrame(() => requestAnimationFrame(res)); return true; } return false; };
      if (done()) return;
      new MutationObserver((_, o) => { if (done()) o.disconnect(); }).observe(document.body, { childList: true, subtree: true, characterData: true });
    });
    return performance.now() - t0;
  });
  await ctx.close();
  return { kind, id, render_ms: +ms.toFixed(1) };
}
for (const id of MCQ) out.push(await once('mcq', id));
for (const id of FRQ) out.push(await once('frq', id));
console.log(JSON.stringify(out));
await browser.close();
