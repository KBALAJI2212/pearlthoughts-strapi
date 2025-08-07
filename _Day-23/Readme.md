# Unleash Feature Flags for React Apps

Unleash is an **open-source feature flag management** system that helps you release new features **gradually**, **safely**, and **with control**. It enables **continuous delivery** by allowing you to toggle features on/off for different users or environments **without deploying new code**.

---

## Use Cases

- Enable/disable features without redeploying
- Roll out features to a % of users (gradual rollout)
- Enable features for specific user segments (e.g., beta testers)
- A/B testing
- Kill switch for unstable features

---

## Local Setup for a React Application

You’ll set up:
1. A local Unleash server (via Docker)
2. A React app that uses the **Unleash Proxy**
3. Feature toggles controlled via the Unleash UI

---

## Prerequisites

- Docker + Docker Compose
- A React frontend app (e.g., Vite, CRA, Next.js)
- Node.js and npm/yarn (for React app)

---

## Step 1: Run Unleash Locally (Using Docker)

Create a `docker-compose.yml` in a new directory:

```yaml
services:
  unleash-db:
    image: postgres:15
    container_name: postgres
    environment:
      POSTGRES_DB: unleash
      POSTGRES_USER: unleash_user
      POSTGRES_PASSWORD: unleash_pass
    volumes:
      - db-data:/var/lib/postgresql/data

  unleash:
    image: unleashorg/unleash-server
    container_name: unleash
    ports:
      - "4242:4242"
    environment:
      DATABASE_HOST: unleash-db
      DATABASE_NAME: unleash
      DATABASE_USERNAME: unleash_user
      DATABASE_PASSWORD: unleash_pass
      INIT_FRONTEND_API_TOKENS: "default:development.unleash-insecure-frontend-api-token"
      INIT_CLIENT_API_TOKENS: "default:development.unleash-insecure-api-token"
      DATABASE_SSL: "false"
      LOG_LEVEL: debug
    depends_on:
      - unleash-db
  proxy:
    image: unleashorg/unleash-proxy
    container_name: unleash-proxy
    ports:
      - "3000:3000"
    environment:
      UNLEASH_URL: http://unleash:4242/api
      UNLEASH_API_TOKEN: "default:development.unleash-insecure-api-token" #Paste your CLIENT API Token copied from Unleash dashboard
      UNLEASH_PROXY_CLIENT_KEYS: "default:development.unleash-insecure-frontend-api-token" #Paste your FRONTEND API Token copied from Unleash dashboard
      UNLEASH_APP_NAME: frontend
      LOG_LEVEL: debug
    depends_on:
      - unleash

volumes:
  db-data:

networks:
  default:
    name : unleash-network
```

Start the services:

```bash
docker-compose up -d
```

### Unleash Dashboard:

Visit: [http://localhost:4242](http://localhost:4242)  
Login with:
- Username: `admin`
- Password: `unleash4all`

---

## Step 2: Create a Feature Toggle

1. Go to the **Unleash dashboard** (`localhost:4242`)
2. Create a new feature toggle (e.g., `showLiveClock`)
3. Enable it for your environment (e.g., `development`)

---

## Step 3: Install Unleash Client in React App


```bash
npm install @unleash/proxy-client-react unleash-proxy-client
```

#### ```NOTE```: If you dont have an App and just want to test this setup using a **Test-App**, Run the following commands: 

```bash
npm create vite@latest unleash-test -- --template react
cd unleash-test
npm install
```

---

## Step 4: Integrate Unleash in Your React App

### Initialize Unleash in your App

```jsx
// copy inside src/main.jsx or src/index.js
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
```

---

### Use Feature Flags in Components

```jsx
// copy inside src/App.jsx
import { useFlag, useUnleashClient } from '@unleash/proxy-client-react';
import { useEffect, useState } from 'react';

function App() {
  const showClock = useFlag('showLiveClock');
  const client = useUnleashClient();
  const allToggles = client.getAllToggles();

  const [time, setTime] = useState(new Date().toLocaleTimeString());

  useEffect(() => {
    if (showClock) {
      const interval = setInterval(() => {
        setTime(new Date().toLocaleTimeString());
      }, 1000);
      return () => clearInterval(interval);
    }
  }, [showClock]);

return (
  <div>
    <h1>My React Clock App</h1>

    {showClock ? (
      <div>{time}</div>
    ) : (
      <div>
        <p>Clock feature is OFF</p>
      </div>
    )}
  </div>
);
}

export default App;
```
### Run Your NodeJs Application 

```bash
npm run dev
```

Visit: [http://localhost:5173](http://localhost:5173) 


---

## Testing Feature Flags

1. Open `http://localhost:4242`
2. Enable or disable the `showLiveClock` flag
3. Save and reload your React app
4. You should see the change **immediately** without redeploying

---

## Clean Up

```bash
docker-compose down -v
```

---

## Notes

- **Proxy Mode** is preferred for frontend apps to avoid exposing admin tokens.
- Always use **Proxy client keys**, not admin keys, in frontend apps.


---

## (Optional) Create an API token through Unleash Admin UI
   
  - Projects > Settings > API access: <type>:<project>:<random-string/hash>

#### Examples

  - Admin Token (full access to the API): **default:admin:abc123xyz456**

  - Client Token (used by SDKs to fetch flags): **client:my-project:6f5123eac7a5480985a9**

  - Frontend Token (used in frontend apps): **frontend:my-project:5c2a1f3de5e8454a8b1a**


---
<h2>PROJECT SCREENSHOTS</h2>

### This is the Unleash Dashboard:
  <img src="./screenshots/Screenshot From 2025-08-07 22-06-58.png" width="1000"/>

### This is screenshot of API Tokens:
  <img src="./screenshots/Screenshot From 2025-08-07 22-07-12.png" width="1000"/>

### These are screenshots of different features in **On/Off** state:

- #### Live Clock:
  <img src="./screenshots/Screenshot From 2025-08-07 22-06-46.png" width="1000"/>
  <img src="./screenshots/Screenshot From 2025-08-07 22-06-14.png" width="1000"/>

- #### Welcome Banner:
  <img src="./screenshots/Screenshot From 2025-08-07 20-09-19.png" width="1000"/>  
  <img src="./screenshots/Screenshot From 2025-08-07 20-21-53.png" width="1000"/>
---


# Understanding Each Step of Unleash Integration

This section explains **what’s happening at each step** during the setup of Unleash for a React-based application using Docker.

---

## Docker Compose Setup

### Step 1: `docker-compose.yml`

We use Docker Compose to launch:
- `unleash-db` → A PostgreSQL container that stores Unleash configs
- `unleash` → The main Unleash server
- `proxy` → The Unleash Proxy that safely exposes feature flags to frontend apps

```yaml
unleash-db:
  image: postgres:15
  ...
```
This sets up a Postgres database for the Unleash server.

```yaml
unleash:
  image: unleashorg/unleash-server
  ports:
    - "4242:4242"
  ...
```
This is the main Unleash UI and backend server. It connects to the Postgres container and listens on port 4242.

```yaml
proxy:
  image: unleashorg/unleash-proxy
  ports:
    - "3000:3000"
  ...
```
The proxy acts as a **safe middleman** between your frontend and the backend, exposing only the necessary flags and using a `frontend`-only client token.

---

## Unleash Dashboard

Visit [http://localhost:4242](http://localhost:4242)

You can log in, create a feature toggle, and manage environments. It’s your **control panel** for flags.

---

## Feature Toggle Setup

You create a toggle like `showLiveClock` via the dashboard.

This will control whether a specific UI component in your React app is shown or not, based on toggle state.

---

## Install SDK

```bash
npm install @unleash/proxy-client-react
```

This SDK helps your React app connect to the Unleash proxy and fetch feature toggles.

---

## SDK Initialization (React)

```jsx
import { UnleashClientProvider, createUnleashClient } from '@unleash/proxy-client-react';
```

We create a `client` that connects to:

- Proxy URL: `http://localhost:3000/proxy`
- Client Key: `default:development.unleash-insecure-frontend-api-token` #Paste Your Key

This client is then passed into a React context using:

```jsx
<UnleashClientProvider unleashClient={unleash}>
  <App />
</UnleashClientProvider>
```

This makes feature flags available throughout the app via hooks.

---

## Using a Feature Flag in Component

```jsx
const showBanner = useFlag('showLiveClock');
```

This line checks if the `showLiveClock` toggle is **enabled**. If true, a Live Clock component is shown. This enables **runtime control** over feature visibility.

---

## Testing

- Go back to the Unleash dashboard.
- Enable/disable the toggle.
- Reload your frontend.

You’ll see the banner appear/disappear—**without deploying** new frontend code.

---

## Teardown

```bash
docker-compose down -v
```

This stops and removes containers and volumes.

---

## Security Tip

Never expose admin tokens in frontend code. Use the **Unleash Proxy** with safe frontend client keys.


---
