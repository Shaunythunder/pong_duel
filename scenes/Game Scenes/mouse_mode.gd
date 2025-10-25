extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalFlagManager.load_data_from_json()
	if GlobalFlagManager.global_flags["mouse_enabled"] == true:
		selected = 0
	elif GlobalFlagManager.global_flags["mouse_enabled"] == false:
		selected = 1
