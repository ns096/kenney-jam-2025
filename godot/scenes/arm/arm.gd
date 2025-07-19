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


# TODO find good balancing
var base_damage = 7.0
var growth_level = 0

var current_arm = 0

# multiply and then scale back later from 500 to 5, because the animation player is fucky wucky
@export_range(1.0,10000.0,0.5) var damage_factor = 1000.0

signal strike_finished(damage)

# TODO
# change sprite on upgrade
# change color on dmg type 
# visual feedback on wrong attack?

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Globals.ability_unlocked.connect(unlock_ability)
	#anim_player.animation_finished.connect(finish_strike)


func _physics_process(delta: float) -> void:
	position = get_global_mouse_position()
	#current_grow = clamp(current_grow + (delta * growth_factor), 0 , max_grow)
	#grow(current_grow)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not anim_player.current_animation.contains("strike"):
			# anim_player.speed_scale = clamp(3.2 - (current_grow * 3), 0.05, 5)
			anim_player.stop(true)
			anim_player.play("basic_strike")
			


func finish_strike():
	emit_signal("strike_finished", max(1.0, base_damage * (damage_factor / 1000)))

	scale = MIN_SCALE
	current_grow = 0
	anim_player.speed_scale = growth_speed
	anim_player.queue("grow_%s" % growth_level)
	
func grow(current_grow: float):
	#position = lerp(MIN_POS, MAX_POS, current_grow)
	scale =  lerp(MIN_SCALE, MAX_SCALE, current_grow)
	
	
func unlock_ability(ability_name: String):
	match ability_name:
		"more_power":
			base_damage += 1
		"increase_growth_level":
			growth_level += 1
		"bigger_arm":
			current_arm += 1
			base_damage += 5
			$Sprite.texture = arm_sprites[current_arm]
