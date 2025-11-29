extends Node2D
class_name StatusIndicator

## Displays current status effects above an entity

@export var offset_y: float = -70.0  ## How far above the entity
@export var stunned_color: Color = Color(1.0, 0.3, 0.3, 1.0)  ## Red
@export var casting_color: Color = Color(0.3, 0.5, 1.0, 1.0)  ## Blue
@export var knocked_color: Color = Color(1.0, 0.6, 0.2, 1.0)  ## Orange

var state_component: Node
var ability_manager: Node
var current_status: String = ""

func _ready():
	# Find components in parent
	state_component = get_parent().get_node_or_null("StateComponent")
	ability_manager = get_parent().get_node_or_null("AbilityManager")
	
	if state_component:
		state_component.state_changed.connect(_on_state_changed)

func _process(_delta):
	queue_redraw()

func _draw():
	if current_status == "":
		return
	
	var color = Color.WHITE
	var text = ""
	
	# Determine what to display
	if state_component:
		if state_component.has_state("stunned"):
			text = "STUNNED"
			color = stunned_color
		elif state_component.has_state("knocked_up"):
			text = "KNOCKED"
			color = knocked_color
		elif state_component.has_state("casting"):
			text = "CASTING"
			color = casting_color
		elif state_component.has_state("rooted"):
			text = "ROOTED"
			color = Color(0.6, 0.4, 0.2, 1.0)
		elif state_component.has_state("silenced"):
			text = "SILENCED"
			color = Color(0.5, 0.2, 0.8, 1.0)
	
	if text == "":
		current_status = ""
		return
	
	current_status = text
	
	# Draw background
	var font = ThemeDB.fallback_font
	var font_size = 14
	var text_size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
	var bg_rect = Rect2(
		Vector2(-text_size.x / 2 - 4, offset_y - 2),
		Vector2(text_size.x + 8, text_size.y + 4)
	)
	draw_rect(bg_rect, Color(0, 0, 0, 0.7))
	
	# Draw text
	draw_string(font, Vector2(-text_size.x / 2, offset_y + text_size.y - 2), text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, color)

func _on_state_changed(state_name: String, active: bool):
	if active:
		current_status = state_name
	else:
		# Check if there are any other active states
		_update_current_status()

func _update_current_status():
	if not state_component:
		current_status = ""
		return
	
	# Priority order for display
	if state_component.has_state("stunned"):
		current_status = "stunned"
	elif state_component.has_state("knocked_up"):
		current_status = "knocked_up"
	elif state_component.has_state("rooted"):
		current_status = "rooted"
	elif state_component.has_state("silenced"):
		current_status = "silenced"
	elif state_component.has_state("casting"):
		current_status = "casting"
	else:
		current_status = ""
