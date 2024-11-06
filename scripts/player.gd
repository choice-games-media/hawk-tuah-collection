extends CharacterBody2D

const START_POS: Vector2 = Vector2(128, 128)
const GRAVITY: int = 1000
const MAX_VELOCITY: int = 600
const FLAP_SPEED = -300
var flying: bool = false
var falling: bool = false
var hawk: bool = true
@onready var hawk_audio: AudioStreamPlayer2D = $Hawk
@onready var tuah_audio: AudioStreamPlayer2D = $Tuah


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
		hawk_audio.play()
		hawk = false
	else:
		tuah_audio.play()
		hawk = true
	velocity.y = FLAP_SPEED
