/* @ds-bundle: {"format":4,"namespace":"CramAppleDesignSystem_c1541a","components":[{"name":"ActionButton","sourcePath":"components/actions/ActionButton.jsx"},{"name":"ActionRow","sourcePath":"components/actions/ActionRow.jsx"},{"name":"RadioOptionRow","sourcePath":"components/choice/RadioOptionRow.jsx"},{"name":"FeedbackCard","sourcePath":"components/feedback/FeedbackCard.jsx"},{"name":"VerdictChip","sourcePath":"components/feedback/VerdictChip.jsx"},{"name":"HintGate","sourcePath":"components/hint/HintGate.jsx"},{"name":"Breadcrumb","sourcePath":"components/navigation/Breadcrumb.jsx"},{"name":"Masthead","sourcePath":"components/navigation/Masthead.jsx"},{"name":"StudyMap","sourcePath":"components/navigation/StudyMap.jsx"},{"name":"Wordmark","sourcePath":"components/navigation/Wordmark.jsx"},{"name":"DeepDiveOverlay","sourcePath":"components/overlay/DeepDiveOverlay.jsx"},{"name":"PaneShell","sourcePath":"components/pane/PaneShell.jsx"},{"name":"Plate","sourcePath":"components/pane/Plate.jsx"},{"name":"PlateGrid","sourcePath":"components/pane/Plate.jsx"},{"name":"ScoreChip","sourcePath":"components/pane/ScoreChip.jsx"},{"name":"AnswerField","sourcePath":"components/question/AnswerField.jsx"},{"name":"GraphFrame","sourcePath":"components/question/GraphFrame.jsx"},{"name":"QuestionHeader","sourcePath":"components/question/QuestionHeader.jsx"},{"name":"RubricCriterionRow","sourcePath":"components/rubric/RubricCriterionRow.jsx"}],"sourceHashes":{"components/actions/ActionButton.jsx":"01695b1357d9","components/actions/ActionRow.jsx":"c8f665cb78ab","components/choice/RadioOptionRow.jsx":"1e0fac486e8f","components/feedback/FeedbackCard.jsx":"330f50bd2a1d","components/feedback/VerdictChip.jsx":"3c966c580299","components/hint/HintGate.jsx":"ffb8f45f9dea","components/navigation/Breadcrumb.jsx":"aca01b842360","components/navigation/Masthead.jsx":"55f90007f656","components/navigation/StudyMap.jsx":"2cff8f2e2ead","components/navigation/Wordmark.jsx":"a8897e25671d","components/overlay/DeepDiveOverlay.jsx":"ced3bf1fe0ba","components/pane/PaneShell.jsx":"41df42361221","components/pane/Plate.jsx":"db42cd4d0380","components/pane/ScoreChip.jsx":"b1beb6a76fe9","components/question/AnswerField.jsx":"57d9f459ad0e","components/question/GraphFrame.jsx":"5d251c73cd1c","components/question/QuestionHeader.jsx":"a1b450f19b42","components/rubric/RubricCriterionRow.jsx":"d85561526dd1","ui_kits/frq/screen.jsx":"e2ea7a968522","ui_kits/home/screen.jsx":"8897b25b1164","ui_kits/mcq/screen.jsx":"b09f52581d70","ui_kits/open-hand-frq/screen.jsx":"08748f91b9cd","ui_kits/open-hand-mcq/screen.jsx":"dc8f7567a2e2"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.CramAppleDesignSystem_c1541a = window.CramAppleDesignSystem_c1541a || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// components/actions/ActionButton.jsx
try { (() => {
const BASE = {
  fontFamily: 'var(--font-body)',
  fontSize: 'var(--type-control-size)',
  lineHeight: 'var(--type-control-line)',
  fontWeight: 'var(--type-control-weight)',
  borderRadius: 'var(--radius-all)',
  padding: 'var(--control-pad-y) var(--control-pad-x)'
};
function ActionButton({
  variant = 'primary',
  disabled = false,
  onClick,
  children,
  type = 'button'
}) {
  let s;
  if (variant === 'primary') {
    s = {
      ...BASE,
      background: disabled ? 'var(--action-primary-disabled)' : 'var(--action-primary-bg)',
      color: 'var(--action-primary-fg)',
      border: '1px solid transparent'
    };
  } else if (variant === 'hint') {
    s = {
      ...BASE,
      background: 'var(--action-hint-bg)',
      color: 'var(--action-hint-fg)',
      border: '1px solid var(--yellow-600)'
    };
  } else if (variant === 'quiet') {
    s = {
      ...BASE,
      background: 'var(--action-quiet-bg)',
      color: 'var(--action-quiet-fg)',
      border: 'var(--border-quiet)'
    };
  } else {
    s = {
      ...BASE,
      background: 'none',
      border: 0,
      padding: '11px 2px',
      color: 'var(--action-link-fg)',
      textDecoration: 'underline',
      textUnderlineOffset: 'var(--underline-offset)',
      textDecorationThickness: 'var(--underline-thickness)'
    };
  }
  return /*#__PURE__*/React.createElement("button", {
    type: type,
    disabled: disabled,
    onClick: onClick,
    style: {
      ...s,
      cursor: disabled ? 'not-allowed' : 'pointer'
    }
  }, children);
}
Object.assign(__ds_scope, { ActionButton });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/actions/ActionButton.jsx", error: String((e && e.message) || e) }); }

// components/actions/ActionRow.jsx
try { (() => {
function ActionRow({
  primary,
  secondary,
  note,
  align = 'split'
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-4)',
      justifyContent: align === 'split' ? 'space-between' : 'flex-start',
      borderTop: '1px solid var(--rule-divider)',
      paddingTop: 'var(--space-4)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-4)'
    }
  }, primary, secondary), note && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-count-size)',
      lineHeight: 'var(--type-count-line)',
      color: 'var(--text-quiet)'
    }
  }, note));
}
Object.assign(__ds_scope, { ActionRow });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/actions/ActionRow.jsx", error: String((e && e.message) || e) }); }

// components/choice/RadioOptionRow.jsx
try { (() => {
function RadioOptionRow({
  letter,
  children,
  selected = false,
  verdict,
  showVerdict = false,
  eliminated = false,
  explanation,
  note,
  onSelect,
  readCount
}) {
  const isCorrect = verdict === 'correct';
  const tag = showVerdict && verdict ? isCorrect ? {
    text: 'Correct',
    fg: 'var(--status-correct)',
    bg: 'var(--blue-050)',
    bd: 'var(--blue-100)'
  } : {
    text: 'Distractor',
    fg: 'var(--status-incorrect)',
    bg: 'var(--maroon-050)',
    bd: 'var(--maroon-300)'
  } : null;
  return /*#__PURE__*/React.createElement("div", {
    role: "radio",
    "aria-checked": selected,
    tabIndex: 0,
    onClick: eliminated ? undefined : onSelect,
    style: {
      display: 'block',
      width: '100%',
      textAlign: 'left',
      background: 'var(--surface-pane)',
      border: selected ? 'var(--border-selected)' : '1px solid var(--rule-300)',
      borderRadius: 'var(--radius-all)',
      padding: '12px var(--row-pad-x)',
      cursor: eliminated ? 'not-allowed' : 'pointer',
      opacity: eliminated ? 'var(--strike-opacity)' : 1
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'flex-start',
      gap: 'var(--space-3)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    "aria-hidden": "true",
    style: {
      flex: '0 0 auto',
      width: '18px',
      height: '18px',
      marginTop: '3px',
      borderRadius: 'var(--radius-dot)',
      border: selected ? '2px solid var(--status-selected-border)' : '2px solid var(--rule-400)',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center'
    }
  }, selected && /*#__PURE__*/React.createElement("span", {
    style: {
      width: '8px',
      height: '8px',
      borderRadius: 'var(--radius-dot)',
      background: 'var(--status-selected-dot)'
    }
  })), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: '0 0 auto',
      fontFamily: 'var(--font-body)',
      fontWeight: 700,
      fontSize: 'var(--type-option-size)',
      lineHeight: 'var(--type-option-line)',
      color: eliminated ? 'var(--status-eliminated)' : 'var(--text-secondary)',
      width: '16px'
    }
  }, letter), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: '1 1 auto',
      fontSize: 'var(--type-option-size)',
      lineHeight: 'var(--type-option-line)',
      fontWeight: selected ? 'var(--type-body-strong-weight)' : 400,
      color: eliminated ? 'var(--status-eliminated)' : 'var(--text-body)',
      textDecoration: eliminated ? 'line-through' : 'none'
    }
  }, children), tag && /*#__PURE__*/React.createElement("span", {
    style: {
      flex: '0 0 auto',
      fontSize: 'var(--type-count-size)',
      fontWeight: 'var(--type-count-weight)',
      letterSpacing: '.06em',
      textTransform: 'uppercase',
      color: tag.fg,
      background: tag.bg,
      border: `1px solid ${tag.bd}`,
      padding: 'var(--chip-pad-y) var(--chip-pad-x)',
      borderRadius: 'var(--radius-all)'
    }
  }, tag.text)), explanation && /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: '10px',
      marginLeft: '46px',
      borderLeft: `var(--border-cap) solid ${isCorrect ? 'var(--blue-600)' : 'var(--maroon-500)'}`,
      paddingLeft: '12px'
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      margin: 0,
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      color: 'var(--text-secondary)'
    }
  }, explanation), note && /*#__PURE__*/React.createElement("p", {
    style: {
      margin: '6px 0 0',
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      color: 'var(--text-body)'
    }
  }, /*#__PURE__*/React.createElement("strong", {
    style: {
      fontWeight: 'var(--type-body-strong-weight)'
    }
  }, "Fix:"), " ", note), typeof readCount === 'number' && /*#__PURE__*/React.createElement("p", {
    style: {
      margin: '6px 0 0',
      fontSize: 'var(--type-count-size)',
      color: 'var(--text-quiet)'
    }
  }, "Read ", readCount, " of 4")));
}
Object.assign(__ds_scope, { RadioOptionRow });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/choice/RadioOptionRow.jsx", error: String((e && e.message) || e) }); }

// components/feedback/VerdictChip.jsx
try { (() => {
function VerdictChip({
  verdict
}) {
  const correct = verdict === 'Correct' || verdict === 'correct';
  return /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'inline-block',
      fontFamily: 'var(--font-body)',
      fontSize: 'var(--type-control-size)',
      lineHeight: 'var(--type-control-line)',
      fontWeight: 700,
      letterSpacing: '.04em',
      textTransform: 'uppercase',
      borderRadius: 'var(--radius-all)',
      padding: '5px 12px',
      color: correct ? 'var(--paper-000)' : 'var(--paper-000)',
      background: correct ? 'var(--status-correct)' : 'var(--status-incorrect)',
      border: `1px solid ${correct ? 'var(--blue-700)' : 'var(--maroon-700)'}`
    }
  }, correct ? 'Correct' : 'Incorrect');
}
Object.assign(__ds_scope, { VerdictChip });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/feedback/VerdictChip.jsx", error: String((e && e.message) || e) }); }

// components/hint/HintGate.jsx
try { (() => {
function HintGate({
  name,
  cost,
  state = 'idle',
  onAsk,
  onConfirm,
  onCancel,
  onHide,
  children
}) {
  const label = {
    fontSize: 'var(--type-control-size)',
    lineHeight: 'var(--type-control-line)',
    fontWeight: 'var(--type-control-weight)',
    fontFamily: 'var(--font-body)'
  };
  const yellowBtn = {
    ...label,
    background: 'var(--action-hint-bg)',
    color: 'var(--action-hint-fg)',
    border: '1px solid var(--yellow-600)',
    borderRadius: 'var(--radius-all)',
    padding: '9px 16px',
    cursor: 'pointer'
  };
  const linkBtn = {
    ...label,
    background: 'none',
    border: 0,
    padding: '9px 2px',
    color: 'var(--action-link-fg)',
    cursor: 'pointer',
    textDecoration: 'underline',
    textUnderlineOffset: 'var(--underline-offset)',
    textDecorationThickness: 'var(--underline-thickness)'
  };
  const block = {
    background: 'var(--surface-hint)',
    border: '1px solid var(--yellow-300)',
    borderTop: 'var(--border-cap) solid var(--cap-hint)',
    borderRadius: 'var(--radius-all)',
    padding: '12px 14px'
  };
  if (state === 'open') {
    return /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
      style: {
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        gap: 'var(--space-3)',
        background: 'var(--surface-hint-receipt)',
        border: '1px solid var(--rule-300)',
        borderLeft: 'var(--border-cap) solid var(--cap-hint)',
        borderRadius: 'var(--radius-all)',
        padding: '8px 12px'
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--type-count-size)',
        fontWeight: 'var(--type-count-weight)',
        letterSpacing: '.04em',
        textTransform: 'uppercase',
        color: 'var(--text-secondary)'
      }
    }, "Hint used \xB7 ", name), onHide && /*#__PURE__*/React.createElement("button", {
      type: "button",
      onClick: onHide,
      style: {
        ...linkBtn,
        padding: 0,
        fontSize: 'var(--type-count-size)'
      }
    }, "Hide")), children && /*#__PURE__*/React.createElement("div", {
      style: {
        marginTop: 'var(--space-3)'
      }
    }, children));
  }
  if (state === 'asking') {
    return /*#__PURE__*/React.createElement("div", {
      style: block
    }, /*#__PURE__*/React.createElement("p", {
      style: {
        margin: '0 0 4px',
        fontSize: 'var(--type-body-size)',
        lineHeight: 'var(--type-body-line)',
        fontWeight: 'var(--type-body-strong-weight)',
        color: 'var(--text-body)'
      }
    }, "Sure you need a hint?"), /*#__PURE__*/React.createElement("p", {
      style: {
        margin: '0 0 12px',
        fontSize: 'var(--type-body-size)',
        lineHeight: 'var(--type-body-line)',
        color: 'var(--text-secondary)'
      }
    }, cost), /*#__PURE__*/React.createElement("div", {
      style: {
        display: 'flex',
        alignItems: 'center',
        gap: 'var(--space-4)'
      }
    }, /*#__PURE__*/React.createElement("button", {
      type: "button",
      onClick: onConfirm,
      style: yellowBtn
    }, "Yes, show me"), /*#__PURE__*/React.createElement("button", {
      type: "button",
      onClick: onCancel,
      style: linkBtn
    }, "No, keep solving")));
  }
  return /*#__PURE__*/React.createElement("div", {
    style: {
      ...block,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      gap: 'var(--space-3)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-3)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    "aria-hidden": "true",
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      width: '22px',
      height: '22px',
      background: 'var(--yellow-500)',
      color: 'var(--ink-900)',
      border: '1px solid var(--yellow-600)',
      fontSize: '14px',
      fontWeight: 700,
      borderRadius: 'var(--radius-all)'
    }
  }, "?"), /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      fontWeight: 'var(--type-body-strong-weight)',
      color: 'var(--text-body)'
    }
  }, name)), /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: onAsk,
    style: {
      ...yellowBtn,
      padding: '7px 14px'
    }
  }, "Show me"));
}
Object.assign(__ds_scope, { HintGate });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/hint/HintGate.jsx", error: String((e && e.message) || e) }); }

// components/navigation/Breadcrumb.jsx
try { (() => {
function Breadcrumb({
  items = [],
  onOpenMap,
  mapOpen = false,
  right
}) {
  return /*#__PURE__*/React.createElement("nav", {
    style: {
      height: 'var(--breadcrumb-height)',
      flex: '0 0 auto',
      background: 'var(--surface-chrome)',
      borderBottom: '1px solid var(--rule-300)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0 var(--gutter)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: '10px'
    }
  }, onOpenMap && /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: onOpenMap,
    style: {
      background: 'none',
      border: 0,
      padding: '2px 6px 2px 0',
      cursor: 'pointer',
      fontSize: '15px',
      color: 'var(--text-secondary)'
    },
    "aria-label": "Study map"
  }, "\u2302 ", /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-breadcrumb-size)',
      fontWeight: 'var(--type-breadcrumb-weight)'
    }
  }, mapOpen ? '▼' : '▸')), items.map((it, i) => /*#__PURE__*/React.createElement("span", {
    key: i,
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: '10px'
    }
  }, i > 0 && /*#__PURE__*/React.createElement("span", {
    "aria-hidden": "true",
    style: {
      color: 'var(--rule-500)',
      fontSize: 'var(--type-breadcrumb-size)'
    }
  }, "\xB7"), /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-breadcrumb-size)',
      lineHeight: 'var(--type-breadcrumb-line)',
      fontWeight: 'var(--type-breadcrumb-weight)',
      color: i === items.length - 1 ? 'var(--orange-700)' : 'var(--text-secondary)'
    }
  }, it)))), right && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-breadcrumb-size)',
      fontWeight: 'var(--type-breadcrumb-weight)',
      color: 'var(--text-secondary)'
    }
  }, right));
}
Object.assign(__ds_scope, { Breadcrumb });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/navigation/Breadcrumb.jsx", error: String((e && e.message) || e) }); }

// components/navigation/StudyMap.jsx
try { (() => {
function StudyMap({
  open = false,
  unit,
  topics = [],
  onClose,
  onPick
}) {
  if (!open) return null;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 'calc(var(--masthead-height) + var(--breadcrumb-height)) 0 0 0',
      background: 'var(--surface-scrim)',
      zIndex: 20
    },
    onClick: onClose
  }, /*#__PURE__*/React.createElement("div", {
    onClick: e => e.stopPropagation(),
    style: {
      background: 'var(--surface-overlay)',
      borderBottom: '1px solid var(--rule-400)',
      boxShadow: 'var(--shadow-overlay)',
      padding: '20px var(--gutter) 24px'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'baseline',
      justifyContent: 'space-between',
      marginBottom: 'var(--space-4)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      alignItems: 'baseline',
      gap: 'var(--space-3)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-eyebrow-size)',
      fontWeight: 'var(--type-eyebrow-weight)',
      letterSpacing: 'var(--type-eyebrow-tracking)',
      textTransform: 'uppercase',
      color: 'var(--text-eyebrow)'
    }
  }, "Study map"), /*#__PURE__*/React.createElement("h2", {
    style: {
      margin: 0,
      fontFamily: 'var(--font-display)',
      fontSize: 'var(--type-pane-title-size)',
      lineHeight: 'var(--type-pane-title-line)',
      fontWeight: 700
    }
  }, unit)), /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: onClose,
    style: {
      background: 'none',
      border: 0,
      cursor: 'pointer',
      fontSize: 'var(--type-control-size)',
      fontWeight: 600,
      color: 'var(--action-link-fg)',
      textDecoration: 'underline',
      textUnderlineOffset: 'var(--underline-offset)',
      textDecorationThickness: 'var(--underline-thickness)'
    }
  }, "Close map")), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: 'repeat(4, minmax(0,1fr))',
      gap: 'var(--pane-gap)'
    }
  }, topics.map((t, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    onClick: () => onPick && onPick(t),
    style: {
      background: t.current ? 'var(--orange-050)' : 'var(--surface-pane)',
      border: t.current ? '2px solid var(--orange-700)' : '1px solid var(--rule-300)',
      borderTop: t.current ? '2px solid var(--orange-700)' : 'var(--border-cap) solid var(--rule-400)',
      borderRadius: 'var(--radius-all)',
      padding: '12px 14px',
      cursor: 'pointer'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'block',
      fontSize: 'var(--type-count-size)',
      fontWeight: 700,
      letterSpacing: '.06em',
      color: 'var(--text-eyebrow)'
    }
  }, t.code), /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'block',
      margin: '2px 0 8px',
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      fontWeight: 'var(--type-body-strong-weight)',
      color: 'var(--text-body)'
    }
  }, t.title), /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      gap: 'var(--space-2)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-count-size)',
      color: 'var(--text-secondary)'
    }
  }, t.done, " of ", t.total, " done"), /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'inline-flex',
      gap: '3px'
    }
  }, Array.from({
    length: t.total
  }).map((_, k) => /*#__PURE__*/React.createElement("span", {
    key: k,
    style: {
      width: '8px',
      height: '8px',
      background: k < t.done ? 'var(--blue-600)' : 'var(--rule-300)'
    }
  })))))))));
}
Object.assign(__ds_scope, { StudyMap });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/navigation/StudyMap.jsx", error: String((e && e.message) || e) }); }

// components/navigation/Wordmark.jsx
try { (() => {
const TONES = {
  'on-brand': 'var(--wordmark-on-brand)',
  'on-light': 'var(--wordmark-on-light)',
  'on-dark': 'var(--wordmark-on-dark)',
  mono: 'var(--wordmark-mono)'
};
function Wordmark({
  tone = 'on-brand',
  size,
  style
}) {
  return /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-wordmark)',
      fontSize: size || 'var(--type-wordmark-size)',
      lineHeight: size ? 1 : 'var(--type-wordmark-line)',
      letterSpacing: 'var(--type-wordmark-tracking)',
      color: TONES[tone] || TONES['on-brand'],
      whiteSpace: 'nowrap',
      ...style
    }
  }, "CramApple");
}
Object.assign(__ds_scope, { Wordmark });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/navigation/Wordmark.jsx", error: String((e && e.message) || e) }); }

// components/navigation/Masthead.jsx
try { (() => {
function Masthead({
  course = 'AP Statistics',
  right
}) {
  return /*#__PURE__*/React.createElement("header", {
    style: {
      height: 'var(--masthead-height)',
      flex: '0 0 auto',
      background: 'var(--orange-600)',
      color: 'var(--text-on-brand)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0 var(--gutter)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Wordmark, {
    tone: "on-brand"
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-5)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-body-size)',
      fontWeight: 'var(--type-body-strong-weight)',
      color: 'var(--paper-000)'
    }
  }, course), right));
}
Object.assign(__ds_scope, { Masthead });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/navigation/Masthead.jsx", error: String((e && e.message) || e) }); }

// components/overlay/DeepDiveOverlay.jsx
try { (() => {
function DeepDiveOverlay({
  open = false,
  eyebrow = 'Deep dive',
  title,
  sections = [],
  onClose,
  onCopy
}) {
  if (!open) return null;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 'calc(var(--masthead-height) + var(--breadcrumb-height)) 0 0 0',
      background: 'var(--surface-scrim)',
      zIndex: 30,
      display: 'flex'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      margin: 'var(--space-5) var(--gutter) var(--space-6)',
      background: 'var(--surface-overlay)',
      border: '1px solid var(--rule-400)',
      borderTop: 'var(--border-cap) solid var(--cap-deepdive)',
      borderRadius: 'var(--radius-all)',
      boxShadow: 'var(--shadow-overlay)',
      display: 'flex',
      flexDirection: 'column',
      minHeight: 0
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'flex-start',
      justifyContent: 'space-between',
      gap: 'var(--space-5)',
      padding: '18px var(--space-7) 14px',
      borderBottom: '1px solid var(--rule-divider)'
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-eyebrow-size)',
      fontWeight: 'var(--type-eyebrow-weight)',
      letterSpacing: 'var(--type-eyebrow-tracking)',
      textTransform: 'uppercase',
      color: 'var(--text-eyebrow)'
    }
  }, eyebrow), /*#__PURE__*/React.createElement("h2", {
    style: {
      margin: '4px 0 0',
      fontFamily: 'var(--font-display)',
      fontWeight: 'var(--type-overlay-title-weight)',
      fontSize: 'var(--type-overlay-title-size)',
      lineHeight: 'var(--type-overlay-title-line)'
    }
  }, title)), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-5)'
    }
  }, onCopy && /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: onCopy,
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: '8px',
      background: 'var(--action-quiet-bg)',
      border: 'var(--border-quiet)',
      borderRadius: 'var(--radius-all)',
      padding: '9px 14px',
      cursor: 'pointer',
      color: 'var(--action-quiet-fg)',
      fontSize: 'var(--type-control-size)',
      fontWeight: 'var(--type-control-weight)',
      fontFamily: 'var(--font-body)'
    }
  }, /*#__PURE__*/React.createElement("svg", {
    width: "18",
    height: "18",
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "currentColor",
    strokeWidth: "1.9",
    strokeLinecap: "round",
    strokeLinejoin: "round",
    "aria-hidden": "true"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M8.6 3.6h11.8v11.8H8.6z"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M15.4 20.4H3.6V8.6"
  })), "Copy deep dive"), /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: onClose,
    style: {
      background: 'none',
      border: 0,
      cursor: 'pointer',
      color: 'var(--action-link-fg)',
      fontSize: 'var(--type-control-size)',
      fontWeight: 'var(--type-control-weight)',
      textDecoration: 'underline',
      textUnderlineOffset: 'var(--underline-offset)',
      textDecorationThickness: 'var(--underline-thickness)'
    }
  }, "Back to the question"))), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: '1 1 auto',
      minHeight: 0,
      padding: '20px var(--space-7)',
      display: 'grid',
      gridTemplateColumns: `repeat(${Math.min(sections.length, 3) || 1}, minmax(0,1fr))`,
      gap: 'var(--space-7)'
    }
  }, sections.map((s, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      borderLeft: 'var(--border-cap) solid var(--teal-500)',
      paddingLeft: 'var(--space-4)'
    }
  }, /*#__PURE__*/React.createElement("h3", {
    style: {
      margin: '0 0 8px',
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      fontWeight: 700,
      color: 'var(--text-body)'
    }
  }, s.title), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      color: 'var(--text-secondary)'
    }
  }, s.body))))));
}
Object.assign(__ds_scope, { DeepDiveOverlay });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/overlay/DeepDiveOverlay.jsx", error: String((e && e.message) || e) }); }

// components/pane/PaneShell.jsx
try { (() => {
const CAPS = {
  rubric: 'var(--cap-rubric)',
  reference: 'var(--cap-reference)',
  hint: 'var(--cap-hint)',
  work: 'var(--cap-work)',
  deepdive: 'var(--cap-deepdive)'
};
function PaneShell({
  voice = 'plain',
  title,
  eyebrow,
  right,
  footer,
  padded = true,
  children,
  style
}) {
  const isQuestion = voice === 'question';
  const cap = CAPS[voice];
  return /*#__PURE__*/React.createElement("section", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      minHeight: 0,
      background: 'var(--surface-pane)',
      border: isQuestion ? 'var(--border-question)' : 'var(--border-pane)',
      ...(cap ? {
        borderTop: `var(--border-cap) solid ${cap}`
      } : {}),
      boxShadow: isQuestion ? 'var(--shadow-section)' : 'var(--shadow-pane)',
      borderRadius: 'var(--radius-all)',
      ...style
    }
  }, (title || eyebrow || right) && /*#__PURE__*/React.createElement("header", {
    style: {
      display: 'flex',
      alignItems: 'baseline',
      justifyContent: 'space-between',
      gap: 'var(--space-3)',
      padding: `14px var(--pane-pad-x) 10px`,
      borderBottom: '1px solid var(--rule-divider)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: '3px'
    }
  }, eyebrow && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-eyebrow-size)',
      lineHeight: 'var(--type-eyebrow-line)',
      fontWeight: 'var(--type-eyebrow-weight)',
      letterSpacing: 'var(--type-eyebrow-tracking)',
      textTransform: 'uppercase',
      color: 'var(--text-eyebrow)'
    }
  }, eyebrow), title && /*#__PURE__*/React.createElement("h2", {
    style: {
      margin: 0,
      fontFamily: 'var(--font-display)',
      fontWeight: 'var(--type-pane-title-weight)',
      fontSize: 'var(--type-pane-title-size)',
      lineHeight: 'var(--type-pane-title-line)',
      color: 'var(--text-body)'
    }
  }, title)), right && /*#__PURE__*/React.createElement("div", {
    style: {
      flex: '0 0 auto'
    }
  }, right)), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: '1 1 auto',
      minHeight: 0,
      padding: padded ? 'var(--pane-pad-y) var(--pane-pad-x)' : 0
    }
  }, children), footer && /*#__PURE__*/React.createElement("div", {
    style: {
      borderTop: '1px solid var(--rule-divider)',
      padding: '12px var(--pane-pad-x)'
    }
  }, footer));
}
Object.assign(__ds_scope, { PaneShell });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/pane/PaneShell.jsx", error: String((e && e.message) || e) }); }

// components/pane/Plate.jsx
try { (() => {
function Plate({
  caption,
  children,
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      width: 'var(--plate-width)',
      height: 'var(--plate-height)',
      overflow: 'hidden',
      background: 'var(--surface-plate)',
      display: 'flex',
      flexDirection: 'column',
      fontFamily: 'var(--font-body)',
      color: 'var(--text-body)',
      ...style
    }
  }, children, caption && /*#__PURE__*/React.createElement("div", {
    style: {
      flex: '0 0 auto',
      height: 'var(--caption-height)',
      display: 'flex',
      alignItems: 'center',
      padding: '0 var(--gutter)',
      fontSize: 'var(--type-caption-size)',
      lineHeight: 'var(--type-caption-line)',
      fontWeight: 'var(--type-caption-weight)',
      color: 'var(--text-quiet)'
    }
  }, caption));
}
function PlateGrid({
  children,
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      flex: '1 1 auto',
      minHeight: 0,
      display: 'grid',
      gridTemplateColumns: 'var(--grid-columns)',
      gap: 'var(--pane-gap)',
      padding: 'var(--space-5) var(--gutter)',
      background: 'var(--surface-desk)',
      ...style
    }
  }, children);
}
Object.assign(__ds_scope, { Plate, PlateGrid });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/pane/Plate.jsx", error: String((e && e.message) || e) }); }

// components/pane/ScoreChip.jsx
try { (() => {
const TONES = {
  earned: {
    fg: 'var(--text-earned)',
    bg: 'var(--blue-050)',
    bd: 'var(--blue-100)'
  },
  lost: {
    fg: 'var(--text-lost)',
    bg: 'var(--maroon-050)',
    bd: 'var(--maroon-300)'
  },
  neutral: {
    fg: 'var(--text-secondary)',
    bg: 'var(--paper-050)',
    bd: 'var(--rule-300)'
  }
};
function ScoreChip({
  earned = null,
  total,
  tone,
  label,
  size = 'md'
}) {
  const t = TONES[tone || (earned === null ? 'neutral' : earned === total ? 'earned' : 'lost')];
  const big = size === 'lg';
  return /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'inline-flex',
      alignItems: 'baseline',
      gap: 'var(--space-2)'
    }
  }, label && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-eyebrow-size)',
      fontWeight: 'var(--type-eyebrow-weight)',
      letterSpacing: 'var(--type-eyebrow-tracking)',
      textTransform: 'uppercase',
      color: 'var(--text-eyebrow)'
    }
  }, label), /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 'var(--type-score-weight)',
      fontSize: big ? 'var(--type-score-size)' : '22px',
      lineHeight: big ? 'var(--type-score-line)' : '24px',
      color: t.fg,
      background: t.bg,
      border: `1px solid ${t.bd}`,
      borderRadius: 'var(--radius-all)',
      padding: big ? '2px 12px' : '1px 9px',
      whiteSpace: 'nowrap'
    }
  }, earned === null ? '—' : earned, " / ", total));
}
Object.assign(__ds_scope, { ScoreChip });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/pane/ScoreChip.jsx", error: String((e && e.message) || e) }); }

// components/feedback/FeedbackCard.jsx
try { (() => {
function FeedbackCard({
  verdict,
  earned,
  total,
  coaching,
  hintsUsed = [],
  marks,
  submitted,
  submittedLabel = 'Your answer'
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--surface-feedback)',
      border: '1px solid var(--purple-rule)',
      borderTop: 'var(--border-cap) solid var(--cap-work)',
      borderRadius: 'var(--radius-all)',
      boxShadow: 'var(--shadow-feedback)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      gap: 'var(--space-4)',
      padding: '14px var(--pane-pad-x) 10px'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-3)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-eyebrow-size)',
      fontWeight: 'var(--type-eyebrow-weight)',
      letterSpacing: 'var(--type-eyebrow-tracking)',
      textTransform: 'uppercase',
      color: 'var(--text-eyebrow)'
    }
  }, "Feedback"), verdict && /*#__PURE__*/React.createElement(__ds_scope.VerdictChip, {
    verdict: verdict
  })), typeof total === 'number' && /*#__PURE__*/React.createElement(__ds_scope.ScoreChip, {
    earned: earned,
    total: total,
    size: "lg"
  })), coaching && /*#__PURE__*/React.createElement("p", {
    style: {
      margin: '0 var(--pane-pad-x) 14px',
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      color: 'var(--text-body)'
    }
  }, coaching), marks && /*#__PURE__*/React.createElement("div", {
    style: {
      margin: '0 var(--pane-pad-x) 14px',
      display: 'grid',
      gap: '8px'
    }
  }, marks), submitted && /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--paper-000)',
      borderTop: '1px solid var(--purple-rule)',
      padding: '12px var(--pane-pad-x)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'block',
      marginBottom: '4px',
      fontSize: 'var(--type-eyebrow-size)',
      fontWeight: 'var(--type-eyebrow-weight)',
      letterSpacing: 'var(--type-eyebrow-tracking)',
      textTransform: 'uppercase',
      color: 'var(--text-eyebrow)'
    }
  }, submittedLabel), /*#__PURE__*/React.createElement("p", {
    style: {
      margin: 0,
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      color: 'var(--text-secondary)'
    }
  }, submitted)), hintsUsed.length > 0 && /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-2)',
      flexWrap: 'wrap',
      borderTop: '1px solid var(--purple-rule)',
      padding: '9px var(--pane-pad-x)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-eyebrow-size)',
      fontWeight: 'var(--type-eyebrow-weight)',
      letterSpacing: 'var(--type-eyebrow-tracking)',
      textTransform: 'uppercase',
      color: 'var(--text-eyebrow)'
    }
  }, "Hints used"), hintsUsed.map((h, i) => /*#__PURE__*/React.createElement("span", {
    key: i,
    style: {
      fontSize: 'var(--type-count-size)',
      fontWeight: 'var(--type-count-weight)',
      color: 'var(--text-hint)',
      background: 'var(--yellow-050)',
      border: '1px solid var(--yellow-300)',
      borderRadius: 'var(--radius-all)',
      padding: 'var(--chip-pad-y) var(--chip-pad-x)'
    }
  }, h))));
}
Object.assign(__ds_scope, { FeedbackCard });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/feedback/FeedbackCard.jsx", error: String((e && e.message) || e) }); }

// components/question/AnswerField.jsx
try { (() => {
function AnswerField({
  value = '',
  placeholder = 'Write your answer',
  onChange,
  rows = 5,
  onAttach,
  attachLabel = 'Attach hand-drawn work',
  readOnly = false,
  count
}) {
  return /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("textarea", {
    value: value,
    placeholder: placeholder,
    rows: rows,
    readOnly: readOnly,
    onChange: e => onChange && onChange(e.target.value),
    style: {
      width: '100%',
      resize: 'none',
      background: 'var(--surface-work)',
      color: 'var(--text-body)',
      border: '1px solid var(--purple-rule)',
      borderTop: 'var(--border-cap) solid var(--cap-work)',
      borderRadius: 'var(--radius-all)',
      padding: '12px 14px',
      fontFamily: 'var(--font-body)',
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      outline: 'none'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      marginTop: '6px'
    }
  }, onAttach ? /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: onAttach,
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: '8px',
      background: 'none',
      border: 0,
      padding: 0,
      cursor: 'pointer',
      color: 'var(--action-link-fg)',
      fontSize: 'var(--type-count-size)',
      fontWeight: 600
    }
  }, /*#__PURE__*/React.createElement("svg", {
    width: "20",
    height: "20",
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "currentColor",
    strokeWidth: "1.9",
    strokeLinecap: "round",
    strokeLinejoin: "round",
    "aria-hidden": "true"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M3.4 8.2h3.3l1.5-2.4h7.6l1.5 2.4h3.3v10.1H3.4z"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M12 16.1a3.3 3.3 0 1 0 0-6.6 3.3 3.3 0 0 0 0 6.6z"
  })), attachLabel) : /*#__PURE__*/React.createElement("span", null), count && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-count-size)',
      color: 'var(--text-quiet)'
    }
  }, count)));
}
Object.assign(__ds_scope, { AnswerField });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/question/AnswerField.jsx", error: String((e && e.message) || e) }); }

// components/question/GraphFrame.jsx
try { (() => {
function GraphFrame({
  caption,
  source,
  children,
  height
}) {
  return /*#__PURE__*/React.createElement("figure", {
    style: {
      margin: 0
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--surface-graph)',
      border: '1px solid var(--rule-graph)',
      borderRadius: 'var(--radius-all)',
      padding: 'var(--space-3)',
      height,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center'
    }
  }, children), (caption || source) && /*#__PURE__*/React.createElement("figcaption", {
    style: {
      display: 'flex',
      justifyContent: 'space-between',
      gap: 'var(--space-3)',
      marginTop: '6px',
      fontSize: 'var(--type-count-size)',
      lineHeight: 'var(--type-count-line)',
      color: 'var(--text-secondary)'
    }
  }, /*#__PURE__*/React.createElement("span", null, caption), source && /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--text-quiet)'
    }
  }, source)));
}
Object.assign(__ds_scope, { GraphFrame });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/question/GraphFrame.jsx", error: String((e && e.message) || e) }); }

// components/question/QuestionHeader.jsx
try { (() => {
function QuestionHeader({
  eyebrow = 'Question',
  topic,
  number,
  total,
  stem,
  points,
  mode
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: '10px'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'baseline',
      justifyContent: 'space-between',
      gap: 'var(--space-4)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      alignItems: 'baseline',
      gap: 'var(--space-3)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-eyebrow-size)',
      fontWeight: 'var(--type-eyebrow-weight)',
      letterSpacing: 'var(--type-eyebrow-tracking)',
      textTransform: 'uppercase',
      color: 'var(--text-eyebrow)'
    }
  }, eyebrow), topic && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-count-size)',
      fontWeight: 600,
      color: 'var(--text-quiet)'
    }
  }, topic)), /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      alignItems: 'baseline',
      gap: 'var(--space-3)'
    }
  }, mode && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-count-size)',
      fontWeight: 700,
      letterSpacing: '.08em',
      textTransform: 'uppercase',
      color: 'var(--text-work)',
      background: 'var(--purple-tint-06)',
      border: '1px solid var(--purple-rule)',
      padding: 'var(--chip-pad-y) var(--chip-pad-x)'
    }
  }, mode), typeof points === 'number' && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-count-size)',
      fontWeight: 600,
      color: 'var(--text-secondary)'
    }
  }, points, " ", points === 1 ? 'point' : 'points'), number && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-count-size)',
      fontWeight: 600,
      color: 'var(--text-quiet)'
    }
  }, number, " of ", total))), /*#__PURE__*/React.createElement("p", {
    style: {
      margin: 0,
      fontSize: 'var(--type-question-size)',
      lineHeight: 'var(--type-question-line)',
      color: 'var(--text-body)',
      textWrap: 'pretty'
    }
  }, stem));
}
Object.assign(__ds_scope, { QuestionHeader });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/question/QuestionHeader.jsx", error: String((e && e.message) || e) }); }

// components/rubric/RubricCriterionRow.jsx
try { (() => {
const MARKS = {
  earned: {
    glyph: '✓',
    fg: 'var(--text-earned)',
    bg: 'var(--blue-050)',
    bd: 'var(--blue-100)'
  },
  revisit: {
    glyph: '↻',
    fg: 'var(--text-revisit)',
    bg: 'var(--clay-050)',
    bd: 'var(--clay-300)'
  },
  taken: {
    glyph: '✕',
    fg: 'var(--text-lost)',
    bg: 'var(--maroon-050)',
    bd: 'var(--maroon-300)'
  },
  pending: {
    glyph: '·',
    fg: 'var(--text-quiet)',
    bg: 'var(--paper-050)',
    bd: 'var(--rule-300)'
  }
};
function RubricCriterionRow({
  code,
  label,
  detail,
  state = 'pending',
  points = 1,
  interactive = false,
  onToggle
}) {
  const m = MARKS[state] || MARKS.pending;
  return /*#__PURE__*/React.createElement("div", {
    onClick: interactive ? onToggle : undefined,
    style: {
      display: 'flex',
      gap: 'var(--space-3)',
      alignItems: 'flex-start',
      width: '100%',
      textAlign: 'left',
      padding: 'var(--row-pad-y) var(--row-pad-x)',
      background: state === 'earned' ? 'var(--blue-050)' : 'var(--surface-pane)',
      border: '1px solid var(--rule-300)',
      borderLeft: `var(--border-cap) solid ${state === 'earned' ? 'var(--blue-600)' : state === 'taken' ? 'var(--maroon-600)' : state === 'revisit' ? 'var(--clay-600)' : 'var(--rule-400)'}`,
      borderRadius: 'var(--radius-all)',
      cursor: interactive ? 'pointer' : 'default'
    }
  }, /*#__PURE__*/React.createElement("span", {
    "aria-hidden": "true",
    style: {
      flex: '0 0 auto',
      width: '24px',
      height: '24px',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      color: m.fg,
      background: m.bg,
      border: `1px solid ${m.bd}`,
      borderRadius: 'var(--radius-all)',
      fontSize: '15px',
      fontWeight: 700
    }
  }, m.glyph), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: '1 1 auto',
      minWidth: 0
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'flex',
      gap: 'var(--space-2)',
      alignItems: 'baseline'
    }
  }, code && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-count-size)',
      fontWeight: 700,
      letterSpacing: '.06em',
      textTransform: 'uppercase',
      color: 'var(--text-eyebrow)'
    }
  }, code), /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      fontWeight: 'var(--type-body-strong-weight)',
      color: 'var(--text-body)'
    }
  }, label)), detail && /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'block',
      marginTop: '2px',
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      color: 'var(--text-secondary)'
    }
  }, detail)), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: '0 0 auto',
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: '20px',
      lineHeight: '24px',
      color: state === 'earned' ? 'var(--text-earned)' : 'var(--text-quiet)'
    }
  }, state === 'earned' ? points : '—', "/", points));
}
Object.assign(__ds_scope, { RubricCriterionRow });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/rubric/RubricCriterionRow.jsx", error: String((e && e.message) || e) }); }

// ui_kits/frq/screen.jsx
try { (() => {
const {
  Plate,
  PlateGrid,
  PaneShell,
  ScoreChip,
  Masthead,
  Breadcrumb,
  StudyMap,
  RubricCriterionRow,
  QuestionHeader,
  GraphFrame,
  AnswerField,
  ActionRow,
  ActionButton,
  HintGate,
  FeedbackCard,
  DeepDiveOverlay
} = window.CramAppleDesignSystem_c1541a;
const pfEyebrow = {
  display: 'block',
  marginBottom: 5,
  fontSize: 'var(--type-eyebrow-size)',
  fontWeight: 'var(--type-eyebrow-weight)',
  letterSpacing: 'var(--type-eyebrow-tracking)',
  textTransform: 'uppercase',
  color: 'var(--text-eyebrow)'
};
const pfBody = {
  margin: 0,
  fontSize: 'var(--type-body-size)',
  lineHeight: 'var(--type-body-line)',
  color: 'var(--text-secondary)'
};
const pfList = {
  margin: 0,
  padding: '0 0 0 18px',
  fontSize: 'var(--type-body-size)',
  lineHeight: 'var(--type-body-line)',
  color: 'var(--text-secondary)',
  display: 'grid',
  gap: 4
};
const eyebrow = pfEyebrow,
  body = pfBody,
  list = pfList;
const PF_CRITERIA = [{
  code: 'E1',
  label: 'Names both variables',
  detail: 'Hours studied predicts final exam score.'
}, {
  code: 'E2',
  label: 'Reads the slope as a rate',
  detail: 'Per one additional hour studied.'
}, {
  code: 'E3',
  label: 'Says predicted mean, not actual',
  detail: 'The line predicts an average, not one student.'
}, {
  code: 'E4',
  label: 'States the units',
  detail: '4.1 points on the final exam.'
}];
function PracticeFRQ() {
  const [text, setText] = React.useState('');
  const [hint, setHint] = React.useState('idle');
  const [submitted, setSubmitted] = React.useState(false);
  const [map, setMap] = React.useState(false);
  const [deep, setDeep] = React.useState(false);
  const hintsUsed = hint === 'open' ? ['Rubric'] : [];
  const marks = ['earned', 'earned', 'revisit', 'earned'];
  const earned = marks.filter(m => m === 'earned').length;
  return /*#__PURE__*/React.createElement(Plate, {
    caption: "CramApple \xB7 AP Statistics \xB7 Unit 2 \xB7 2.3 Least-Squares Regression \xB7 Practice"
  }, /*#__PURE__*/React.createElement(Masthead, {
    course: "AP Statistics",
    right: /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 13,
        fontWeight: 700,
        letterSpacing: '.12em',
        textTransform: 'uppercase',
        color: 'var(--paper-000)'
      }
    }, "Practice")
  }), /*#__PURE__*/React.createElement(Breadcrumb, {
    items: ['Unit 2', '2.3 Least-Squares Regression', 'Question 4'],
    mapOpen: map,
    onOpenMap: () => setMap(m => !m),
    right: "Question 4 of 12"
  }), /*#__PURE__*/React.createElement(PlateGrid, null, /*#__PURE__*/React.createElement(PaneShell, {
    voice: submitted ? 'rubric' : 'hint',
    eyebrow: "Scoring",
    title: submitted ? 'Rubric' : 'How this is scored',
    right: /*#__PURE__*/React.createElement(ScoreChip, {
      earned: submitted ? earned : null,
      total: 4
    }),
    style: {
      height: '100%'
    }
  }, submitted ? /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 10
    }
  }, PF_CRITERIA.map((c, i) => /*#__PURE__*/React.createElement(RubricCriterionRow, {
    key: c.code,
    code: c.code,
    label: c.label,
    detail: c.detail,
    state: marks[i]
  })), /*#__PURE__*/React.createElement("p", {
    style: {
      ...body,
      fontSize: 'var(--type-count-size)',
      marginTop: 4
    }
  }, "\u21BB means revisit, not wrong forever \u2014 the point is still available next attempt.")) : /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 16
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: body
  }, "This question is worth 4 points. You can answer without seeing how they are split."), /*#__PURE__*/React.createElement(HintGate, {
    name: "Show me the rubric",
    cost: "This reveals all four scoring criteria before you write, and is listed on your feedback.",
    state: hint,
    onAsk: () => setHint('asking'),
    onConfirm: () => setHint('open'),
    onCancel: () => setHint('idle'),
    onHide: () => setHint('idle')
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 10
    }
  }, PF_CRITERIA.map(c => /*#__PURE__*/React.createElement(RubricCriterionRow, {
    key: c.code,
    code: c.code,
    label: c.label,
    detail: c.detail,
    state: "pending"
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      borderTop: '1px solid var(--rule-divider)',
      paddingTop: 14
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "How points are earned"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, "Name both variables."), /*#__PURE__*/React.createElement("li", null, "Read the slope as a rate."), /*#__PURE__*/React.createElement("li", null, "Say predicted mean."))), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "How points are lost"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, "Promising one student a score."), /*#__PURE__*/React.createElement("li", null, "Writing cause instead of prediction."), /*#__PURE__*/React.createElement("li", null, "Dropping the units."))))), /*#__PURE__*/React.createElement(PaneShell, {
    voice: "question",
    eyebrow: "Question",
    title: "Interpreting slope",
    right: /*#__PURE__*/React.createElement(ScoreChip, {
      earned: submitted ? earned : null,
      total: 4,
      label: "Score"
    }),
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 14,
      height: '100%',
      minHeight: 0,
      gridTemplateRows: 'auto auto minmax(0,1fr) auto'
    }
  }, /*#__PURE__*/React.createElement(QuestionHeader, {
    topic: "2.3 Least-Squares Regression",
    mode: "Practice",
    points: 4,
    stem: /*#__PURE__*/React.createElement(React.Fragment, null, "The least-squares line for predicting final exam score from hours studied per week is ", /*#__PURE__*/React.createElement("span", {
      style: {
        fontFamily: 'var(--font-math)'
      }
    }, "\u0177 = 42.6 + 4.1x"), ". Interpret the slope in the context of this study.")
  }), /*#__PURE__*/React.createElement(GraphFrame, {
    caption: "Hours studied per week vs. final exam score",
    source: "n = 15",
    height: submitted ? 118 : 206
  }, /*#__PURE__*/React.createElement("svg", {
    viewBox: "0 0 640 200",
    width: "100%",
    height: "100%",
    preserveAspectRatio: "xMidYMid meet",
    role: "img",
    "aria-label": "Scatterplot of hours studied against final exam score"
  }, /*#__PURE__*/React.createElement("line", {
    x1: "54",
    y1: "168",
    x2: "616",
    y2: "168",
    stroke: "var(--purple-500)",
    strokeWidth: "1.5"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "54",
    y1: "168",
    x2: "54",
    y2: "14",
    stroke: "var(--purple-500)",
    strokeWidth: "1.5"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "70",
    y1: "156",
    x2: "600",
    y2: "34",
    stroke: "var(--purple-600)",
    strokeWidth: "2"
  }), [[86, 150], [122, 146], [158, 132], [194, 134], [230, 118], [266, 112], [302, 108], [338, 96], [374, 88], [410, 84], [446, 70], [482, 66], [518, 54], [554, 48], [590, 40]].map(([x, y], i) => /*#__PURE__*/React.createElement("circle", {
    key: i,
    cx: x,
    cy: y,
    r: "4.5",
    fill: "var(--purple-500)"
  })), /*#__PURE__*/React.createElement("circle", {
    cx: "566",
    cy: "140",
    r: "6",
    fill: "var(--yellow-500)",
    stroke: "var(--yellow-700)",
    strokeWidth: "1.5"
  }), /*#__PURE__*/React.createElement("text", {
    x: "574",
    y: "136",
    fontSize: "11",
    fill: "var(--yellow-700)",
    fontFamily: "var(--font-body)",
    fontWeight: "700"
  }, "influence"), /*#__PURE__*/React.createElement("text", {
    x: "335",
    y: "190",
    textAnchor: "middle",
    fontSize: "12",
    fill: "var(--purple-500)",
    fontFamily: "var(--font-body)"
  }, "Hours studied per week"), /*#__PURE__*/React.createElement("text", {
    x: "16",
    y: "92",
    textAnchor: "middle",
    fontSize: "12",
    fill: "var(--purple-500)",
    fontFamily: "var(--font-body)",
    transform: "rotate(-90 16 92)"
  }, "Final exam score"))), submitted ? /*#__PURE__*/React.createElement(FeedbackCard, {
    verdict: "incorrect",
    earned: earned,
    total: 4,
    coaching: "Three of four moves are there. \u201Cwill raise a score\u201D promises one student what the line only predicts as a mean. Fix: write \u201Cthe predicted mean final exam score increases by 4.1 points\u201D.",
    hintsUsed: hintsUsed,
    submitted: text || 'Every extra hour of study will raise a score by 4.1 points on the final exam.',
    submittedLabel: "Your answer"
  }) : /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Your work"), /*#__PURE__*/React.createElement(AnswerField, {
    value: text,
    onChange: setText,
    rows: 4,
    onAttach: () => {},
    count: "Aim for one sentence, four moves"
  })), /*#__PURE__*/React.createElement(ActionRow, {
    note: submitted ? 'Scored against 4 criteria' : 'One submission per question',
    primary: submitted ? /*#__PURE__*/React.createElement(ActionButton, {
      variant: "primary"
    }, "Next question") : /*#__PURE__*/React.createElement(ActionButton, {
      variant: "primary",
      disabled: text.trim().length === 0,
      onClick: () => setSubmitted(true)
    }, "Submit answer"),
    secondary: submitted ? /*#__PURE__*/React.createElement(ActionButton, {
      variant: "link",
      onClick: () => setDeep(true)
    }, "Open the deep dive") : /*#__PURE__*/React.createElement(ActionButton, {
      variant: "link"
    }, "Skip for now")
  }))), /*#__PURE__*/React.createElement(PaneShell, {
    voice: "reference",
    eyebrow: "Allowed",
    title: "Reference Materials",
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 18
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Topic"), /*#__PURE__*/React.createElement("p", {
    style: body
  }, "2.3 Least-Squares Regression \u2014 using a fitted line to predict a quantitative response.")), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Skills"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, "2.D \u2014 Interpret slope and intercept in context."), /*#__PURE__*/React.createElement("li", null, "2.B \u2014 Describe form, direction and strength from a scatterplot."), /*#__PURE__*/React.createElement("li", null, "4.B \u2014 Distinguish association from causation."))), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Vocabulary"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Slope"), " \u2014 change in the predicted mean response per one-unit change in x."), /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Predicted value"), " \u2014 \u0177, the line's estimate, never an individual's actual score."), /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Explanatory variable"), " \u2014 x, here hours studied."))), /*#__PURE__*/React.createElement("div", {
    style: {
      borderTop: '1px solid var(--rule-divider)',
      paddingTop: 12
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "On the exam"), /*#__PURE__*/React.createElement("p", {
    style: body
  }, "Formula sheet gives \u0177 = a + bx and b = r(s", /*#__PURE__*/React.createElement("sub", null, "y"), "/s", /*#__PURE__*/React.createElement("sub", null, "x"), "). Context is not on the sheet \u2014 you supply it."))))), /*#__PURE__*/React.createElement(StudyMap, {
    open: map,
    unit: "Unit 2 \xB7 Exploring Two-Variable Data",
    onClose: () => setMap(false),
    topics: [{
      code: '2.1',
      title: 'Two Categorical Variables',
      done: 6,
      total: 6
    }, {
      code: '2.2',
      title: 'Scatterplots & Correlation',
      done: 4,
      total: 7
    }, {
      code: '2.3',
      title: 'Least-Squares Regression',
      done: 3,
      total: 8,
      current: true
    }, {
      code: '2.4',
      title: 'Residuals & Departures',
      done: 0,
      total: 5
    }]
  }), /*#__PURE__*/React.createElement(DeepDiveOverlay, {
    open: deep,
    title: "Why slope is a mean, not a promise",
    onClose: () => setDeep(false),
    onCopy: () => {},
    sections: [{
      title: 'The claim',
      body: 'A slope of 4.1 says that among students like these, the predicted mean final exam score is 4.1 points higher for each additional hour studied per week. It is a statement about the line, not about any one student.'
    }, {
      title: 'The trap',
      body: '“Will score 4.1 points higher” promises an individual an outcome. The regression line has no individuals in it — the residuals hold everything it missed, and for a single student that gap is often larger than the slope.'
    }, {
      title: 'The habit',
      body: 'Write it in four moves: per one extra hour (rate), the predicted mean final exam score (response, as a mean), increases by 4.1 (magnitude), points (units). Four moves, four rubric points.'
    }]
  }));
}
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/frq/screen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/home/screen.jsx
try { (() => {
const {
  Plate,
  PlateGrid,
  PaneShell,
  ScoreChip,
  Masthead,
  Breadcrumb,
  StudyMap,
  ActionRow,
  ActionButton
} = window.CramAppleDesignSystem_c1541a;
const hEyebrow = {
  display: 'block',
  marginBottom: 5,
  fontSize: 'var(--type-eyebrow-size)',
  fontWeight: 'var(--type-eyebrow-weight)',
  letterSpacing: 'var(--type-eyebrow-tracking)',
  textTransform: 'uppercase',
  color: 'var(--text-eyebrow)'
};
const hBody = {
  margin: 0,
  fontSize: 'var(--type-body-size)',
  lineHeight: 'var(--type-body-line)',
  color: 'var(--text-secondary)'
};
const UNITS = [{
  code: '2.1',
  title: 'Two Categorical Variables',
  done: 6,
  total: 6,
  mode: 'Practice'
}, {
  code: '2.2',
  title: 'Scatterplots & Correlation',
  done: 4,
  total: 7,
  mode: 'Practice'
}, {
  code: '2.3',
  title: 'Least-Squares Regression',
  done: 3,
  total: 8,
  mode: 'Open Hand',
  current: true
}, {
  code: '2.4',
  title: 'Residuals & Departures',
  done: 0,
  total: 5,
  mode: 'Open Hand'
}, {
  code: '2.5',
  title: 'Correlation vs. Causation',
  done: 0,
  total: 4,
  mode: 'Open Hand'
}, {
  code: '2.6',
  title: 'Unit 2 Mixed Review',
  done: 0,
  total: 12,
  mode: 'Practice'
}];
function Screen() {
  const [map, setMap] = React.useState(false);
  const [topic, setTopic] = React.useState('2.3');
  const done = UNITS.reduce((s, u) => s + u.done, 0);
  const total = UNITS.reduce((s, u) => s + u.total, 0);
  return /*#__PURE__*/React.createElement(Plate, {
    caption: "CramApple \xB7 AP Statistics \xB7 Unit 2 \xB7 Exploring Two-Variable Data"
  }, /*#__PURE__*/React.createElement(Masthead, {
    course: "AP Statistics",
    right: /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 13,
        fontWeight: 700,
        letterSpacing: '.12em',
        textTransform: 'uppercase',
        color: 'var(--paper-000)'
      }
    }, "Home")
  }), /*#__PURE__*/React.createElement(Breadcrumb, {
    items: ['Home', 'Unit 2 · Exploring Two-Variable Data'],
    mapOpen: map,
    onOpenMap: () => setMap(m => !m),
    right: `${done} of ${total} questions done`
  }), /*#__PURE__*/React.createElement(PlateGrid, null, /*#__PURE__*/React.createElement(PaneShell, {
    voice: "question",
    eyebrow: "Where you left off",
    title: "2.3 Least-Squares Regression",
    right: /*#__PURE__*/React.createElement(ScoreChip, {
      earned: done,
      total: total,
      tone: "neutral",
      label: "Unit"
    }),
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 16,
      height: '100%',
      minHeight: 0,
      gridTemplateRows: 'auto auto minmax(0,1fr) auto'
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      margin: 0,
      fontSize: 'var(--type-question-size)',
      lineHeight: 'var(--type-question-line)'
    }
  }, "Question 4 \u2014 interpret the slope of a least-squares line in context."), /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--surface-work)',
      border: '1px solid var(--purple-rule)',
      borderTop: 'var(--border-cap) solid var(--cap-work)',
      padding: '12px 14px'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: hEyebrow
  }, "Last attempt"), /*#__PURE__*/React.createElement("p", {
    style: hBody
  }, "3 of 4 points. The missed point was ", /*#__PURE__*/React.createElement("strong", {
    style: {
      color: 'var(--text-revisit)'
    }
  }, "\u21BB says predicted mean, not actual"), " \u2014 it is still available.")), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: hEyebrow
  }, "This unit's habits"), /*#__PURE__*/React.createElement("ul", {
    style: {
      margin: 0,
      padding: '0 0 0 18px',
      display: 'grid',
      gap: 4,
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      color: 'var(--text-secondary)'
    }
  }, /*#__PURE__*/React.createElement("li", null, "Name both variables before you name a number."), /*#__PURE__*/React.createElement("li", null, "Keep the response a predicted mean."), /*#__PURE__*/React.createElement("li", null, "Say association until the design earns cause."))), /*#__PURE__*/React.createElement(ActionRow, {
    note: "Practice mode",
    primary: /*#__PURE__*/React.createElement(ActionButton, {
      variant: "primary"
    }, "Resume question 4"),
    secondary: /*#__PURE__*/React.createElement(ActionButton, {
      variant: "link"
    }, "Start the unit over")
  }))), /*#__PURE__*/React.createElement(PaneShell, {
    voice: "rubric",
    eyebrow: "Study map",
    title: "Unit 2 \xB7 Exploring Two-Variable Data",
    right: /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--type-count-size)',
        fontWeight: 600,
        color: 'var(--text-secondary)'
      }
    }, done, " of ", total, " done"),
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: '1fr 1fr',
      gap: 12
    }
  }, UNITS.map(u => {
    const active = topic === u.code;
    return /*#__PURE__*/React.createElement("div", {
      key: u.code,
      onClick: () => setTopic(u.code),
      style: {
        cursor: 'pointer',
        background: active ? 'var(--orange-050)' : 'var(--surface-pane)',
        border: active ? '2px solid var(--orange-500)' : '1px solid var(--rule-300)',
        borderTop: active ? '2px solid var(--orange-700)' : 'var(--border-cap) solid var(--rule-400)',
        padding: '12px 14px'
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        display: 'flex',
        alignItems: 'baseline',
        justifyContent: 'space-between'
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--type-count-size)',
        fontWeight: 700,
        letterSpacing: '.06em',
        color: 'var(--text-eyebrow)'
      }
    }, u.code), /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--type-count-size)',
        fontWeight: 600,
        color: u.mode === 'Open Hand' ? 'var(--text-work)' : 'var(--text-secondary)'
      }
    }, u.mode)), /*#__PURE__*/React.createElement("span", {
      style: {
        display: 'block',
        margin: '3px 0 10px',
        fontSize: 'var(--type-option-size)',
        lineHeight: 'var(--type-option-line)',
        fontWeight: 600
      }
    }, u.title), /*#__PURE__*/React.createElement("span", {
      style: {
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        gap: 8
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--type-count-size)',
        color: 'var(--text-secondary)'
      }
    }, u.done, " of ", u.total), /*#__PURE__*/React.createElement("span", {
      style: {
        display: 'inline-flex',
        gap: 3
      }
    }, Array.from({
      length: u.total
    }).map((_, k) => /*#__PURE__*/React.createElement("span", {
      key: k,
      style: {
        width: 9,
        height: 9,
        background: k < u.done ? 'var(--blue-600)' : 'var(--rule-300)'
      }
    })))));
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: 16,
      borderTop: '1px solid var(--rule-divider)',
      paddingTop: 14,
      display: 'flex',
      alignItems: 'center',
      gap: 16
    }
  }, /*#__PURE__*/React.createElement(ActionButton, {
    variant: "primary"
  }, "Open ", topic), /*#__PURE__*/React.createElement(ActionButton, {
    variant: "link"
  }, "See every unit"), /*#__PURE__*/React.createElement("span", {
    style: {
      marginLeft: 'auto',
      fontSize: 'var(--type-count-size)',
      color: 'var(--text-quiet)'
    }
  }, "Open Hand is free to explore \xB7 Practice is scored"))), /*#__PURE__*/React.createElement(PaneShell, {
    voice: "reference",
    eyebrow: "How it works",
    title: "Two modes",
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 18
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: hEyebrow
  }, "Open Hand"), /*#__PURE__*/React.createElement("p", {
    style: hBody
  }, "Nothing is hidden. The rubric or answer key is face-up and you move it yourself to watch the score change. Nothing is scored.")), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: hEyebrow
  }, "Practice"), /*#__PURE__*/React.createElement("p", {
    style: hBody
  }, "The same question with the scoring withheld. Pull a hint only if you need one \u2014 every hint is listed on your feedback.")), /*#__PURE__*/React.createElement("div", {
    style: {
      borderTop: '1px solid var(--rule-divider)',
      paddingTop: 14
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: hEyebrow
  }, "Marks"), /*#__PURE__*/React.createElement("ul", {
    style: {
      margin: 0,
      padding: 0,
      listStyle: 'none',
      display: 'grid',
      gap: 7,
      fontSize: 'var(--type-body-size)',
      lineHeight: 'var(--type-body-line)',
      color: 'var(--text-secondary)'
    }
  }, /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--text-earned)',
      fontWeight: 700
    }
  }, "\u2713"), "\xA0\xA0point earned"), /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--text-revisit)',
      fontWeight: 700
    }
  }, "\u21BB"), "\xA0\xA0revisit \u2014 still available"), /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--text-lost)',
      fontWeight: 700
    }
  }, "\u2715"), "\xA0\xA0Open Hand only: point taken back"), /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--text-hint)',
      fontWeight: 700
    }
  }, "?"), "\xA0\xA0a hint, and what it costs"))), /*#__PURE__*/React.createElement("div", {
    style: {
      borderTop: '1px solid var(--rule-divider)',
      paddingTop: 14
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: hEyebrow
  }, "Exam"), /*#__PURE__*/React.createElement("p", {
    style: hBody
  }, "AP Statistics \xB7 May 2027. You have covered 2 of 9 units."))))), /*#__PURE__*/React.createElement(StudyMap, {
    open: map,
    unit: "Unit 2 \xB7 Exploring Two-Variable Data",
    onClose: () => setMap(false),
    topics: UNITS.slice(0, 4)
  }));
}
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/home/screen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/mcq/screen.jsx
try { (() => {
const {
  Plate,
  PlateGrid,
  PaneShell,
  ScoreChip,
  Masthead,
  Breadcrumb,
  StudyMap,
  RadioOptionRow,
  QuestionHeader,
  ActionRow,
  ActionButton,
  HintGate,
  FeedbackCard,
  VerdictChip,
  DeepDiveOverlay
} = window.CramAppleDesignSystem_c1541a;
const pmEyebrow = {
  display: 'block',
  marginBottom: 5,
  fontSize: 'var(--type-eyebrow-size)',
  fontWeight: 'var(--type-eyebrow-weight)',
  letterSpacing: 'var(--type-eyebrow-tracking)',
  textTransform: 'uppercase',
  color: 'var(--text-eyebrow)'
};
const pmBody = {
  margin: 0,
  fontSize: 'var(--type-body-size)',
  lineHeight: 'var(--type-body-line)',
  color: 'var(--text-secondary)'
};
const pmList = {
  margin: 0,
  padding: '0 0 0 18px',
  fontSize: 'var(--type-body-size)',
  lineHeight: 'var(--type-body-line)',
  color: 'var(--text-secondary)',
  display: 'grid',
  gap: 4
};
const eyebrow = pmEyebrow,
  body = pmBody,
  list = pmList;
const PM_OPTIONS = [{
  letter: 'A',
  text: 'Students who study one more hour per week score 4.1 points higher on the final.',
  verdict: 'distractor',
  why: 'Drops “predicted” and “mean”, so it promises every individual student the same 4.1 points.',
  fix: 'Say the predicted mean score, not what students score.'
}, {
  letter: 'B',
  text: 'For each additional hour studied per week, the predicted mean final exam score increases by 4.1 points.',
  verdict: 'correct',
  why: 'Names both variables, reads the slope as a rate, keeps the response a predicted mean, and carries the units.'
}, {
  letter: 'C',
  text: 'Studying one more hour per week causes final exam scores to rise by 4.1 points.',
  verdict: 'distractor',
  why: 'Observational data cannot support a causal claim; the line only describes association.',
  fix: 'Reserve “causes” for randomised experiments.'
}, {
  letter: 'D',
  text: 'The mean final exam score for these students is 4.1 points.',
  verdict: 'distractor',
  why: 'Reads the slope as if it were a centre. 4.1 is a rate of change, not a mean score.',
  fix: 'Slope answers “per one more x”, never “on average, y is”.'
}];
function Screen() {
  const [picked, setPicked] = React.useState(null);
  const [hint, setHint] = React.useState('idle');
  const [submitted, setSubmitted] = React.useState(false);
  const [map, setMap] = React.useState(false);
  const [deep, setDeep] = React.useState(false);
  const eliminated = hint === 'open' ? ['A', 'D'] : [];
  const correct = picked === 'B';
  const hintsUsed = hint === 'open' ? ['Rule out two choices'] : [];
  return /*#__PURE__*/React.createElement(Plate, {
    caption: "CramApple \xB7 AP Statistics \xB7 Unit 2 \xB7 2.3 Least-Squares Regression \xB7 Practice"
  }, /*#__PURE__*/React.createElement(Masthead, {
    course: "AP Statistics",
    right: /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 13,
        fontWeight: 700,
        letterSpacing: '.12em',
        textTransform: 'uppercase',
        color: 'var(--paper-000)'
      }
    }, "Practice")
  }), /*#__PURE__*/React.createElement(Breadcrumb, {
    items: ['Unit 2', '2.3 Least-Squares Regression', 'Question 7'],
    mapOpen: map,
    onOpenMap: () => setMap(m => !m),
    right: "Question 7 of 12"
  }), /*#__PURE__*/React.createElement(PlateGrid, null, /*#__PURE__*/React.createElement(PaneShell, {
    voice: submitted ? 'rubric' : 'hint',
    eyebrow: "Scoring",
    title: submitted ? 'Answer Key' : 'Elimination',
    right: /*#__PURE__*/React.createElement(ScoreChip, {
      earned: submitted ? correct ? 1 : 0 : null,
      total: 1
    }),
    style: {
      height: '100%'
    }
  }, submitted ? /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 10
    }
  }, PM_OPTIONS.map(o => {
    const isRight = o.verdict === 'correct';
    return /*#__PURE__*/React.createElement("div", {
      key: o.letter,
      style: {
        background: 'var(--surface-pane)',
        border: '1px solid var(--rule-300)',
        borderLeft: `var(--border-cap) solid ${isRight ? 'var(--blue-600)' : picked === o.letter ? 'var(--clay-600)' : 'var(--rule-400)'}`,
        padding: '10px 12px'
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        display: 'flex',
        alignItems: 'baseline',
        gap: 8
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 16,
        fontWeight: 700,
        color: isRight ? 'var(--text-earned)' : picked === o.letter ? 'var(--text-revisit)' : 'var(--text-quiet)'
      }
    }, isRight ? '✓' : picked === o.letter ? '↻' : '·'), /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--type-body-size)',
        fontWeight: 700
      }
    }, o.letter), /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--type-body-size)',
        lineHeight: 'var(--type-body-line)',
        color: 'var(--text-secondary)'
      }
    }, isRight ? 'Credited' : o.fix)));
  })) : /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 16
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: body
  }, "One point. One submission. The key stays closed until you commit."), /*#__PURE__*/React.createElement(HintGate, {
    name: "Rule out two choices",
    cost: "This strikes out two distractors and is listed on your feedback.",
    state: hint,
    onAsk: () => setHint('asking'),
    onConfirm: () => setHint('open'),
    onCancel: () => setHint('idle'),
    onHide: () => setHint('idle')
  }, /*#__PURE__*/React.createElement("p", {
    style: body
  }, "A and D are struck out in the question pane. Two remain \u2014 one of them names a cause the data cannot support.")), /*#__PURE__*/React.createElement("div", {
    style: {
      borderTop: '1px solid var(--rule-divider)',
      paddingTop: 14
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "How points are earned"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, "Read the stem before the options."), /*#__PURE__*/React.createElement("li", null, "Name the rate, then the response."), /*#__PURE__*/React.createElement("li", null, "Check the response is a mean."))), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "How points are lost"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, "Picking the first plausible wording."), /*#__PURE__*/React.createElement("li", null, "Accepting a causal verb."), /*#__PURE__*/React.createElement("li", null, "Reading slope as a centre."))))), /*#__PURE__*/React.createElement(PaneShell, {
    voice: "question",
    eyebrow: "Question",
    title: "Reading a slope",
    right: /*#__PURE__*/React.createElement(ScoreChip, {
      earned: submitted ? correct ? 1 : 0 : null,
      total: 1,
      label: "Score"
    }),
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 16,
      height: '100%',
      minHeight: 0,
      gridTemplateRows: 'auto minmax(0,1fr) auto auto'
    }
  }, /*#__PURE__*/React.createElement(QuestionHeader, {
    topic: "2.3 Least-Squares Regression",
    mode: "Practice",
    points: 1,
    stem: /*#__PURE__*/React.createElement(React.Fragment, null, "A least-squares line predicting final exam score from hours studied per week has slope 4.1. Which statement interprets the slope correctly?")
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 10,
      alignContent: 'start',
      minHeight: 0
    }
  }, (submitted ? PM_OPTIONS.filter(o => o.verdict === 'correct' || o.letter === picked) : PM_OPTIONS).map(o => /*#__PURE__*/React.createElement(RadioOptionRow, {
    key: o.letter,
    letter: o.letter,
    selected: picked === o.letter,
    verdict: o.verdict,
    showVerdict: submitted,
    eliminated: !submitted && eliminated.includes(o.letter),
    onSelect: () => setPicked(o.letter)
  }, o.text)), submitted && !correct && /*#__PURE__*/React.createElement("p", {
    style: {
      margin: 0,
      fontSize: 'var(--type-count-size)',
      color: 'var(--text-quiet)'
    }
  }, "The two options you did not pick are explained in the Answer Key.")), submitted ? /*#__PURE__*/React.createElement(FeedbackCard, {
    verdict: correct ? 'correct' : 'incorrect',
    earned: correct ? 1 : 0,
    total: 1,
    hintsUsed: hintsUsed,
    coaching: correct ? 'Right, and for the right reason: predicted mean, per one extra hour, in points. Keep all four moves when you write it out on an FRQ.' : `You picked ${picked}. ${PM_OPTIONS.find(o => o.letter === picked).why} Next time: check that the response is a predicted mean before you check the number.`
  }) : /*#__PURE__*/React.createElement("span", null), /*#__PURE__*/React.createElement(ActionRow, {
    note: submitted ? 'One point · scored' : picked ? 'Ready to submit' : 'Pick one answer',
    primary: submitted ? /*#__PURE__*/React.createElement(ActionButton, {
      variant: "primary"
    }, "Next question") : /*#__PURE__*/React.createElement(ActionButton, {
      variant: "primary",
      disabled: !picked,
      onClick: () => setSubmitted(true)
    }, "Submit answer"),
    secondary: submitted ? /*#__PURE__*/React.createElement(ActionButton, {
      variant: "link",
      onClick: () => setDeep(true)
    }, "Open the deep dive") : /*#__PURE__*/React.createElement(ActionButton, {
      variant: "link"
    }, "Skip for now")
  }))), /*#__PURE__*/React.createElement(PaneShell, {
    voice: "reference",
    eyebrow: "Allowed",
    title: "Reference Materials",
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 18
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Topic"), /*#__PURE__*/React.createElement("p", {
    style: body
  }, "2.3 Least-Squares Regression \u2014 using a fitted line to predict a quantitative response.")), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Skills"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, "2.D \u2014 Interpret slope and intercept in context."), /*#__PURE__*/React.createElement("li", null, "2.B \u2014 Describe form, direction and strength from a scatterplot."), /*#__PURE__*/React.createElement("li", null, "4.B \u2014 Distinguish association from causation."))), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Vocabulary"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Slope"), " \u2014 change in the predicted mean response per one-unit change in x."), /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Predicted value"), " \u2014 \u0177, the line's estimate, never an individual's actual score."), /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Explanatory variable"), " \u2014 x, here hours studied."))), /*#__PURE__*/React.createElement("div", {
    style: {
      borderTop: '1px solid var(--rule-divider)',
      paddingTop: 12
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "On the exam"), /*#__PURE__*/React.createElement("p", {
    style: body
  }, "Formula sheet gives \u0177 = a + bx. Context is not on the sheet \u2014 you supply it."))))), /*#__PURE__*/React.createElement(StudyMap, {
    open: map,
    unit: "Unit 2 \xB7 Exploring Two-Variable Data",
    onClose: () => setMap(false),
    topics: [{
      code: '2.1',
      title: 'Two Categorical Variables',
      done: 6,
      total: 6
    }, {
      code: '2.2',
      title: 'Scatterplots & Correlation',
      done: 4,
      total: 7
    }, {
      code: '2.3',
      title: 'Least-Squares Regression',
      done: 3,
      total: 8,
      current: true
    }, {
      code: '2.4',
      title: 'Residuals & Departures',
      done: 0,
      total: 5
    }]
  }), /*#__PURE__*/React.createElement(DeepDiveOverlay, {
    open: deep,
    title: "Three ways a slope sentence fails",
    onClose: () => setDeep(false),
    onCopy: () => {},
    sections: [{
      title: 'Promising an individual',
      body: 'The line predicts a mean. Any sentence that tells one student what they will score has left the model behind.'
    }, {
      title: 'Claiming a cause',
      body: 'These data are observational. The slope describes association only.'
    }, {
      title: 'Confusing rate with centre',
      body: 'Slope answers “per one more hour”, never “on average, what do students score?”.'
    }]
  }));
}
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/mcq/screen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/open-hand-frq/screen.jsx
try { (() => {
const {
  Plate,
  PlateGrid,
  PaneShell,
  ScoreChip,
  Masthead,
  Breadcrumb,
  StudyMap,
  RubricCriterionRow,
  QuestionHeader,
  GraphFrame,
  ActionRow,
  ActionButton,
  DeepDiveOverlay
} = window.CramAppleDesignSystem_c1541a;
const ohfEyebrow = {
  display: 'block',
  marginBottom: 5,
  fontSize: 'var(--type-eyebrow-size)',
  fontWeight: 'var(--type-eyebrow-weight)',
  letterSpacing: 'var(--type-eyebrow-tracking)',
  textTransform: 'uppercase',
  color: 'var(--text-eyebrow)'
};
const ohfBody = {
  margin: 0,
  fontSize: 'var(--type-body-size)',
  lineHeight: 'var(--type-body-line)',
  color: 'var(--text-secondary)'
};
const ohfList = {
  margin: 0,
  padding: '0 0 0 18px',
  fontSize: 'var(--type-body-size)',
  lineHeight: 'var(--type-body-line)',
  color: 'var(--text-secondary)',
  display: 'grid',
  gap: 4
};
const eyebrow = ohfEyebrow,
  body = ohfBody,
  list = ohfList;
const OHF_CRITERIA = [{
  code: 'E1',
  label: 'Names both variables',
  detail: 'Hours studied predicts final exam score.'
}, {
  code: 'E2',
  label: 'Reads the slope as a rate',
  detail: 'Per one additional hour studied.'
}, {
  code: 'E3',
  label: 'Says predicted mean, not actual',
  detail: 'The line predicts an average, not one student.'
}, {
  code: 'E4',
  label: 'States the units',
  detail: '4.1 points on the final exam.'
}];
function OpenHandFRQ() {
  const [awarded, setAwarded] = React.useState([true, true, true, true]);
  const [map, setMap] = React.useState(false);
  const [deep, setDeep] = React.useState(false);
  const earned = awarded.filter(Boolean).length;
  const toggle = i => setAwarded(a => a.map((v, k) => k === i ? !v : v));
  return /*#__PURE__*/React.createElement(Plate, {
    caption: "CramApple \xB7 AP Statistics \xB7 Unit 2 \xB7 2.3 Least-Squares Regression \xB7 Open Hand"
  }, /*#__PURE__*/React.createElement(Masthead, {
    course: "AP Statistics",
    right: /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 13,
        fontWeight: 700,
        letterSpacing: '.12em',
        textTransform: 'uppercase',
        color: 'var(--paper-000)'
      }
    }, "Open Hand")
  }), /*#__PURE__*/React.createElement(Breadcrumb, {
    items: ['Unit 2', '2.3 Least-Squares Regression', 'Question 4'],
    mapOpen: map,
    onOpenMap: () => setMap(m => !m),
    right: "Question 4 of 12"
  }), /*#__PURE__*/React.createElement(PlateGrid, null, /*#__PURE__*/React.createElement(PaneShell, {
    voice: "rubric",
    eyebrow: "Face-up",
    title: "Rubric",
    right: /*#__PURE__*/React.createElement(ScoreChip, {
      earned: earned,
      total: 4
    }),
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      ...body,
      marginBottom: 14
    }
  }, "Every point is face-up. Take one back to see what the answer loses."), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 10
    }
  }, OHF_CRITERIA.map((c, i) => /*#__PURE__*/React.createElement(RubricCriterionRow, {
    key: c.code,
    code: c.code,
    label: c.label,
    detail: c.detail,
    state: awarded[i] ? 'earned' : 'taken',
    interactive: true,
    onToggle: () => toggle(i)
  }))), /*#__PURE__*/React.createElement("p", {
    style: {
      ...body,
      marginTop: 14,
      color: 'var(--text-quiet)',
      fontSize: 'var(--type-count-size)'
    }
  }, "Click a criterion to take the point back. \u2715 is the teacher's hand \u2014 in Practice a missed point is \u21BB.")), /*#__PURE__*/React.createElement(PaneShell, {
    voice: "question",
    eyebrow: "Question",
    title: "Interpreting slope",
    right: /*#__PURE__*/React.createElement(ScoreChip, {
      earned: earned,
      total: 4,
      label: "Score"
    }),
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 14,
      height: '100%',
      minHeight: 0,
      gridTemplateRows: 'auto auto minmax(0,1fr) auto'
    }
  }, /*#__PURE__*/React.createElement(QuestionHeader, {
    topic: "2.3 Least-Squares Regression",
    mode: "Open Hand",
    points: 4,
    stem: /*#__PURE__*/React.createElement(React.Fragment, null, "The least-squares line for predicting final exam score from hours studied per week is ", /*#__PURE__*/React.createElement("span", {
      style: {
        fontFamily: 'var(--font-math)'
      }
    }, "\u0177 = 42.6 + 4.1x"), ". Interpret the slope in the context of this study.")
  }), /*#__PURE__*/React.createElement(GraphFrame, {
    caption: "Hours studied per week vs. final exam score",
    source: "n = 15"
  }, /*#__PURE__*/React.createElement("svg", {
    viewBox: "0 0 640 200",
    width: "100%",
    height: "188",
    role: "img",
    "aria-label": "Scatterplot of hours studied against final exam score"
  }, /*#__PURE__*/React.createElement("line", {
    x1: "54",
    y1: "168",
    x2: "616",
    y2: "168",
    stroke: "var(--purple-500)",
    strokeWidth: "1.5"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "54",
    y1: "168",
    x2: "54",
    y2: "14",
    stroke: "var(--purple-500)",
    strokeWidth: "1.5"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "70",
    y1: "156",
    x2: "600",
    y2: "34",
    stroke: "var(--purple-600)",
    strokeWidth: "2"
  }), [[86, 150], [122, 146], [158, 132], [194, 134], [230, 118], [266, 112], [302, 108], [338, 96], [374, 88], [410, 84], [446, 70], [482, 66], [518, 54], [554, 48], [590, 40]].map(([x, y], i) => /*#__PURE__*/React.createElement("circle", {
    key: i,
    cx: x,
    cy: y,
    r: "4.5",
    fill: "var(--purple-500)"
  })), /*#__PURE__*/React.createElement("circle", {
    cx: "566",
    cy: "140",
    r: "6",
    fill: "var(--yellow-500)",
    stroke: "var(--yellow-700)",
    strokeWidth: "1.5"
  }), /*#__PURE__*/React.createElement("text", {
    x: "574",
    y: "136",
    fontSize: "11",
    fill: "var(--yellow-700)",
    fontFamily: "var(--font-body)",
    fontWeight: "700"
  }, "influence"), /*#__PURE__*/React.createElement("text", {
    x: "335",
    y: "190",
    textAnchor: "middle",
    fontSize: "12",
    fill: "var(--purple-500)",
    fontFamily: "var(--font-body)"
  }, "Hours studied per week"), /*#__PURE__*/React.createElement("text", {
    x: "16",
    y: "92",
    textAnchor: "middle",
    fontSize: "12",
    fill: "var(--purple-500)",
    fontFamily: "var(--font-body)",
    transform: "rotate(-90 16 92)"
  }, "Final exam score"))), /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--surface-work)',
      border: '1px solid var(--purple-rule)',
      borderTop: 'var(--border-cap) solid var(--cap-work)',
      padding: '14px 16px'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Credited response"), /*#__PURE__*/React.createElement("p", {
    style: {
      margin: 0,
      fontSize: 'var(--type-option-size)',
      lineHeight: 'var(--type-option-line)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      background: awarded[1] ? 'var(--blue-050)' : 'transparent',
      textDecoration: awarded[1] ? 'none' : 'line-through',
      color: awarded[1] ? 'var(--text-body)' : 'var(--status-eliminated)'
    }
  }, "For each additional hour studied per week,"), ' ', /*#__PURE__*/React.createElement("span", {
    style: {
      background: awarded[2] ? 'var(--blue-050)' : 'transparent',
      textDecoration: awarded[2] ? 'none' : 'line-through',
      color: awarded[2] ? 'var(--text-body)' : 'var(--status-eliminated)'
    }
  }, "the predicted mean"), ' ', /*#__PURE__*/React.createElement("span", {
    style: {
      background: awarded[0] ? 'var(--blue-050)' : 'transparent',
      textDecoration: awarded[0] ? 'none' : 'line-through',
      color: awarded[0] ? 'var(--text-body)' : 'var(--status-eliminated)'
    }
  }, "final exam score"), ' ', "increases by 4.1", ' ', /*#__PURE__*/React.createElement("span", {
    style: {
      background: awarded[3] ? 'var(--blue-050)' : 'transparent',
      textDecoration: awarded[3] ? 'none' : 'line-through',
      color: awarded[3] ? 'var(--text-body)' : 'var(--status-eliminated)'
    }
  }, "points"), "."), /*#__PURE__*/React.createElement("p", {
    style: {
      ...body,
      marginTop: 8,
      fontSize: 'var(--type-count-size)'
    }
  }, "Highlight shows which rubric point each phrase is carrying.")), /*#__PURE__*/React.createElement(ActionRow, {
    note: "Nothing is scored in Open Hand",
    primary: /*#__PURE__*/React.createElement(ActionButton, {
      variant: "primary"
    }, "Next question"),
    secondary: /*#__PURE__*/React.createElement(ActionButton, {
      variant: "link",
      onClick: () => setDeep(true)
    }, "Open the deep dive")
  }))), /*#__PURE__*/React.createElement(PaneShell, {
    voice: "reference",
    eyebrow: "Allowed",
    title: "Reference Materials",
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 18
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Topic"), /*#__PURE__*/React.createElement("p", {
    style: body
  }, "2.3 Least-Squares Regression \u2014 using a fitted line to predict a quantitative response.")), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Skills"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, "2.D \u2014 Interpret slope and intercept in context."), /*#__PURE__*/React.createElement("li", null, "2.B \u2014 Describe form, direction and strength from a scatterplot."), /*#__PURE__*/React.createElement("li", null, "4.B \u2014 Distinguish association from causation."))), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Vocabulary"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Slope"), " \u2014 change in the predicted mean response per one-unit change in x."), /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Predicted value"), " \u2014 \u0177, the line's estimate, never an individual's actual score."), /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Explanatory variable"), " \u2014 x, here hours studied."))), /*#__PURE__*/React.createElement("div", {
    style: {
      borderTop: '1px solid var(--rule-divider)',
      paddingTop: 12
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "On the exam"), /*#__PURE__*/React.createElement("p", {
    style: body
  }, "Formula sheet gives \u0177 = a + bx and b = r(s", /*#__PURE__*/React.createElement("sub", null, "y"), "/s", /*#__PURE__*/React.createElement("sub", null, "x"), "). Context is not on the sheet \u2014 you supply it."))))), /*#__PURE__*/React.createElement(StudyMap, {
    open: map,
    unit: "Unit 2 \xB7 Exploring Two-Variable Data",
    onClose: () => setMap(false),
    topics: [{
      code: '2.1',
      title: 'Two Categorical Variables',
      done: 6,
      total: 6
    }, {
      code: '2.2',
      title: 'Scatterplots & Correlation',
      done: 4,
      total: 7
    }, {
      code: '2.3',
      title: 'Least-Squares Regression',
      done: 3,
      total: 8,
      current: true
    }, {
      code: '2.4',
      title: 'Residuals & Departures',
      done: 0,
      total: 5
    }]
  }), /*#__PURE__*/React.createElement(DeepDiveOverlay, {
    open: deep,
    title: "Why slope is a mean, not a promise",
    onClose: () => setDeep(false),
    onCopy: () => {},
    sections: [{
      title: 'The claim',
      body: 'A slope of 4.1 says that among students like these, the predicted mean final exam score is 4.1 points higher for each additional hour studied per week. It is a statement about the line, not about any one student.'
    }, {
      title: 'The trap',
      body: '“Will score 4.1 points higher” promises an individual an outcome. The regression line has no individuals in it — the residuals hold everything it missed, and for a single student that gap is often larger than the slope.'
    }, {
      title: 'The habit',
      body: 'Write it in four moves: per one extra hour (rate), the predicted mean final exam score (response, as a mean), increases by 4.1 (magnitude), points (units). Four moves, four rubric points.'
    }]
  }));
}
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/open-hand-frq/screen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/open-hand-mcq/screen.jsx
try { (() => {
const {
  Plate,
  PlateGrid,
  PaneShell,
  ScoreChip,
  Masthead,
  Breadcrumb,
  StudyMap,
  RadioOptionRow,
  QuestionHeader,
  ActionRow,
  ActionButton,
  DeepDiveOverlay
} = window.CramAppleDesignSystem_c1541a;
const ohmEyebrow = {
  display: 'block',
  marginBottom: 5,
  fontSize: 'var(--type-eyebrow-size)',
  fontWeight: 'var(--type-eyebrow-weight)',
  letterSpacing: 'var(--type-eyebrow-tracking)',
  textTransform: 'uppercase',
  color: 'var(--text-eyebrow)'
};
const ohmBody = {
  margin: 0,
  fontSize: 'var(--type-body-size)',
  lineHeight: 'var(--type-body-line)',
  color: 'var(--text-secondary)'
};
const ohmList = {
  margin: 0,
  padding: '0 0 0 18px',
  fontSize: 'var(--type-body-size)',
  lineHeight: 'var(--type-body-line)',
  color: 'var(--text-secondary)',
  display: 'grid',
  gap: 4
};
const eyebrow = ohmEyebrow,
  body = ohmBody,
  list = ohmList;
const OHM_OPTIONS = [{
  letter: 'A',
  text: 'Students who study one more hour per week score 4.1 points higher on the final.',
  verdict: 'distractor',
  why: 'Drops “predicted” and “mean”, so it promises every individual student the same 4.1 points.',
  fix: 'Say the predicted mean score, not what students score.'
}, {
  letter: 'B',
  text: 'For each additional hour studied per week, the predicted mean final exam score increases by 4.1 points.',
  verdict: 'correct',
  why: 'Names both variables, reads the slope as a rate, keeps the response a predicted mean, and carries the units.'
}, {
  letter: 'C',
  text: 'Studying one more hour per week causes final exam scores to rise by 4.1 points.',
  verdict: 'distractor',
  why: 'Observational data cannot support a causal claim; the line only describes association.',
  fix: 'Reserve “causes” for randomised experiments.'
}, {
  letter: 'D',
  text: 'The mean final exam score for these students is 4.1 points.',
  verdict: 'distractor',
  why: 'Reads the slope as if it were a centre. 4.1 is a rate of change, not a mean score.',
  fix: 'Slope answers “per one more x”, never “on average, y is”.'
}];
function Screen() {
  const [picked, setPicked] = React.useState('B');
  const [read, setRead] = React.useState(['B']);
  const [map, setMap] = React.useState(false);
  const [deep, setDeep] = React.useState(false);
  const pick = l => {
    setPicked(l);
    setRead(r => r.includes(l) ? r : [...r, l]);
  };
  return /*#__PURE__*/React.createElement(Plate, {
    caption: "CramApple \xB7 AP Statistics \xB7 Unit 2 \xB7 2.3 Least-Squares Regression \xB7 Open Hand"
  }, /*#__PURE__*/React.createElement(Masthead, {
    course: "AP Statistics",
    right: /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 13,
        fontWeight: 700,
        letterSpacing: '.12em',
        textTransform: 'uppercase',
        color: 'var(--paper-000)'
      }
    }, "Open Hand")
  }), /*#__PURE__*/React.createElement(Breadcrumb, {
    items: ['Unit 2', '2.3 Least-Squares Regression', 'Question 7'],
    mapOpen: map,
    onOpenMap: () => setMap(m => !m),
    right: "Question 7 of 12"
  }), /*#__PURE__*/React.createElement(PlateGrid, null, /*#__PURE__*/React.createElement(PaneShell, {
    voice: "rubric",
    eyebrow: "Face-up",
    title: "Answer Key",
    right: /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--type-count-size)',
        fontWeight: 600,
        color: 'var(--text-secondary)'
      }
    }, read.length, " of 4 read"),
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      ...body,
      marginBottom: 14
    }
  }, "Nothing is scored here. Read every explanation \u2014 three of these four are traps you will meet again."), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 10
    }
  }, OHM_OPTIONS.map(o => {
    const isRead = read.includes(o.letter);
    const correct = o.verdict === 'correct';
    return /*#__PURE__*/React.createElement("div", {
      key: o.letter,
      onClick: () => pick(o.letter),
      style: {
        cursor: 'pointer',
        background: 'var(--surface-pane)',
        border: '1px solid var(--rule-300)',
        borderLeft: `var(--border-cap) solid ${correct ? 'var(--blue-600)' : 'var(--maroon-600)'}`,
        padding: '10px 12px'
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        display: 'flex',
        alignItems: 'baseline',
        justifyContent: 'space-between',
        gap: 8
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--type-body-size)',
        fontWeight: 700,
        color: correct ? 'var(--text-earned)' : 'var(--text-lost)'
      }
    }, o.letter, " \xB7 ", correct ? 'Credited' : 'Distractor'), /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--type-count-size)',
        fontWeight: 600,
        color: isRead ? 'var(--text-earned)' : 'var(--text-quiet)'
      }
    }, isRead ? '✓ read' : '· unread')), /*#__PURE__*/React.createElement("span", {
      style: {
        display: 'block',
        marginTop: 4,
        fontSize: 'var(--type-body-size)',
        lineHeight: 'var(--type-body-line)',
        color: 'var(--text-secondary)'
      }
    }, correct ? 'Four moves, four ways to lose the point.' : o.fix));
  })), /*#__PURE__*/React.createElement("p", {
    style: {
      ...body,
      marginTop: 14,
      fontSize: 'var(--type-count-size)',
      color: 'var(--text-quiet)'
    }
  }, "Selecting an option is free in Open Hand. It counts as reading, not as answering.")), /*#__PURE__*/React.createElement(PaneShell, {
    voice: "question",
    eyebrow: "Question",
    title: "Reading a slope",
    right: /*#__PURE__*/React.createElement("span", {
      style: {
        fontSize: 'var(--type-count-size)',
        fontWeight: 600,
        color: 'var(--text-secondary)'
      }
    }, "Not scored"),
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 16,
      height: '100%',
      minHeight: 0,
      gridTemplateRows: 'auto minmax(0,1fr) auto'
    }
  }, /*#__PURE__*/React.createElement(QuestionHeader, {
    topic: "2.3 Least-Squares Regression",
    mode: "Open Hand",
    points: 1,
    stem: /*#__PURE__*/React.createElement(React.Fragment, null, "A least-squares line predicting final exam score from hours studied per week has slope 4.1. Which statement interprets the slope correctly?")
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 10,
      alignContent: 'start',
      minHeight: 0
    }
  }, OHM_OPTIONS.map(o => /*#__PURE__*/React.createElement(RadioOptionRow, {
    key: o.letter,
    letter: o.letter,
    selected: picked === o.letter,
    verdict: o.verdict,
    showVerdict: true,
    onSelect: () => pick(o.letter),
    explanation: picked === o.letter ? o.why : undefined,
    note: picked === o.letter ? o.fix : undefined
  }, o.text))), /*#__PURE__*/React.createElement(ActionRow, {
    note: `${read.length} of 4 explanations read`,
    primary: /*#__PURE__*/React.createElement(ActionButton, {
      variant: "primary"
    }, "Next question"),
    secondary: /*#__PURE__*/React.createElement(ActionButton, {
      variant: "link",
      onClick: () => setDeep(true)
    }, "Open the deep dive")
  }))), /*#__PURE__*/React.createElement(PaneShell, {
    voice: "reference",
    eyebrow: "Allowed",
    title: "Reference Materials",
    style: {
      height: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gap: 18
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Topic"), /*#__PURE__*/React.createElement("p", {
    style: body
  }, "2.3 Least-Squares Regression \u2014 using a fitted line to predict a quantitative response.")), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Skills"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, "2.D \u2014 Interpret slope and intercept in context."), /*#__PURE__*/React.createElement("li", null, "2.B \u2014 Describe form, direction and strength from a scatterplot."), /*#__PURE__*/React.createElement("li", null, "4.B \u2014 Distinguish association from causation."))), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "Vocabulary"), /*#__PURE__*/React.createElement("ul", {
    style: list
  }, /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Slope"), " \u2014 change in the predicted mean response per one-unit change in x."), /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Predicted value"), " \u2014 \u0177, the line's estimate, never an individual's actual score."), /*#__PURE__*/React.createElement("li", null, /*#__PURE__*/React.createElement("strong", null, "Explanatory variable"), " \u2014 x, here hours studied."))), /*#__PURE__*/React.createElement("div", {
    style: {
      borderTop: '1px solid var(--rule-divider)',
      paddingTop: 12
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: eyebrow
  }, "On the exam"), /*#__PURE__*/React.createElement("p", {
    style: body
  }, "Formula sheet gives \u0177 = a + bx. Context is not on the sheet \u2014 you supply it."))))), /*#__PURE__*/React.createElement(StudyMap, {
    open: map,
    unit: "Unit 2 \xB7 Exploring Two-Variable Data",
    onClose: () => setMap(false),
    topics: [{
      code: '2.1',
      title: 'Two Categorical Variables',
      done: 6,
      total: 6
    }, {
      code: '2.2',
      title: 'Scatterplots & Correlation',
      done: 4,
      total: 7
    }, {
      code: '2.3',
      title: 'Least-Squares Regression',
      done: 3,
      total: 8,
      current: true
    }, {
      code: '2.4',
      title: 'Residuals & Departures',
      done: 0,
      total: 5
    }]
  }), /*#__PURE__*/React.createElement(DeepDiveOverlay, {
    open: deep,
    title: "Three ways a slope sentence fails",
    onClose: () => setDeep(false),
    onCopy: () => {},
    sections: [{
      title: 'Promising an individual',
      body: 'The line predicts a mean. Any sentence that tells one student what they will score has left the model behind — the residual for that student is usually bigger than the slope.'
    }, {
      title: 'Claiming a cause',
      body: 'These data are observational. Hours studied is entangled with prior grades, sleep and course load; the slope describes association only.'
    }, {
      title: 'Confusing rate with centre',
      body: 'Slope answers “per one more hour”. Intercept answers “at zero hours”. Neither answers “on average, what do students score?”.'
    }]
  }));
}
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/open-hand-mcq/screen.jsx", error: String((e && e.message) || e) }); }

__ds_ns.ActionButton = __ds_scope.ActionButton;

__ds_ns.ActionRow = __ds_scope.ActionRow;

__ds_ns.RadioOptionRow = __ds_scope.RadioOptionRow;

__ds_ns.FeedbackCard = __ds_scope.FeedbackCard;

__ds_ns.VerdictChip = __ds_scope.VerdictChip;

__ds_ns.HintGate = __ds_scope.HintGate;

__ds_ns.Breadcrumb = __ds_scope.Breadcrumb;

__ds_ns.Masthead = __ds_scope.Masthead;

__ds_ns.StudyMap = __ds_scope.StudyMap;

__ds_ns.Wordmark = __ds_scope.Wordmark;

__ds_ns.DeepDiveOverlay = __ds_scope.DeepDiveOverlay;

__ds_ns.PaneShell = __ds_scope.PaneShell;

__ds_ns.Plate = __ds_scope.Plate;

__ds_ns.PlateGrid = __ds_scope.PlateGrid;

__ds_ns.ScoreChip = __ds_scope.ScoreChip;

__ds_ns.AnswerField = __ds_scope.AnswerField;

__ds_ns.GraphFrame = __ds_scope.GraphFrame;

__ds_ns.QuestionHeader = __ds_scope.QuestionHeader;

__ds_ns.RubricCriterionRow = __ds_scope.RubricCriterionRow;

})();
