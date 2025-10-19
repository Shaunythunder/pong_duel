extends ColorRect

@onready var ai_bullet_ball_paddle = get_node("../..Paddles/AI Paddle (Right)")

var default_color: Color = color

func _on_ready():
	ai_bullet_ball_paddle.stealth_ball_attack_incoming.connect(_on_bullet_ball_attack_incoming)
	BulletPatterns.attack_ended.connect(_on_attack_ended)
	
func _on_attack_ended() -> void:
	color = default_color
	
func _on_bullet_ball_attack_incoming() -> void:
	color = Color.RED
	
