extends CharacterBody2D
class_name Player

## Main player controller

@export var move_speed: float = 300.0
@export var spawn_position: Vector2 = Vector2.ZERO

@onready var ability_manager = $AbilityManager
@onready var input_handler = $InputHandler
@onready var health_component = $HealthComponent
@onready var state_component = $StateComponent

var movement_direction: Vector2 = Vector2.ZERO

func _ready():
	# Connect input signals
	input_handler.movement_input.connect(_on_movement_input)
	input_handler.ability_input.connect(_on_ability_input)
	
	# Connect health signals
	health_component.death.connect(_on_death)
	health_component.respawned.connect(_on_respawned)
	health_component.out_of_stocks.connect(_on_out_of_stocks)
	
	# Connect state signals
	state_component.state_changed.connect(_on_state_changed)
	
	spawn_position = global_position

func _physics_process(_delta):
	# Only move if alive and can move
	if health_component.is_alive() and state_component.can_move():
		velocity = movement_direction * move_speed
		move_and_slide()
	else:
		# Can't move - zero out velocity
		velocity = Vector2.ZERO

func _on_movement_input(direction: Vector2):
	# Only accept movement input if we can move
	if state_component.can_move():
		movement_direction = direction
	else:
		movement_direction = Vector2.ZERO

func _on_ability_input(slot: int, target_direction: Vector2):
	# Only use abilities if alive and can act
	if health_component.is_alive() and state_component.can_use_abilities():
		ability_manager.use_ability(slot, target_direction)

func _on_state_changed(state_name: String, active: bool):
	# Interrupt casting if stunned or silenced
	if active and (state_name == "stunned" or state_name == "silenced"):
		if ability_manager.get_is_casting():
			ability_manager.interrupt_cast()
			print("Cast interrupted by ", state_name, "!")

func _on_death():
	# Disable input and movement
	movement_direction = Vector2.ZERO
	velocity = Vector2.ZERO
	
	# Interrupt any casting
	if ability_manager.get_is_casting():
		ability_manager.interrupt_cast()
	
	# Clear any active states on death
	state_component.clear_all_states()
	
	print("Player died! Stocks remaining: ", health_component.current_stocks)

func _on_respawned():
	# Reset position
	global_position = spawn_position
	movement_direction = Vector2.ZERO
	velocity = Vector2.ZERO
	print("Player respawned!")

func _on_out_of_stocks():
	print("GAME OVER - Player ran out of stocks!")
	# Could trigger game over screen, etc.

## Public method that other entities can call to damage this player
func take_damage(amount: float, source: Node = null) -> void:
	health_component.take_damage(amount, source)
