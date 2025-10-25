extends ColorRect

@onready var ai_bullet_ball_paddle = get_parent()

func _on_ready():
	ai_bullet_ball_paddle.change_color(_on_change_color)
	
func _on_change_color(new_color: Color) -> void:
	color = new_color


func _on_ai_paddle_right_change_color(attack_style_color: Color) -> void:
	color = attack_style_color
