extends Area2D
class_name HomingProjectile

## Homing projectile that tracks and follows targets

@export var speed: float = 300.0
@export var damage: float = 8.0
@export var lifetime: float = 5.0
@export var homing_strength: float = 8.0  ## How aggressively it turns (radians per second) - INCREASED
@export var search_radius: float = 400.0  ## How far it looks for targets
@export var pierce_count: int = 0

var direction: Vector2 = Vector2.RIGHT
var owner_id: int = -1
var pierced: int = 0
var hit_entities: Array = []
var target: Node2D = null
var can_retarget: bool = true  ## Can find new targets after losing one

func _ready():
	body_entered.connect(_on_body_entered)
	
	# Auto-destroy after lifetime
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	
	# Find initial target with a small delay to avoid hitting caster
	get_tree().create_timer(0.1).timeout.connect(_find_target)

func _physics_process(delta):
	# Try to find a target if we don't have one
	if target == null or not is_instance_valid(target):
		if can_retarget:
			_find_target()
	
	# Home in on target if we have one
	if target != null and is_instance_valid(target):
		var to_target = (target.global_position - global_position).normalized()
		# Smoothly rotate toward target
		direction = direction.lerp(to_target, homing_strength * delta).normalized()
	
	# Move in current direction
	position += direction * speed * delta
	rotation = direction.angle()

func setup(start_pos: Vector2, dir: Vector2, caster_id: int):
	global_position = start_pos
	direction = dir.normalized()
	owner_id = caster_id
	rotation = direction.angle()

func _find_target():
	var best_target: Node2D = null
	var closest_distance: float = INF  # Changed from search_radius to find truly closest
	
	# Get all bodies in physics space
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = search_radius
	query.shape = shape
	query.transform = global_transform
	query.collision_mask = 3  # Layers 1 and 2 (players and enemies)
	query.exclude = [get_rid()]  # Exclude self
	
	var results = space_state.intersect_shape(query)
	
	# Find closest valid target
	for result in results:
		var body = result.collider
		
		# Skip if it's the owner (caster)
		if body.get_instance_id() == owner_id:
			continue
		
		# Skip if already hit
		if body in hit_entities:
			continue
		
		# Check if it has a take_damage method
		if not body.has_method("take_damage"):
			continue
		
		# Check if it's alive (has health component)
		var health_comp = body.get_node_or_null("HealthComponent")
		if health_comp != null and not health_comp.is_alive():
			continue  # Skip dead targets
		
		# Check distance - prioritize closest
		var distance = global_position.distance_to(body.global_position)
		if distance < closest_distance and distance <= search_radius:
			closest_distance = distance
			best_target = body
	
	target = best_target
	
	if target != null:
		print("Homing projectile locked onto: ", target.name, " at distance ", closest_distance)

func _on_body_entered(body: Node2D):
	# Don't hit the caster
	if body.get_instance_id() == owner_id:
		print("Projectile skipped caster: ", body.name)
		return
	
	# Don't hit the same entity twice
	if body in hit_entities:
		return
	
	# Check if the body has a take_damage method
	if body.has_method("take_damage"):
		# Check if target is alive
		var health_comp = body.get_node_or_null("HealthComponent")
		if health_comp != null and not health_comp.is_alive():
			return  # Don't hit dead targets
		
		body.take_damage(damage, get_parent())
		hit_entities.append(body)
		print("Homing projectile hit: ", body.name)
		_handle_hit()

func _handle_hit():
	pierced += 1
	if pierced > pierce_count:
		queue_free()
	else:
		# Lost our target, find a new one
		target = null
