extends Node

const PLAYER_LIVES: int = 5
const AI_LIVES: int = 5

const FAKE_LIVES: int = 3
const BULLET_LIVES: int = 3
const STEALTH_LIVES: int = 3

const BALL_DANGEROUS_THROTTLE: float = 0.95
const BOSS_BALL_DANGEROUS_THROTTLE: float = 0.95
const BALL_BOUNCE_SPEED_MULITPLIER: = 1.04

const SHOT_CLEARANCE: int = 15
const DUEL_SCENE_PATH: String = "res://scenes/Game Scenes/RealBallDuel.tscn"
const HOW_TO_PLAY_SCENE_PATH: String = "res://scenes/Game Scenes/HowToPlay.tscn"
const MAIN_MENU_PATH: String = "res://scenes/Game Scenes/MainMenu.tscn"
const BULLET_TYPES_PATH: String = "res://scenes/Game Scenes/HowToPlayBulletTypes.tscn"

const RAPID_FIRE_AMOUNT: int = 35
const RAPID_FIRE_RATE: int = 150
const RAPID_FIRE_SPEED: int = 1000

const STEALTH_BALL_SPEED: int = 800

const BOSS_FAKE_BALL_AMOUNT: int = 10

const BOSS_RAPID_FIRE_AMOUNT: int = 35
const BOSS_RAPID_FIRE_RATE: int = 150
const BOSS_RAPID_FIRE_SPEED: int = 1000

const BOSS_STEALTH_BALL_SPEED: int = 800
