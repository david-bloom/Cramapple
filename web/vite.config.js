import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { fileURLToPath, URL } from 'node:url';

// Real item packages are imported straight from the repo's content directory
// rather than copied into the app, so the plates always render what the
// authoring pipeline actually produced.
const packages = fileURLToPath(new URL('../content/item-packages', import.meta.url));

export default defineConfig({
  plugins: [react()],
  resolve: { alias: { '@packages': packages } },
  server: { port: 5173, fs: { allow: ['..'] } }
});
