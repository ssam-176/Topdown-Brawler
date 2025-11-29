extends CharacterBody2D

## Simple test dummy that takes damage

@export var spawn_position: Vector2 = Vector2.ZERO

@onready var health_component = $HealthComponent
@onready var state_component = $StateComponent

func _ready():
	health_component.death.connect(_on_death)
	health_component.respawned.connect(_on_respawned)
	
	# Store spawn position
	spawn_position = global_position

func take_damage(amount: float, source: Node = null) -> void:
	# Only take damage if alive
	if health_component.is_alive():
		health_component.take_damage(amount, source)

func _on_death():
	print("Dummy destroyed!")
	# Clear states on death
	if state_component:
		state_component.clear_all_states()

func _on_respawned():
	# Reset to spawn position
	global_position = spawn_position
	print("Dummy respawned at ", spawn_position)
