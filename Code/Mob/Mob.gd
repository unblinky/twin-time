extends CharacterBody3D
class_name Mob

@export var player: Player

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity += position.direction_to(player.position) * delta
	move_and_slide()
