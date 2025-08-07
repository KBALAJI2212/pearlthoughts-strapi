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
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #141E30, #243B55)',
      color: '#fff',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      fontFamily: 'sans-serif',
      textAlign: 'center',
      padding: '2rem'
    }}>
      <h1 style={{
        fontSize: '3rem',
        fontWeight: 'bold',
        marginBottom: '2rem',
        textShadow: '2px 2px 4px rgba(0, 0, 0, 0.3)'
      }}>
        🕒 My React Clock App
      </h1>

      {showClock ? (
        <div style={{
          backgroundColor: 'rgba(255, 255, 255, 0.1)',
          padding: '2rem 3rem',
          borderRadius: '12px',
          boxShadow: '0 4px 20px rgba(0, 0, 0, 0.3)',
          fontSize: '2.5rem',
          fontWeight: 'bold'
        }}>
          {time}
        </div>
      ) : (
        <div style={{
          backgroundColor: 'rgba(0, 0, 0, 0.3)',
          padding: '1.5rem 2rem',
          borderRadius: '12px',
          boxShadow: '0 4px 20px rgba(0, 0, 0, 0.2)'
        }}>
          <p style={{ fontSize: '1.5rem' }}> Clock feature is OFF</p>
        </div>
      )}
    </div>
  );
}

export default App;
