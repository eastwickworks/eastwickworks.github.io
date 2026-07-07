# Eastwick Works portfolio site

Static art-portfolio site for Geert Schoors (the user's father-figure/family; user = Elias).
No build step. `index.html` (layout, CSS, JS, EN+NL texts in the `I18N` object) +
`works.js` (artwork data) + `images/`.

## Common task: adding new artworks

The user brings photos + titles/dimensions in batches every few months.

1. Save/copy each photo to `images/large/<slug>.jpg` (slug: lowercase-with-dashes from title).
2. Run `powershell -ExecutionPolicy Bypass -File add-thumbs.ps1` — shrinks oversized
   large images to 1600px and generates missing 640px thumbs.
3. Append one entry per work to `WORKS` in `works.js`, at the position the user wants
   (file order = display order; the user curates best-first). Categories: `color`, `bw`, `sketch`.
   Dimension strings follow the literal format `Height: 42 cm ; 16.5 in` / `Width: ...`.
4. Preview: launch config `eastwick-works` (serve.ps1, port 8321), verify grid + lightbox.
5. Commit and `git push` — GitHub Pages redeploys automatically.

## Conventions

- Titles are stored WITHOUT surrounding quotes; the site renders ‘…’ around them.
- Keep the brand look: paper `#F8F4F1`, ink `#241812`, brown `#411E06`, sienna accent
  `#A05222` used sparingly. Fonts: Cormorant Garamond + Jost.
- Both languages must stay in sync: any new UI text goes into `I18N.en` and `I18N.nl`.
- Visitor stats: GoatCounter (`eastwickworks.goatcounter.com`), script tag at the
  bottom of index.html.
