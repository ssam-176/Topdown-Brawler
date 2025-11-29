extends Area2D
class_name Projectile

## Base projectile that flies in a direction and damages targets

@export var speed: float = 400.0
@export var damage: float = 10.0
@export var lifetime: float = 3.0
@export var pierce_count: int = 0  ## 0 = destroyed on hit, >0 = can hit multiple targets

var direction: Vector2 = Vector2.RIGHT
var owner_id: int = -1  ## To prevent hitting the caster
var pierced: int = 0
var hit_entities: Array = []  ## Track what we've hit to avoid double-hitting

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	# Auto-destroy after lifetime
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta):
	position += direction * speed * delta

func setup(start_pos: Vector2, dir: Vector2, caster_id: int):
	global_position = start_pos
	direction = dir.normalized()
	owner_id = caster_id
	rotation = direction.angle()

func _on_body_entered(body: Node2D):
	# Don't hit the caster
	if body.get_instance_id() == owner_id:
		return
	
	# Don't hit the same entity twice
	if body in hit_entities:
		return
	
	# Check if the body has a take_damage method
	if body.has_method("take_damage"):
		# Check if target is alive (has health component)
		var health_comp = body.get_node_or_null("HealthComponent")
		if health_comp != null and not health_comp.is_alive():
			return  # Don't hit dead targets
		
		body.take_damage(damage, get_parent())
		hit_entities.append(body)
		_handle_hit()

func _on_area_entered(_area: Area2D):
	# Handle hitting other projectiles or areas if needed
	pass

func _handle_hit():
	pierced += 1
	if pierced > pierce_count:
		queue_free()
