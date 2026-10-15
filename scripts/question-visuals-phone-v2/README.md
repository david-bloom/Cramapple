**LIVE: six v2 paths committed 2026-10-15 11:30:14UTC; independent final Pass and 12 desktop / 320 CSS views verified. See `production-release.json` and the bounded certificate in docs/qa.**

# Six compact visual revisions for narrow phones

Live 320 CSS-pixel browser measurement found each question image only 230.6667px wide after existing pane padding. The previous 22px artwork labels scaled to 14.93px. This revision uses 26px meaningful labels on the same 340px artwork, giving 17.59px at the conservative minimum image width of 230px. Graph tick labels remain excepted under DECISION-0120.

All six source specifications, equations, points, curves, ion/particle counts, volume labels and accessible descriptions are unchanged. The old Chemistry OHT footer is moved below the lower box; the new Chemistry footer is wrapped without changing its words. Ion-label bounds are checked inside circles. Titles, axes and captions are checked inside the canvas and against text overlap; the OHT footer clears both boxes. SVG and 2× PNG hashes, renderer/engine/spec hashes and immutable v2 paths are pinned by the manifest. Rebuild is byte-identical. This uses the prior graph/particle engine at `../question-visuals-pilot/render.py`; no new frontend, schema or runtime renderer.

All current v1 metadata and bytes are retained. The six-path transaction guards each current image path, complete reviewed source normalized only for image_path, published status and existing approvals; it preserves question/scoring columns, choices, taxonomy/labels and visual decisions. Only new approved metadata and image paths are written. Recovery swaps the six paths back to their approved v1 revisions and retains both revisions/metadata. Rehearse both operations with ROLLBACK before claiming the recovery path exercised.

Meaningful glyphs are measured against the actual image width, not the browser viewport override. The browser was at 75% zoom, so a requested 240 device-pixel viewport measured 320 CSS pixels. No browser zoom preference was changed. Final evidence must record measured CSS width, complete decoded image and no horizontal document overflow.
