# Rake — App Store Optimization (ASO) Master Strategy

This document details keyword ranking architecture, metadata optimization rules, Product Page Optimization (PPO) testing, and Custom Product Pages (CPP) for **Rake** across European storefronts.

---

## 1. Algorithmic Principles & Store Differences

### Apple App Store
- **Indexed Fields**: App Title (30 chars, weight: 10/10), Subtitle (30 chars, weight: 8/10), Keyword Field (100 chars, weight: 6/10), In-App Purchase display titles.
- **Ignored Fields**: Long description is **not indexed** by Apple’s organic search algorithm (only impacts conversion).
- **Keyword Field Optimization Rules**:
  - Separate terms strictly with single commas and **zero spaces** (e.g., `zen,sand,garden,draw,relax`).
  - Do not duplicate keywords already present in the Title or Subtitle (waste of characters).
  - Use singular forms (Apple algorithms index plural forms automatically in Western European languages).
  - Do not include trademarked names, category names, or the word "app".

### Google Play Store
- **Indexed Fields**: App Title (50 chars), Short Description (80 chars), Long Description (4000 chars), Developer Name, Package URL.
- **Keyword Density Optimization**:
  - Primary keywords should appear `4 to 5 times` naturally across the 4000-character description (target density: `1.2% – 1.8%`).
  - Keyword stuffing (`> 2.5%`) triggers algorithmic penalties or store listing rejection.

---

## 2. Multi-Language Keyword Matrix (All 10 Languages)

| Language | Primary High-Volume Keywords | Secondary Relevance Keywords | Long-Tail Mindfulness Keywords |
|---|---|---|---|
| **English (en)** | zen garden, sand garden, relax game, drawing app | calm, mindfulness, rake, ASMR, anti stress | relaxing sand drawing, pocket zen garden, quiet meditation sandbox |
| **German (de)** | zengarten, sandgarten, entspannung, malen | achtsamkeit, ruhe, harke, antistress, meditieren | zen garten app, beruhigende spiele, sand zeichnen ohne timer |
| **French (fr)** | jardin zen, sable zen, jeu relaxant, dessin | méditation, sérénité, râteau, anti stress, calme | dessiner dans le sable, jardin japonais virtuel, pause détente |
| **Spanish (es)** | jardín zen, arena zen, juego relajante, pintar | meditación, calma, rastrillo, antiestrés, paz | dibujar en arena, jardín de arena relajante, terapia antiestrés |
| **Italian (it)** | giardino zen, sabbia zen, gioco rilassante | meditazione, calma, rastrello, antistress, quiete | disegnare nella sabbia, giardino zen giapponese, momento di pausa |
| **Portuguese (pt)** | jardim zen, areia zen, jogo relaxante, calma | meditação, paz, rastelo, antiestresse, desenhar | desenhar na areia, jardim japonês de bolso, momento de tranquilidade |
| **Dutch (nl)** | zentuin, zandtuin, ontspannen, rustgevend | meditatie, rust, hark, antistress, tekenen | zentuin op je telefoon, rustgevende spelletjes, zand tekenen |
| **Polish (pl)** | ogród zen, piasek zen, relaks, antystres | medytacja, spokój, grabie, rysowanie, wyciszenie | japoński ogród w telefonie, relaksujące rysowanie, spokojne gry |
| **Swedish (sv)** | zenträdgård, sandträdgård, avkoppling, rita | meditation, lugn, kratta, antistress, ro | rita i sanden, zen trädgård mobil, lugna meditativa spel |
| **Turkish (tr)** | zen bahçesi, kum bahçesi, rahatlatıcı oyun | meditasyon, sakinlik, tırmık, antistres, çizim | kumda çizim yapma, huzurlu japon bahçesi, rahatlama oyunu |

---

## 3. Product Page Optimization (PPO) A/B Testing Schedule

Run consecutive 14-day PPO tests in App Store Connect and Google Play Store Experiments. Minimum sample size: 2,500 impressions per variant.

```
[ W1 - W2 ] Test 1: Master Icon Test (Sand Swirl vs. River Pebble)
[ W3 - W4 ] Test 2: Hero Screenshot 1 Headline ("Find Your Quiet" vs. "Breathe & Draw")
[ W5 - W6 ] Test 3: Screenshot Color Tone (Warm Natural Cream vs. Deep Basalt Slate)
[ W7 - W8 ] Test 4: Video Preview Poster Frame Thumbnail
```

### Test 1 Hypothesis & Metrics
- **Hypothesis**: An icon showing a recognizable river stone resting inside concentric sand grooves will achieve a `12%` higher conversion rate than an abstract sand swirl because it conveys immediate tactile grounding.
- **Target Metric**: Product Page View to Install Conversion Rate (CVR). Baseline target: `24.0%`.

---

## 4. Custom Product Pages (CPP) Strategy

Create tailored Custom Product Pages in App Store Connect with custom URLs and matched screenshots:

1. **CPP 1: TikTok ASMR Audience (`/app/rake-zen?ppid=asmr`)**:
   - Hero Screenshot: Emphasizes sound texture, crisp gravel grooves, and haptics.
   - Text overlay: *"Crisp Sand Audio & Gentle Haptics"*.
2. **CPP 2: Study / Remote Work Productivity (`/app/rake-zen?ppid=study`)**:
   - Hero Screenshot: Shows clean iPad on a wooden desk next to coffee.
   - Text overlay: *"The Perfect 2-Minute Screen Pause"*.
3. **CPP 3: Cozy Gamers (`/app/rake-zen?ppid=cozy`)**:
   - Hero Screenshot: Displays the warm Kyoto Moss and Sakura Blossom theme.
   - Text overlay: *"No Timers. No Pressure. Pure Cozy Sandbox"*.

---

## 5. Recommended ASO Analytics & Tracking Stack

- **AppTweak**: Primary tool for European keyword rankings, search volume estimation, and share of voice (SOV) tracking across all 10 EU localizations.
- **App Store Connect Analytics**: Conversion rate funnel (Impressions → Product Page Views → Installs).
- **Google Play Console Store Analysis**: Organic search vs. Play Store explore breakdown and country-specific benchmark comparisons.

