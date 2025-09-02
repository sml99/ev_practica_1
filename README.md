# EV Practica 1 — Godot 4 project documentation

A small 3D environment built in Godot 4 featuring a gym/reception space with interactive props, doors, lights, and a first‑person camera rig. The project includes source Blender files, imported GLBs, ready‑to‑use scenes, and reusable scripts for common interactions.

## Requirements

- Godot 4.2

## Quick start

1. Open Godot 4 and select `project.godot` in this folder.
2. Open the main scene at `scenes/main/gym.tscn`.

## Project structure

- `scenes/`
  - `main/gym.tscn` — entry scene with the environment assembled
  - `environments/` — building blocks: `floor.tscn`, `wall.tscn`, `stairs.tscn`, `room_with_chairs.tscn`, `connector.tscn`, `entrance_room.tscn`
  - `props/` — placeable items (doors, benches, dumbbell racks, etc.). Most have `.glb` (import) and `.tscn` (ready node) variants
- `scripts/` — gameplay/interaction scripts (see below)
- `materiales/` — materials and textures used by scenes and props
- `BLENDER/` — authoring `.blend` sources for imported meshes
- `shaders/` — custom shaders and sky texture

## Key scenes

- `scenes/main/gym.tscn` — main playable environment
- `scenes/main/camera/camera.tscn` — first‑person style camera rig
- `scenes/main/camera/camera_orbit.tscn` — orbit camera rig useful for inspection/debug

## Gameplay and interactions

This project includes reusable scripts to enable common 3D interactions:

- `fps_player.gd` — first‑person movement character (add to a player Kinematic/CharacterBody)
- `interactive_door.gd` — animated/interactive door logic; some doors may require a pass
- `nfc_pass.gd` — NFC pass behavior (used to unlock/validate access)
- `grabbable_object.gd` — base and helper for pick‑up/hold interactions
- `toggle_light.gd`, `motion_light.gd` — switchable and motion‑activated lights
- `ground_level_zone.gd`, `upper_level_zone.gd` — load/unload rooms

Inputs: The interact/use keys are defined in the project’s Input Map (Project > Project Settings > Input Map). If no bindings appear, create entries (commonly "E" for interact and mouse for look) and ensure your player/camera scripts reference them.

## Assets and materials

- Props (GLBs and scenes) live under `scenes/props/` (e.g., `bench.tscn`, `dumbbell_rack.tscn`, `treadmill.tscn`, `door.tscn`, `nfc_pass.tscn`).
- Materials in `materiales/` (e.g., `gym_floor.tres`, `office_walls.tres`, `screen.tres`, wood/fabric materials). Textures like `fabric_texture.jpg`, parquet/oak webp files are included.
- Blender sources in `BLENDER/` for round‑tripping mesh edits.
