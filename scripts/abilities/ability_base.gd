extends Resource
class_name AbilityBase

## Base resource class for all abilities
## Stores data that can be tweaked in the inspector

enum CastType {
	FRONT_CAST,  ## Cast time BEFORE ability executes (traditional cast)
	BACK_CAST,   ## Cast time AFTER ability executes (backswing/recovery)
	INSTANT      ## No cast time at all
}

@export var ability_name: String = "Unnamed Ability"
@export var cooldown: float = 1.0
@export var energy_cost: float = 20.0
@export var cast_time: float = 0.2  ## Time before/after ability executes
@export var cast_type: CastType = CastType.FRONT_CAST  ## When the cast time happens
@export var icon: Texture2D
@export var behavior_script: Script  ## The GDScript that defines how this ability works

## Additional parameters that can be used by behaviors
@export_group("Behavior Parameters")
@export var projectile_scene: PackedScene  ## For projectile abilities
@export var projectile_speed: float = 400.0
@export var projectile_damage: float = 10.0
@export var projectile_lifetime: float = 3.0
@export var dash_distance: float = 200.0  ## For dash abilities
@export var dash_duration: float = 0.2

## Optionally store a reference to the behavior instance
var behavior_instance: AbilityBehavior = null

func get_behavior() -> AbilityBehavior:
	if behavior_instance == null and behavior_script != null:
		behavior_instance = behavior_script.new()
		behavior_instance.ability_data = self
	return behavior_instance
