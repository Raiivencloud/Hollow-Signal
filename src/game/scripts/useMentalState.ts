import { useState, useEffect } from 'react';

/**
 * Simulates a mental state for the UI demo
 */
export function useMentalState() {
  const [anxiety, setAnxiety] = useState(0);
  const [paranoia, setParanoia] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setAnxiety(prev => Math.max(0, prev - 0.005));
    }, 100);

    return () => clearInterval(interval);
  }, []);

  const triggerAnxiety = (amount: number) => {
    setAnxiety(prev => Math.min(1, prev + amount));
  };

  const addParanoia = (amount: number) => {
    setParanoia(prev => Math.min(1, prev + amount));
  };

  return { anxiety, paranoia, triggerAnxiety, addParanoia };
}
