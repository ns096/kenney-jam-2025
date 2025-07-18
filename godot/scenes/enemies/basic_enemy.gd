extends Node2D

@onready var anim_player = $AnimationPlayer

@export_range(10,100) var current_health = 100

	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass
	#if event is InputEventMouseButton and event.is_pressed():
		#anim_player.play("hurt")
		


func hurt(damage: float):
	current_health -= damage
	if current_health <= 0:
		die()
	else:
		anim_player.play("hurt")
		
	
func die():
	anim_player.play("death")
	
