import React from 'react';

/**
 * A question stem is authored as nodes, not JSX, so content stays data.
 * STIX Two Math is reserved for set mathematics -- a `math` node is the only
 * thing that gets it.
 */
export function Stem({ nodes = [] }) {
  return (
    <>
      {nodes.map((n, i) => (
        n.type === 'math'
          ? <span key={i} style={{ fontFamily: 'var(--font-math)' }}>{n.value}</span>
          : <React.Fragment key={i}>{n.value}</React.Fragment>
      ))}
    </>
  );
}
