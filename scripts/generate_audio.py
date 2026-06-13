import asyncio
from pathlib import Path

import edge_tts
from edge_tts.exceptions import NoAudioReceived

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

WORD_AUDIO = {
    "word-jaana": "जाना",
    "word-aana": "आना",
    "word-karna": "करना",
    "word-khaana": "खाना",
    "word-peena": "पीना",
    "word-bolna": "बोलना",
    "word-dekhna": "देखना",
    "word-lena": "लेना",
    "word-dena": "देना",
    "word-hona": "होना",
    "form-jaana-0": "जा रही हूँ",
    "form-jaana-1": "गयी",
    "form-jaana-2": "जाना है",
    "form-jaana-3": "जाऊँगी",
    "form-aana-0": "आ रही हूँ",
    "form-aana-1": "आयी",
    "form-aana-2": "आना है",
    "form-aana-3": "आएगा",
    "form-karna-0": "कर रही हूँ",
    "form-karna-1": "किया",
    "form-karna-2": "करना है",
    "form-karna-3": "करेगा",
    "form-khaana-0": "खा रही हूँ",
    "form-khaana-1": "खाया",
    "form-khaana-2": "खायी",
    "form-khaana-3": "खाना है",
    "form-peena-0": "पी रही हूँ",
    "form-peena-1": "पिया",
    "form-peena-2": "पीना है",
    "form-peena-3": "पिएगा",
    "form-bolna-0": "बोल रही हूँ",
    "form-bolna-1": "बोला",
    "form-bolna-2": "बोलना है",
    "form-bolna-3": "बोलेगा",
    "form-dekhna-0": "देख रही हूँ",
    "form-dekhna-1": "देखा",
    "form-dekhna-2": "देखना है",
    "form-dekhna-3": "देखेगा",
    "form-lena-0": "ले रही हूँ",
    "form-lena-1": "लिया",
    "form-lena-2": "लेना है",
    "form-lena-3": "लेगा",
    "form-dena-0": "दे रही हूँ",
    "form-dena-1": "दिया",
    "form-dena-2": "देना है",
    "form-dena-3": "देगा",
    "form-hona-0": "हो रहा है",
    "form-hona-1": "हुआ",
    "form-hona-2": "होना है",
    "form-hona-3": "होगा",
    "word-kaam": "काम",
    "word-ghar": "घर",
    "word-office": "ऑफिस",
    "word-paani": "पानी",
    "word-chai": "चाय",
    "word-coffee": "कॉफी",
    "word-doodh": "दूध",
    "word-roti": "रोटी",
    "word-rice": "चावल",
    "word-sabzi": "सब्ज़ी",
    "word-dal": "दाल",
    "word-namak": "नमक",
    "word-cheeni": "चीनी",
    "word-phone": "फोन",
    "word-message": "मेसेज",
    "word-call": "कॉल",
    "word-photo": "फोटो",
    "word-video": "वीडियो",
    "word-movie": "मूवी",
    "word-song": "गाना",
    "word-gaadi": "गाड़ी",
    "word-auto": "ऑटो",
    "word-train": "ट्रेन",
    "word-flight": "फ्लाइट",
    "word-ticket": "टिकट",
    "word-paise": "पैसे",
    "word-time": "टाइम",
    "word-mummy": "मम्मी",
    "word-papa": "पापा",
    "word-tau": "ताऊ",
    "word-chacha": "चाचा",
    "word-maama": "मामा",
    "word-phupha": "फूफा",
    "word-mausa": "मौसा",
    "word-dost": "दोस्त",
    "word-baat": "बात",
    "word-sawaal": "सवाल",
    "word-jawab": "जवाब",
}


async def generate() -> None:
    AUDIO_DIR.mkdir(exist_ok=True)
    for prompt_id, text in {**PROMPTS, **WORD_AUDIO}.items():
        output = AUDIO_DIR / f"{prompt_id}.mp3"
        if output.exists():
            continue
        for attempt in range(1, 4):
            try:
                communicate = edge_tts.Communicate(text, VOICE, rate="-8%")
                await communicate.save(str(output))
                print(f"generated {output}")
                break
            except NoAudioReceived:
                if attempt == 3:
                    print(f"skipped {prompt_id}: no audio received after 3 attempts")
                else:
                    await asyncio.sleep(1)


if __name__ == "__main__":
    asyncio.run(generate())
