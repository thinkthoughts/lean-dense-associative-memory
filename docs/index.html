<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="color-scheme" content="dark light" />
  <title>Formalizing Dense Associative Memory in Lean</title>
  <meta name="description" content="A kernel-checked Lean formalization of the exact finite layer of Dense Associative Memory: one-flip energy, exact signal/noise decomposition, and equiprobable ±1 pattern coordinates." />
  <meta property="og:title" content="Formalizing Dense Associative Memory in Lean" />
  <meta property="og:description" content="Exact one-flip energy, signal/noise decomposition, and equiprobable ±1 pattern coordinates." />
  <meta property="og:image" content="DAM.png" />
  <style>
    :root {
      --bg: #0b1020;
      --panel: #11182a;
      --panel-2: #161f35;
      --text: #eef3ff;
      --muted: #aebbd6;
      --line: #2a3858;
      --accent: #79a8ff;
      --accent-2: #f3bd62;
      --good: #8ad6a0;
      --max: 980px;
      --radius: 18px;
    }
    * { box-sizing: border-box; }
    html { scroll-behavior: smooth; }
    body {
      margin: 0;
      background:
        radial-gradient(circle at 15% 0%, rgba(70, 112, 190, 0.14), transparent 32rem),
        var(--bg);
      color: var(--text);
      font: 17px/1.65 system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }
    a { color: var(--accent); text-decoration-thickness: 1px; text-underline-offset: 3px; }
    a:hover { color: #a8c5ff; }
    code {
      font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
      font-size: 0.9em;
      color: #d8e4ff;
    }
    .wrap { width: min(calc(100% - 34px), var(--max)); margin: 0 auto; }
    header {
      padding: 42px 0 24px;
      border-bottom: 1px solid var(--line);
    }
    .eyebrow {
      color: var(--accent);
      text-transform: uppercase;
      letter-spacing: .12em;
      font-size: .78rem;
      font-weight: 700;
      margin-bottom: 10px;
    }
    h1, h2, h3 {
      font-family: Georgia, "Times New Roman", serif;
      line-height: 1.15;
      margin-top: 0;
    }
    h1 {
      font-size: clamp(2.25rem, 5vw, 4rem);
      margin-bottom: 14px;
      max-width: 880px;
    }
    .dek {
      color: var(--muted);
      font-size: clamp(1.06rem, 2vw, 1.3rem);
      max-width: 820px;
      margin: 0;
    }
    .meta {
      display: flex;
      flex-wrap: wrap;
      gap: 10px 18px;
      margin-top: 22px;
      color: var(--muted);
      font-size: .92rem;
    }
    .hero {
      margin: 30px 0 14px;
      background: #fff;
      border-radius: var(--radius);
      overflow: hidden;
      border: 1px solid var(--line);
    }
    .hero img { display: block; width: 100%; height: auto; }
    .caption {
      color: var(--muted);
      font-size: .88rem;
      margin-top: 9px;
    }
    main { padding: 34px 0 70px; }
    section {
      padding: 30px 0;
      border-top: 1px solid var(--line);
    }
    section:first-child { border-top: 0; padding-top: 10px; }
    h2 { font-size: 1.8rem; margin-bottom: 16px; }
    h3 { font-size: 1.25rem; margin-bottom: 10px; }
    p { margin: 0 0 15px; }
    .lead {
      font-size: 1.17rem;
      color: #f5f7ff;
    }
    .callout {
      background: linear-gradient(135deg, rgba(121,168,255,.10), rgba(243,189,98,.06));
      border: 1px solid var(--line);
      border-radius: var(--radius);
      padding: 22px 24px;
      margin: 22px 0;
    }
    .math {
      overflow-x: auto;
      padding: 8px 0;
      text-align: center;
      font-size: 1.08rem;
    }
    .chain {
      display: grid;
      grid-template-columns: repeat(7, minmax(120px, 1fr));
      gap: 8px;
      margin: 22px 0 8px;
      overflow-x: auto;
      padding-bottom: 6px;
    }
    .step {
      min-width: 130px;
      padding: 14px 12px;
      border: 1px solid var(--line);
      border-radius: 14px;
      background: var(--panel);
      text-align: center;
      font-size: .88rem;
    }
    .step strong { display: block; color: var(--text); margin-bottom: 5px; }
    .step small { color: var(--muted); }
    .boundary {
      display: grid;
      grid-template-columns: 1.35fr .65fr;
      gap: 16px;
      margin-top: 18px;
    }
    .boundary > div {
      border-radius: var(--radius);
      padding: 20px;
      border: 1px solid var(--line);
      background: var(--panel);
    }
    .now { box-shadow: inset 4px 0 0 var(--good); }
    .next { box-shadow: inset 4px 0 0 var(--accent-2); }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 16px;
      font-size: .94rem;
    }
    th, td {
      padding: 11px 12px;
      border-bottom: 1px solid var(--line);
      vertical-align: top;
      text-align: left;
    }
    th {
      color: #dce7ff;
      font-weight: 700;
      background: rgba(255,255,255,.025);
    }
    td:first-child { width: 42%; }
    .sourcebox {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 14px;
      margin-top: 16px;
    }
    .sourcebox a {
      display: block;
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 14px;
      padding: 16px;
      text-decoration: none;
    }
    .sourcebox strong { display: block; color: var(--text); margin-bottom: 3px; }
    .sourcebox span { color: var(--muted); font-size: .9rem; }
    footer {
      border-top: 1px solid var(--line);
      color: var(--muted);
      padding: 24px 0 40px;
      font-size: .88rem;
    }

    .site-header {
      border-bottom: 1px solid var(--line);
      background: rgba(11,16,32,.88);
      backdrop-filter: blur(10px);
      position: sticky;
      top: 0;
      z-index: 20;
    }
    .site-header .inner,
    .site-footer .footer-inner {
      width: min(calc(100% - 34px), var(--max));
      margin: 0 auto;
    }
    .site-header .inner {
      min-height: 54px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 20px;
    }
    .brand {
      font-weight: 750;
      color: var(--text);
      text-decoration: none;
      letter-spacing: .01em;
    }
    .site-nav {
      display: flex;
      align-items: center;
      gap: 16px;
      font-size: .9rem;
    }
    .site-nav a { text-decoration: none; color: var(--muted); }
    .site-nav a:hover { color: var(--text); }
    .howto {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 12px;
      margin-top: 18px;
    }
    .howto .item {
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 14px;
      padding: 16px;
    }
    .howto .n {
      color: var(--accent);
      font-size: .78rem;
      font-weight: 800;
      letter-spacing: .08em;
      text-transform: uppercase;
      margin-bottom: 6px;
    }
    .howto strong { display: block; margin-bottom: 5px; }
    .repo-path {
      background: var(--panel-2);
      border: 1px solid var(--line);
      border-radius: 12px;
      padding: 14px 16px;
      overflow-x: auto;
      margin: 14px 0;
    }
    .site-footer {
      border-top: 1px solid var(--line);
      padding: 30px 0 38px;
      color: var(--muted);
      font-size: .88rem;
    }
    .footer-statement {
      color: var(--text);
      font-family: Georgia, "Times New Roman", serif;
      font-size: 1.04rem;
      margin-bottom: 12px;
    }
    .footer-links {
      display: flex;
      flex-wrap: wrap;
      gap: 8px 16px;
      margin-bottom: 12px;
    }
    .footer-links a { text-decoration: none; color: var(--muted); }
    .footer-links a:hover { color: var(--text); }
    .footer-copyright { font-size: .82rem; color: #8e9ab3; }

    @media (max-width: 760px) {
      .boundary, .sourcebox, .howto { grid-template-columns: 1fr; }
      body { font-size: 16px; }
      header { padding-top: 28px; }
    }
  </style>
  <script>
    window.MathJax = {
      tex: { inlineMath: [['\\(','\\)']], displayMath: [['\\[','\\]']] },
      svg: { fontCache: 'global' }
    };
  </script>
  <script defer src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js"></script>
</head>
<body>
  <div class="site-header">
    <div class="inner">
      <a class="brand" href="/">labreports.app</a>
      <nav class="site-nav" aria-label="Site">
        <a href="/about/">About</a>
        <a href="/feed/">Feed</a>
      </nav>
    </div>
  </div>
  <header>
    <div class="wrap">
      <div class="eyebrow">Lab report · Dense Associative Memory</div>
      <h1>Formalizing Dense Associative Memory in Lean</h1>
      <p class="dek">Exact one-flip energy, signal/noise decomposition, and equiprobable \( \pm 1 \) pattern coordinates.</p>
      <div class="meta">
        <span>Report route: <strong>/dam</strong></span>
        <span>Lean build: <strong>8940 jobs · successful</strong></span>
        <span>Scope: <strong>exact DAM statements preceding asymptotic capacity analysis</strong></span>
      </div>

      <figure class="hero">
        <img src="DAM.png" alt="Dense Associative Memory network illustration" />
      </figure>
      <p class="caption">Header illustration. Mathematical claims are stated and scoped in the report below.</p>
    </div>
  </header>

  <main class="wrap">
    <section>
      <h2>Reading point</h2>
      <p class="lead">This report formalizes exact Dense Associative Memory statements from the Krotov–Hopfield model before the variance, Gaussian, and asymptotic capacity arguments begin.</p>

      <div class="callout">
        <div class="math">
          \[
          E(\sigma)
          =
          -\sum_{\mu}
          F\!\left(
          \sum_i \xi_i^\mu \sigma_i
          \right),
          \qquad
          F(x)=x^n.
          \]
        </div>
        <p>The formalization separates three levels that should not be conflated:</p>
        <div class="math">
          \[
          \text{exact identities}
          \;\neq\;
          \text{probabilistic structure}
          \;\neq\;
          \text{asymptotic approximation}.
          \]
        </div>
      </div>
    </section>

    <section>
      <h2>1. Exact one-flip mechanics</h2>
      <p>Let \( \xi^\mu \) be a selected stored pattern and let \( \operatorname{flip}_i \) negate coordinate \(i\). The one-flip energy change is</p>
      <div class="math">
        \[
        \Delta E_i^\mu
        =
        E(\operatorname{flip}_i(\xi^\mu))
        -
        E(\xi^\mu).
        \]
      </div>

      <p>The relation between flip-energy gap and update gap depends on the stored bit:</p>
      <div class="math">
        \[
        \xi_i^\mu=+1
        \Longrightarrow
        \operatorname{flipEnergyGap}
        =
        \operatorname{updateGap},
        \]
        \[
        \xi_i^\mu=-1
        \Longrightarrow
        \operatorname{flipEnergyGap}
        =
        -\operatorname{updateGap}.
        \]
      </div>

      <p>These are kernel-checked by <code>flipEnergyGap_eq_updateGap_of_pos</code> and <code>flipEnergyGap_eq_neg_updateGap_of_neg</code>.</p>
    </section>

    <section>
      <h2>2. Selected-memory geometry</h2>
      <p>For a binary stored pattern, the selected-memory self-overlap is exactly</p>
      <div class="math">
        \[
        \langle \xi^\mu,\xi^\mu\rangle=N.
        \]
      </div>
      <p>Flipping one coordinate changes that selected-memory overlap to</p>
      <div class="math">
        \[
        \langle \xi^\mu,\operatorname{flip}_i(\xi^\mu)\rangle=N-2.
        \]
      </div>
      <p>The relevant Lean theorems are <code>overlap_self_of_binary</code> and <code>overlap_self_flip_of_binary</code>.</p>
    </section>

    <section>
      <h2>3. Exact signal term</h2>
      <p>For polynomial separation \(F(x)=x^n\), the selected memory contributes the exact finite signal</p>
      <div class="math">
        \[
        \boxed{
        S_n(N)=N^n-(N-2)^n
        }.
        \]
      </div>
      <p><code>self_signal_term</code> proves this identity before any large-\(N\) approximation is introduced.</p>
    </section>

    <section>
      <h2>4. Exact signal/noise decomposition</h2>
      <p>The contribution from all memories other than the selected one is represented by <code>noiseTerm</code>. The one-flip energy gap then decomposes exactly as</p>
      <div class="math">
        \[
        \boxed{
        \Delta E_i^\mu
        =
        \left[N^n-(N-2)^n\right]
        +
        \operatorname{noiseTerm}(n,\xi,\mu,i)
        }.
        \]
      </div>
      <p>This is <code>flipEnergyGap_signal_noise_decomposition</code>. No variance estimate, Gaussian approximation, or asymptotic limit is required for this equality.</p>
    </section>

    <section>
      <h2>5. Explicit random-pattern interface</h2>
      <p>For finite memory and neuron index types, the random-pattern layer is specified by the Boolean sample space</p>
      <div class="math">
        \[
        \Omega
        =
        \mathrm{Memory}\to\mathrm{Neuron}\to\mathrm{Bool},
        \]
      </div>
      <p>with a uniform PMF <code>uniformSamples</code>. Boolean coordinates are mapped to spin values by</p>
      <div class="math">
        \[
        \operatorname{toPM}(\mathrm{true})=+1,
        \qquad
        \operatorname{toPM}(\mathrm{false})=-1.
        \]
      </div>

      <p>The Boolean marginals are proved fair, and the final bridge theorem <code>patternCoordinate_pm_half</code> gives the spin-valued statement</p>
      <div class="math">
        \[
        \boxed{
        \mathbb{P}(\xi_i^\mu=+1)
        =
        \mathbb{P}(\xi_i^\mu=-1)
        =
        \frac12
        }.
        \]
      </div>
    </section>

    <section>
      <h2>Formalization map</h2>
      <div class="chain" aria-label="Formalization chain">
        <div class="step"><strong>DAM energy</strong><small><code>energy</code>, <code>polyF</code></small></div>
        <div class="step"><strong>One-flip gap</strong><small><code>flipEnergyGap</code></small></div>
        <div class="step"><strong>\(N\to N-2\)</strong><small>selected-memory overlap</small></div>
        <div class="step"><strong>Exact signal</strong><small>\(N^n-(N-2)^n\)</small></div>
        <div class="step"><strong>Signal + noise</strong><small>exact decomposition</small></div>
        <div class="step"><strong>Uniform ensemble</strong><small>fair Boolean marginal</small></div>
        <div class="step"><strong>\(\pm1\) coordinate</strong><small><code>patternCoordinate_pm_half</code></small></div>
      </div>

      <div class="boundary">
        <div class="now">
          <h3>Formalized in this report</h3>
          <p>Exact one-flip identities, selected-memory geometry, exact signal term, exact signal/noise decomposition, explicit uniform binary ensemble, and equiprobable \( \pm1 \) stored coordinates.</p>
        </div>
        <div class="next">
          <h3>Subsequent checkpoints</h3>
          <p>Distinct-coordinate independence → noise variance → Gaussian approximation → capacity scaling.</p>
        </div>
      </div>
    </section>

    <section>
      <h2>Kernel-checked theorem map</h2>
      <table>
        <thead>
          <tr><th>Mathematical statement</th><th>Lean object / theorem</th></tr>
        </thead>
        <tbody>
          <tr><td>Polynomial separation</td><td><code>polyF</code></td></tr>
          <tr><td>One-coordinate flip</td><td><code>flip</code></td></tr>
          <tr><td>Flip-energy gap</td><td><code>flipEnergyGap</code></td></tr>
          <tr><td>Positive stored bit: flip gap = update gap</td><td><code>flipEnergyGap_eq_updateGap_of_pos</code></td></tr>
          <tr><td>Negative stored bit: flip gap = −update gap</td><td><code>flipEnergyGap_eq_neg_updateGap_of_neg</code></td></tr>
          <tr><td>Selected-memory self-overlap = \(N\)</td><td><code>overlap_self_of_binary</code></td></tr>
          <tr><td>One-flip selected-memory overlap = \(N-2\)</td><td><code>overlap_self_flip_of_binary</code></td></tr>
          <tr><td>Exact signal \(N^n-(N-2)^n\)</td><td><code>self_signal_term</code></td></tr>
          <tr><td>Exact signal/noise split</td><td><code>flipEnergyGap_signal_noise_decomposition</code></td></tr>
          <tr><td>Every sampled collection is binary</td><td><code>areBinaryPatterns_patternsOf</code></td></tr>
          <tr><td>Fair Boolean coordinate</td><td><code>coordinatePMF_true</code>, <code>coordinatePMF_false</code></td></tr>
          <tr><td>Fair spin-valued coordinate</td><td><code>patternCoordinate_pm_half</code></td></tr>
        </tbody>
      </table>
    </section>

    <section>
      <h2>Boundary of the present result</h2>
      <p>The present kernel-checked boundary covers exact identities through the marginal equiprobability of each spin coordinate. Distinct-coordinate independence, noise variance, Gaussian approximation, and capacity scaling remain subsequent checkpoints.</p>
      <div class="math">
        \[
        \text{distinct-coordinate independence}
        \to
        \text{noise variance}
        \to
        \text{Gaussian approximation}
        \to
        \text{capacity scaling}.
        \]
      </div>
      <p>Keeping those stages explicit separates proved identities from stochastic assumptions and later asymptotic reasoning.</p>
    </section>

    <section>
      <h2>How to use this repo</h2>
      <p class="lead">Use the repository as a checked map from the DAM equations in the source paper to the exact kernel-checked statements currently proved in Lean.</p>

      <div class="howto">
        <div class="item">
          <div class="n">01 · Read</div>
          <strong>Start with the report boundary</strong>
          <span>Use this page to distinguish exact identities from later probabilistic and asymptotic checkpoints.</span>
        </div>
        <div class="item">
          <div class="n">02 · Inspect</div>
          <strong>Open the Lean statements</strong>
          <span><code>LeanDAM/Basic.lean</code> contains the DAM objects and update mechanics; <code>LeanDAM/Capacity.lean</code> contains the one-flip signal and random-pattern interface.</span>
        </div>
        <div class="item">
          <div class="n">03 · Check</div>
          <strong>Run the Lean build</strong>
          <span><code>lake build</code> checks the current theorem state against the pinned Lean/mathlib environment.</span>
        </div>
        <div class="item">
          <div class="n">04 · Extend</div>
          <strong>Continue at the next checkpoint</strong>
          <span>Distinct-coordinate independence is the next formal target before noise variance, Gaussian approximation, and capacity scaling.</span>
        </div>
      </div>

      <div class="repo-path"><code>lake build</code></div>

      <p>The theorem map above is the index: locate a mathematical statement, follow its Lean theorem name, then inspect the exact hypotheses and conclusion in the source file.</p>
    </section>

    <section>
      <h2>Source and verification</h2>
      <div class="sourcebox">
        <a href="https://arxiv.org/abs/1606.01164">
          <strong>Krotov &amp; Hopfield</strong>
          <span>Dense Associative Memory for Pattern Recognition · arXiv:1606.01164v2</span>
        </a>
        <a href="https://github.com/thinkthoughts/lean-dense-associative-memory">
          <strong>Lean repository</strong>
          <span>thinkthoughts/lean-dense-associative-memory</span>
        </a>
      </div>
      <p style="margin-top:16px">Current verified build state: <strong>8940 jobs completed successfully</strong>.</p>
    </section>
  </main>

  <footer class="site-footer">
    <div class="footer-inner">
      <div class="footer-statement">Admissible generalizations trail leading specifications.</div>
      <nav class="footer-links" aria-label="Related sites">
        <a href="https://labreports.app/">labreports.app</a>
        <a href="https://goodmath.app/">goodmath.app</a>
        <a href="https://climatereality.app/">climatereality.app</a>
        <a href="https://climatedemocracy.app/">climatedemocracy.app</a>
        <a href="https://danhawkley.dev/">danhawkley.dev</a>
        <a href="https://github.com/readingpoint">github.com/readingpoint</a>
      </nav>
      <div class="footer-copyright">© 2026 · Dense Associative Memory report · labreports.app/dam</div>
    </div>
  </footer>
</body>
</html>
