# Hook Ability 🪝

## New Ability: Skillshot Hook

A fast projectile that hooks the first enemy hit, dealing damage and pulling them toward you!

### How It Works:
- Fires a fast, straight-line projectile
- Hits the **first enemy** it touches
- Deals **15 damage**
- **Pulls the enemy** 150 units toward you over 0.4 seconds
- Enemy is briefly disabled during the pull (can't move)

### Visual Design:
- **Yellow/gold** elongated projectile (capsule shape)
- Travels in a straight line
- Very fast (800 speed vs 400 for basic projectile)

### Stats:
- **Cooldown**: 6 seconds
- **Energy Cost**: 40
- **Damage**: 15
- **Speed**: 800 (very fast!)
- **Lifetime**: 1.5 seconds
- **Pull Distance**: 150 units
- **Pull Duration**: 0.4 seconds

## Setup Instructions

1. **Open `resources/abilities/hook.tres`** in the inspector

2. **In "Behavior Parameters" section, set:**
   - **Projectile Scene**: Drag `scenes/projectiles/hook_projectile.tscn` here

3. **Assign to Player:**
   - Open `scenes/player/player.tscn`
   - Select `AbilityManager` node
   - In `Ability Slots`, assign to Element 3 (F key)
   - Drag `resources/abilities/hook.tres` into the slot

4. **Test it!**
   - Press F to fire the hook
   - Hit a dummy and watch it get pulled toward you
   - The dummy will slide smoothly to a position in front of you

## How the Pull Works:

### Target Positioning:
1. Hook hits an enemy
2. Calculates direction from enemy to you
3. Places enemy 150 units in front of you
4. Smoothly pulls them there over 0.4 seconds

### During Pull:
- Enemy **cannot move** (physics disabled)
- Pull uses smooth tween animation (EASE_OUT for natural feel)
- After pull completes, enemy control returns

### Interactions:
- ✅ Works on test dummies
- ✅ Works on other players (when you add P2)
- ✅ Pulls through walls (no collision check - can be changed)
- ✅ Pulls dead enemies (can be changed if needed)

## Strategic Uses:

**Combo Potential:**
1. Hook enemy toward you
2. While they're being pulled, line up abilities
3. Hit them with projectiles/dash as they arrive

**Positioning:**
- Pull enemies away from cover
- Pull enemies into hazards
- Pull enemies toward teammates (in future 2v2)

**Escape:**
- Hook an enemy, then dash away while they're pulled
- Creates distance between you and other threats

## Customization Options:

### In `hook_projectile.gd`:
- **pull_distance**: How far from you they end up (default: 150)
- **pull_duration**: How long the pull takes (default: 0.4s)
- **speed**: How fast the hook travels (default: 800)
- **damage**: Damage on hit (default: 15)

### Balance Considerations:

**Current Settings:**
- High cooldown (6s) - can't spam
- High energy cost (40) - expensive
- Fast projectile - easier to land
- Moderate damage - not a kill move

**To make it stronger:**
- Increase damage
- Reduce cooldown
- Increase pull distance (pull farther)
- Reduce pull duration (faster pull)

**To make it weaker:**
- Decrease projectile speed (harder to land)
- Increase cooldown
- Decrease pull distance (less displacement)

## Visual Feedback:

Currently the hook has:
- Yellow projectile body
- Chain/rope visual (Line2D - can be enhanced)
- Capsule collision shape (narrow skillshot)

### Future Enhancements:
- Draw a chain from player to hook while traveling
- Animate chain retracting during pull
- Add particle effects on hit
- Add screen shake on successful hook
- Add sound effects (whoosh + clang)

## Testing Tips:

1. **Test range:**
   - Stand far from a dummy
   - Fire hook - it should travel straight for 1.5 seconds before disappearing
   - At 800 speed × 1.5s = 1200 units of range!

2. **Test pull:**
   - Hit a dummy from any distance
   - Watch it smoothly slide toward you
   - It should end up ~150 units in front of you

3. **Test miss:**
   - Fire hook at empty space
   - It should disappear after 1.5 seconds
   - No pull happens

4. **Test combo:**
   - Hook a dummy
   - While it's being pulled, fire projectiles (Q)
   - They should hit the dummy mid-pull

## Ability Loadout So Far:

1. **Q - Basic Projectile**: Spam damage
2. **E - Dash**: Mobility
3. **R - Homing Burst**: Multi-target
4. **F - Hook**: Engage/displacement

Great variety! Each ability serves a different purpose.

## Next Steps:

With 4 abilities working, you could:
1. Add Player 2 for actual PvP combat testing
2. Add visual effects (particles, trails, impacts)
3. Add sound effects
4. Create more ability variations
5. Add passive effects or ultimate abilities
6. Build a proper UI for cooldowns and energy
