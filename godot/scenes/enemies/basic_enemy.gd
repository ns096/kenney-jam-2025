extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var current_health = 15
var max_health = 15

var reward_xp = 2
var regeneration = 0

@export var enemies_0: Array[Texture2D] = []
@export var enemies_1: Array[Texture2D] = []

var current_threat_level = 0

signal reward_received(reward_xp: int)

var regen_interval = 0.25
var timer = 0.0
var BASE_REGEN = 0.1
func _physics_process(delta: float) -> void:
	if anim_player.current_animation.contains("death") or anim_player.current_animation.contains("spawn"):
		return
	timer += delta
	if timer >= regen_interval:
		timer = 0.0
		health_regen(BASE_REGEN)
		
	

func health_regen(factor: float):
	current_health = clamp(current_health + (regeneration * factor), 0, max_health)
	$Health.value = current_health

func spawn_next(anim):
	setup_enemy(current_threat_level)
	anim_player.queue("spawn")
	anim_player.queue("threat_loop_%s" %current_threat_level)

func setup_enemy(threat_level: int):
	match threat_level:
		0:
			get_enemy_sprite(enemies_0)
			set_health(35)
			reward_xp = 3
			regeneration = 0
		1:
			get_enemy_sprite(enemies_1)
			set_health(50)
			reward_xp = 6
			regeneration = 3

func set_health(health):
		max_health = health
		current_health = max_health
		$Health.value = max_health
		$Health.max_value = max_health


func get_enemy_sprite(enemy_sprites: Array[Texture2D]):
	$SizeControl/Sprite2D.texture = enemy_sprites.pick_random()


func hurt(damage: float):
	
	if anim_player.current_animation.contains("death") or anim_player.current_animation.contains("spawn"):
		return
	
	current_health -= damage
	$Health.value = current_health
	if current_health <= 0:
		die()
	else:

		anim_player.play("hurt",-1, 1.5)
		anim_player.queue("threat_loop_%s" %current_threat_level)

		

func die():
	anim_player.play("death")
	
func get_reward():
	emit_signal("reward_received", reward_xp)
