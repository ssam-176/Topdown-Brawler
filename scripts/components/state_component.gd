extends Node
class_name StateComponent

## Manages entity states like stunned, rooted, silenced, etc.

signal state_changed(state_name: String, active: bool)

@export var casting_allows_movement: bool = true  ## Can player move while casting?

var active_states: Dictionary = {}  ## state_name: expiry_time
var owner_node: Node

func _ready():
	owner_node = get_parent()

func _process(_delta):
	# Check for expired states
	var current_time = Time.get_ticks_msec() / 1000.0
	var expired_states = []
	
	for state_name in active_states:
		if active_states[state_name] <= current_time:
			expired_states.append(state_name)
	
	# Remove expired states
	for state_name in expired_states:
		remove_state(state_name)

## Add a state with a duration (0 = permanent until manually removed)
func add_state(state_name: String, duration: float = 0.0) -> void:
	var was_active = has_state(state_name)
	
	if duration > 0:
		var current_time = Time.get_ticks_msec() / 1000.0
		active_states[state_name] = current_time + duration
	else:
		active_states[state_name] = INF  # Permanent
	
	if not was_active:
		state_changed.emit(state_name, true)
		print(owner_node.name, " gained state: ", state_name)

## Remove a state
func remove_state(state_name: String) -> void:
	if active_states.has(state_name):
		active_states.erase(state_name)
		state_changed.emit(state_name, false)
		print(owner_node.name, " lost state: ", state_name)

## Check if entity has a specific state
func has_state(state_name: String) -> bool:
	return active_states.has(state_name)

## Check if entity has any crowd control
func is_crowd_controlled() -> bool:
	return has_state("stunned") or has_state("rooted") or has_state("knocked_up")

## Check if entity can move
func can_move() -> bool:
	# Can't move if stunned, rooted, or knocked up
	if has_state("stunned") or has_state("rooted") or has_state("knocked_up"):
		return false
	
	# Check if casting prevents movement
	if has_state("casting") and not casting_allows_movement:
		return false
	
	return true

## Check if entity can use abilities (doesn't check casting - that's handled by AbilityManager)
func can_use_abilities() -> bool:
	return not (has_state("stunned") or has_state("silenced"))

## Check if entity can act at all
func can_act() -> bool:
	return not has_state("stunned")

## Clear all states
func clear_all_states() -> void:
	var states_to_remove = active_states.keys()
	for state_name in states_to_remove:
		remove_state(state_name)
