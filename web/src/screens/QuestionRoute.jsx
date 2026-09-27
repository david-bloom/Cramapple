import React, { useEffect } from 'react';
import { Navigate, useNavigate, useParams } from 'react-router-dom';
import { getQuestion, nextQuestion } from '../content/index.js';
import { useSession } from '../session/SessionProvider.jsx';
import { PracticeFrqScreen } from './PracticeFrqScreen.jsx';
import { PracticeMcqScreen } from './PracticeMcqScreen.jsx';
import { OpenHandFrqScreen } from './OpenHandFrqScreen.jsx';
import { OpenHandMcqScreen } from './OpenHandMcqScreen.jsx';
import { PracticeByoqFrqScreen } from './PracticeByoqFrqScreen.jsx';
import { PracticeByoqMcqScreen } from './PracticeByoqMcqScreen.jsx';

const SCREENS = {
  'practice:frq': PracticeFrqScreen,
  'practice:mcq': PracticeMcqScreen,
  'open-hand:frq': OpenHandFrqScreen,
  'open-hand:mcq': OpenHandMcqScreen,
  // A BYOQ item never resolves an 'open-hand:*:byoq' key, on purpose: it has no
  // answer key to show face-up. See DECISION-0057. This is the enforcement
  // point for that rule, including against a hand-typed URL.
  'practice:frq:byoq': PracticeByoqFrqScreen,
  'practice:mcq:byoq': PracticeByoqMcqScreen
};

/**
 * One route for every question. The mode comes from the path and the item type
 * from the content, so the four templates are four screens behind two URLs
 * rather than four hand-wired routes.
 */
export function QuestionRoute() {
  const { mode, packageId } = useParams();
  const navigate = useNavigate();
  const { setLast } = useSession();

  const question = getQuestion(packageId);
  const key = question?.source === 'student' ? `${mode}:${question.item_type}:byoq` : `${mode}:${question?.item_type}`;
  const Screen = question ? SCREENS[key] : null;

  useEffect(() => {
    // Real packages and BYOQ items are not part of the walkthrough, so neither
    // becomes its resume point.
    if (question && Screen && question.source !== 'package' && question.source !== 'student') setLast(packageId, mode);
  }, [question, Screen, packageId, mode, setLast]);

  if (!question || !Screen) return <Navigate to="/" replace />;

  const goNext = () => {
    const next = nextQuestion(question);
    navigate(next ? `/${mode}/${next.package_id}` : '/');
  };

  // Remount on navigation so per-question local state (a draft answer, a
  // selection) does not leak from one question into the next.
  return <Screen key={`${mode}:${packageId}`} question={question} onNext={goNext} />;
}
