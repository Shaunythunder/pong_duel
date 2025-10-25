extends Node

# ========== Constants ==========

# ========== Variables ==========

# ========== Methods ==========

# ========== Helpers ==========

@onready var label = $"Label"
# ========== Godot Runtime ==========

var count_down_time: int = 1
var timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalPause.game_paused = true
	GlobalPause.count_down_active = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.timeout.connect(_on_second_progression)
	timer.start()
	
func set_text(text: String):
	label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_second_progression() -> void:
	count_down_time -= 1
	if count_down_time <= 0:
		get_tree().paused = false
		GlobalPause.game_paused = false
		GlobalPause.count_down_active = false
		queue_free()
