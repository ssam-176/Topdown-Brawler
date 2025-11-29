extends Node2D
class_name StockDisplay

## Displays remaining stocks/lives above an entity

@export var stock_size: float = 8.0
@export var stock_spacing: float = 4.0
@export var offset_y: float = -55.0  ## How far above the entity
@export var stock_color: Color = Color(1, 1, 1, 0.9)
@export var lost_stock_color: Color = Color(0.3, 0.3, 0.3, 0.5)

var health_component: HealthComponent
var current_stocks: int = 0
var max_stocks: int = 0

func _ready():
	# Find health component in parent
	health_component = get_parent().get_node_or_null("HealthComponent")
	if health_component and health_component.use_stocks:
		health_component.stock_changed.connect(_on_stock_changed)
		current_stocks = health_component.current_stocks
		max_stocks = health_component.max_stocks
	else:
		visible = false

func _draw():
	if not is_instance_valid(health_component) or not health_component.use_stocks:
		return
	
	# Calculate total width
	var total_width = (max_stocks * stock_size) + ((max_stocks - 1) * stock_spacing)
	var start_x = -total_width / 2.0
	
	# Draw each stock
	for i in range(max_stocks):
		var x = start_x + (i * (stock_size + stock_spacing))
		var pos = Vector2(x, offset_y)
		var color = stock_color if i < current_stocks else lost_stock_color
		
		# Draw as a circle
		draw_circle(pos + Vector2(stock_size / 2, stock_size / 2), stock_size / 2, color)
		# Draw border
		draw_arc(pos + Vector2(stock_size / 2, stock_size / 2), stock_size / 2, 0, TAU, 16, Color.WHITE, 1.0)

func _on_stock_changed(current: int, max_val: int):
	current_stocks = current
	max_stocks = max_val
	queue_redraw()
