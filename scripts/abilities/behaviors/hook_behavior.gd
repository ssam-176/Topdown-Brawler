extends AbilityBehavior
class_name HookBehavior

## Ability that shoots a hook projectile that pulls enemies

func execute(_cast_position: Vector2, target_direction: Vector2) -> void:
	if ability_data.projectile_scene == null:
		push_error("HookBehavior: projectile_scene not set in ability resource!")
		return
	
	# Spawn hook projectile
	var hook = ability_data.projectile_scene.instantiate()
	if hook == null:
		push_error("HookBehavior: projectile_scene doesn't instantiate properly!")
		return
	
	# Configure hook
	hook.speed = ability_data.projectile_speed
	hook.damage = ability_data.projectile_damage
	hook.lifetime = ability_data.projectile_lifetime
	
	# Add to scene
	caster.get_tree().current_scene.add_child(hook)
	
	# Position and aim
	var spawn_offset = 30.0
	var spawn_pos = caster.global_position + target_direction * spawn_offset
	
	# Hook needs a reference to the caster for pulling
	if hook.has_method("setup"):
		hook.setup(spawn_pos, target_direction, caster.get_instance_id(), caster)
	
	print("Hook fired!")
