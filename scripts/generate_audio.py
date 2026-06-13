import asyncio
from pathlib import Path

import edge_tts

VOICE = "hi-IN-SwaraNeural"
AUDIO_DIR = Path("audio")

PROMPTS = {
    "office-jaana": "कल ऑफिस जाना है",
    "khana-khaaya": "मैंने खाना खाया",
    "ghar-gaya": "वह घर गया",
    "paani-chahiye": "मुझे पानी चाहिए",
    "kya-bola": "तुमने क्या बोला",
    "kha-rahi": "मैं खाना खा रही हूँ",
    "movie-dekhna": "आज मूवी देखना है",
    "kaam-karna": "मुझे काम करना है",
    "chai-peena": "चाय पीना है",
    "phone-liya": "मैंने फोन लिया",
    "message-dena": "उसको मेसेज देना है",
    "kya-hua": "क्या हुआ",
    "kal-aayega": "वह कल आएगा",
    "maine-kiya": "मैंने ऑलरेडी किया",
    "ghar-aa-rahi": "मैं घर आ रही हूँ",
    "tum-dekhoge": "तुम बाद में देखोगे",
    "remedial-jaana": "जाना है",
    "remedial-khaana": "खाना है",
    "remedial-karna": "करना है",
    "remedial-bolna": "बोलना है",
}


async def generate() -> None:
    AUDIO_DIR.mkdir(exist_ok=True)
    for prompt_id, text in PROMPTS.items():
        output = AUDIO_DIR / f"{prompt_id}.mp3"
        if output.exists():
            continue
        communicate = edge_tts.Communicate(text, VOICE, rate="-8%")
        await communicate.save(str(output))
        print(f"generated {output}")


if __name__ == "__main__":
    asyncio.run(generate())
