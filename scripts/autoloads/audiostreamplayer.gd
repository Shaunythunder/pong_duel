extends AudioStreamPlayer

const MAIN_MENU_SONG: AudioStream = preload("res://Resources/music/Bullet Pong Main Menu.mp3")
const GAME_MUSIC_SONG: AudioStream = preload("res://Resources/music/Bullet Pong Game Music.mp3")
const BOSS_MUSIC_SONG:AudioStream = preload("res://Resources/music/Bullet Pong Boss Music.mp3")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.finished.connect(_on_finished)

func play_main_menu():
	stream = MAIN_MENU_SONG
	play()

func play_game_music():
	stream = GAME_MUSIC_SONG
	play()
	
func play_boss_music():
	stream = BOSS_MUSIC_SONG
	play()

func _on_finished():
	play()
