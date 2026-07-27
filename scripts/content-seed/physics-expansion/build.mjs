import path from "node:path";
import { apphy1 } from "./apphy1.mjs";
import { apphy2 } from "./apphy2.mjs";
import { apphycm } from "./apphycm.mjs";
import { apphycem } from "./apphycem.mjs";
import { dirname, validateSubject, writeArtifacts } from "./lib.mjs";

export const subjects = [apphy1, apphy2, apphycm, apphycem];
const outputDirectory = process.argv[2] ?? path.join(dirname, "generated");
const manifest = writeArtifacts(subjects, outputDirectory);

for (const subject of subjects) {
  const items = validateSubject(subject);
  const byUnit = Object.groupBy(items, (item) => `U${item.unit}`);
  const allocation = Object.fromEntries(
    Object.entries(byUnit).map(([unit, rows]) => [
      unit,
      {
        total: rows.length,
        frq: rows.filter((row) => row.itemType === "frq").length,
        mcq: rows.filter((row) => row.itemType === "mcq").length,
      },
    ]),
  );
  console.log(`${subject.prefix}: ${JSON.stringify(allocation)}`);
}

console.log(`Generated ${Object.values(manifest).flat().length} validated items in ${outputDirectory}`);
