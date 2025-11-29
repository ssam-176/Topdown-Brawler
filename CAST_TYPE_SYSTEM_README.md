# Cast Type System 🎯

## New Feature: Front-Cast vs Back-Cast

Abilities can now have cast time **before** (frontswing) or **after** (backswing) execution!

### Cast Types:

1. **FRONT_CAST** (Traditional)
   - Wait → Execute → Done
   - Good for: Telegraphed abilities, powerful spells
   - Example: Homing Burst (0.3s wait, then fires)

2. **BACK_CAST** (Instant with Recovery)
   - Execute → Recovery → Done
   - Good for: Responsive attacks, skillshots
   - Example: Basic Projectile, Hook (fires instantly, then 0.15-0.2s recovery)

3. **INSTANT** (No Cast Time)
   - Execute → Done (no delay)
   - Good for: Movement, instant reactions
   - Example: Dash (completely instant)

## Current Ability Setup:

### Q - Basic Projectile
- **Cast Type**: BACK_CAST
- **Cast Time**: 0.15s (after)
- **Feel**: Projectile fires instantly, then short delay before next ability

### E - Dash
- **Cast Type**: INSTANT
- **Cast Time**: 0.0s
- **Feel**: Completely instant, maximum responsiveness

### R - Homing Burst
- **Cast Type**: FRONT_CAST
- **Cast Time**: 0.3s (before)
- **Feel**: 0.3s windup, then projectiles fire (powerful but telegraphed)

### F - Hook
- **Cast Type**: BACK_CAST
- **Cast Time**: 0.2s (after)
- **Feel**: Hook flies instantly, then 0.2s recovery before next ability

## Why This Matters:

### Responsiveness:
- **Back-cast** feels more responsive (instant action)
- **Front-cast** feels more deliberate (wind-up)
- **Instant** feels immediate (no delay at all)

### Balance:
- Fast abilities → Back-cast (quick but still has timing)
- Powerful abilities → Front-cast (telegraphed, can be dodged)
- Mobility → Instant (needs to be reactive)

### Gameplay:
- **Front-cast**: Enemy can see you charging, dodge/interrupt
- **Back-cast**: Ability lands, but you're vulnerable after
- **Instant**: No vulnerability, but usually weaker/utility

## Examples in Action:

### Front-Cast (Homing Burst):
```
Press R → 0.3s charging → Projectiles fire → Can cast again
          ↓
     Can be stunned/interrupted
     No projectiles if interrupted
```

### Back-Cast (Basic Projectile):
```
Press Q → Projectile fires → 0.15s recovery → Can cast again
                              ↓
                    Can be stunned but projectile already fired
```

### Instant (Dash):
```
Press E → Dash happens → Can cast again immediately
```

## Interruption:

### Front-Cast:
- Get stunned during windup → **Ability cancelled**
- No energy spent, no cooldown

### Back-Cast:
- Get stunned during recovery → **Ability already happened**
- Energy spent, cooldown started
- But you're locked for remaining recovery time

### Instant:
- Can't interrupt (no cast time)

## Configuration:

In any ability resource, you can set:

1. **Cast Time**: Duration (seconds)
2. **Cast Type**: 
   - `FRONT_CAST` (0)
   - `BACK_CAST` (1)
   - `INSTANT` (2)

## Design Tips:

**Use FRONT_CAST for:**
- Ultimate abilities
- High damage spells
- AoE abilities
- Channeled effects

**Use BACK_CAST for:**
- Skillshots
- Basic attacks
- Quick spells
- Combo starters

**Use INSTANT for:**
- Mobility (dash, blink)
- Defensive abilities (shield, parry)
- Reactive abilities (counter, dodge)

## Feel the Difference:

Test it now:
1. Press **Q** - projectile fires INSTANTLY, then recovery
2. Press **R** - wait 0.3s, then burst fires
3. Press **E** - dash happens with ZERO delay

The back-cast projectile feels much snappier than the front-cast burst!
