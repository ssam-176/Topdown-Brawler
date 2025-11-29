extends AbilityBehavior
class_name ProjectileBehavior

## Ability that spawns a projectile

func execute(_cast_position: Vector2, target_direction: Vector2) -> void:
	if ability_data.projectile_scene == null:
		push_error("ProjectileBehavior: projectile_scene not set in ability resource!")
		return
	
	# Spawn projectile
	var projectile = ability_data.projectile_scene.instantiate() as Projectile
	if projectile == null:
		push_error("ProjectileBehavior: projectile_scene doesn't instantiate a Projectile!")
		return
	
	# Configure projectile
	projectile.speed = ability_data.projectile_speed
	projectile.damage = ability_data.projectile_damage
	projectile.lifetime = ability_data.projectile_lifetime
	
	# Add to scene
	caster.get_tree().current_scene.add_child(projectile)
	
	# Position and aim
	var spawn_pos = caster.global_position + target_direction * 30.0  # spawn offset
	projectile.setup(spawn_pos, target_direction, caster.get_instance_id())
	
	print("Projectile spawned at ", spawn_pos, " moving in direction ", target_direction)
