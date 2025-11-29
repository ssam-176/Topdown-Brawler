# Health Regeneration & Stock System

## New Features Added! 🎮

### 1. Health Regeneration
Entities now passively regenerate health over time.

**How it works:**
- Health slowly regenerates after not taking damage for a while
- Regen rate and delay are configurable per entity
- Can be enabled/disabled completely

**Player Settings:**
- **Regen Rate**: 5 HP/second
- **Regen Delay**: 3 seconds after last damage
- Max Health: 100

**Dummy Settings:**
- **Regen Rate**: 2 HP/second  
- **Regen Delay**: 5 seconds after last damage
- Max Health: 50

### 2. Stock/Lives System
Each entity now has a limited number of stocks (lives).

**How it works:**
- Each death consumes 1 stock
- When stocks reach 0, the entity is permanently dead (no respawn)
- Stock count is displayed as circles above entities
- White circles = stocks remaining
- Gray circles = stocks lost

**Player Settings:**
- **3 stocks** total
- Respawn time: 3 seconds per death

**Dummy Settings:**
- **2 stocks** total
- Respawn time: 2 seconds per death

## Visual Indicators

### Health Bar (below stocks)
- **Green**: > 30% health
- **Red**: ≤ 30% health
- Regenerates visually as health regens

### Stock Display (above health bar)
- **White circles**: Lives remaining
- **Gray circles**: Lives lost
- Disappears when entity runs out of stocks

## Testing the New Systems

1. **Test Health Regen:**
   - Shoot a dummy a few times (don't kill it)
   - Stop shooting and watch its health bar
   - After 5 seconds, it starts regenerating health (slowly turns more green)

2. **Test Stocks:**
   - Kill a dummy (5 projectile hits)
   - Watch it lose 1 stock (one circle turns gray)
   - It respawns after 2 seconds
   - Kill it again - it loses its last stock
   - Now it's dead permanently (won't respawn)

3. **Test Player Stocks:**
   - Stand in front of your own projectile (tricky but possible!)
   - Or wait for Player 2 to damage you
   - Die 3 times to see "GAME OVER"
   - Player has 3 stocks, so you need to die 3 times

## Configuration

All settings are in the **HealthComponent** node in the Inspector:

### Health Regeneration Section:
- **Health Regen Rate**: HP per second (0 = disabled)
- **Regen Delay**: Seconds after damage before regen starts
- **Regen In Combat**: Allow regen while taking damage (currently false)

### Stock System Section:
- **Use Stocks**: Enable/disable stock system
- **Max Stocks**: Total number of lives
- **Current Stocks**: Current lives (auto-set to max on start)

## Signals Added

The HealthComponent now emits these new signals:

```gdscript
stock_changed(current: int, max: int)  # When stock count changes
out_of_stocks()  # When entity runs out of stocks
```

You can connect to these for game logic:

```gdscript
health_component.out_of_stocks.connect(func():
    print("Game Over!")
    # Show game over screen, etc.
)
```

## Balancing Tips

**For faster gameplay:**
- Increase regen rate
- Decrease regen delay
- Give more stocks

**For slower, more tactical gameplay:**
- Decrease regen rate
- Increase regen delay
- Give fewer stocks

**Current balance:**
- Dummies are easier to kill (50 HP, 2 stocks, slower regen)
- Player is tankier (100 HP, 3 stocks, faster regen)

## Next Steps

With health regen and stocks working, you could:
1. Add Player 2 for actual PvP combat
2. Add more abilities to test the combat
3. Add a round/match system that resets stocks
4. Add visual effects when stocks are lost (particles, screen shake)
5. Add a game over screen
