extends Area2D
class_name HookProjectile

## Fast projectile that hooks and pulls the first enemy hit

@export var speed: float = 600.0
@export var damage: float = 15.0
@export var lifetime: float = 1.5
@export var pull_distance: float = 150.0  ## How far to pull the target
@export var pull_duration: float = 0.4  ## How long the pull takes

var direction: Vector2 = Vector2.RIGHT
var owner_id: int = -1
var has_hit: bool = false
var caster: Node2D = null

# Pull tracking
var pull_target: Node2D = null
var pull_start_pos: Vector2
var pull_end_pos: Vector2
var pull_timer: float = 0.0
var is_pulling: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	
	# Auto-destroy after lifetime
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta):
	if not has_hit:
		position += direction * speed * delta
	elif is_pulling:
		_update_pull(delta)

func setup(start_pos: Vector2, dir: Vector2, caster_id: int, caster_node: Node2D):
	global_position = start_pos
	direction = dir.normalized()
	owner_id = caster_id
	caster = caster_node
	rotation = direction.angle()

func _on_body_entered(body: Node2D):
	# Don't hit the caster
	if body.get_instance_id() == owner_id:
		return
	
	# Only hit once
	if has_hit:
		return
	
	# Check if the body has a take_damage method
	if body.has_method("take_damage"):
		# Check if target is alive
		var health_comp = body.get_node_or_null("HealthComponent")
		if health_comp != null and not health_comp.is_alive():
			return  # Don't hook dead targets
		
		has_hit = true
		
		# Deal damage
		body.take_damage(damage, caster)
		
		print("Hook hit: ", body.name)
		
		# Start pulling the target
		_start_pull(body)

func _start_pull(target: Node2D):
	if not is_instance_valid(caster) or not is_instance_valid(target):
		queue_free()
		return
	
	pull_target = target
	pull_start_pos = target.global_position
	
	# Calculate pull destination (in front of caster)
	var pull_direction = (caster.global_position - target.global_position).normalized()
	pull_end_pos = caster.global_position - (pull_direction * pull_distance)
	
	pull_timer = 0.0
	is_pulling = true
	
	# Apply stunned state for the duration of the pull
	var state_comp = target.get_node_or_null("StateComponent")
	if state_comp:
		state_comp.add_state("stunned", pull_duration + 0.1)
	
	print("Started pulling ", target.name, " from ", pull_start_pos, " to ", pull_end_pos)

func _update_pull(delta: float):
	if not is_instance_valid(pull_target) or not is_instance_valid(caster):
		queue_free()
		return
	
	# Check if target is still alive
	var health_comp = pull_target.get_node_or_null("HealthComponent")
	if health_comp != null and not health_comp.is_alive():
		# Target died during pull, stop pulling
		is_pulling = false
		queue_free()
		return
	
	pull_timer += delta
	var progress = pull_timer / pull_duration
	
	if progress >= 1.0:
		# Pull complete
		pull_target.global_position = pull_end_pos
		is_pulling = false
		print("Pull complete for ", pull_target.name)
		queue_free()
		return
	
	# Ease out interpolation
	var eased_progress = 1.0 - pow(1.0 - progress, 2.0)
	
	# Interpolate position
	var new_pos = pull_start_pos.lerp(pull_end_pos, eased_progress)
	pull_target.global_position = new_pos
	
	# If it's a CharacterBody2D, also update velocity to 0
	if pull_target is CharacterBody2D:
		pull_target.velocity = Vector2.ZERO
