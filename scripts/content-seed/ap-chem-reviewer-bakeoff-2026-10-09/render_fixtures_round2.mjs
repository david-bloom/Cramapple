import playwright from "/Users/davidbloom/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright/index.js";
import { mkdir } from "node:fs/promises";
import { pathToFileURL } from "node:url";

const { chromium } = playwright;
const atlas = "/Users/davidbloom/Documents/Cramapple.nosync/output/ap-chemistry-ced-diagrams/ced-diagram-atlas.html";
const outDir = "/Users/davidbloom/Documents/Cramapple.nosync/scripts/content-seed/ap-chem-reviewer-bakeoff-2026-10-09/fixtures-round2";

await mkdir(outDir, { recursive: true });
const browser = await chromium.launch({ headless: true });

async function render(figureId, filename, mutation) {
  const page = await browser.newPage({ viewport: { width: 1240, height: 900 }, deviceScaleFactor: 1.5 });
  await page.goto(pathToFileURL(atlas).href);
  await page.evaluate(({ id, variant }) => {
    document.querySelector("header").remove();
    document.querySelectorAll(`main > figure:not(#${id})`).forEach((node) => node.remove());
    document.body.style.margin = "0";
    document.body.style.background = "white";
    const figure = document.querySelector(`#${id}`);
    figure.style.margin = "0";

    if (variant === "second-order-negative-slope") {
      [...figure.querySelectorAll("text")]
        .find((node) => node.textContent.includes("slope = +k"))
        .textContent = "slope = −k";
    }
    if (variant === "reverse-electron-flow") {
      const arrow = [...figure.querySelectorAll("path")].find(
        (node) => node.getAttribute("stroke") === "var(--brand)" && node.getAttribute("marker-end") === "url(#electronArrow)",
      );
      arrow.removeAttribute("marker-end");
      arrow.setAttribute("marker-start", "url(#electronArrow)");
      [...figure.querySelectorAll("text")]
        .find((node) => node.textContent.includes("electron flow"))
        .textContent = "← electron flow";
    }
  }, { id: figureId, variant: mutation });
  await page.locator(`#${figureId}`).screenshot({ path: `${outDir}/${filename}.png` });
  await page.close();
}

await render("integrated-rate-plots", "I4-correct-integrated-rate-plots", "correct");
await render("integrated-rate-plots", "I5-wrong-second-order-slope", "second-order-negative-slope");
await render("electrochemical-cell", "I6-correct-galvanic-cell", "correct");
await render("electrochemical-cell", "I7-wrong-electron-flow", "reverse-electron-flow");
await browser.close();

