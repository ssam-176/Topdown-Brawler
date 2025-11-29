extends Node
class_name AbilityBehavior

## Base class for ability behaviors
## Each ability type (projectile, dash, etc.) extends this

var ability_data: AbilityBase
var caster: Node2D

## Called when the ability is used
func execute(_cast_position: Vector2, _target_direction: Vector2) -> void:
	push_error("execute() must be overridden in child class")

## Optional: Called every frame while ability is active
func update(_delta: float) -> void:
	pass

## Optional: Called when ability ends or is cancelled
func cleanup() -> void:
	pass
