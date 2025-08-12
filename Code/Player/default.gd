extends CharacterBody3D
class_name Player

@onready var mouse_plane = $MousePlane
@onready var target = $Target
@onready var pivot = $Pivot

var speed: float = 4.0 # m /s.
var jump_velocity: float = 6.5
var kill_floor: float = -10.0
var spawn_point: Vector3

func _ready() -> void:
	# Signal hooks.
	mouse_plane.input_event.connect(OnHover)
	
	# Initalize.
	spawn_point = position

func OnHover(_camera, _event, event_position, _normal, _shape_idx):
	print(event_position)
	target.position = event_position - position

func _physics_process(delta: float) -> void:
	# Update arm.
	pivot.rotation.y = atan2(-target.position.x, -target.position.z)
	if position.y < kill_floor:
		position = spawn_point
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
