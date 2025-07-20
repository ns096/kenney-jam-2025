extends MarginContainer

@export var ability_name = ""
@export var title = ""
@export var cost = 0
@export var description = ""
@export var full_text = ""

@export var cost_scaling = func(_cost): 
	return _cost * 4

signal ability_bought(ability_name: String)

@export var unlock_textures: Array[Texture2D] = []

@export var unlockable = 1
var unlocked = 0

func _physics_process(delta: float) -> void:
	if cost <= Globals.xp and unlockable > unlocked:
		$MarginContainer/VBoxContainer/Button.disabled = false
	else:
		$MarginContainer/VBoxContainer/Button.disabled = true
		
	var unlocked_counter = unlocked
	for unlock in $MarginContainer/VBoxContainer/HBoxContainer.get_children():
		if unlocked_counter > 0:
			unlocked_counter -= 1
			unlock.texture = unlock_textures[1]
		else:
			unlock.texture = unlock_textures[0]
	update_text()

func _ready() -> void:
	var original = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
	
	for i in range(unlockable):
		var unlock = original.duplicate()
		unlock.visible = true
		$MarginContainer/VBoxContainer/HBoxContainer.add_child(unlock)
	original.queue_free()
	
	update_text()

func update_text():
	var buy_color
	if $MarginContainer/VBoxContainer/Button.disabled:
		buy_color = "red"
	else:
		buy_color = "gold"
	
	if unlocked == unlockable:
		$MarginContainer/VBoxContainer/RichTextLabel.text = ("[font_size=20 ][color=black]%s[/color][/font_size]\n" % full_text)
	else:
		$MarginContainer/VBoxContainer/RichTextLabel.text = ("[font_size=14 ][color=black]%s[/color][/font_size]\n" % title) \
		+ ("[font_size=12 ][color=black]%s[/color][/font_size]\n" % description) \
		+ ("[font_size=12 ][color=%s]%s XP[/color][/font_size]\n" %[buy_color, cost])

func _on_button_pressed() -> void:
	$AudioStreamPlayer.pitch_scale = randf_range(0.9,1.1)
	$AudioStreamPlayer.play()
	Globals.emit_signal("ability_unlocked", ability_name, cost)

	unlocked += 1
	cost *= 4
	update_text()
	$MarginContainer/VBoxContainer/Button.disabled = true
