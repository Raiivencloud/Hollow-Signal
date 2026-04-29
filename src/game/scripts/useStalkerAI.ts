import { useState, useEffect } from 'react';

export function useStalkerAI(playerPos: { x: number; y: number }, flashlightOn: boolean) {
  const [pos, setPos] = useState({ x: 100, y: 100 });
  const [state, setState] = useState<'IDLE' | 'STALKING' | 'CHASING'>('IDLE');

  useEffect(() => {
    const interval = setInterval(() => {
      const dist = Math.sqrt(
        Math.pow(playerPos.x - pos.x, 2) + Math.pow(playerPos.y - pos.y, 2)
      );

      if (flashlightOn) {
        if (dist > 200) {
          setState('STALKING');
          // Move slowly towards player
          setPos(prev => ({
            x: prev.x + (playerPos.x - prev.x) * 0.02,
            y: prev.y + (playerPos.y - prev.y) * 0.02
          }));
        } else {
          setState('CHASING');
          // Aggressive move
          setPos(prev => ({
            x: prev.x + (playerPos.x - prev.x) * 0.05,
            y: prev.y + (playerPos.y - prev.y) * 0.05
          }));
        }
      } else {
        setState('IDLE');
        // Drift away
      }
    }, 50);

    return () => clearInterval(interval);
  }, [playerPos, flashlightOn, pos]);

  return { pos, state };
}
