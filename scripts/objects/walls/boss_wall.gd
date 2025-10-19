extends ColorRect

@onready var ai_bullet_ball_paddle = get_node("../../../Paddles/AI Paddle (Right)")

var default_color: Color = color

func _ready():
	ai_bullet_ball_paddle.boss_attack_status.connect(_on_special_attack_status)
	BulletPatterns.attack_ended.connect(_on_attack_ended)
	ai_bullet_ball_paddle.stealth_attack_ended.connect(_on_attack_ended)
	
func _on_attack_ended() -> void:
	color = default_color
	
func _on_special_attack_status(special_attack_charge: float, attack_style_color: Color) -> void:
	color = Color.WHITE.lerp(attack_style_color, special_attack_charge)
