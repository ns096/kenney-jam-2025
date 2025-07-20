extends Node2D


var max_grow = 1
var current_grow = 0.0
var growth_factor = 1./4.
var growth_speed = 1

@export var arm_sprites: Array[Texture2D] = []

var MIN_POS = Vector2(30,3)
var MIN_SCALE = Vector2(0.5,0.5)

var MAX_POS = Vector2(467.0,2.0)
var MAX_SCALE = Vector2(4,4)


var old_scale = scale
@export var scale_anim = Vector2.ONE:
	set(val):
		scale_anim = val
		scale = old_scale * scale_anim

var double_attack_unlocked = false

# TODO find good balancing
@export var base_damage = 3.0 :
	get:
		return base_damage
	set(val):
		Globals.base_damage = val
		base_damage = val

var growth_level = 0

var current_arm = 0

# multiply and then scale back later from 500 to 5, because the animation player is fucky wucky
@export_range(1.0,1000000.0,0.5) var damage_factor = 1000.0

signal strike_finished(damage)

# TODO
# change sprite on upgrade
# change color on dmg type 
# visual feedback on wrong attack?

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Globals.ability_unlocked.connect(unlock_ability)
	Globals.pause_game.connect(func(pause): get_tree().paused = pause)
	#anim_player.animation_finished.connect(finish_strike)


func _physics_process(delta: float) -> void:
	position = get_global_mouse_position()
	Globals.power = calculate_power()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not anim_player.current_animation.contains("strike"):
			# anim_player.speed_scale = clamp(3.2 - (current_grow * 3), 0.05, 5)
			anim_player.stop(true)
			if double_attack_unlocked:
				anim_player.play("double_strike")
			else:
				anim_player.play("basic_strike")


func strike():
	emit_signal("strike_finished", calculate_power())


func finish_strike():
	emit_signal("strike_finished", calculate_power())
	# anim_player.speed_scale = growth_speed
	anim_player.queue("grow_%s" % growth_level)


func calculate_power():
	return max(1.0, base_damage * (damage_factor / 1000))
	
func unlock_ability(ability_name: String,cost):
	match ability_name:
		"more_power":
			old_scale += Vector2(0.2,0.2)
			base_damage += 3
			base_damage *= 1.5 
		"increase_growth_level":
			growth_level += 1
			current_arm += 1
			base_damage += 5
			$Sprite.texture = arm_sprites[current_arm]
		"increase_speed":
			anim_player.speed_scale += 0.2
		"double_attack":
			double_attack_unlocked = true
