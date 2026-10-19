# Period

A private cycle tracker that runs in the browser and installs on an iPhone home screen. No account and no server. Your data never leaves your device.

This repository documents how it was built. It contains code only, never anyone's data.

## What it does

- Log periods, flow, pain, mood, symptoms and notes.
- Predicts the next period as a window, and shows an estimated fertile window in the calendar.
- Insights and multi-year trends (12 months, 3 years, all time) calculated from your own logs.
- Cycle sync ideas for food, exercise, focus and love, each with sources and an honest note on how strong the evidence is.
- Export and import your data as text.

It is not a medical device and not a way to avoid pregnancy. Predictions come from your own past cycles and are deliberately wide.

## Run it locally

You need Python 3 (any recent version) or any static file server.

```bash
git clone <your-repo-url> period
cd period
python3 -m http.server 8000
```

Open http://localhost:8000. To try it with invented data, tap **Try with sample data** on the Home screen.

The app is a single `index.html` plus a manifest, a small service worker and icons. There is no build step and no dependencies.

## Put it on your phone

The page must be served over HTTPS to install on an iPhone. GitHub Pages does that for free:

1. Push this repository to GitHub.
2. Repository **Settings > Pages**, set the source to your main branch, root folder.
3. Open the Pages address in **Safari** on the iPhone.
4. Tap **Share**, then **Add to Home Screen**.

The installed app keeps its own storage, separate from Safari. Start logging in the installed app, or move data across with Export and Import (Periods tab, at the bottom).

## Privacy model

- **Where data lives:** the browser's `localStorage`, under the key `cycletracker.v1`, on your device only. It is not in this repository and not on any server.
- **Network:** the app makes no requests with your data. The only outside request is the optional font stylesheet from Google Fonts, which tells Google your IP address. To avoid it, delete the `fonts.googleapis.com` line in `index.html`. The app falls back to a system serif.
- **Service worker:** `sw.js` caches the app files so it works offline. It never touches your data.
- **Backups:** Export shows your data as text for you to copy. Nothing is downloaded or uploaded automatically.

## Keeping data out of the repository

If you fork this or build something similar, keep personal data out of git:

1. `.gitignore` blocks the usual places data ends up: `*.backup.json`, `period-export*`, `*.db`, `*.sqlite`, `data/`, `private/`.
2. Install the pre-commit check once per clone:
   ```bash
   scripts/install-hooks.sh
   ```
   It stops a commit if a file looks like a Period backup or a database. Run it by hand with `scripts/check-no-data.sh`.
3. Take screenshots only with the sample data.
4. Never paste an export into an issue or a pull request.
5. If data was committed by mistake, deleting it in a new commit is not enough, because it stays in the history. Rewrite the history (for example with `git filter-repo`) and treat anything pushed as public.

## How predictions work

All numbers come from `calc()` in `index.html`.

- Cycle length is the gap between period start dates. Gaps under 15 or over 60 days are ignored.
- The estimate uses the last 6 valid cycles: average length and standard deviation.
- **Next period window:** last start + average length, plus or minus `max(2, ceil(sd))` days. With fewer than 2 cycles it assumes 28 days and plus or minus 3.
- **Fertile window estimate:** ovulation is assumed about 14 days before the next period. The window runs from 19 days before the predicted start to 14 days before it, widened by the same margin.
- **Confidence:** Good needs 6 cycles with sd of 2 or less. Moderate needs 3. Otherwise Low.

## Project layout

```
index.html              the whole app: styles, markup, logic
manifest.webmanifest    install metadata
sw.js                   offline cache for the app files
icons/                  app icon (PNG, 180, 192 and 512 px)
scripts/                data check and pre-commit hook installer
docs/screenshots/       screenshots made from sample data
```

## Design

Newsreader serif for headings and numbers, system sans for text, a sky-blue palette with rose for periods and lilac for the fertile estimate, light and dark themes, and a floating dock. The icon is a five-loop interlaced knot in red on warm white, by the project author.

## Sources for the Cycle sync section

Listed with links inside the app (Periods tab) and summarised here: McNulty et al. 2020 (exercise), Jang, Zhang and Elfenbein 2025 (cognition), Roney 2015 (desire), NIH Office of Dietary Supplements iron fact sheet, WebMD and Medical News Today on cycle syncing.

## Licence

[PolyForm Noncommercial 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0). You may use, study, change and share this code for personal, educational, research and other noncommercial purposes. You may not sell it or use it commercially. The full terms are in `LICENSE`.

This is a source-available licence, not an open-source one. The Period name and the icon artwork in `icons/` are not covered by the code licence and may not be reused in another product.
