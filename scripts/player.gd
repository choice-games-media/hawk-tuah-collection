extends CharacterBody2D

const START_POS = Vector2(128, 128)
const GRAVITY = 1000
const MAX_VELOCITY = 600
const FLAP_SPEED = -500
var flying = false
var falling = false


func _ready() -> void:
	reset()


func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta

		if velocity.y > MAX_VELOCITY:
			velocity.y = MAX_VELOCITY

		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
		elif falling:
			set_rotation(PI / 2)

		move_and_collide(velocity * delta)


func reset():
	flying = false
	falling = false
	position = START_POS
	set_rotation(0)


func flap():
	velocity.y = FLAP_SPEED
