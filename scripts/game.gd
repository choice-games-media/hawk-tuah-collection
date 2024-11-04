extends Node2D

const SCROLL_SPEED = 2
const PIPE_DELAY = 100
const PIPE_RANGE = 50
var game_running = false
var game_over = false
var scroll
var score
var screen_size
var ground_height
var pipes = []
@onready var player = $Player
@onready var ground = $Ground
@onready var pipe_timer = $PipeTimer
@export var pipe_scene: PackedScene


func _ready() -> void:
	screen_size = get_window().size
	ground_height = (
		ground.get_node("TileMapLayer").get_used_rect().size.y
		* ground.get_node("TileMapLayer").tile_set.tile_size.y
	)
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

		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED


func _new_game():
	game_running = false
	game_over = false
	scroll = 0
	score = 0
	pipes.clear()
	generate_pipes()
	player.reset()


func _start_game():
	game_running = true
	player.flying = true
	player.flap()
	pipe_timer.start()


func _on_pipe_timer_timeout() -> void:
	generate_pipes()


func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY  # Puts the pipe off screen, so it slides in from the right later on
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)  # Available vertical space after the ground + a random value
	pipe.hit.connect(bird_hit)
	add_child(pipe)
	pipes.append(pipe)


func bird_hit():
	pass
