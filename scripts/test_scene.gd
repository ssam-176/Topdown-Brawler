extends Node2D

## Test scene script - connects UI to player

@onready var player = $Player
@onready var ability_ui = $CanvasLayer/AbilityUI

func _ready():
	# Connect UI to player's ability manager
	if player and ability_ui:
		ability_ui.setup(player.ability_manager)
