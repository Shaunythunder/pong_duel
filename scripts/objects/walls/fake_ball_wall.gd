extends ColorRect

@onready var ai_bullet_ball_paddle = get_node("../../../Paddles/AI Paddle (Right)")

var default_color: Color = color

func _ready():
	ai_bullet_ball_paddle.special_attack_status.connect(_on_special_attack_status)
	BulletPatterns.attack_ended.connect(_on_attack_ended)
	
func _on_attack_ended() -> void:
	color = default_color
	
func _on_special_attack_status(special_attack_charge) -> void:
	print(special_attack_charge)
	color = Color.WHITE.lerp(Color.GREEN, special_attack_charge)
