extends MarginContainer

@export var ability_name = ""
@export var cost = 0
@export var description = ""

func _ready() -> void:
	$MarginContainer/VBoxContainer/RichTextLabel.text = ("[font_size=20 ][color=black]%s[/color][/font_size]\n" % ability_name) \
	+ ("%s\n" % description) \
	+ ("%s XP\n" % cost) 
