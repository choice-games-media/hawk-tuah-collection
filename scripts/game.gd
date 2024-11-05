extends Node2D

const SCROLL_SPEED: int = 2
const PIPE_DELAY: int = 100
const PIPE_RANGE: int = 50
var game_running: bool = false
var game_over: bool = false
var scroll: int
var score: int
var screen_size: Vector2i
var ground_height: int
var pipes: Array
@onready var player: CharacterBody2D = $Player
@onready var ground: TileMapLayer = $Ground
@onready var pipe_timer: Timer = $PipeTimer
@export var pipe_scene: PackedScene


func _ready() -> void:
	screen_size = get_window().size
	ground_height = (
		ground.get_node("TileMapLayer").get_used_rect().size.y
		* ground.get_node("TileMapLayer").tile_set.tile_size.y
	)
	_new_game()


func _input(_event: InputEvent) -> void:  # There's probably a more efficient way of doing this
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


func _on_pipe_timer_timeout() -> void:
	_generate_pipes()


func _new_game() -> void:
	game_running = false
	game_over = false
	scroll = 0
	score = 0
	pipes.clear()
	_generate_pipes()
	player.reset()


func _start_game() -> void:
	game_running = true
	player.flying = true
	player.flap()
	pipe_timer.start()


func _stop_game() -> void:
	pass


func _generate_pipes() -> void:
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY  # Puts the pipe off screen, so it slides in from the right later on
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)  # Available vertical space after the ground + a random value
	pipe.hit.connect(_bird_hit)
	add_child(pipe)
	pipes.append(pipe)


func _bird_hit() -> void:
	pass
