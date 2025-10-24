extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalFlagManager.mouse_enabled == true:
		selected = 0
	elif GlobalFlagManager.mouse_enabled == false:
		selected = 1
