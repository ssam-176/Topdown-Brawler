extends Control
class_name AbilityUI

## UI that displays ability slots, cooldowns, and energy

@onready var ability_slot_1 = $AbilitySlots/Slot1
@onready var ability_slot_2 = $AbilitySlots/Slot2
@onready var ability_slot_3 = $AbilitySlots/Slot3
@onready var ability_slot_4 = $AbilitySlots/Slot4
@onready var energy_bar = $EnergyBar
@onready var energy_label = $EnergyBar/Label

var ability_manager: AbilityManager
var slots: Array = []

func _ready():
	slots = [ability_slot_1, ability_slot_2, ability_slot_3, ability_slot_4]

func setup(ability_mgr: AbilityManager):
	ability_manager = ability_mgr
	
	# Connect signals
	ability_manager.cooldown_started.connect(_on_cooldown_started)
	ability_manager.energy_changed.connect(_on_energy_changed)
	
	# Initialize slots
	_update_ability_slots()
	_update_energy_bar()

func _process(_delta):
	if ability_manager:
		_update_cooldowns()

func _update_ability_slots():
	for i in range(4):
		var slot = slots[i]
		var ability = ability_manager.ability_slots[i]
		
		if ability:
			slot.get_node("VBox/Name").text = ability.ability_name
			slot.get_node("VBox/Key").text = _get_key_for_slot(i)
			slot.get_node("VBox/Cost").text = "Cost: " + str(int(ability.energy_cost))
		else:
			slot.get_node("VBox/Name").text = "Empty"
			slot.get_node("VBox/Key").text = _get_key_for_slot(i)
			slot.get_node("VBox/Cost").text = "-"

func _update_cooldowns():
	for i in range(4):
		var slot = slots[i]
		var cooldown = ability_manager.get_cooldown(i)
		var cooldown_label = slot.get_node("Cooldown")
		
		if cooldown > 0:
			cooldown_label.text = "%.1f" % cooldown
			cooldown_label.visible = true
			slot.modulate = Color(0.5, 0.5, 0.5, 1.0)  # Dim when on cooldown
		else:
			cooldown_label.visible = false
			
			# Check if can use (has enough energy)
			if ability_manager.can_use_ability(i):
				slot.modulate = Color(1.0, 1.0, 1.0, 1.0)  # Normal
			else:
				slot.modulate = Color(0.7, 0.7, 0.7, 1.0)  # Slightly dim if not enough energy

func _on_cooldown_started(slot: int, _duration: float):
	# Visual feedback when cooldown starts
	if slot >= 0 and slot < 4:
		var slot_node = slots[slot]
		slot_node.modulate = Color(0.5, 0.5, 0.5, 1.0)

func _update_energy_bar():
	if not ability_manager:
		return
	
	var percentage = ability_manager.current_energy / ability_manager.max_energy
	energy_bar.value = percentage * 100
	energy_label.text = "%d / %d" % [int(ability_manager.current_energy), int(ability_manager.max_energy)]

func _on_energy_changed(_current: float, _max: float):
	_update_energy_bar()

func _get_key_for_slot(slot: int) -> String:
	match slot:
		0: return "Q"
		1: return "E"
		2: return "R"
		3: return "F"
	return "?"
