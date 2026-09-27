import { useEffect } from 'react';

/**
 * Close an overlay on Escape. Both overlays in this product (the study map and
 * the deep dive) cover the plate below the breadcrumb, so a keyboard user needs
 * a way out that is not the mouse.
 */
export function useEscapeToClose(open, onClose) {
  useEffect(() => {
    if (!open || !onClose) return undefined;
    const onKey = (e) => { if (e.key === 'Escape') onClose(); };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [open, onClose]);
}
