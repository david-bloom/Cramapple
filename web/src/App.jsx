import React from 'react';
import { HashRouter, Routes, Route, Navigate } from 'react-router-dom';
import { SessionProvider } from './session/SessionProvider.jsx';
import { HomeScreen } from './screens/HomeScreen.jsx';
import { QuestionRoute } from './screens/QuestionRoute.jsx';

/**
 * HashRouter, not BrowserRouter: the app is a static build with no server
 * rewrite rules, and a hash route survives a refresh on any host.
 */
export function App() {
  return (
    <SessionProvider>
      <HashRouter>
        <Routes>
          <Route path="/" element={<HomeScreen />} />
          <Route path="/:mode/:packageId" element={<QuestionRoute />} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </HashRouter>
    </SessionProvider>
  );
}
