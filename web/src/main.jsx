import React from 'react';
import ReactDOM from 'react-dom/client';

// The design system's entry point. It is an @import list only -- every token
// the app uses resolves through it.
import './styles/styles.css';
import './styles/app.css';

import { App } from './App.jsx';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
