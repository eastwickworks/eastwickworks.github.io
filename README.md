# Eastwick Works — portfolio site

**Live at: https://eastwickworks.github.io**
(GitHub repo: https://github.com/eastwickworks/eastwickworks.github.io)

Art portfolio of Geert Schoors. A single static page (`index.html`), the artwork
list (`works.js`) and the images — no build step, no framework, nothing to install.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole site: layout, styling, English + Dutch texts, lightbox. |
| `works.js` | The artwork list. **This is the only file you touch to add works.** |
| `images/large/` | Full-view images, max 1600 px, named `slug.jpg`. |
| `images/thumb/` | Grid thumbnails, max 640 px, same names. |
| `images/logo.png`, `images/hero.jpg` | Logo and the ‘True Colors’ hero image. |
| `add-thumbs.ps1` | Shrinks new photos and creates missing thumbnails automatically. |
| `serve.ps1` | Local preview: run it, then open http://localhost:8321 |

## Adding new works (every few months)

The easy way: start Claude Code in this folder and say
*"Add these works: [photos + titles + dimensions + category]"* — it does all of the below.

By hand:

1. Copy the photo to `images/large/my-new-work.jpg` (filename = slug: lowercase, dashes).
2. Run `powershell -ExecutionPolicy Bypass -File add-thumbs.ps1`
   (shrinks it if oversized and creates the thumbnail).
3. Add one line to `WORKS` in `works.js` at the position where it should appear
   (order in the file = order on the site, best works first):
   ```js
   { cat: "color", slug: "my-new-work", title: "My New Work", h: "Height: 42 cm ; 16.5 in", w: "Width: 29.7 cm ; 11.7 in", sold: false },
   ```
   `cat` is `"color"`, `"bw"` or `"sketch"`. Set `sold: true` to show a SOLD marker.
   Leave `h`/`w` as `""` if unknown.
4. Publish (see below).

To change the works shown on the home page, edit the `FEATURED` list at the bottom
of `works.js`.

Texts (bio, intro, contact) live in `index.html` — English and Dutch versions are
side by side in the `I18N` object near the bottom.

## Publishing (GitHub Pages)

The site is a git repository. After any change:

```
git add -A
git commit -m "Add new works"
git push
```

The site updates automatically a minute later. Claude Code can do this for you too.

## Visitor statistics

The site uses [GoatCounter](https://www.goatcounter.com) — free, no cookies, GDPR-friendly.
One-time setup: create an account at https://www.goatcounter.com/signup with the code
`eastwickworks` (so the URL becomes `eastwickworks.goatcounter.com`).
After that, view your visitor numbers any time at **https://eastwickworks.goatcounter.com**.
Until the account exists the counter silently does nothing — the site is unaffected.
