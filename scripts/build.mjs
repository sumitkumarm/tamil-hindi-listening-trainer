import { cp, mkdir } from "node:fs/promises";

const files = [
  "manifest.webmanifest",
  "service-worker.js",
  "icon.svg"
];

await mkdir("dist", { recursive: true });
await mkdir("dist/.openai", { recursive: true });

await Promise.all(files.map((file) => cp(file, `dist/${file}`)));
await cp(".openai/hosting.json", "dist/.openai/hosting.json");
