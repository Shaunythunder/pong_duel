extends ColorRect

@onready var ai_ball_paddle = get_node("../../../Paddles/AI Paddle (Right)")

var default_color: Color = color
var color_tween: Tween

func _ready():
	ai_ball_paddle.special_attack_status.connect(_on_special_attack_status)
	ai_ball_paddle.attack_ended.connect(_on_attack_ended)
	
func _on_attack_ended() -> void:
	color = default_color
	
func _on_special_attack_status(special_attack_charge) -> void:
	var color_target = Color.WHITE.lerp(Color.BLUE, special_attack_charge)
	
	color_tween = create_tween()
	color_tween.tween_property(self, "modulate", color_target, 0.2)
