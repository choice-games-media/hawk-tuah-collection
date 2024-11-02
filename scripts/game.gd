extends Node2D

const SCROLL_SPEED = 2
const PIPE_DELAY = 100
const PIPE_RANGE = 200
var game_running = false
var game_over = false
var scroll
var score
var screen_size
var ground_height
var pipes
@onready var player = $Player
@onready var ground = $Ground


func _ready() -> void:
	screen_size = get_window().size
	_new_game()


func _input(_event):
	if not game_over:
		if Input.is_action_just_pressed("flap"):
			if not game_running:
				_start_game()
			else:
				if player.flying:
					player.flap()


func _process(_delta: float) -> void:
	if game_running:
		scroll += SCROLL_SPEED

		if scroll >= screen_size.x:
			scroll = 0

		ground.position.x = -scroll


func _new_game():
	game_running = false
	game_over = false
	scroll = 0
	score = 0
	player.reset()


func _start_game():
	game_running = true
	player.flying = true
	player.flap()
