import argparse
import os
import sys
import time
from html import escape
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from generate_audio import PROMPTS, WORD_AUDIO


DEFAULT_VOICE = "hi-IN-Kavya:MAI-Voice-2"
DEFAULT_OUTPUT_DIR = Path("audio")
OUTPUT_FORMAT = "audio-24khz-160kbitrate-mono-mp3"


def load_env_file(path: Path) -> None:
    if not path.exists():
        return

    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and key not in os.environ:
            os.environ[key] = value


def required_env(name: str) -> str:
    value = os.environ.get(name, "").strip()
    if not value:
        raise RuntimeError(f"Missing {name}. Set it in the environment or .env.local.")
    return value


def build_ssml(text: str, voice: str) -> str:
    return (
        '<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" '
        'xmlns:mstts="http://www.w3.org/2001/mstts" xml:lang="hi-IN">'
        f'<voice name="{escape(voice)}">'
        '<mstts:express-as style="friendly" styledegree="0.8">'
        f"{escape(text)}"
        "</mstts:express-as>"
        "</voice>"
        "</speak>"
    )


def synthesize(endpoint: str, key: str, voice: str, text: str) -> bytes:
    request = Request(
        endpoint,
        data=build_ssml(text, voice).encode("utf-8"),
        headers={
            "Ocp-Apim-Subscription-Key": key,
            "Content-Type": "application/ssml+xml",
            "X-Microsoft-OutputFormat": OUTPUT_FORMAT,
            "User-Agent": "hindi-listening-trainer",
        },
        method="POST",
    )

    with urlopen(request, timeout=45) as response:
        return response.read()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate Hindi clips with Microsoft MAI-Voice-2.")
    parser.add_argument("--output-dir", default=str(DEFAULT_OUTPUT_DIR), help="Directory for generated MP3 files.")
    parser.add_argument("--voice", default=os.environ.get("MAI_VOICE", DEFAULT_VOICE), help="Azure voice name.")
    parser.add_argument("--force", action="store_true", help="Overwrite existing MP3 files.")
    return parser.parse_args()


def main() -> int:
    load_env_file(Path(".env.local"))
    load_env_file(Path(".env"))
    args = parse_args()

    try:
        key = required_env("AZURE_SPEECH_KEY")
        region = required_env("AZURE_SPEECH_REGION")
    except RuntimeError as error:
        print(error, file=sys.stderr)
        print("Example: AZURE_SPEECH_REGION=eastus MAI_VOICE=hi-IN-Kavya:MAI-Voice-2", file=sys.stderr)
        return 2

    endpoint = f"https://{region}.tts.speech.microsoft.com/cognitiveservices/v1"
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    for prompt_id, text in {**PROMPTS, **WORD_AUDIO}.items():
        output = output_dir / f"{prompt_id}.mp3"
        if output.exists() and not args.force:
            print(f"skipped {output}")
            continue

        try:
            output.write_bytes(synthesize(endpoint, key, args.voice, text))
            print(f"generated {output} with {args.voice}")
            time.sleep(0.2)
        except HTTPError as error:
            detail = error.read().decode("utf-8", errors="replace")
            print(f"Azure Speech HTTP {error.code} for {prompt_id}: {detail}", file=sys.stderr)
            return 1
        except URLError as error:
            print(f"Azure Speech request failed for {prompt_id}: {error}", file=sys.stderr)
            return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
