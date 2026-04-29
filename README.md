# Hollow Signal 🕹️🌑

**Hollow Signal** is an atmospheric 2D psychological horror experience developed with the **Godot Engine**. The project focuses on procedural storytelling and immersive environmental horror, driven by a complex decoupled script architecture.

## 🚀 Key Technical Systems (GDScript)

* **Procedural Horror Engine:** Implements `ProceduralHorror.gd` and `LevelGenerator.gd` to create unpredictable environments and high replayability.
* **Mental & Sanity Systems:** A dedicated `MentalSystem.gd` that tracks player psychological state, affecting world perception and gameplay mechanics.
* **Advanced Game Logic:** Robust management of game states through `AchievementManager.gd`, `DecisionSystem.gd`, and `DialogueSystem.gd`.
* **Atmospheric Controllers:** Dynamic world interaction via `LightingController.gd` and `HorrorEffects.gd` for deep immersion.

## 🛠️ Technical Stack

* **Engine:** [Godot Engine 4.x](https://godotengine.org/)
* **Language:** **GDScript** (Optimized for high-performance real-time logic).
* **Architecture:** Signal-based decoupled design, ensuring scalability and clean communication between game systems.
* **Web Integration:** Project includes a Vite-based web wrapper for potential browser deployment and community engagement.

## 📦 Project Structure

```text
godot_source/
└── scripts/        # Core Game Systems (LevelGen, AI Stalker, Mental System)
src/                # Web integration & landing page architecture
├── assets/         # High-fidelity textures and environmental audio
└── project_files/  # Godot project configuration and scene manifests
