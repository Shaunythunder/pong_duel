extends OptionButton

# ========== Constants ==========

# ========== Variables ==========

# ========== Methods ==========

# ========== Helpers ==========

# ========== Godot Runtime ==========


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalFlagManager.load_data_from_json()
	if GlobalFlagManager.global_flags["difficulty"] == GlobalConstants.EASY:
		selected = 0
	elif GlobalFlagManager.global_flags["difficulty"] == GlobalConstants.MEDIUM:
		selected = 1
	elif GlobalFlagManager.global_flags["difficulty"] == GlobalConstants.HARD:
		selected = 2
	elif GlobalFlagManager.global_flags["difficulty"] == GlobalConstants.INSANE:
		selected = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
