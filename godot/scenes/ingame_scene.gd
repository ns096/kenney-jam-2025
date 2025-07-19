extends Node2D

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay

func _ready() -> void:
	fade_overlay.visible = true
	
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())
	
	pause_overlay.game_exited.connect(_save_game)
	
	
	# All events/signals get connected here
	$Arm.strike_finished.connect($Enemy.hurt)
	$Enemy.reward_received.connect($UI/MainUI.receive_reward)
	$UI/MainUI.threat_level_increased.connect(func(threat): $Enemy.current_threat_level = threat)
	


func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true
		
func _save_game() -> void:
	SaveGame.save_game(get_tree())


func create_enemy():
	$Enemy.setup()
