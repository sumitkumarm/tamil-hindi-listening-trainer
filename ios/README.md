# Pesa Hindi — native iOS source handoff

A new SwiftUI iOS 16+ app for a Tamil speaker learning practical spoken Hindi/Hinglish. The old web app is preserved outside `ios/`.

## What is included

- Thirty ordered days with 120 authored listening prompts, 30 everyday roleplays, Tamil/English explanations, and optional speaking practice.
- Audio before answer reveal; meaning, anchor-word, time-clue, and useful-reply practice. Display uses Latin Hindi transliteration. All 180 prompt/opening/reply speech lines have separate authored Devanagari text for the Hindi synthesizer; the learner need not read Devanagari.
- Each daily listening round includes four new prompts plus up to four due reviews. Wrong/guessed material returns sooner; confident recalls receive longer intervals. Immediate repeats do not count as delayed retention, and retained material still returns when due.
- Local saved progress, separate lesson/accuracy/review measures, and no XP/streak pressure. A nominal 12-minute daily plan leaves room for listening, recall, a roleplay and speaking within 15 minutes; timing is guidance, not an enforced lockout.
- Speech/microphone permission handling, cancellation tokens, background cleanup, and a rough transcript explicitly described as practice feedback rather than a pronunciation grade. Recognition availability depends on the device/service; listening and manual practice remain useful without recognition.
- Original MP3 resources, an Xcode project/shared scheme, assets, and XCTest source for curriculum, progress/persistence, speech coverage, and review behavior.

## Original brief recovered

Original task ID: `019ec01b-834b-7b00-8e01-92010d76bafd` (Design Hindi learning). Its priorities were urban Hindi/Hinglish listening comprehension; noun/verb anchors and audible verb families; first-person feminine and common third-person forms; Tamil plus English after answering; gist over word-perfect grammar; no required alphabet study or streak pressure. The new request expands the earlier 14-day, 8–10-minute concept to 30 days and practical conversation.

## Validation and next step

`python ios/validate_sources.py` passes: 30 days, 120 prompts, 30 roleplays, 180 Hindi speech lines, 14 application Swift files, project references, plist/scheme XML, and asset references. Results are in `ios/validation.json`.

**Xcode compilation, XCTest execution, simulator UI, and on-device audio have not been verified.** This Windows host has no Xcode/iOS SDK. Source checks caught and fixed an omitted speech-source project reference, an initializer missing after custom decoding, and a curriculum parameter-label mismatch; they cannot prove the remaining SwiftUI code compiles.

On a Mac, open `ios/PesaHindi.xcodeproj`, select the shared PesaHindi scheme and an installed iPhone simulator, then build and run tests (Product > Test). Run through onboarding, audio, a full daily round, wrong/guessed reviews, roleplay, permission denial, background recording cancellation, and progress reload. Choose your signing team before installing on an iPhone. No App Store archive or publication was made.

This is a source implementation awaiting native QA, not a validated fluency product. Thirty days at fifteen minutes is 7.5 hours; the curriculum targets practical gains in familiar exchanges and does not guarantee conversational fluency. Authored Tamil/Hindi content and synthesized audio should also receive a native-speaker listening review before release.
