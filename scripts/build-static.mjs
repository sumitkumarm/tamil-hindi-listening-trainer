import { cp, mkdir, rm } from "node:fs/promises";

const files = [
  "index.html",
  "styles.css",
  "app.js",
  "audio-data.js",
  "manifest.webmanifest",
  "service-worker.js",
  "icon.svg"
];

await rm("netlify-dist", { recursive: true, force: true });
await mkdir("netlify-dist", { recursive: true });
await Promise.all(files.map((file) => cp(file, `netlify-dist/${file}`)));
