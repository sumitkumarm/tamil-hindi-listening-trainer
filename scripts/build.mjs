import { cp, mkdir, rm } from "node:fs/promises";

const files = [
  "manifest.webmanifest",
  "service-worker.js",
  "icon.svg"
];

await mkdir("dist", { recursive: true });

await Promise.all(files.map((file) => cp(file, `dist/${file}`)));
