# Homing Burst Ability 🎯

## New Ability: Homing Missiles

A burst of 3 homing projectiles that track and chase down nearby enemies!

### How It Works:
- Fires 3 small projectiles in a spread pattern
- Each projectile independently searches for and tracks targets
- Projectiles smoothly curve toward their target
- 8 damage per projectile (24 total if all hit)
- Search radius: 400 units
- Lifetime: 5 seconds

### Visual Design:
- **Purple/magenta** projectiles (smaller than basic projectiles)
- Fires in a fan pattern
- Slight delay between each projectile (0.08s) for visual flair

### Stats:
- **Cooldown**: 4 seconds
- **Energy Cost**: 35
- **Damage per projectile**: 8 (24 total)
- **Speed**: 300 (slower than basic projectile for more tracking)
- **Homing Strength**: 3.0 rad/s (how fast they turn)

## Setup Instructions

1. **Open `resources/abilities/homing_burst.tres`** in the inspector

2. **In "Behavior Parameters" section, set:**
   - **Projectile Scene**: Drag `scenes/projectiles/homing_projectile.tscn` here

3. **Assign to Player:**
   - Open `scenes/player/player.tscn`
   - Select `AbilityManager` node
   - In `Ability Slots`, assign to any slot (like Element 2 for R key)
   - Drag `resources/abilities/homing_burst.tres` into the slot

4. **Test it!**
   - Press R (or whatever slot you assigned it to)
   - Watch 3 purple projectiles fan out and track enemies

## How Homing Works:

### Target Acquisition:
1. Each projectile searches for targets within 400 units when spawned
2. Finds the closest valid target that:
   - Isn't the caster
   - Hasn't been hit already
   - Has a `take_damage()` method
3. Locks onto that target

### Tracking Behavior:
- Projectiles smoothly curve toward their target
- Won't make instant 90° turns (limited by `homing_strength`)
- Continues tracking even if target moves
- Can retarget if original target dies

### Smart Features:
- Won't hit the same target twice
- Won't hit the player who fired it
- Each projectile can track a different target
- Continues in last direction if target is lost

## Testing Tips:

1. **Test spread pattern:**
   - Fire at empty space to see the fan pattern
   - All 3 should spread out in different directions

2. **Test homing:**
   - Stand far from a dummy
   - Fire past it (not directly at it)
   - Watch projectiles curve back toward the dummy

3. **Test multiple targets:**
   - Position yourself between 2+ dummies
   - Fire at the center
   - Each projectile should pick a different target

4. **Test retargeting:**
   - Fire at a dummy cluster
   - Kill one dummy while projectiles are flying
   - Projectiles should find new targets

## Customization Options:

### In `homing_projectile.gd`:
- **speed**: How fast it travels (default: 300)
- **homing_strength**: How aggressively it turns (default: 3.0)
- **search_radius**: How far it looks for targets (default: 400)
- **can_retarget**: Find new targets after losing one (default: true)

### In `homing_burst_behavior.gd`:
- **projectile_count**: Number of projectiles (line 12, default: 3)
- **spread_angle**: Fan angle in degrees (line 13, default: 30°)
- **spawn_delay**: Time between each projectile (line 23, default: 0.08s)

## Balance Notes:

**Compared to Basic Projectile:**
- ✅ Guaranteed to hit (homing)
- ✅ Multiple projectiles (3x)
- ✅ Can hit multiple targets
- ❌ Lower total damage per target (8 vs 10)
- ❌ Slower speed (300 vs 400)
- ❌ Higher energy cost (35 vs 15)
- ❌ Longer cooldown (4s vs 1s)

**Best used for:**
- Finishing off low-health enemies
- Hitting evasive targets
- Damaging multiple enemies at once
- Applying pressure while dodging

## Next Steps:

With 3 abilities working (Basic Projectile, Dash, Homing Burst), you could:
1. Add a 4th ability (melee? AoE?)
2. Add Player 2 to test PvP combat
3. Add visual effects (trails, particles)
4. Balance the abilities against each other
