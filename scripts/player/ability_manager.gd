extends Node
class_name AbilityManager

## Manages ability slots, cooldowns, and energy for a player

signal ability_used(slot: int)
signal energy_changed(current: float, max: float)
signal cooldown_started(slot: int, duration: float)
signal ability_cast_started(slot: int)
signal ability_cast_finished(slot: int)

@export var max_energy: float = 100.0
@export var energy_regen_rate: float = 20.0  ## Energy per second
@export var ability_slots: Array[AbilityBase] = []

var current_energy: float = 100.0
var cooldowns: Array[float] = [0.0, 0.0, 0.0, 0.0]
var player: Node2D
var is_casting: bool = false
var state_component: Node

func _ready():
	player = get_parent()
	current_energy = max_energy
	state_component = player.get_node_or_null("StateComponent")
	
	# Ensure we have 4 slots
	ability_slots.resize(4)

func _process(delta: float):
	# Regenerate energy
	if current_energy < max_energy:
		current_energy = min(current_energy + energy_regen_rate * delta, max_energy)
		energy_changed.emit(current_energy, max_energy)
	
	# Update cooldowns
	for i in range(4):
		if cooldowns[i] > 0:
			cooldowns[i] = max(0, cooldowns[i] - delta)

## Attempt to use ability in slot (0-3)
func use_ability(slot: int, target_direction: Vector2) -> bool:
	if slot < 0 or slot >= 4:
		return false
	
	var ability = ability_slots[slot]
	if ability == null:
		return false
	
	# Check if already casting
	if is_casting:
		print("Cannot cast - already casting!")
		return false
	
	# Check cooldown
	if cooldowns[slot] > 0:
		print("Ability on cooldown: ", cooldowns[slot], "s remaining")
		return false
	
	# Check energy
	if current_energy < ability.energy_cost:
		print("Not enough energy! Need ", ability.energy_cost, ", have ", current_energy)
		return false
	
	# Handle different cast types
	match ability.cast_type:
		AbilityBase.CastType.FRONT_CAST:
			_start_front_cast(slot, target_direction)
		AbilityBase.CastType.BACK_CAST:
			_start_back_cast(slot, target_direction)
		AbilityBase.CastType.INSTANT:
			_execute_instant(slot, target_direction)
	
	return true

## Front cast: Cast time BEFORE ability executes
func _start_front_cast(slot: int, target_direction: Vector2):
	var ability = ability_slots[slot]
	var cast_time = ability.cast_time
	
	# Set casting state
	is_casting = true
	if state_component:
		state_component.add_state("casting", cast_time)
	
	ability_cast_started.emit(slot)
	print("Started front-casting ", ability.ability_name, " (", cast_time, "s)")
	
	# Wait for cast time, then execute
	await get_tree().create_timer(cast_time).timeout
	
	# Check if still valid to cast (might have been interrupted)
	if not is_instance_valid(player) or not is_casting:
		print("Front-cast was interrupted, not executing")
		return
	
	# Execute ability
	_execute_ability(slot, target_direction)
	
	# End casting
	_end_cast(slot)

## Back cast: Ability executes IMMEDIATELY, then cast time after
func _start_back_cast(slot: int, target_direction: Vector2):
	var ability = ability_slots[slot]
	var cast_time = ability.cast_time
	
	# Execute ability FIRST
	_execute_ability(slot, target_direction)
	
	# THEN set casting state (backswing/recovery)
	is_casting = true
	if state_component:
		state_component.add_state("casting", cast_time)
	
	ability_cast_started.emit(slot)
	print("Executed ", ability.ability_name, ", now in recovery (", cast_time, "s)")
	
	# Wait for recovery time
	await get_tree().create_timer(cast_time).timeout
	
	# End casting
	_end_cast(slot)

## Instant cast: No cast time at all
func _execute_instant(slot: int, target_direction: Vector2):
	var ability = ability_slots[slot]
	
	print("Instant-casting ", ability.ability_name)
	
	# Execute immediately
	_execute_ability(slot, target_direction)

## Execute the actual ability
func _execute_ability(slot: int, target_direction: Vector2):
	var ability = ability_slots[slot]
	
	var behavior = ability.get_behavior()
	if behavior:
		behavior.caster = player
		behavior.execute(player.global_position, target_direction)
		
		# Consume resources
		current_energy -= ability.energy_cost
		cooldowns[slot] = ability.cooldown
		
		# Emit signals
		energy_changed.emit(current_energy, max_energy)
		cooldown_started.emit(slot, ability.cooldown)
		ability_used.emit(slot)

func _end_cast(slot: int):
	is_casting = false
	if state_component:
		state_component.remove_state("casting")
	
	ability_cast_finished.emit(slot)
	print("Finished casting/recovery for slot ", slot)

## Interrupt current cast
func interrupt_cast():
	if is_casting:
		is_casting = false
		if state_component:
			state_component.remove_state("casting")
		print("Cast interrupted!")

## Get remaining cooldown for a slot
func get_cooldown(slot: int) -> float:
	if slot >= 0 and slot < 4:
		return cooldowns[slot]
	return 0.0

## Check if ability can be used
func can_use_ability(slot: int) -> bool:
	if slot < 0 or slot >= 4:
		return false
	var ability = ability_slots[slot]
	if ability == null:
		return false
	return cooldowns[slot] <= 0 and current_energy >= ability.energy_cost and not is_casting

## Check if currently casting
func get_is_casting() -> bool:
	return is_casting
