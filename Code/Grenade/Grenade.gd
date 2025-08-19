extends RigidBody3D
class_name Grenade

var launch_force = 6.0 # Multiplier?
var countdown_length = 3.0

func _ready() -> void:
	get_tree().create_timer(countdown_length).timeout.connect(OnTimedOut)

func OnTimedOut():
	queue_free()
