extends Node2D
class_name HealthBar

## Simple health bar that floats above an entity

@export var bar_width: float = 60.0
@export var bar_height: float = 8.0
@export var offset_y: float = -40.0  ## How far above the entity
@export var background_color: Color = Color(0.2, 0.2, 0.2, 0.8)
@export var health_color: Color = Color(0.2, 1.0, 0.2, 1.0)
@export var low_health_color: Color = Color(1.0, 0.2, 0.2, 1.0)
@export var low_health_threshold: float = 0.3

var health_component: HealthComponent
var current_percentage: float = 1.0

func _ready():
	# Find health component in parent
	health_component = get_parent().get_node_or_null("HealthComponent")
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
		health_component.death.connect(_on_death)
		health_component.respawned.connect(_on_respawned)
		current_percentage = health_component.get_health_percentage()

func _draw():
	if not is_instance_valid(health_component):
		return
	
	var pos = Vector2(-bar_width / 2, offset_y)
	
	# Draw background
	draw_rect(Rect2(pos, Vector2(bar_width, bar_height)), background_color)
	
	# Draw health bar
	var health_width = bar_width * current_percentage
	var color = health_color if current_percentage > low_health_threshold else low_health_color
	draw_rect(Rect2(pos, Vector2(health_width, bar_height)), color)
	
	# Draw border
	draw_rect(Rect2(pos, Vector2(bar_width, bar_height)), Color.WHITE, false, 1.0)

func _on_health_changed(current: float, max_health: float):
	current_percentage = current / max_health if max_health > 0 else 0.0
	queue_redraw()

func _on_death():
	visible = false

func _on_respawned():
	visible = true
	current_percentage = 1.0
	queue_redraw()
