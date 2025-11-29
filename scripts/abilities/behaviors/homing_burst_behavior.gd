extends AbilityBehavior
class_name HomingBurstBehavior

## Ability that spawns multiple homing projectiles in a burst pattern

func execute(_cast_position: Vector2, target_direction: Vector2) -> void:
	if ability_data.projectile_scene == null:
		push_error("HomingBurstBehavior: projectile_scene not set in ability resource!")
		return
	
	# Get parameters from ability data
	var projectile_count = 3  # Could make this configurable
	var spread_angle = deg_to_rad(30)  # Total spread in radians
	var spawn_offset = 30.0
	
	# Calculate angle step between projectiles
	var angle_step = spread_angle / max(projectile_count - 1, 1)
	var start_angle = target_direction.angle() - (spread_angle / 2.0)
	
	# Spawn each projectile with slight delay for visual effect
	for i in range(projectile_count):
		# Add small delay between each projectile
		await caster.get_tree().create_timer(i * 0.08).timeout
		
		if not is_instance_valid(caster):
			return
		
		# Calculate direction for this projectile
		var angle = start_angle + (i * angle_step)
		var projectile_direction = Vector2(cos(angle), sin(angle))
		
		# Spawn projectile
		var projectile = ability_data.projectile_scene.instantiate()
		if projectile == null:
			continue
		
		# Configure projectile - directly set properties
		projectile.speed = ability_data.projectile_speed
		projectile.damage = ability_data.projectile_damage
		projectile.lifetime = ability_data.projectile_lifetime
		
		# Add to scene
		caster.get_tree().current_scene.add_child(projectile)
		
		# Position and aim
		var spawn_pos = caster.global_position + projectile_direction * spawn_offset
		
		# Check if projectile has setup method
		if projectile.has_method("setup"):
			projectile.setup(spawn_pos, projectile_direction, caster.get_instance_id())
		else:
			projectile.global_position = spawn_pos
			projectile.direction = projectile_direction
			projectile.owner_id = caster.get_instance_id()
	
	print("Homing burst fired!")
