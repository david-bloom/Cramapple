import { mkdtempSync, mkdirSync, copyFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { execFileSync } from 'node:child_process';
import { readFileSync } from 'node:fs';

const root = dirname(fileURLToPath(import.meta.url));
const destination = resolve(process.argv[2] ?? join(tmpdir(), 'cramapple-loops-imports'));
mkdirSync(destination, { recursive: true });
const manifest = JSON.parse(readFileSync(join(root, 'manifest.json'), 'utf8'));
for (const { file } of manifest) {
  if (!/^\d{2}-[a-z-]+\.mjml$/.test(file)) throw new Error('Invalid import filename');
  const staging = mkdtempSync(join(tmpdir(), 'cramapple-mjml-'));
  try {
    // Loops requires this exact root entry, not the numbered source filename.
    copyFileSync(join(root, 'loops', file), join(staging, 'index.mjml'));
    const archive = join(destination, file.replace(/\.mjml$/, '.zip'));
    rmSync(archive, { force: true });
    execFileSync('zip', ['-q', archive, 'index.mjml'], { cwd: staging });
    const entries = execFileSync('unzip', ['-Z1', archive], { encoding: 'utf8' }).trim();
    if (entries !== 'index.mjml') throw new Error('Invalid Loops archive contents');
  } finally {
    rmSync(staging, { recursive: true, force: true });
  }
}
console.log(`Validated ${manifest.length} Loops import archives in ${destination}`);
