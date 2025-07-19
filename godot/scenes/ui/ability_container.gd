extends MarginContainer

@export var ability_name = ""
@export var title = ""
@export var cost = 0
@export var description = ""

signal ability_bought(ability_name: String)

func _physics_process(delta: float) -> void:
	if cost < Globals.xp:
		$MarginContainer/VBoxContainer/Button.disabled = true
	else:
		$MarginContainer/VBoxContainer/Button.disabled = false

func _ready() -> void:
	$MarginContainer/VBoxContainer/RichTextLabel.text = ("[font_size=20 ][color=black]%s[/color][/font_size]\n" % title) \
	+ ("%s\n" % description) \
	+ ("%s XP\n" % cost) 


func _on_button_pressed() -> void:
	Globals.xp -= cost
	Globals.emit_signal("ability_unlocked", ability_name)
