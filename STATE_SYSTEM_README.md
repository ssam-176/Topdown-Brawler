# State/Crowd Control System 🔒

## New System: StateComponent

A flexible system for managing entity states like stunned, rooted, silenced, etc.

### States Supported:
- **stunned**: Cannot move or use abilities
- **rooted**: Cannot move, but can use abilities
- **silenced**: Can move, but cannot use abilities
- **knocked_up**: Cannot move or use abilities (similar to stun, but different for visuals later)

### How It Works:
1. States are added with a duration (or permanent)
2. States automatically expire after their duration
3. Components check states before allowing actions
4. States emit signals when added/removed

## Hook Integration

The hook now properly disables hooked targets:

### During Hook Pull:
- Target gains **"stunned"** state for 0.5 seconds (pull duration + 0.1s)
- Target **cannot move** (WASD does nothing)
- Target **cannot use abilities** (Q/E/R/F does nothing)
- Target is smoothly pulled to position
- After stun expires, full control returns

### What Gets Blocked:
✅ Movement input (WASD)
✅ Ability usage (Q/E/R/F)
✅ Dash ability (even if activated before stun)
✅ Any custom abilities you add later

## Testing the System

1. **Hook a dummy:**
   - Press F to hook
   - Dummy is pulled and can't move during pull
   - After pull, dummy stays in place (dummies don't move anyway)

2. **Hook Player 2 (when added):**
   - Hook them with F
   - They spam WASD - nothing happens
   - They spam abilities - nothing happens
   - After 0.5s, they regain control

3. **Hook yourself (tricky but possible):**
   - Fire a projectile
   - Dash into your own hook projectile
   - You'll be stunned and pulled

## State Checking

### In Player/Entity Scripts:
```gdscript
# Check if can move
if state_component.can_move():
    # Allow movement
    
# Check if can use abilities
if state_component.can_use_abilities():
    # Allow ability usage
    
# Check if has specific state
if state_component.has_state("stunned"):
    # Do something
    
# Check if has any CC
if state_component.is_crowd_controlled():
    # Entity is CCed
```

## Adding New States

### In Your Ability/Projectile:
```gdscript
# Get the state component
var state_comp = target.get_node_or_null("StateComponent")

# Add a state
if state_comp:
    state_comp.add_state("stunned", 2.0)  # 2 second stun
    state_comp.add_state("rooted", 1.5)   # 1.5 second root
    state_comp.add_state("silenced", 3.0) # 3 second silence
```

### State Durations:
- `duration > 0`: State expires after duration
- `duration = 0`: Permanent until manually removed
- States auto-cleanup when expired

## Future State Ideas

### Movement States:
- **slowed**: Reduce movement speed by X%
- **hasted**: Increase movement speed by X%
- **grounded**: Can't use mobility abilities
- **airborne**: Immune to ground-based effects

### Ability States:
- **disarmed**: Can't use basic attacks
- **pacified**: Can't deal damage
- **channeling**: Casting something, can be interrupted

### Defensive States:
- **invulnerable**: Can't take damage
- **immune**: Can't be CCed
- **shielded**: Has a damage shield

### Utility States:
- **revealed**: Visible even when stealthed
- **stealthed**: Hidden from enemies
- **burning/poisoned**: Damage over time

## Visual Feedback (Future)

You could add visual indicators for states:
- Red outline for stunned
- Gray effect for rooted
- Purple effect for silenced
- Particle effects for each state
- Icon above entity showing active states

## State Priority

Currently all states work independently. You could add:
- **CC immunity** after being CCed (diminishing returns)
- **Cleanse** abilities that remove states
- **State resistance** (reduce duration)
- **State immunity** (specific states can't be applied)

## Performance Notes

- States are checked in `_process()` for expiry
- Very lightweight (just Dictionary lookups)
- Signals only emit when states change
- No physics calculations needed

## What This Enables

Now that you have state management:
1. ✅ Hook properly disables targets
2. ✅ Future abilities can stun/root/silence
3. ✅ Dash checks if movement is allowed
4. ✅ Can build cleanse/immunity abilities
5. ✅ Can add slows, hastes, buffs/debuffs
6. ✅ Foundation for status effects

## Next Steps

With state system working:
- Add Player 2 to test hook in PvP
- Add more CC abilities (stun projectile, root zone, etc.)
- Add visual effects for states
- Add cleanse/dispel abilities
- Add immunity frames after respawn
- Add buff/debuff abilities
