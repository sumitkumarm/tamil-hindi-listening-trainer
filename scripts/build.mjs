import { cp, mkdir } from "node:fs/promises";

const files = [
  "public/manifest.webmanifest",
  "public/service-worker.js",
  "public/icon.svg",
  "public/app.js"
];

await mkdir("dist", { recursive: true });
await mkdir("dist/.openai", { recursive: true });

await Promise.all(files.map((file) => cp(file, `dist/${file.replace("public/", "")}`)));
await cp(".openai/hosting.json", "dist/.openai/hosting.json");
