"use client";

import { useEffect } from "react";

export default function Page() {
  useEffect(() => {
    if (document.querySelector('script[data-app-script="hindi-listening-trainer"]')) return;
    const script = document.createElement("script");
    script.src = "/app.js";
    script.defer = true;
    script.dataset.appScript = "hindi-listening-trainer";
    document.body.append(script);
  }, []);

  return (
    <div className="app-shell">
      <header className="topbar">
        <div>
          <p className="eyebrow">Tamil speaker Hindi trainer</p>
          <h1>Listen for the anchor</h1>
        </div>
        <button className="icon-button" id="installButton" type="button" hidden title="Install app" aria-label="Install app">
          <span aria-hidden="true">+</span>
        </button>
      </header>

      <main>
        <section className="view active" id="todayView" aria-labelledby="todayTab">
          <div className="session-panel">
            <div className="session-meta">
              <span id="sessionCount">Prompt 1 of 16</span>
              <span id="sessionSkill">Meaning from audio</span>
            </div>
            <div className="progress-rail" aria-hidden="true">
              <div id="sessionBar" />
            </div>

            <div className="listen-stage">
              <button className="listen-button" id="playButton" type="button">
                <span className="play-icon" aria-hidden="true">▶</span>
                <span>Play phrase</span>
              </button>
              <p className="audio-state" id="audioState">Tap play, then answer from what you hear.</p>
            </div>

            <div className="quiz-card">
              <p className="quiz-question" id="quizQuestion">What is the rough meaning?</p>
              <div className="options" id="options" />
            </div>

            <div className="reveal-card" id="revealCard" hidden>
              <div className="result-line" id="resultLine" />
              <div className="heard-phrase" id="heardPhrase" />
              <div className="meaning-grid">
                <div>
                  <span>Tamil</span>
                  <p id="tamilMeaning" />
                </div>
                <div>
                  <span>English</span>
                  <p id="englishMeaning" />
                </div>
              </div>
              <div className="pattern-strip">
                <span id="verbFamily" />
                <span id="tensePattern" />
              </div>
              <button className="primary-button" id="nextButton" type="button">Next</button>
            </div>
          </div>
        </section>

        <section className="view" id="verbsView" aria-labelledby="verbsTab">
          <div className="section-heading">
            <h2>Verb Families</h2>
            <p>Base action, common spoken forms, and meanings.</p>
          </div>
          <div className="verb-list" id="verbList" />
        </section>

        <section className="view" id="searchView" aria-labelledby="searchTab">
          <div className="section-heading">
            <h2>Heard a word?</h2>
            <p>Search approximate sounds like <strong>gya</strong>, <strong>khana</strong>, <strong>pani</strong>, or <strong>office</strong>.</p>
          </div>
          <label className="search-box">
            <span>Word or sound</span>
            <input id="wordSearch" type="search" autoComplete="off" placeholder="Type what she heard" />
          </label>
          <div className="search-summary" id="searchSummary" />
          <div className="search-results" id="searchResults" />
        </section>

        <section className="view" id="progressView" aria-labelledby="progressTab">
          <div className="section-heading">
            <h2>Progress</h2>
            <p>Recognition grows when a form is answered correctly across sessions.</p>
          </div>
          <div className="stats-grid">
            <div className="stat-card">
              <span>Base words</span>
              <strong id="wordBankCount">0</strong>
            </div>
            <div className="stat-card">
              <span>Benchmark</span>
              <strong id="benchmarkScore">0%</strong>
            </div>
            <div className="stat-card">
              <span>Attempts</span>
              <strong id="attemptCount">0</strong>
            </div>
            <div className="stat-card">
              <span>Learned phrases</span>
              <strong id="learnedCount">0</strong>
            </div>
            <div className="stat-card">
              <span>Current session</span>
              <strong id="sessionAccuracy">0%</strong>
            </div>
          </div>
          <div className="progress-block">
            <h3>Verbs recognized</h3>
            <div id="verbProgress" />
          </div>
          <div className="progress-block">
            <h3>Noun anchors</h3>
            <div id="nounProgress" />
          </div>
          <div className="progress-block">
            <h3>Tense patterns</h3>
            <div id="tenseProgress" />
          </div>
          <div className="progress-block">
            <h3>14-day word plan</h3>
            <div id="dayPlan" />
          </div>
          <button className="secondary-button" id="resetButton" type="button">Reset progress</button>
        </section>
      </main>

      <nav className="tabbar" aria-label="Primary">
        <button className="tab active" id="todayTab" type="button" data-view="todayView">
          <span aria-hidden="true">●</span>
          <span>Today</span>
        </button>
        <button className="tab" id="verbsTab" type="button" data-view="verbsView">
          <span aria-hidden="true">◆</span>
          <span>Verbs</span>
        </button>
        <button className="tab" id="searchTab" type="button" data-view="searchView">
          <span aria-hidden="true">⌕</span>
          <span>Search</span>
        </button>
        <button className="tab" id="progressTab" type="button" data-view="progressView">
          <span aria-hidden="true">◼</span>
          <span>Progress</span>
        </button>
      </nav>
    </div>
  );
}
