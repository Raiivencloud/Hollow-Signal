import { useState, useEffect, useCallback } from 'react';

export function usePlayerController(initialX: number, initialY: number) {
  const [pos, setPos] = useState({ x: initialX, y: initialY });
  const [rotation, setRotation] = useState(0);
  const [flashlightOn, setFlashlightOn] = useState(false);
  const [velocity, setVelocity] = useState({ x: 0, y: 0 });

  const speed = 5;

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'f' || e.key === 'F') {
        setFlashlightOn(prev => !prev);
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  const updatePosition = useCallback((keys: Set<string>) => {
    let dx = 0;
    let dy = 0;

    if (keys.has('ArrowUp')) dy -= 1;
    if (keys.has('ArrowDown')) dy += 1;
    if (keys.has('ArrowLeft')) dx -= 1;
    if (keys.has('ArrowRight')) dx += 1;

    // Normalize diagonal movement
    if (dx !== 0 && dy !== 0) {
      const length = Math.sqrt(dx * dx + dy * dy);
      dx /= length;
      dy /= length;
    }

    if (dx !== 0 || dy !== 0) {
      const newRotation = Math.atan2(dy, dx) * (180 / Math.PI);
      setRotation(newRotation);
      
      setPos(prev => ({
        x: Math.max(0, Math.min(800, prev.x + dx * speed)),
        y: Math.max(0, Math.min(600, prev.y + dy * speed))
      }));
    }
  }, []);

  return { pos, rotation, flashlightOn, updatePosition };
}
