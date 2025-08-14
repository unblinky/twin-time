extends Area3D
class_name Mob

@export var player: Player

func _process(delta: float) -> void:
	position = position.move_toward(player.position, delta)
