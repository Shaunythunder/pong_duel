extends AudioStreamPlayer

const BULLET_ATTACK_SOUND: AudioStream = preload("res://Resources/sound effect/Bullet Attack.mp3")
const FAKE_ATTACK_SOUND: AudioStream = preload("res://Resources/sound effect/fake ball attack.mp3")
const STEALTH_ATTACK_SOUND:AudioStream = preload("res://Resources/sound effect/Stealth Attack.mp3")
const PONG_BALL_BOUNCE_SOUND: AudioStream = preload("res://Resources/sound effect/Pong Ball Bounce.mp3")
const GOAL_SOUND: AudioStream = preload("res://Resources/sound effect/Goal.mp3")
const GAME_OVER: AudioStream = preload("res://Resources/sound effect/Game Over.mp3")
const VICTORY: AudioStream = preload("res://Resources/sound effect/Victory.mp3")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func play_fake_attack_sound():
	stream = FAKE_ATTACK_SOUND
	play()
	
func play_stealth_attack_sound():
	stream = STEALTH_ATTACK_SOUND
	play()

func play_bullet_attack_sound():
	stream = BULLET_ATTACK_SOUND
	play()

func play_game_over_sound():
	stream = GAME_OVER
	play()
	
func play_victory_sound():
	stream = VICTORY
	play()
	
func play_pong_ball_bounce_sound():
	stream = PONG_BALL_BOUNCE_SOUND
	play()
	
func play_goal_sound():
	stream = GOAL_SOUND
	play()
