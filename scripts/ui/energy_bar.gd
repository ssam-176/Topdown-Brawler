extends Node2D
class_name EnergyBar

## Displays energy bar below health bar

@export var bar_width: float = 60.0
@export var bar_height: float = 5.0
@export var offset_y: float = -32.0  ## How far above the entity (below health bar)
@export var background_color: Color = Color(0.2, 0.2, 0.2, 0.8)
@export var energy_color: Color = Color(1.0, 0.9, 0.2, 1.0)  ## Yellow
@export var low_energy_color: Color = Color(1.0, 0.5, 0.1, 1.0)  ## Orange
@export var low_energy_threshold: float = 0.3

var ability_manager: Node
var current_percentage: float = 1.0

func _ready():
	# Find ability manager in parent
	ability_manager = get_parent().get_node_or_null("AbilityManager")
	if ability_manager:
		ability_manager.energy_changed.connect(_on_energy_changed)
		# Get initial energy
		if ability_manager.max_energy > 0:
			current_percentage = ability_manager.current_energy / ability_manager.max_energy

func _draw():
	if not is_instance_valid(ability_manager):
		return
	
	var pos = Vector2(-bar_width / 2, offset_y)
	
	# Draw background
	draw_rect(Rect2(pos, Vector2(bar_width, bar_height)), background_color)
	
	# Draw energy bar
	var energy_width = bar_width * current_percentage
	var color = energy_color if current_percentage > low_energy_threshold else low_energy_color
	draw_rect(Rect2(pos, Vector2(energy_width, bar_height)), color)
	
	# Draw border
	draw_rect(Rect2(pos, Vector2(bar_width, bar_height)), Color.WHITE, false, 1.0)

func _on_energy_changed(current: float, max_energy: float):
	current_percentage = current / max_energy if max_energy > 0 else 0.0
	queue_redraw()
