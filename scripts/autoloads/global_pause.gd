extends Node

var game_paused: bool = false
var count_down_active: bool = false

signal pause_toggle()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().connect("tree_changed", _on_tree_changed)

func _input(event: InputEvent) -> void:
	if not count_down_active:
		if event.is_action_pressed("ui_cancel"):
			game_paused = not game_paused
			get_tree().paused = game_paused
			pause_toggle.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_tree_changed() -> void:
	if get_tree() != null:
		game_paused = false
		get_tree().paused = game_paused
