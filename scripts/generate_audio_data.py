import base64
import json
from pathlib import Path


AUDIO_DIR = Path("audio")
OUTPUT = Path("audio-data.js")


def main() -> None:
    data = {}
    for audio_file in sorted(AUDIO_DIR.glob("*.mp3")):
        encoded = base64.b64encode(audio_file.read_bytes()).decode("ascii")
        data[audio_file.stem] = f"data:audio/mpeg;base64,{encoded}"

    OUTPUT.write_text(
        "window.promptAudioData = "
        + json.dumps(data, ensure_ascii=True, separators=(",", ":"))
        + ";\n",
        encoding="utf-8",
    )
    print(f"Wrote {len(data)} embedded audio clips to {OUTPUT}")


if __name__ == "__main__":
    main()
