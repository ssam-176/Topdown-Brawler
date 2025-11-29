# Top-Down Brawler - Setup Guide

## What's Been Built

I've created a modular ability system for your 1v1 fighter. Here's what you have:

### Core Systems
1. **Player** - Basic movement with WASD
2. **Ability Manager** - Handles 4 ability slots, cooldowns, and energy
3. **Input Handler** - Separated input logic for easy controller support later
4. **Ability System** - Modular resource-based abilities with behavior scripts

### Abilities Included
1. **Basic Projectile** - Shoots in direction of mouse (Q key)
2. **Dash** - Dashes in direction of mouse (E key)

### Controls
- **WASD** - Movement
- **Q** - Ability slot 1
- **E** - Ability slot 2  
- **R** - Ability slot 3
- **F** - Ability slot 4
- **Mouse** - Aim direction

## Setup Instructions (IN GODOT EDITOR)

### Step 1: Configure the Projectile Ability
The projectile ability needs to know what projectile scene to spawn.

1. Open `resources/abilities/basic_projectile.tres` in the inspector
2. Click on the `behavior_script` field (should show ProjectileBehavior)
3. In the script parameters below, you'll see:
   - **Projectile Scene**: Drag `scenes/projectiles/projectile.tscn` here
   - **Projectile Speed**: 400 (default is fine)
   - **Projectile Damage**: 10 (default is fine)
   - **Projectile Lifetime**: 3 (default is fine)
   - **Spawn Offset**: 30 (default is fine)

### Step 2: Assign Abilities to Player
1. Open `scenes/player/player.tscn`
2. Select the `AbilityManager` node
3. In the inspector, find **Ability Slots** (it's an Array)
4. Set the size to 4
5. Assign abilities:
   - **Element 0**: Drag `resources/abilities/basic_projectile.tres`
   - **Element 1**: Drag `resources/abilities/dash.tres`
   - **Element 2**: Leave empty for now
   - **Element 3**: Leave empty for now

### Step 3: Test!
1. Run the project (F5)
2. You should spawn as a blue circle
3. Move with WASD
4. Press Q to shoot a projectile toward your mouse
5. Press E to dash toward your mouse
6. Watch energy drain and cooldowns (you can see in the output/debug if you print statements)

## Architecture Overview

```
Player (CharacterBody2D)
├── AbilityManager - Manages slots, cooldowns, energy
├── InputHandler - Converts inputs to signals
├── CollisionShape2D
└── Sprite2D

Ability System:
├── AbilityBase (Resource) - Stores data (cooldown, cost, name)
└── AbilityBehavior (Script) - Defines what ability does
    ├── ProjectileBehavior - Spawns projectiles
    └── DashBehavior - Dashes player
```

## Adding New Abilities (Future)

1. Create a new behavior script in `scripts/abilities/behaviors/`
2. Extend `AbilityBehavior`
3. Override the `execute()` method
4. Create a new `.tres` resource file
5. Set the behavior_script to your new behavior
6. Configure parameters in the inspector
7. Assign to a player's ability slot

## Known Limitations / To-Do

- No UI yet (cooldown/energy displays)
- No health system
- No damage feedback
- No visual effects
- Projectiles don't have proper collision setup yet
- Camera doesn't move with mouse distance (can add later)
- Only supports 1 player (multiplayer scaffolding is ready though)

## File Structure

```
topdown-brawler/
├── scenes/
│   ├── player/
│   │   └── player.tscn
│   ├── projectiles/
│   │   └── projectile.tscn
│   └── test_scene.tscn
├── scripts/
│   ├── player/
│   │   ├── player.gd
│   │   ├── ability_manager.gd
│   │   └── input_handler.gd
│   ├── abilities/
│   │   ├── ability_base.gd
│   │   └── behaviors/
│   │       ├── ability_behavior.gd
│   │       ├── projectile_behavior.gd
│   │       └── dash_behavior.gd
│   └── projectiles/
│       └── projectile.gd
└── resources/
    └── abilities/
        ├── basic_projectile.tres
        └── dash.tres
```

## Testing Tips

- Energy starts at 100 and regens at 20/second
- Projectile costs 15 energy, 1s cooldown
- Dash costs 25 energy, 3s cooldown
- You should be able to spam Q pretty fast
- E has a longer cooldown

Let me know what works and what doesn't!
