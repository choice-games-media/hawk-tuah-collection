extends Node2D

const PIPE_DELAY: int = 100
const PIPE_RANGE: int = 150
var game_running: bool = false
var game_over: bool = false
var scroll_speed: float = 2
var scroll: float
var score: int
var screen_size: Vector2i
var ground_height: int
var pipes: Array
var score_up_audio: AudioStream = preload("uid://dpwijtkqu3j8h")
var hawk_tuah_audio: AudioStream = preload("uid://pmfihm3e61fi")
@onready var background: Sprite2D = $Background
@onready var score_label: Label = $Background/MarginContainer/ScoreLabel
@onready var high_score_label: Label = $Background/MarginContainer/HighScoreLabel
@onready var instructions_label: Label = $Background/MarginContainer/InstructionsLabel
@onready var player: CharacterBody2D = $Player
@onready var ground: Area2D = $Ground
@onready var pipe_timer: Timer = $PipeTimer
@onready var restart_button: CanvasLayer = $RestartButton
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer
@export var pipe_scene: PackedScene


func _ready() -> void:
	screen_size = get_window().size
	ground_height = (
		ground.get_node("TileMapLayer").get_used_rect().size.y
		* ground.get_node("TileMapLayer").tile_set.tile_size.y
	)
	if Global.night_mode:
		background.set_texture(load("uid://c862ab86yjh7f"))
		get_window().set_title("Hawky Tuah (Night Mode)")
		pipe_timer.set_wait_time(pipe_timer.get_wait_time() * 1.5)
	else:
		background.set_texture(load("uid://cepyg81km0gpf"))
		get_window().set_title("Hawky Tuah")
	_new_game()


func _input(_event: InputEvent) -> void:  # There's probably a more efficient way of doing this
	if not game_over:
		if Input.is_action_just_pressed("flap"):
			if not game_running:
				_start_game()
			else:
				if player.flying:
					player.flap()

					# Dynamically gets the size of the collision shape
					var player_collision_y: int = (
						player.get_node("CollisionShape2D").get_shape().get_rect().position.y
					)

					# When the ENTIRE collision shape has touched the roof, end the game
					if player.position.y < -(player_collision_y):
						_stop_game()


func _process(_delta: float) -> void:
	if game_running:
		scroll += scroll_speed

		if scroll >= screen_size.x:
			scroll = 0

		ground.position.x = -scroll

		for pipe in pipes:
			pipe.position.x -= scroll_speed


func _physics_process(delta: float) -> void:
	if Global.night_mode:
		scroll_speed += 0.25 * delta


func _on_pipe_timer_timeout() -> void:
	_generate_pipes()


func _new_game() -> void:
	game_running = false
	game_over = false
	pipes.clear()
	get_tree().call_group("pipes", "queue_free")
	scroll_speed = 2
	scroll = 0
	score = 0
	score_label.set_text("SCORE: " + str(score))
	if Global.night_mode:
		high_score_label.set_text("BEST: " + str(Global.get_save("hawky_tuah_night_best")))
	else:
		high_score_label.set_text("BEST: " + str(Global.get_save("hawky_tuah_best")))
	player.reset()
	player.hawk = true
	restart_button.hide()
	_generate_pipes()
	instructions_label.show()


func _start_game() -> void:
	game_running = true
	player.flying = true
	player.flap()
	pipe_timer.start()
	instructions_label.hide()


func _stop_game() -> void:
	if not game_over:
		audio_player.set_stream(hawk_tuah_audio)
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
		audio_player.set_stream(score_up_audio)
		audio_player.play()
	score_label.set_text("SCORE: " + str(score))

	var current_best_score = "night_" if Global.night_mode else ""
	current_best_score = "hawky_tuah_" + current_best_score + "best"

	if score > Global.get_save(current_best_score):
		high_score_label.set_text("NEW BEST: " + str(score))
		Global.set_save(current_best_score, score)

	if Global.night_mode:
		Global.set_save("coins", Global.get_save("coins") + 2)
	else:
		Global.set_save("coins", Global.get_save("coins") + 1)


func _on_restart_button() -> void:
	_new_game()
