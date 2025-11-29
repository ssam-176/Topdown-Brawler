# Health & Damage System

## What's New

### Components Added:
1. **HealthComponent** - Reusable health system for any entity
2. **HealthBar** - Visual health bar that floats above entities
3. **Test Dummy** - Red targets to shoot at

### Features:
- ✅ Health tracking (current/max)
- ✅ Damage dealing/receiving
- ✅ Death and auto-respawn
- ✅ Visual health bars above entities
- ✅ Invulnerability flag
- ✅ Health signals for animations/effects

## How It Works

### Taking Damage:
Any entity with a `take_damage(amount, source)` method can receive damage. The method calls the HealthComponent which:
1. Reduces health
2. Emits signals
3. Handles death if health reaches 0
4. Auto-respawns after a delay

### Projectiles:
- Projectiles now properly damage entities they hit
- Won't hit the same target twice
- Won't hit their caster
- Destroyed after hitting (unless pierce_count > 0)

### Death & Respawn:
- When health reaches 0, entity "dies":
  - Becomes invisible
  - Physics disabled
  - `death` signal emitted
- After `respawn_time` seconds:
  - Health restored to max
  - Visibility/physics restored
  - `respawned` signal emitted
  - Player returns to spawn position

## Testing

Run the game and you'll see:
- **Blue circle** = You (Player)
- **Red circles** = Test dummies

Shoot the dummies with Q:
- Each projectile does 10 damage
- Dummies have 50 health (die after 5 hits)
- Dummies respawn after 2 seconds
- You respawn after 3 seconds if you somehow die

Watch the health bars above each entity turn from green to red as they take damage!

## Configuration

### In Player Scene:
- Select `HealthComponent` node
- Adjust in inspector:
  - **Max Health**: 100 (default)
  - **Respawn Time**: 3 seconds
  - **Invulnerable**: false

### In Test Dummy Scene:
- Dummies have 50 health
- Respawn after 2 seconds

### In Projectile Ability:
- Open `resources/abilities/basic_projectile.tres`
- Adjust **Projectile Damage** (currently 10)

## Adding Health to New Entities

1. Add a `HealthComponent` node as a child
2. Add a `take_damage(amount, source)` method that calls `health_component.take_damage()`
3. Optionally add a `HealthBar` node for visual feedback
4. Connect to health signals if you want custom behavior:
   - `health_changed(current, max)`
   - `damage_taken(amount, source)`
   - `death()`
   - `respawned()`

## Health Signals

The HealthComponent emits useful signals you can connect to:

```gdscript
health_component.health_changed.connect(func(current, max):
	print("Health: ", current, "/", max)
)

health_component.damage_taken.connect(func(amount, source):
	print("Took ", amount, " damage from ", source)
	# Play hurt animation, spawn damage numbers, etc.
)

health_component.death.connect(func():
	print("I died!")
	# Play death animation, drop loot, etc.
)

health_component.respawned.connect(func():
	print("I'm back!")
	# Play spawn effect, etc.
)
```

## Next Steps

Now that we have health/damage working, you could:
1. Add player 2 for actual 1v1 combat
2. Add more varied abilities
3. Add damage feedback (screen shake, hit particles)
4. Add a kill counter/score system
5. Add different damage types or armor
