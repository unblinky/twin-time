extends Node3D
class_name Level

const PLAYER = preload("res://Player/Player.tscn")

@onready var spawn_point = $SpawnPoint
@onready var exit = $Exit

var main: Main

func _ready() -> void:
	exit.body_entered.connect(OnExit)
	
	var player: Player
	player = PLAYER.instantiate()
	player.position = spawn_point.position
	add_child(player)

func OnExit(body):
	print("Exiting")
	if body is Player:
		main.NextLevel()
