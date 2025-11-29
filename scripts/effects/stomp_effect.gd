extends Node2D
class_name StompEffect

## Visual effect for the stomp ability

@export var max_radius: float = 150.0
@export var duration: float = 0.3
@export var color: Color = Color(1.0, 0.8, 0.2, 0.6)  # Orange/yellow

var elapsed: float = 0.0

func _ready():
	# Auto-destroy after duration
	get_tree().create_timer(duration).timeout.connect(queue_free)

func _process(delta):
	elapsed += delta
	queue_redraw()

func _draw():
	var progress = elapsed / duration
	if progress >= 1.0:
		return
	
	# Ease out for expansion
	var eased = 1.0 - pow(1.0 - progress, 2.0)
	var current_radius = max_radius * eased
	
	# Fade out as it expands
	var alpha = 1.0 - progress
	var draw_color = Color(color.r, color.g, color.b, color.a * alpha)
	
	# Draw expanding circle
	draw_circle(Vector2.ZERO, current_radius, draw_color)
	
	# Draw expanding ring for emphasis
	draw_arc(Vector2.ZERO, current_radius, 0, TAU, 32, Color(draw_color.r, draw_color.g, draw_color.b, draw_color.a * 1.5), 3.0)
