extends Node

const SAVE_PATH: String = "user://global_flags.json"

var global_flags: Dictionary = {
	"mouse_enabled": true,
	"difficulty": GlobalConstants.MEDIUM,
	"player_color": Color.WHITE
}

func save_data_to_json() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		push_error("Failed to open file at %s for saving" % SAVE_PATH)
		return
		
	var content: String = JSON.stringify(global_flags)
	file.store_string(content)
	file.close()
	
func load_data_from_json() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("Save file not found: %s" % SAVE_PATH)
		file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	var json_content: String = file.get_as_text()
	file.close()
	
	var temp_json: JSON = JSON.new()
	temp_json.parse(json_content)
	global_flags = temp_json.data as Dictionary

func disable_mouse():
	global_flags["mouse_enabled"] = false
	save_data_to_json()

func enable_mouse():
	global_flags["mouse_enabled"] = true
	save_data_to_json()
	
func change_difficulty(difficulty: String) -> void:
	global_flags["difficulty"] = difficulty
	save_data_to_json()
	
func change_color(color: Color) -> void:
	global_flags["player_color"] = color
