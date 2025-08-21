extends Node
class_name Main

@onready var recap_ui = $RecapUI
@onready var next_button = $RecapUI/VBox/NextButton

var levels: Array[PackedScene] = [preload("res://Levels/Level_01.tscn"), preload("res://Levels/Level_02.tscn")]
var level_index: int = -1
var current_level: Level

func _ready() -> void:
	next_button.pressed.connect(OnRadicalClick)
	recap_ui.hide()
	NextLevel()

func OnRadicalClick():
	recap_ui.hide()
	NextLevel()

func EndLevel():
	recap_ui.show()

func NextLevel():
	# Increment level index, or wrap to first level.
	if level_index < levels.size() - 1:
		level_index += 1
	else:
		level_index = 0
	
	if current_level != null:
		current_level.queue_free()
	current_level = levels[level_index].instantiate()
	current_level.main = self
	add_child(current_level)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
