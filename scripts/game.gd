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
var score_up_audio: AudioStream = preload("res://assets/sfx/spit_on_that_thang.mp3")
var hawk_tuah_audio: AudioStream = preload("res://assets/sfx/angry_hawk_tuah.mp3")
@onready var player: CharacterBody2D = $Player
@onready var ground: Area2D = $Ground
@onready var pipe_timer: Timer = $PipeTimer
@onready var score_label: Label = $Background/ScoreLabel
@onready var restart_button: CanvasLayer = $RestartButton
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer
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
					if player.position.y < 0:  # Player is off the screen
						_stop_game()


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
	pipes.clear()
	get_tree().call_group("pipes", "queue_free")
	scroll = 0
	score = 0
	score_label.text = "SCORE: " + str(score)
	player.reset()
	player.hawk = true
	restart_button.hide()
	_generate_pipes()


func _start_game() -> void:
	game_running = true
	player.flying = true
	player.flap()
	pipe_timer.start()


func _stop_game() -> void:
	if not game_over:
		audio_player.stream = hawk_tuah_audio
		audio_player.play()

	player.flying = false
	player.falling = true
	game_running = false
	game_over = true
	pipe_timer.stop()
	restart_button.show()


func _generate_pipes() -> void:
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY  # Puts the pipe off screen, so it slides in from the right later on
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)  # Available vertical space after the ground + a random value
	pipe.hit.connect(_on_pipe_hit)
	pipe.scored.connect(_update_score)
	add_child(pipe)
	pipes.append(pipe)


func _on_pipe_hit() -> void:
	_stop_game()


func _on_ground_hit() -> void:
	_stop_game()


func _update_score() -> void:
	score += 1
	if score % 5 == 0:
		audio_player.stream = score_up_audio
		audio_player.play()
	score_label.text = "SCORE: " + str(score)


func _on_restart_button() -> void:
	_new_game()
