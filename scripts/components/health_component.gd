extends Node
class_name HealthComponent

## Reusable health component that can be added to any entity

signal health_changed(current: float, max: float)
signal damage_taken(amount: float, source: Node)
signal death()
signal respawned()
signal stock_changed(current: int, max: int)
signal out_of_stocks()

@export var max_health: float = 100.0
@export var current_health: float = 100.0
@export var can_die: bool = true
@export var respawn_time: float = 3.0
@export var invulnerable: bool = false

@export_group("Health Regeneration")
@export var health_regen_rate: float = 0.0  ## Health per second (0 = no regen)
@export var regen_delay: float = 3.0  ## Time after taking damage before regen starts
@export var regen_in_combat: bool = false  ## Can regen while taking damage?

@export_group("Stock System")
@export var use_stocks: bool = false  ## Enable stock/lives system
@export var max_stocks: int = 3  ## Total lives
@export var current_stocks: int = 3  ## Current lives remaining

var is_dead: bool = false
var owner_node: Node
var time_since_last_damage: float = 0.0

func _ready():
	owner_node = get_parent()
	current_health = max_health
	if use_stocks:
		current_stocks = max_stocks
		stock_changed.emit(current_stocks, max_stocks)
	health_changed.emit(current_health, max_health)

func _process(delta: float):
	if is_dead or not health_regen_rate > 0:
		return
	
	# Track time since last damage
	time_since_last_damage += delta
	
	# Only regen if delay has passed (or if we allow combat regen)
	if regen_in_combat or time_since_last_damage >= regen_delay:
		if current_health < max_health:
			current_health = min(max_health, current_health + health_regen_rate * delta)
			health_changed.emit(current_health, max_health)

## Take damage from a source
func take_damage(amount: float, source: Node = null) -> void:
	if is_dead or invulnerable:
		return
	
	current_health = max(0, current_health - amount)
	time_since_last_damage = 0.0  # Reset regen delay
	health_changed.emit(current_health, max_health)
	damage_taken.emit(amount, source)
	
	print(owner_node.name, " took ", amount, " damage. Health: ", current_health, "/", max_health)
	
	if current_health <= 0 and can_die:
		die()

## Heal the entity
func heal(amount: float) -> void:
	if is_dead:
		return
	
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

## Set health to a specific value
func set_health(value: float) -> void:
	current_health = clamp(value, 0, max_health)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0 and can_die and not is_dead:
		die()

## Handle death
func die() -> void:
	if is_dead:
		return
	
	is_dead = true
	death.emit()
	
	print(owner_node.name, " died!")
	
	# Check stocks
	if use_stocks:
		current_stocks -= 1
		stock_changed.emit(current_stocks, max_stocks)
		print(owner_node.name, " stocks remaining: ", current_stocks)
		
		if current_stocks <= 0:
			# Out of stocks - no respawn
			out_of_stocks.emit()
			print(owner_node.name, " is out of stocks!")
			_disable_entity()
			return
	
	# Disable the owner (visually hide, disable collision, etc.)
	_disable_entity()
	
	# Auto respawn if enabled
	if respawn_time > 0:
		await get_tree().create_timer(respawn_time).timeout
		respawn()

## Disable entity visuals and physics
func _disable_entity() -> void:
	if owner_node is CharacterBody2D or owner_node is Area2D:
		owner_node.set_physics_process(false)
		owner_node.visible = false

## Enable entity visuals and physics
func _enable_entity() -> void:
	if owner_node is CharacterBody2D or owner_node is Area2D:
		owner_node.set_physics_process(true)
		owner_node.visible = true

## Respawn the entity
func respawn() -> void:
	if not is_dead:
		return
	
	# Can't respawn if out of stocks
	if use_stocks and current_stocks <= 0:
		return
	
	is_dead = false
	current_health = max_health
	time_since_last_damage = 0.0
	health_changed.emit(current_health, max_health)
	respawned.emit()
	
	print(owner_node.name, " respawned!")
	
	# Re-enable the owner
	_enable_entity()

## Reset stocks (useful for round resets)
func reset_stocks() -> void:
	current_stocks = max_stocks
	stock_changed.emit(current_stocks, max_stocks)

## Check if entity is alive
func is_alive() -> bool:
	return not is_dead

## Get health percentage (0.0 to 1.0)
func get_health_percentage() -> float:
	return current_health / max_health if max_health > 0 else 0.0

## Check if entity has stocks remaining
func has_stocks_remaining() -> bool:
	if not use_stocks:
		return true
	return current_stocks > 0
