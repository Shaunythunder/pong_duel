extends Label

# ========== Constants ==========

# ========== Variables ==========

# ========== Methods ==========

# ========== Helpers ==========

# ========== Godot Runtime ==========


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "High Score: %s" % str(int(GlobalUnlocks.save_data[GlobalFlagManager.global_flags["difficulty"]]["survival_highscore"]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
