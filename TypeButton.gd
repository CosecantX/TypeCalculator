extends OptionButton

const types = preload("res://Types.gd").types

func _ready():
	for type in types:
		self.add_item(str(type).capitalize())
