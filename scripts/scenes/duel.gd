extends Node2D

# ========== Constants ==========

const MAIN_MENU_PATH: String = "res://scenes/MainMenu.tscn"

@onready var ball: Node = $"Projectiles/Ball"

@export_enum(
	"Pong Ball", 
	"Fake Ball", 
	"Bullet Ball", 
	"Stealth Ball", 
	"Boss Ball", 
	"Survival Mode"
	) var level: String = "Pong Ball"

var lives_ui_path: String = "res://scenes/Functional/Lives Overlay.tscn"
var pause_menu_path: String = "res://scenes/Functional/PauseMenu.tscn"
var victory_menu_path: String = "res://scenes/Functional/VictoryMenu.tscn"
var defeated_menu_path: String = "res://scenes/Functional/DefeatedMenu.tscn"

var victory_menu
var defeated_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BallManager.clear_pools()
	BallManager.initialize_ball_pool()
	var lives_ui_scene: PackedScene = load(lives_ui_path)
	if lives_ui_scene:
		var lives_ui: Node = lives_ui_scene.instantiate()
		add_child(lives_ui)
		
	var pause_menu_scene: PackedScene = load(pause_menu_path)
	if pause_menu_scene:
		var pause_menu: Node = pause_menu_scene.instantiate()
		add_child(pause_menu)
	
	var victory_menu_scene: PackedScene = load(victory_menu_path)
	if victory_menu_scene:
		victory_menu = victory_menu_scene.instantiate()
		add_child(victory_menu)
		
	var defeated_menu_scene: PackedScene = load(defeated_menu_path)
	if defeated_menu_scene:
		defeated_menu = defeated_menu_scene.instantiate()
		add_child(defeated_menu)
		
	ScoreBus.initialize_lives(GlobalConstants.PLAYER_LIVES, GlobalConstants.AI_LIVES)
	ball.goal_scored.connect(_on_goal_scored)
	ScoreBus.game_over.connect(_on_game_over)
	
func _on_goal_scored(side: String):
	if side == "Left":
		ScoreBus.ai_scored()
	elif side == "Right":
		if level == "Survival Mode":
			ScoreBus.player_scored_survival()
		else:
			ScoreBus.player_scored()
		
func _on_game_over(winner: String):
	if winner == "Player":
		victory_menu.visible = true
		if level == "Pong Ball":
			GlobalUnlocks.save_data["pong_ball_completed"] = true
		if level == "Fake Ball":
			GlobalUnlocks.save_data["fake_ball_completed"] = true
		if level == "Bullet Ball":
			GlobalUnlocks.save_data["bullet_ball_completed"] = true
		if level == "Stealth Ball":
			GlobalUnlocks.save_data["stealth_ball_completed"] = true
		if level == "Boss Ball":
			GlobalUnlocks.save_data["boss_ball_completed"] = true
		if level == "Survival Mode":
			GlobalUnlocks.save_data["survival_highscore"] = ScoreBus.get_player_score()
	elif winner == "AI":
		defeated_menu.visible = true
	
	get_tree().paused = true
		
		
			
			
		
