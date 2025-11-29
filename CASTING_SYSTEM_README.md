# Casting System ⏱️

## New Feature: Cast Time & Ability Queueing Prevention

Abilities now have a **cast time** before they execute, preventing ability spam and preparing for animations.

### How It Works:

1. **Press ability key** (Q/E/R/F)
2. **Cast time starts** (default: 0.2 seconds)
3. **"Casting" state applied** - can't use other abilities
4. **After cast time** - ability executes
5. **Casting state removed** - can use abilities again

### Key Features:

✅ **Prevents ability spam** - Can't use Q while casting E
✅ **Prepares for animations** - Cast time = animation duration (later)
✅ **Can be interrupted** - Getting stunned/silenced cancels cast
✅ **Movement optional** - Can configure if casting stops movement

## Current Settings:

### Cast Time:
- **Default**: 0.2 seconds for all abilities
- Configurable per ability manager
- Fast enough to feel responsive
- Long enough to prevent spam

### Movement During Cast:
- **Default**: Can move while casting (`casting_allows_movement = true`)
- Change in StateComponent if you want rooted casting
- Most MOBAs allow movement during cast

### States That Interrupt Cast:
- ❌ **Stunned** - Interrupts cast
- ❌ **Silenced** - Interrupts cast  
- ❌ **Death** - Interrupts cast

## Testing:

### Test 1 - Ability Spam Prevention:
1. Press Q (projectile)
2. Immediately press E (dash)
3. **Result**: E doesn't fire until Q finishes casting (0.2s delay)
4. See console: "Cannot cast - already casting!"

### Test 2 - Multiple Abilities:
1. Press Q
2. Wait 0.2 seconds
3. Press E
4. **Result**: Both fire, but with a small gap

### Test 3 - Cast Interruption:
1. Start casting Q (projectile)
2. Get hooked by enemy (or hook yourself!)
3. **Result**: Cast interrupted, projectile doesn't fire
4. See console: "Cast interrupted by stunned!"

### Test 4 - Cooldown Still Works:
1. Press Q
2. Ability casts after 0.2s
3. Try to press Q again immediately
4. **Result**: On cooldown, can't cast

## Signals Added:

The AbilityManager now emits:

```gdscript
ability_cast_started(slot: int)  # When cast begins
ability_cast_finished(slot: int)  # When cast completes
```

### Usage Example:
```gdscript
ability_manager.ability_cast_started.connect(func(slot):
    print("Started casting ability ", slot)
    # Play casting animation
    # Show casting bar
)

ability_manager.ability_cast_finished.connect(func(slot):
    print("Finished casting ability ", slot)
    # End casting animation
)
```

## Configuration:

### In Player Scene:
Select **StateComponent** node:
- **Casting Allows Movement**: 
  - `true` = Can move while casting (default)
  - `false` = Rooted while casting

Select **AbilityManager** node:
- **Cast Time**: Duration of cast (default: 0.2)

### Per-Ability Cast Times (Future):

You could add different cast times per ability:
- Fast abilities: 0.1s (dash, basic attack)
- Normal abilities: 0.2s (projectile)
- Slow abilities: 0.5s (ultimate, big spells)

Currently all use the same default cast time.

## Visual Feedback (Future):

When you add animations, you can:
1. Play casting animation when `ability_cast_started` fires
2. Play execute animation when `ability_cast_finished` fires
3. Show casting bar during cast time
4. Add casting particles/effects
5. Show interrupted effect if cast cancelled

## Advantages:

### Gameplay:
- **More tactical** - Can't spam all abilities instantly
- **Skill expression** - Good players time abilities better
- **Counterplay** - Can interrupt important casts
- **Prevents spam** - Can't use 4 abilities in 0.1 seconds

### Future Features:
- Easy to add casting animations
- Easy to add casting bars
- Easy to add different cast times per ability
- Easy to add "instant cast" abilities (0s cast time)

## Current Ability Flow:

**Before (instant):**
```
Press Q → Projectile fires → Done
```

**Now (with cast time):**
```
Press Q → Casting state (0.2s) → Projectile fires → Done
              ↓
        Can't use other abilities
        Can still move (default)
```

**If interrupted:**
```
Press Q → Casting state → Get stunned → Cast cancelled
              ↓                            ↓
        0.1s elapsed                 No projectile
                                     No energy spent
                                     No cooldown
```

## Energy & Cooldown:

**Important**: Energy and cooldown are **NOT consumed** until cast completes!

- Start casting Q
- Get interrupted
- **Result**: Still have full energy, Q not on cooldown

This feels fair - if your cast is interrupted, you don't lose resources.

## Next Steps:

With casting working:
1. Add Player 2 to test interrupting each other's casts
2. Add visual casting indicators
3. Add different cast times per ability
4. Add channeled abilities (continuous casting)
5. Add instant-cast abilities (0s cast time)
6. Add casting animations
