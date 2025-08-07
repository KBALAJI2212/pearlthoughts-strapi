import App from './App.jsx'
import React from 'react'
import ReactDOM from 'react-dom/client';
import {
  UnleashClient,
  FlagProvider,
} from '@unleash/proxy-client-react';

const client = new UnleashClient({
  url: 'http://localhost:3000/proxy', // Proxy URL
  clientKey: 'default:development.unleash-insecure-frontend-api-token', // Paste your CLIENT API Token copied from Unleash dashboard
  appName: 'vite-react-app',
  environment: 'development',
});

client.start();

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <FlagProvider unleashClient={client}>
      <App />
    </FlagProvider>
  </React.StrictMode>
);
