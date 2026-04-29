/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { usePlayerController } from './game/scripts/usePlayerController';
import { useStalkerAI } from './game/scripts/useStalkerAI';
import { Zap, Eye, Ghost, User, Lightbulb, LightbulbOff } from 'lucide-react';

export default function App() {
  const [keys, setKeys] = useState<Set<string>>(new Set());
  const { pos: playerPos, rotation, flashlightOn, updatePosition } = usePlayerController(400, 300);
  const { pos: stalkerPos, state: stalkerState } = useStalkerAI(playerPos, flashlightOn);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => setKeys(prev => new Set(prev).add(e.key));
    const handleKeyUp = (e: KeyboardEvent) => setKeys(prev => {
      const next = new Set(prev);
      next.delete(e.key);
      return next;
    });

    window.addEventListener('keydown', handleKeyDown);
    window.addEventListener('keyup', handleKeyUp);

    const loop = setInterval(() => {
      updatePosition(keys);
    }, 16);

    return () => {
      window.removeEventListener('keydown', handleKeyDown);
      window.removeEventListener('keyup', handleKeyUp);
      clearInterval(loop);
    };
  }, [keys, updatePosition]);

  const detectionPercent = stalkerState === 'IDLE' ? 0 : stalkerState === 'STALKING' ? 45 : 98;

  return (
    <div className="bg-zinc-950 font-sans min-h-screen p-6 text-zinc-100 overflow-hidden border-8 border-zinc-900">
      {/* Header Section */}
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-3xl font-black tracking-tighter text-red-600 italic uppercase">
            Hollow Signal 
            <span className="text-zinc-500 font-mono text-sm tracking-widest ml-2 not-italic">v1.2.0-STABLE</span>
          </h1>
          <p className="text-zinc-400 text-[10px] mt-1 font-mono tracking-widest">GODOT 4.2 ENGINE | PROJECT ARCHITECTURE: MODULAR HORROR 2D</p>
        </div>
        <div className="flex gap-3">
          <div className="px-3 py-1 bg-zinc-900 border border-zinc-800 rounded text-[10px] font-mono flex items-center gap-2">
            <div className="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse"></div>
            RENDER_SUCCESS
          </div>
          <div className={`px-3 py-1 border rounded text-[10px] font-mono transition-colors duration-500 ${flashlightOn ? 'bg-red-900/30 border-red-800 text-red-400' : 'bg-zinc-900 border-zinc-800 text-zinc-500'}`}>
            {flashlightOn ? 'SIGNAL_EMIT_ACTIVE' : 'STEALTH_MODE'}
          </div>
        </div>
      </div>

      {/* Bento Grid Container */}
      <div className="grid grid-cols-12 grid-rows-6 gap-4 h-[calc(100vh-180px)] max-h-[800px]">
        
        {/* Project Explorer */}
        <div className="col-span-3 row-span-4 bg-zinc-900/50 border border-zinc-800 p-4 rounded-xl flex flex-col">
          <div className="text-[10px] text-zinc-500 font-bold uppercase tracking-widest mb-4">res:// Project Explorer</div>
          <ul className="space-y-2 font-mono text-[11px] text-zinc-400 flex-1 overflow-y-auto">
            <li className="flex items-center gap-2 text-zinc-600">📂 assets/</li>
            <li className="pl-4 text-zinc-600 italic">- textures/</li>
            <li className="pl-4 text-zinc-600 italic">- audio/</li>
            <li className="flex items-center gap-2 text-zinc-400">📂 <span className="text-zinc-200">scenes/</span></li>
            <li className="pl-4 flex items-center gap-2">🎬 MainLevel.tscn</li>
            <li className="pl-4 flex items-center gap-2 text-red-500/80">🎬 Player.tscn</li>
            <li className="pl-4 flex items-center gap-2">🎬 Stalker.tscn</li>
            <li className="flex items-center gap-2 text-zinc-400">📂 <span className="text-zinc-200">scripts/</span></li>
            <li className="pl-4 flex items-center gap-2 text-red-400">📜 Player.gd</li>
            <li className="pl-4 flex items-center gap-2 text-pink-400">📜 ProgressionManager.gd</li>
            <li className="pl-4 flex items-center gap-2 text-emerald-400">📜 ResourceManager.gd</li>
            <li className="pl-4 flex items-center gap-2 text-indigo-400">📜 DecisionSystem.gd</li>
            <li className="pl-4 flex items-center gap-2 text-cyan-400">📜 TimeDistortion.gd</li>
            <li className="pl-4 flex items-center gap-2 text-slate-500">📜 InvisibleThreat.gd</li>
            <li className="pl-4 flex items-center gap-2 text-amber-500">📜 FlashbackManager.gd</li>
            <li className="pl-4 flex items-center gap-2 text-red-400">📜 Stalker.gd</li>
            <li className="pl-4 flex items-center gap-2 text-zinc-500 italic">📜 GameEvents.gd</li>
          </ul>
          <div className="mt-4 pt-4 border-t border-zinc-800/50">
            <div className="flex justify-between text-[8px] text-zinc-500 font-bold uppercase mb-1">
              <span>RAM_USAGE</span>
              <span>102MB</span>
            </div>
            <div className="w-full bg-zinc-800 h-1 rounded-full">
              <div className="bg-zinc-600 h-1 rounded-full w-[25%] transition-all"></div>
            </div>
          </div>
        </div>

        {/* Main Viewport (The Game) */}
        <div className="col-span-6 row-span-4 bg-zinc-900 border border-zinc-700 rounded-xl overflow-hidden flex flex-col relative group">
          <div className="flex justify-between items-center p-3 bg-zinc-900/80 border-b border-zinc-800 absolute top-0 left-0 right-0 z-30 transition-opacity group-hover:opacity-100 opacity-40">
            <div className="text-[10px] text-zinc-400 font-bold uppercase tracking-widest flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-red-600"></div>
              Live Viewport: scenes/MainLevel.tscn
            </div>
            <div className="flex gap-1.5">
              <div className="w-2 h-2 rounded-full bg-red-400/50"></div>
              <div className="w-2 h-2 rounded-full bg-yellow-400/50"></div>
              <div className="w-2 h-2 rounded-full bg-green-400/50"></div>
            </div>
          </div>
          
          <div className="flex-1 relative bg-black cursor-none">
            {/* Dark Layer */}
            <div 
              className="absolute inset-0 z-10 pointer-events-none transition-opacity duration-1000"
              style={{
                background: flashlightOn 
                  ? `radial-gradient(circle at ${playerPos.x}px ${playerPos.y}px, transparent 0%, rgba(0,0,0,0.92) 120px, #000 280px)`
                  : 'rgba(0,0,0,0.98)'
              }}
            />

            {/* Subtle Grid Floor */}
            <div className="absolute inset-0 opacity-[0.03] z-0" style={{ backgroundImage: 'linear-gradient(to right, #666 1px, transparent 1px), linear-gradient(to bottom, #666 1px, transparent 1px)', backgroundSize: '40px 40px' }} />

            {/* Stalker */}
            <motion.div
              animate={{ x: stalkerPos.x - 20, y: stalkerPos.y - 20 }}
              transition={{ type: 'spring', damping: 25, stiffness: 80 }}
              className="absolute z-10"
              style={{ opacity: flashlightOn ? 1 : 0.02 }}
            >
              <div className="relative">
                 <Ghost className={`${stalkerState === 'CHASING' ? 'text-red-600 animate-pulse' : 'text-zinc-800'} w-10 h-10 blur-[1px]`} />
                 {stalkerState === 'CHASING' && (
                    <div className="absolute -inset-4 bg-red-500/10 rounded-full blur-2xl animate-ping" />
                 )}
              </div>
            </motion.div>

            {/* Player */}
            <motion.div
              animate={{ x: playerPos.x - 16, y: playerPos.y - 16, rotate: rotation }}
              className="absolute z-20 flex items-center justify-center"
            >
              <div className="relative">
                <div className="w-8 h-8 rounded-full bg-zinc-400/10 border border-zinc-500/30 flex items-center justify-center">
                  <User className="text-zinc-400 w-5 h-5 shadow-[0_0_10px_rgba(255,255,255,0.2)]" />
                </div>
                {flashlightOn && (
                  <div 
                    className="absolute left-full top-1/2 -translate-y-1/2 w-48 h-32 bg-yellow-200/5 blur-3xl origin-left"
                    style={{ clipPath: 'polygon(0 40%, 100% 0, 100% 100%, 0 60%)' }}
                  />
                )}
              </div>
            </motion.div>

            {/* Loading/Dark overlay tutorial */}
            {!flashlightOn && (
              <div className="absolute inset-0 flex flex-col items-center justify-center z-40 bg-black/40 backdrop-blur-[2px]">
                <p className="text-zinc-700 text-[10px] font-mono tracking-[0.3em] uppercase">Visual Signal Interrupted</p>
                <div className="mt-2 text-zinc-800 text-[8px] uppercase flex gap-4">
                  <span>[W-A-S-D] MOTION</span>
                  <span>[F] EMIT SIGNAL</span>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Detection Engine */}
        <div className="col-span-3 row-span-3 bg-zinc-900 border border-zinc-800 p-4 rounded-xl flex flex-col justify-between">
          <div className="text-[10px] text-zinc-500 font-bold uppercase tracking-widest flex justify-between">
            Detection Radar
            <span className="text-red-500 animate-pulse">● LIVE</span>
          </div>
          <div className="flex items-center justify-center relative py-6">
            <div className="w-28 h-28 rounded-full border border-zinc-800 flex items-center justify-center relative">
              <div className="absolute inset-0 border border-red-900/10 rounded-full scale-75"></div>
              <div className={`w-20 h-20 rounded-full border transition-colors ${stalkerState === 'CHASING' ? 'border-red-600/50' : 'border-zinc-700/50'} animate-pulse`}></div>
              
              {/* Radar Sweep */}
              <div className="absolute inset-0 border-t border-zinc-700/50 rounded-full animate-spin [animation-duration:4s]"></div>
              
              <div className={`w-1.5 h-1.5 rounded-full absolute ${stalkerState === 'IDLE' ? 'bg-zinc-700' : 'bg-red-500 shadow-[0_0_8px_red] animate-bounce'}`}></div>
            </div>
          </div>
          <div className="space-y-3">
            <div className="flex justify-between text-[10px] font-mono text-zinc-400">
              <span className="flex items-center gap-2"><Eye className="w-3 h-3" /> SIGNAL_PROXIMITY</span>
              <span className={`italic font-bold ${stalkerState === 'CHASING' ? 'text-red-500' : 'text-zinc-600'}`}>{detectionPercent}%</span>
            </div>
            <div className="w-full bg-zinc-800 h-1.5 rounded-full overflow-hidden">
              <motion.div 
                animate={{ width: `${detectionPercent}%` }}
                className={`h-full rounded-full ${stalkerState === 'CHASING' ? 'bg-red-600' : 'bg-zinc-600'}`}
              />
            </div>
            <p className="text-[9px] text-zinc-600 leading-tight italic">AI Behavior: {stalkerState === 'CHASING' ? 'AGGRESSIVE_STRIKE' : stalkerState === 'STALKING' ? 'PREDATORY_OBSERVATION' : 'STANDBY'}</p>
          </div>
        </div>

        {/* Visibility Mechanics */}
        <div className="col-span-3 row-span-3 bg-zinc-900/50 border border-zinc-800 p-4 rounded-xl">
          <div className="text-[10px] text-zinc-500 font-bold uppercase tracking-widest mb-3">Emission Stats</div>
          <div className="grid grid-cols-2 gap-2">
            <div className="bg-zinc-950 p-3 rounded border border-zinc-800/50">
              <div className="text-[8px] text-zinc-500 font-mono uppercase mb-1 flex items-center gap-1">
                <Zap className="w-2 h-2" /> Lumens
              </div>
              <div className={`text-lg font-bold font-mono ${flashlightOn ? 'text-yellow-400' : 'text-zinc-700'}`}>
                {flashlightOn ? '4,280' : '0,000'}
              </div>
            </div>
            <div className="bg-zinc-950 p-3 rounded border border-zinc-800/50">
              <div className="text-[8px] text-zinc-500 font-mono uppercase mb-1 flex items-center gap-1">
                <motion.div animate={{ scale: flashlightOn ? [1, 1.2, 1] : 1 }} transition={{ repeat: Infinity }}>
                  <div className="w-2 h-2 rounded-full bg-red-600/50"></div>
                </motion.div>
                Heat
              </div>
              <div className={`text-lg font-bold font-mono ${flashlightOn ? 'text-red-500' : 'text-zinc-700'}`}>
                {flashlightOn ? 'HIGH' : 'LOW'}
              </div>
            </div>
          </div>
          <div className="mt-4 flex flex-col gap-2">
            <div className="text-[9px] text-zinc-500 font-mono flex items-center justify-between">
              <span>BATTERY_LIFE</span>
              <span className="text-green-500">OPTIMAL</span>
            </div>
            <div className="flex gap-0.5">
              {[1, 2, 3, 4, 5, 6].map(i => (
                <div key={i} className="h-1 bg-green-900/50 flex-1 border border-green-800/20"></div>
              ))}
            </div>
          </div>
        </div>

        {/* Settings Inspector */}
        <div className="col-span-9 row-span-2 bg-zinc-900/80 border border-zinc-800 p-5 rounded-xl flex items-center gap-12">
          <div className="flex-1 border-r border-zinc-800/50 pr-8">
            <div className="text-[10px] text-zinc-500 font-bold mb-4 uppercase tracking-[0.2em]">GDScript Preview: Stalker Logic</div>
            <div className="bg-zinc-950 p-3 rounded font-mono text-[9px] text-zinc-500 border border-zinc-800/50 h-24 overflow-hidden">
               <span className="text-orange-400">func</span> _stalk_logic():<br/>
               &nbsp;&nbsp;<span className="text-orange-400">var</span> player_is_still = target.velocity.length() &lt; 10.0<br/>
               &nbsp;&nbsp;<span className="text-orange-400">var</span> mult = stillness_multiplier <span className="text-orange-400">if</span> player_is_still <span className="text-orange-400">else</span> 1.0<br/>
               &nbsp;&nbsp;velocity = dir * (stalking_speed * mult)<br/>
               &nbsp;&nbsp;move_and_slide()
            </div>
          </div>
          <div className="shrink-0 flex flex-col gap-2">
            <button className="bg-red-700 hover:bg-red-600 active:bg-red-800 text-white text-[10px] font-bold py-2.5 px-8 rounded uppercase tracking-widest transition-all shadow-lg shadow-red-900/20 ring-1 ring-red-500/50">
              Deploy to Godot
            </button>
            <p className="text-right text-[8px] text-zinc-600 uppercase font-mono italic">Scripts: 4 Active</p>
          </div>
        </div>

      </div>

      {/* Status Bar */}
      <div className="mt-4 flex items-center justify-between text-[10px] font-mono text-zinc-500 border-t border-zinc-900 pt-4">
        <div className="flex gap-6 items-center">
          <div className="flex gap-2">
            <span className="text-zinc-700">FPS:</span> 144
          </div>
          <div className="flex gap-2">
            <span className="text-zinc-700">COORD:</span> {Math.round(playerPos.x)},{Math.round(playerPos.y)}
          </div>
          <div className="flex gap-2">
            <span className="text-zinc-700">STALKER:</span> DIST_{Math.round(Math.sqrt(Math.pow(playerPos.x - stalkerPos.x, 2) + Math.pow(playerPos.y - stalkerPos.y, 2)))}
          </div>
        </div>
        <div className="flex items-center gap-2">
           <Zap className="w-3 h-3 text-red-900" />
           <span className="uppercase italic tracking-wider">Project Prepared for Godot Deployment</span>
        </div>
      </div>
    </div>
  );
}

