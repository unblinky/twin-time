extends Area3D
class_name Bullet

@onready var timer: Timer = $Timer
var impulse_power: float = 10

func _ready() -> void:
	timer.timeout.connect(OnTimedOut)
	area_entered.connect(OnAreaEntered)

func _process(delta: float) -> void:
	var direction: Vector2 = Vector2(-sin(rotation.y), -cos(rotation.y))
	position.x += direction.x * impulse_power * delta
	position.z += direction.y * impulse_power * delta

	#var direction = rotation.rotated(Vector3.UP, deg_to_rad(45))
	#apply_impulse(direction * 5)
	#apply_impulse(Vector3(direction.x, 10, direction.y))

func OnAreaEntered(other_area):
	if other_area is Mob:
		other_area.queue_free()
		queue_free()

func OnTimedOut():
	queue_free()
