import playwright from "/Users/davidbloom/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright/index.js";
import { mkdir } from "node:fs/promises";
import { pathToFileURL } from "node:url";

const atlas = "/Users/davidbloom/Documents/Cramapple.nosync/output/ap-chemistry-ced-diagrams/ced-diagram-atlas.html";
const outDir = "/Users/davidbloom/Documents/Cramapple.nosync/scripts/content-seed/ap-chem-reviewer-bakeoff-2026-10-09/fixtures";
const { chromium } = playwright;

await mkdir(outDir, { recursive: true });
const browser = await chromium.launch({ headless: true });

async function render(name, mutation) {
  const page = await browser.newPage({ viewport: { width: 720, height: 720 }, deviceScaleFactor: 2 });
  await page.goto(pathToFileURL(atlas).href);
  await page.evaluate((variant) => {
    const figure = document.querySelector("#particulate-models");
    const svg = figure.querySelector("svg");
    const groups = [...svg.querySelectorAll(":scope > g")];
    groups[0].remove();
    groups[1].remove();
    groups[2].setAttribute("transform", "translate(0 0)");
    svg.setAttribute("viewBox", "0 0 285 340");
    svg.style.width = "570px";
    svg.style.height = "680px";
    figure.querySelector("figcaption").remove();
    figure.style.width = "610px";
    figure.style.margin = "0";
    figure.style.padding = "20px";
    document.querySelector("header").remove();
    document.querySelectorAll("main > figure:not(#particulate-models)").forEach((node) => node.remove());
    document.body.style.margin = "0";
    document.body.style.background = "white";

    if (variant === "wrong-caption") {
      [...svg.querySelectorAll("text")]
        .find((node) => node.textContent.includes("B limits"))
        .textContent = "A limits; one B particle remains";
    }
    if (variant === "missing-particle") {
      svg.querySelector('circle[cx="270"][cy="205"]')?.remove();
    }
  }, mutation);
  await page.locator("#particulate-models").screenshot({ path: `${outDir}/${name}.png` });
  await page.close();
}

await render("I1-correct-limiting-reactant", "correct");
await render("I2-wrong-limiting-reactant-caption", "wrong-caption");
await render("I3-missing-product-side-particle", "missing-particle");
await browser.close();
