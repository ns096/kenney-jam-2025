extends Control

var all_time_xp = 0
var current_threat_level = 0

signal threat_level_increased(current_threat_level)

func _ready() -> void:
	Globals.ability_unlocked.connect(on_ability_unlocked)

func receive_reward(reward_xp):
	Globals.xp += reward_xp
	all_time_xp += reward_xp
	
	if  current_threat_level == 0 and all_time_xp >= 15: 
		increase_threat_level()
	elif  current_threat_level == 1 and all_time_xp >= 80: 
		increase_threat_level()
	elif  current_threat_level == 2 and all_time_xp >= 180: 
		increase_threat_level()
		
		
func on_ability_unlocked(ability_name, cost):
	Globals.xp -= cost

func update_resources():
	$VBoxContainer/Resources/XP.text = "XP: %s" %Globals.xp
	$VBoxContainer/Resources/Threat.text = "Threat: %s" %current_threat_level
	$VBoxContainer/Resources/Power.text = "Power: %.f" %Globals.power

func _physics_process(delta: float) -> void:
	update_resources()


func increase_threat_level():
	current_threat_level += 1
	emit_signal("threat_level_increased", current_threat_level)

func _on_stats_pressed() -> void:
	pass # Replace with function body.

func _on_abilities_pressed() -> void:
	$VBoxContainer/Ability_Overlay.visible = not $VBoxContainer/Ability_Overlay.visible
	# Globals.emit_signal("pause_game", $VBoxContainer/Ability_Overlay.visible)
