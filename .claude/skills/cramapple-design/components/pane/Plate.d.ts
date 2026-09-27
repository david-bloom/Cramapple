import * as React from 'react';

/**
 * The fixed 1440×900 frame. It never scrolls and never holds a collapsed region — size content to fit or cut copy.
 * @startingPoint section="Plate" subtitle="The fixed 1440×900 three-pane frame" viewport="1440x900"
 */
export interface PlateProps {
  /** The single 10px line at the bottom of the plate. */
  caption?: React.ReactNode;
  /** Masthead, Breadcrumb, a PlateGrid, and any overlays. */
  children?: React.ReactNode;
  style?: React.CSSProperties;
}
export declare function Plate(props: PlateProps): JSX.Element;

/** The 352 / fluid / 324 three-pane grid, 20px gaps inside 40px gutters. */
export interface PlateGridProps { children?: React.ReactNode; style?: React.CSSProperties }
export declare function PlateGrid(props: PlateGridProps): JSX.Element;
