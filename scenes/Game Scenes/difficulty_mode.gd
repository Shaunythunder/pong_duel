extends OptionButton

# ========== Constants ==========

# ========== Variables ==========

# ========== Methods ==========

# ========== Helpers ==========

# ========== Godot Runtime ==========


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalFlagManager.difficulty == GlobalConstants.EASY:
		selected = 0
	elif GlobalFlagManager.difficulty == GlobalConstants.MEDIUM:
		selected = 1
	elif GlobalFlagManager.difficulty == GlobalConstants.HARD:
		selected = 2
	elif GlobalFlagManager.difficulty == GlobalConstants.INSANE:
		selected = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
