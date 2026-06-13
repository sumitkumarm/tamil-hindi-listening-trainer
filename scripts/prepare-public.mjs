import { cp, mkdir, rm } from "node:fs/promises";

const publicFiles = [
  "app.js",
  "manifest.webmanifest",
  "service-worker.js",
  "icon.svg"
];

await rm("public", { recursive: true, force: true });
await mkdir("public", { recursive: true });
await Promise.all(publicFiles.map((file) => cp(file, `public/${file}`)));
