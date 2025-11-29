# Stomp Ability 💥

## New Ability: Ground Stomp AoE

A powerful area-of-effect ability that knocks back all nearby enemies!

### How It Works:

1. **Wind-up** - 0.5 second cast time (telegraphed)
2. **Stomp** - Creates expanding shockwave
3. **Knockback** - All enemies within 150 units knocked back
4. **Stun** - Enemies stunned for 0.2 seconds
5. **Damage** - 20 damage to all hit

### Visual Design:
- **Orange/yellow expanding circle** from player position
- Circle grows to 150 unit radius over 0.3 seconds
- Fades out as it expands
- Clear visual indicator of AoE range

### Stats:
- **Cast Type**: FRONT_CAST (0.5s wind-up)
- **Cooldown**: 8 seconds
- **Energy Cost**: 50 (expensive!)
- **Damage**: 20
- **Radius**: 150 units
- **Knockback Distance**: 120 units
- **Knockback Duration**: 0.3 seconds
- **Stun Duration**: 0.2 seconds

## Setup Instructions

1. **The ability resource is already created** at `resources/abilities/stomp.tres`

2. **Assign to Player:**
   - Open `scenes/player/player.tscn`
   - Select `AbilityManager` node
   - In `Ability Slots`, assign to any empty slot (or replace one)
   - Drag `resources/abilities/stomp.tres` into the slot

3. **Test it!**
   - Get close to dummies
   - Press the ability key (whatever slot you assigned)
   - See 0.5s wind-up, then BOOM!
   - Dummies fly backwards and can't move for 0.2s

## Ability Mechanics:

### Wind-Up (Frontswing):
- **0.5 seconds** to cast
- Very telegraphed - enemies can see it coming
- Can be interrupted (stun cancels cast)
- No energy spent if interrupted

### AoE Detection:
- Scans 150 unit radius around player
- Hits ALL enemies in range
- Won't hit dead enemies
- Won't hit self

### Knockback:
- Enemies pushed 120 units away from caster
- Direction: Away from player
- Smooth ease-out animation (0.3s)
- If enemy is exactly on you, random direction

### Crowd Control:
- Applies "knocked_up" state
- Duration: 0.2 seconds
- Can't move during knockback
- Can't use abilities during knockback

## Strategic Uses:

**Defensive:**
- Create space when surrounded
- Interrupt enemy combos
- Escape from pressure

**Offensive:**
- Setup for skillshots (enemies pushed to predictable positions)
- Interrupt enemy casts
- Peel for teammates (future 2v2)

**Positioning:**
- Push enemies away from objectives
- Push enemies into walls/corners
- Push enemies toward teammates

## Balance Notes:

**Strengths:**
- ✅ Hits multiple enemies
- ✅ CC (knockback + stun)
- ✅ Good defensive tool
- ✅ Guaranteed damage in melee range

**Weaknesses:**
- ❌ Very long cast time (0.5s)
- ❌ High energy cost (50)
- ❌ Long cooldown (8s)
- ❌ Requires close range
- ❌ Can be interrupted
- ❌ Pushes enemies away (hard to follow up)

## Combo Ideas:

### Setup Combo:
1. Hook enemy toward you (F)
2. Stomp while they're pulled (knocks them away)
3. Homing Burst as they fly back (R)

### Defensive Combo:
1. Surrounded by enemies
2. Stomp (creates space)
3. Dash away (E)

### Interrupt:
1. Enemy charging powerful ability
2. Get close
3. Stomp to interrupt their cast

## Customization:

You can adjust in `resources/abilities/stomp.tres`:
- **Cast Time**: Wind-up duration (currently 0.5s)
- **Cooldown**: Time between uses (currently 8s)
- **Energy Cost**: Energy required (currently 50)

Or edit `stomp_behavior.gd` for:
- **Stomp Radius**: AoE size (line 5, currently 150)
- **Knockback Distance**: How far enemies fly (line 6, currently 120)
- **Knockback Duration**: Knockback speed (line 7, currently 0.3s)
- **Stun Duration**: CC length (line 8, currently 0.2s)
- **Damage**: Damage dealt (line 9, currently 20)

## Testing Tips:

1. **Test wind-up:**
   - Press stomp
   - Try to use another ability during 0.5s cast
   - Should be blocked

2. **Test interruption:**
   - Start casting stomp
   - Get yourself hooked (shoot hook into wall, walk into it)
   - Cast should cancel

3. **Test AoE:**
   - Stand in middle of 3+ dummies
   - Stomp
   - All dummies should fly outward

4. **Test knockback:**
   - Stand next to a dummy
   - Stomp
   - Watch dummy fly 120 units away
   - Watch dummy unable to move for 0.2s

5. **Test visual:**
   - Stomp
   - Watch orange circle expand from your position
   - Should match the actual AoE range

## Current Loadout:

You now have **5 abilities** to choose from! Mix and match 4:

1. **Q - Basic Projectile**: Spam damage
2. **E - Dash**: Mobility
3. **R - Homing Burst**: Multi-target
4. **F - Hook**: Displacement
5. **NEW - Stomp**: AoE knockback

Great variety for different playstyles!
