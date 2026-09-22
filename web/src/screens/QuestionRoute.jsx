import React, { useEffect } from 'react';
import { Navigate, useNavigate, useParams } from 'react-router-dom';
import { getQuestion, nextQuestion } from '../content/index.js';
import { useSession } from '../session/SessionProvider.jsx';
import { PracticeFrqScreen } from './PracticeFrqScreen.jsx';
import { PracticeMcqScreen } from './PracticeMcqScreen.jsx';
import { OpenHandFrqScreen } from './OpenHandFrqScreen.jsx';
import { OpenHandMcqScreen } from './OpenHandMcqScreen.jsx';

const SCREENS = {
  'practice:frq': PracticeFrqScreen,
  'practice:mcq': PracticeMcqScreen,
  'open-hand:frq': OpenHandFrqScreen,
  'open-hand:mcq': OpenHandMcqScreen
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
  const Screen = question ? SCREENS[`${mode}:${question.item_type}`] : null;

  useEffect(() => {
    // Real packages are reviewed directly and are not part of the walkthrough,
    // so they never become its resume point.
    if (question && Screen && question.source !== 'package') setLast(packageId, mode);
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
