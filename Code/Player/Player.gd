extends Node3D
class_name Player

var speed: float = 4.0 # m /s.
var velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	# Player movement.
	velocity = Vector3.ZERO
	
	if Input.is_action_pressed("move_left"):
		velocity += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		velocity += Vector3.RIGHT
	if Input.is_action_pressed("move_forward"):
		velocity += Vector3.FORWARD
	if Input.is_action_pressed("move_back"):
		velocity += Vector3.BACK
	
	position += velocity.normalized() * delta * speed
