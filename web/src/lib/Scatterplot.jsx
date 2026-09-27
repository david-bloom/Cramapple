import React from 'react';

/**
 * The question's own data, drawn as inline SVG. There is no chart library in
 * this product and none should be added -- graphics are the question's data,
 * on a purple-tint field with purple axis labels, and any called-out mark
 * (an influence point, an outlier) is yellow.
 *
 * Coordinates are authored directly in the 640x200 viewBox, the same space the
 * design templates use, so a content author places marks by eye.
 */
export function Scatterplot({
  points = [],
  fitLine,
  highlight,
  xLabel,
  yLabel,
  height,
  label = 'Scatterplot'
}) {
  return (
    <svg
      viewBox="0 0 640 200"
      width="100%"
      height={height || '100%'}
      preserveAspectRatio="xMidYMid meet"
      role="img"
      aria-label={label}
    >
      <line x1="54" y1="168" x2="616" y2="168" stroke="var(--purple-500)" strokeWidth="1.5" />
      <line x1="54" y1="168" x2="54" y2="14" stroke="var(--purple-500)" strokeWidth="1.5" />

      {fitLine && (
        <line
          x1={fitLine[0][0]} y1={fitLine[0][1]} x2={fitLine[1][0]} y2={fitLine[1][1]}
          stroke="var(--purple-600)" strokeWidth="2"
        />
      )}

      {points.map(([x, y], i) => (
        <circle key={i} cx={x} cy={y} r="4.5" fill="var(--purple-500)" />
      ))}

      {highlight && (
        <>
          <circle
            cx={highlight.x} cy={highlight.y} r="6"
            fill="var(--yellow-500)" stroke="var(--yellow-700)" strokeWidth="1.5"
          />
          <text
            x={highlight.x + 8} y={highlight.y - 4}
            fontSize="11" fill="var(--yellow-700)" fontFamily="var(--font-body)" fontWeight="700"
          >{highlight.label}</text>
        </>
      )}

      {xLabel && (
        <text x="335" y="190" textAnchor="middle" fontSize="12" fill="var(--purple-500)" fontFamily="var(--font-body)">
          {xLabel}
        </text>
      )}
      {yLabel && (
        <text
          x="16" y="92" textAnchor="middle" fontSize="12" fill="var(--purple-500)"
          fontFamily="var(--font-body)" transform="rotate(-90 16 92)"
        >{yLabel}</text>
      )}
    </svg>
  );
}
