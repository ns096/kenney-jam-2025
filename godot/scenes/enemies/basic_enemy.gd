extends Node2D

@onready var anim_player = $AnimationPlayer

var current_health = 15
var max_health = 15

var reward_xp = 2
var regeneration = 0

@export var enemies_0: Array[Texture2D] = []
@export var enemies_1: Array[Texture2D] = []

var current_threat_level = 0


func health_regen(factor: int):
	current_health += regeneration * factor

func spawn_next(anim):
	print(anim)
	setup_enemy(current_threat_level)
	anim_player.queue("spawn")

func setup_enemy(threat_level: int):

	match threat_level:
		0:
			get_enemy_sprite(enemies_0)
			
			set_health(40)
			reward_xp = 3
			regeneration = 0
		1:
			get_enemy_sprite(enemies_1)
			set_health(50)
			reward_xp = 6
			regeneration = 5

func set_health(health):
		max_health = health
		current_health = max_health
		$Health.value = max_health
		$Health.max_value = max_health



func get_enemy_sprite(enemy_sprites: Array[Texture2D]):
	$SizeControl/Sprite2D.texture = enemy_sprites.pick_random()


func hurt(damage: float):
	current_health -= damage
	$Health.value = current_health
	if current_health <= 0:
		die()
	else:
		anim_player.play("hurt")
		
	
func die():
	anim_player.play("death")
	
	
