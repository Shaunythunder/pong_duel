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
var boss_lives_ui_path: String = "res://scenes/Functional/Boss Lives Overlay.tscn"
var pause_menu_path: String = "res://scenes/Functional/PauseMenu.tscn"
var victory_menu_path: String = "res://scenes/Functional/VictoryMenu.tscn"
var defeated_menu_path: String = "res://scenes/Functional/DefeatedMenu.tscn"
var count_down_path: String = "res://scenes/Functional/CountDown.tscn"

var victory_menu
var defeated_menu
var boss_paddle
var count_down
var difficulty: String
var player_lives: int
var ai_lives: int
var boss_lives: int
var game_started: bool = false

func set_difficulty_weights():
	if difficulty == GlobalConstants.EASY:
		player_lives = GlobalConstants.PLAYER_LIVES_EASY
		ai_lives = GlobalConstants.AI_LIVES_EASY
		boss_lives = GlobalConstants.BOSS_LIVES_EASY
	elif difficulty == GlobalConstants.MEDIUM:
		player_lives = GlobalConstants.PLAYER_LIVES_MEDIUM
		ai_lives = GlobalConstants.AI_LIVES_MEDIUM
		boss_lives = GlobalConstants.BOSS_LIVES_MEDIUM
	elif difficulty == GlobalConstants.HARD:
		player_lives = GlobalConstants.PLAYER_LIVES_HARD
		ai_lives = GlobalConstants.AI_LIVES_HARD
		boss_lives = GlobalConstants.BOSS_LIVES_HARD
	elif difficulty == GlobalConstants.INSANE:
		player_lives = GlobalConstants.PLAYER_LIVES_INSANE
		ai_lives = GlobalConstants.AI_LIVES_INSANE
		boss_lives = GlobalConstants.BOSS_LIVES_INSANE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	difficulty = GlobalFlagManager.difficulty
	set_difficulty_weights()
	BallManager.clear_pools()
	BallManager.initialize_ball_pool()
	if BallManager.available_balls.size() > 0:
		for pool_ball in BallManager.available_balls:
			var ball_node = pool_ball["node"]
			ball_node.goal_scored.connect(_on_goal_scored)
	if not level == "Boss Ball":
		var lives_ui_scene: PackedScene = load(lives_ui_path)
		if lives_ui_scene:
			var lives_ui: Node = lives_ui_scene.instantiate()
			add_child(lives_ui)
	else:
		var boss_lives_ui_scene: PackedScene = load(boss_lives_ui_path)
		if boss_lives_ui_scene:
			var boss_lives_ui: Node = boss_lives_ui_scene.instantiate()
			add_child(boss_lives_ui)
		
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
	
	if level == "Boss Ball":
		boss_paddle = $"Paddles/AI Paddle (Right)"
		boss_paddle.boss_hit.connect(_on_boss_hit)
		ScoreBus.initialize_boss_lives(
			player_lives, 
			boss_lives,
			boss_lives,
			boss_lives,
			)
	elif level == "Survival Mode":
		ScoreBus.initialize_lives(player_lives, 0)
	else:
		ScoreBus.initialize_lives(player_lives, ai_lives)
	ball.goal_scored.connect(_on_goal_scored)
	ScoreBus.game_over.connect(_on_game_over)
	_start_game_pause()
	
func _start_game_pause():
	var count_down_scene: PackedScene = load(count_down_path)
	if count_down_scene:
		count_down = count_down_scene.instantiate()
		add_child(count_down)
		count_down.set_text("Game Start")
		get_tree().paused = true
	
func _on_goal_scored(side: String):
	var timer_text: String
	if side == "Left":
		ScoreBus.ai_scored()
		timer_text = "AI Scored"
	elif side == "Right":
		if level == "Survival Mode":
			ScoreBus.player_scored_survival()
		else:
			ScoreBus.player_scored()
		timer_text = "Player Scored"
	var count_down_scene: PackedScene = load(count_down_path)
	if not ScoreBus.game_has_ended:
		if count_down_scene:
			count_down = count_down_scene.instantiate()
			add_child(count_down)
			count_down.set_text(timer_text)
			get_tree().paused = true


func _on_boss_hit(mode: String):
	ScoreBus.boss_hit(mode)
		
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
	
func _process(_delta: float) -> void:
	if not game_started:
		_start_game_pause()
		game_started = true
		
			
			
		
