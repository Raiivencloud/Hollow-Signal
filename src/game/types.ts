/**
 * Hollow Signal - Game Logic Types
 */

export interface GameState {
  playerPos: { x: number; y: number };
  playerRotation: number;
  flashlightOn: boolean;
  stalkerPos: { x: number; y: number };
  stalkerState: 'IDLE' | 'STALKING' | 'CHASING';
}

export const GAME_BOUNDS = {
  width: 800,
  height: 600
};
