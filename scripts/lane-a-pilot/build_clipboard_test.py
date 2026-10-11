"""Build a local page that puts the REAL Copy-notes payload on the clipboard.

Purpose: answer, in one paste session, what actually survives a Google Docs
paste — before we build the export the wrong way round.

It writes the same two clipboard flavours production would (`text/html` and
`text/plain`, via `ClipboardItem`, exactly as `copyDeepDive` does), with the
Figures section built by `export_figures.py`. Three variants, so one sitting
settles every open question:

  A  inline <svg>        what the pilot emits today
  B  data: URI PNG       rasterised in the browser, no hosting needed
  C  text only           the control: description + labelled parts, no drawing

If B pastes, we never need public raster hosting. If only C survives, the
notice stays and hosting becomes the real fix. If A works, delete the notice.

Needs a secure context for the async clipboard API, so it is served over
localhost rather than opened as a file.
"""
from __future__ import annotations

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import export_figures as X  # noqa: E402
import render as R  # noqa: E402

P = X.P
H2 = "font-family:Arial,sans-serif;font-size:16pt;line-height:1.25;margin:0 0 7pt;"


def notes_prose() -> tuple[str, str]:
    """A realistic Lesson Notes body, so the paste is tested in context."""
    secs = [
        ("Core idea", "A titration curve plots pH against the volume of titrant added. Students read "
                      "it to find the equivalence point and, for weak acids, the half-equivalence point."),
        ("How points are lost", "Confusing the half-equivalence point with the equivalence point. "
                                "pKa is read at the half-equivalence point."),
    ]
    h = (f'<h1 style="font-family:Arial,sans-serif;font-size:22pt;line-height:1.25;margin:0 0 7pt;">'
         f"Titration curves</h1>"
         f'<p style="{P}">AP Chemistry · Unit 8 · Topic 8.5</p>')
    t = ["AP Chemistry · Unit 8 · Topic 8.5", "", "Titration curves", ""]
    for title, body in secs:
        h += f'<h3 style="{X.H3}">{title}</h3><p style="{P}">{body}</p>'
        t += [title, body, ""]
    return h, "\n".join(t)


def main() -> None:
    specs = {k: v for k, v in json.load(open(os.path.join(HERE, "specs.json"))).items()
             if not k.startswith("_")}
    figs = [specs["chem-titration"], specs["chem-approach-equilibrium"]]

    prose_h, prose_t = notes_prose()
    fig_h, fig_t = X.figures_section(figs, "full")
    html_inline = prose_h + fig_h
    plain = prose_t + "\n" + fig_t

    # Variant C: the same section with the drawings removed entirely.
    text_only = prose_h + f'<h2 style="{H2}">Figures</h2>'
    for f in figs:
        text_only += (f'<h3 style="{X.H3}">{f["title"]}</h3>'
                      f'<p style="{P}">{f["caption"]}</p>'
                      f'<p style="{P}"><b>What the figure shows.</b> {X.esc(f["alt"])}</p>'
                      f'<p style="{P}"><b>Labelled parts.</b></p><ul>'
                      + "".join(f'<li style="{P}">{X.esc(l)}</li>' for l in f["labels"]) + "</ul>")

    svgs = [R.render(f, "full") for f in figs]
    payload = {"inline": html_inline, "textonly": text_only, "plain": plain,
               "svgs": svgs, "titles": [f["title"] for f in figs],
               "alts": [f["alt"] for f in figs], "captions": [f["caption"] for f in figs],
               "h3": X.H3, "p": P, "h2": H2}

    page = """<!doctype html><html><head><meta charset="utf-8">
<title>Copy-notes clipboard test</title>
<style>
 body{font:15px/1.5 system-ui;margin:0;background:#FAFAF8;color:#151515}
 .wrap{max-width:860px;margin:0 auto;padding:28px 20px 60px}
 h1{font-size:22px;margin:0 0 6px} .sub{color:#6E6E6E;margin:0 0 22px}
 .btns{display:flex;gap:10px;flex-wrap:wrap;margin:0 0 10px}
 button{font:600 15px system-ui;padding:11px 16px;border:1px solid #151515;background:#fff;cursor:pointer}
 button:hover{background:#151515;color:#fff}
 #s{min-height:22px;margin:0 0 20px;font-weight:600}
 ol{padding-left:20px} li{margin:0 0 7px}
 .card{background:#fff;border:1px solid #D8D8D3;padding:18px;margin:18px 0}
 .card h2{font-size:15px;margin:0 0 10px;text-transform:uppercase;letter-spacing:.06em}
 svg{max-width:100%;height:auto}
 code{background:#eee;padding:1px 5px}
</style></head><body><div class="wrap">
<h1>Copy-notes clipboard test</h1>
<p class="sub">Puts the real Copy-notes payload on your clipboard — same two flavours
(<code>text/html</code> + <code>text/plain</code>) and the same <code>ClipboardItem</code> call
production would use. Paste each one into a Google Doc.</p>

<div class="btns">
 <button onclick="go('inline')">A · Copy with inline SVG</button>
 <button onclick="go('png')">B · Copy with PNG images</button>
 <button onclick="go('textonly')">C · Copy text only</button>
</div>
<p id="s"></p>

<div class="card"><h2>What to look for</h2><ol>
<li><b>A</b> pastes with both diagrams visible → inline SVG is fine, we delete the warning.</li>
<li><b>A</b> loses the diagrams but <b>B</b> keeps them → rasterise at copy time; no hosting needed.</li>
<li>Both A and B lose them → the warning stays and public raster URLs become the real fix.</li>
<li>In every case the written description and labelled parts should survive — that is <b>C</b>.</li>
</ol></div>

<div class="card"><h2>What is in the copy</h2><div id="prev"></div></div>
<canvas id="cv" style="display:none"></canvas>
</div>
<script>
const D = PAYLOAD;
document.getElementById('prev').innerHTML = D.inline;
const say = (m, ok) => { const s = document.getElementById('s');
  s.textContent = m; s.style.color = ok === false ? '#8a2f3f' : '#1f56a8'; };

function svgToPng(svg){ return new Promise((res, rej) => {
  const img = new Image();
  img.onload = () => { const c = document.getElementById('cv');
    c.width = img.width * 2; c.height = img.height * 2;
    const x = c.getContext('2d'); x.fillStyle = '#FAFAF8';
    x.fillRect(0, 0, c.width, c.height); x.drawImage(img, 0, 0, c.width, c.height);
    res(c.toDataURL('image/png')); };
  img.onerror = rej;
  img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svg)));
}); }

async function buildPng(){
  let h = D.inline.split('<h2')[0] + '<h2 style="' + D.h2 + '">Figures</h2>';
  for (let i = 0; i < D.svgs.length; i++){
    const url = await svgToPng(D.svgs[i]);
    h += '<h3 style="' + D.h3 + '">' + D.titles[i] + '</h3>'
      +  '<p style="' + D.p + '">' + D.captions[i] + '</p>'
      +  '<p style="' + D.p + '"><img src="' + url + '" width="620" alt="' + D.alts[i] + '"></p>'
      +  '<p style="' + D.p + '"><b>What the figure shows.</b> ' + D.alts[i] + '</p>';
  }
  return h;
}

async function go(kind){
  try{
    say('Preparing…');
    const html = kind === 'png' ? await buildPng() : (kind === 'inline' ? D.inline : D.textonly);
    await navigator.clipboard.write([new ClipboardItem({
      'text/html': new Blob([html], {type:'text/html'}),
      'text/plain': new Blob([D.plain], {type:'text/plain'})
    })]);
    say('Copied variant ' + kind.toUpperCase() + ' (' + html.length.toLocaleString()
        + ' chars of HTML). Now paste into a Google Doc.');
  }catch(e){ say('Copy failed: ' + e + ' — this page must be served over localhost, not file://', false); }
}
</script></body></html>"""
    page = page.replace("PAYLOAD", json.dumps(payload))
    out = os.path.join(HERE, "out", "clipboard-test.html")
    open(out, "w").write(page)
    print(f"wrote {out}  ({len(page)//1024} KB, {len(figs)} figures)")


if __name__ == "__main__":
    main()
