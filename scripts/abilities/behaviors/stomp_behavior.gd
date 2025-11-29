extends AbilityBehavior
class_name StompBehavior

## Ability that creates an AoE knockback around the player

@export var stomp_radius: float = 150.0  ## Radius of the stomp
@export var knockback_distance: float = 120.0  ## How far enemies are knocked back
@export var knockback_duration: float = 0.3  ## How long the knockback takes
@export var stun_duration: float = 0.4  ## How long enemies are stunned (should be >= knockback_duration)
@export var damage: float = 20.0  ## Damage dealt

var stomp_effect_scene = preload("res://scenes/effects/stomp_effect.tscn")

func execute(_cast_position: Vector2, _target_direction: Vector2) -> void:
	if not is_instance_valid(caster):
		return
	
	print("STOMP activated at ", caster.global_position)
	
	# Spawn visual effect
	_spawn_effect()
	
	# Find all enemies in radius
	var space_state = caster.get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = stomp_radius
	query.shape = shape
	query.transform = caster.global_transform
	query.collision_mask = 3  # Layers 1 and 2 (players and enemies)
	
	var results = space_state.intersect_shape(query)
	
	var hit_count = 0
	
	# Apply knockback and damage to each target
	for result in results:
		var target = result.collider
		
		# Don't affect self
		if target.get_instance_id() == caster.get_instance_id():
			continue
		
		# Check if target is alive
		var health_comp = target.get_node_or_null("HealthComponent")
		if health_comp != null and not health_comp.is_alive():
			continue
		
		# Check if target can take damage
		if not target.has_method("take_damage"):
			continue
		
		# Deal damage
		target.take_damage(damage, caster)
		
		# Apply knockback
		_knockback_target(target)
		
		hit_count += 1
		print("Stomped: ", target.name)
	
	print("Stomp hit ", hit_count, " targets")

func _spawn_effect():
	var effect = stomp_effect_scene.instantiate()
	effect.max_radius = stomp_radius
	caster.get_tree().current_scene.add_child(effect)
	effect.global_position = caster.global_position

func _knockback_target(target: Node2D):
	if not is_instance_valid(target) or not is_instance_valid(caster):
		return
	
	# Calculate knockback direction (away from caster)
	var knockback_dir = (target.global_position - caster.global_position).normalized()
	
	# If target is exactly on top of caster, pick a random direction
	if knockback_dir.length() < 0.1:
		knockback_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	var knockback_start = target.global_position
	var knockback_end = knockback_start + (knockback_dir * knockback_distance)
	
	# Apply knocked_up state (can't move or use abilities)
	var state_comp = target.get_node_or_null("StateComponent")
	if state_comp:
		state_comp.add_state("knocked_up", stun_duration)
	
	# Use tween for smooth knockback
	var tween = caster.get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	# Animate position
	tween.tween_property(target, "global_position", knockback_end, knockback_duration)
	
	# Zero velocity during knockback if CharacterBody2D
	if target is CharacterBody2D:
		tween.tween_callback(func():
			if is_instance_valid(target) and target is CharacterBody2D:
				target.velocity = Vector2.ZERO
		).set_delay(0.0)
	
	print("Knocking back ", target.name, " from ", knockback_start, " to ", knockback_end)
