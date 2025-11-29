extends AbilityBehavior
class_name DashBehavior

## Ability that dashes the player in a direction

var is_dashing: bool = false
var dash_velocity: Vector2 = Vector2.ZERO
var dash_timer: float = 0.0

func execute(_cast_position: Vector2, target_direction: Vector2) -> void:
	if caster == null or not caster is CharacterBody2D:
		return
	
	# Check if caster can move (not stunned/rooted)
	var state_comp = caster.get_node_or_null("StateComponent")
	if state_comp and not state_comp.can_move():
		print("Cannot dash - movement disabled!")
		return
	
	# Get dash parameters from ability data
	var dash_distance = ability_data.dash_distance
	var dash_duration = ability_data.dash_duration
	
	# Calculate dash velocity
	dash_velocity = target_direction * (dash_distance / dash_duration)
	dash_timer = dash_duration
	is_dashing = true
	
	print("Dashing in direction ", target_direction, " with velocity ", dash_velocity)
	
	# Connect to process if not already connected
	if not caster.get_tree().process_frame.is_connected(_process_dash):
		caster.get_tree().process_frame.connect(_process_dash)

func _process_dash():
	if not is_dashing:
		return
	
	var delta = caster.get_process_delta_time()
	dash_timer -= delta
	
	if dash_timer <= 0 or caster == null:
		cleanup()
		return
	
	# Check if we can still move (might get stunned mid-dash)
	var state_comp = caster.get_node_or_null("StateComponent")
	if state_comp and not state_comp.can_move():
		cleanup()
		return
	
	# Apply dash movement
	if caster is CharacterBody2D:
		caster.velocity = dash_velocity
		caster.move_and_slide()

func cleanup():
	is_dashing = false
	dash_timer = 0.0
	if caster != null and caster.get_tree().process_frame.is_connected(_process_dash):
		caster.get_tree().process_frame.disconnect(_process_dash)
