extends Node

const SAVE_PATH: String = "user://save_data.json"

var save_data: Dictionary = {
		"Easy": {
			"pong_ball_completed": false,
			"fake_ball_completed": false,
			"bullet_ball_completed": false,
			"stealth_ball_completed": false,
			"boss_ball_completed": false,
			"survival_highscore": 0,
		},
		"Medium": {
			"pong_ball_completed": false,
			"fake_ball_completed": false,
			"bullet_ball_completed": false,
			"stealth_ball_completed": false,
			"boss_ball_completed": false,
			"survival_highscore": 0,
		},
		"Hard": {
			"pong_ball_completed": false,
			"fake_ball_completed": false,
			"bullet_ball_completed": false,
			"stealth_ball_completed": false,
			"boss_ball_completed": false,
			"survival_highscore": 0,
		},
		"INSANE": {
			"pong_ball_completed": false,
			"fake_ball_completed": false,
			"bullet_ball_completed": false,
			"stealth_ball_completed": false,
			"boss_ball_completed": false,
			"survival_highscore": 0,
		},
 	}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func reset_progress():
	save_data = {
		"Easy": {
			"pong_ball_completed": false,
			"fake_ball_completed": false,
			"bullet_ball_completed": false,
			"stealth_ball_completed": false,
			"boss_ball_completed": false,
			"survival_highscore": 0,
		},
		"Medium": {
			"pong_ball_completed": false,
			"fake_ball_completed": false,
			"bullet_ball_completed": false,
			"stealth_ball_completed": false,
			"boss_ball_completed": false,
			"survival_highscore": 0,
		},
		"Hard": {
			"pong_ball_completed": false,
			"fake_ball_completed": false,
			"bullet_ball_completed": false,
			"stealth_ball_completed": false,
			"boss_ball_completed": false,
			"survival_highscore": 0,
		},
		"INSANE": {
			"pong_ball_completed": false,
			"fake_ball_completed": false,
			"bullet_ball_completed": false,
			"stealth_ball_completed": false,
			"boss_ball_completed": false,
			"survival_highscore": 0,
		},
	 }
	save_data_to_json()

func save_data_to_json() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		push_error("Failed to open file at %s for saving" % SAVE_PATH)
		return
		
	var content: String = JSON.stringify(save_data)
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
	save_data = temp_json.data as Dictionary
	
func pong_duel_complete() -> void:
	save_data["pong_ball_completed"] = true
	save_data_to_json()
	
func fake_duel_complete() -> void:
	save_data["fake_ball_completed"] = true
	save_data_to_json()

func bullet_duel_complete() -> void:
	save_data["bullet_ball_completed"] = true
	save_data_to_json()

func stealth_duel_complete() -> void:
	save_data["stealth_ball_completed"] = true
	save_data_to_json()
	
func boss_duel_complete() -> void:
	save_data["bullet_ball_completed"] = true
	save_data_to_json()

func survival_mode_complete(score: int):
	if score > save_data["survival_highscore"]:
		save_data["survival_highscore"] = score
	save_data_to_json()
