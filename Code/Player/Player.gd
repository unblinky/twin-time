extends CharacterBody3D

var speed: float = 4.0 # m /s.
var velocity: Vector3 = Vector3.ZERO

@onready var mouse_plane = $MousePlane
@onready var target = $Target
@onready var pivot = $Pivot

func _ready() -> void:
	mouse_plane.input_event.connect(OnHover)

func OnHover(_camera, _event, event_position, _normal, _shape_idx):
	print(event_position)
	target.position = event_position - position

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
	
	# Arm Rotation.
	var angle = atan2(-target.position.x, -target.position.z)
	pivot.rotation.y = angle
