extends CharacterBody3D
class_name Player

const BULLET = preload("res://Bullet/Bullet.tscn")
const GRENADE = preload("res://Grenade/Grenade.tscn")

@onready var mouse_plane = $MousePlane
@onready var target = $Target
@onready var pivot = $Pivot
@onready var arm: MeshInstance3D = $Pivot/Arm
@onready var movement_ui = $MovementUI

var push_force: float = 2.0 # meters / sec.
var speed: float = 4.0 # m /s.
var jump_velocity: float = 6.5
var max_velocity: float = 8.0
var kill_floor: float = -10.0
var spawn_point: Vector3

var toggle_movement_mode: bool = false
var stop_watch: float = 0.0

func _ready() -> void:
	# Signal hooks.
	mouse_plane.input_event.connect(OnHover)
	
	# Initalize.
	spawn_point = position

func _process(delta: float) -> void:
	stop_watch += delta
	movement_ui.UpdateTime(stop_watch)

func SpawnBullet():
	var bullet = BULLET.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = arm.global_position
	bullet.rotation = pivot.rotation

func SpawnGrenade():
	var grenade = GRENADE.instantiate()
	get_parent().add_child(grenade)
	grenade.global_position = arm.global_position
	var direction = Vector2.from_angle(pivot.rotation.y)
	#print(direction)
	grenade.apply_impulse(Vector3(-direction.y, 1, -direction.x) * grenade.countdown_length)

func OnHover(_camera, _event, event_position, _normal, _shape_idx):
	target.position = event_position - position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Update arm.
	pivot.rotation.y = atan2(-target.position.x, -target.position.z)
	if position.y < kill_floor:
		position = spawn_point
	

	##=============
	## Toggle.
	if Input.is_action_just_pressed("toggle_movement"):
		toggle_movement_mode = !toggle_movement_mode
		movement_ui.ToggleMode()
	
	# Fire.
	if Input.is_action_just_pressed("fire"):
		#SpawnBullet()
		SpawnGrenade()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get the player movement input.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	## Toggle the alternate.
	if !toggle_movement_mode:
		##=======================
		## Regular movement area.
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			# Deceleration.
			velocity.x = move_toward(velocity.x, 0, 1.0)
			velocity.z = move_toward(velocity.z, 0, 1.0)
	else:
		##========================
		# Alternate movement area.
		if direction:
			velocity.x += direction.x * speed / 8.0
			velocity.z += direction.z * speed / 8.0
		else:
			# Deceleration.
			velocity.x = move_toward(velocity.x, 0, 0.15 * delta)
			velocity.z = move_toward(velocity.z, 0, 0.15 * delta)
			
		# Clamp to max_velocity.
		velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
		velocity.z = clamp(velocity.z, -max_velocity, max_velocity)
	
	move_and_slide()
	
	# Trying for player interaction with `RigidBody3D`.
	# https://kidscancode.org/godot_recipes/4.x/physics/character_vs_rigid/
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
