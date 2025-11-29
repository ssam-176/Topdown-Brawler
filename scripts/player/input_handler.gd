extends Node
class_name InputHandler

## Handles input for the player
## Separating this makes it easier to add controller support later

signal movement_input(direction: Vector2)
signal ability_input(slot: int, target_direction: Vector2)

@export var player_id: int = 1  ## 1 or 2 for local multiplayer

var ability_manager: AbilityManager

func _ready():
	ability_manager = get_parent().get_node("AbilityManager")

func _process(_delta: float):
	handle_movement()
	handle_abilities()

func handle_movement():
	var input_dir = Vector2.ZERO
	
	# Player 1 uses WASD
	if player_id == 1:
		input_dir.x = Input.get_axis("move_left", "move_right")
		input_dir.y = Input.get_axis("move_up", "move_down")
	# Player 2 could use arrow keys (implement later)
	
	if input_dir.length() > 0:
		input_dir = input_dir.normalized()
	
	movement_input.emit(input_dir)

func handle_abilities():
	if player_id != 1:
		return  # Only player 1 for now
	
	var mouse_pos = get_viewport().get_mouse_position()
	var player_screen_pos = get_parent().get_global_transform_with_canvas().origin
	var target_direction = (mouse_pos - player_screen_pos).normalized()
	
	# Check for ability key presses (Q, E, R, F)
	if Input.is_action_just_pressed("ability_1"):
		ability_input.emit(0, target_direction)
	elif Input.is_action_just_pressed("ability_2"):
		ability_input.emit(1, target_direction)
	elif Input.is_action_just_pressed("ability_3"):
		ability_input.emit(2, target_direction)
	elif Input.is_action_just_pressed("ability_4"):
		ability_input.emit(3, target_direction)
