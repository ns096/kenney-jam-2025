extends Control


var current_xp = 0
var all_time_xp = 0
var current_threat_level = 0

signal threat_level_increased(current_threat_level)

func receive_reward(reward_xp):
	current_xp += reward_xp
	all_time_xp += reward_xp
	$VBoxContainer/Resources/XP.text = "XP: %s" %current_xp
	
	if  current_threat_level == 0 and all_time_xp >= 10: 
		increase_threat_level()
	elif  current_threat_level == 1 and all_time_xp >= 50: 
		increase_threat_level()
	elif  current_threat_level == 2 and all_time_xp >= 100: 
		increase_threat_level()
		

func increase_threat_level():
	current_threat_level += 1
	emit_signal("threat_level_increased", current_threat_level)
	$VBoxContainer/Resources/Threat.text = "Threat: %s" %current_threat_level
