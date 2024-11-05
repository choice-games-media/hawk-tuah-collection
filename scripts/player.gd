extends CharacterBody2D

const START_POS: Vector2 = Vector2(128, 128)
const GRAVITY: int = 1000
const MAX_VELOCITY: int = 600
const FLAP_SPEED = -300
var flying: bool = false
var falling: bool = false
var hawk: bool = true
var hawk_audio: AudioStream = preload("res://assets/sfx/hawk.ogg")
var tuah_audio: AudioStream = preload("res://assets/sfx/tuah.ogg")
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer


func _ready() -> void:
	reset()


func _physics_process(delta) -> void:
	if flying or falling:
		velocity.y += GRAVITY * delta

		if velocity.y > MAX_VELOCITY:
			velocity.y = MAX_VELOCITY

		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
		elif falling:
			set_rotation(PI / 2)

		move_and_collide(velocity * delta)


func reset() -> void:
	flying = false
	falling = false
	position = START_POS
	set_rotation(0)


func flap() -> void:
	if hawk:
		audio_player.stream = hawk_audio
		hawk = false
	else:
		audio_player.stream = tuah_audio
		hawk = true
	audio_player.play()
	velocity.y = FLAP_SPEED
