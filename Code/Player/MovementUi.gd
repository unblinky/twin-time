extends Control
class_name MovementUI

@onready var w = $W
@onready var s = $S
@onready var a = $A
@onready var d = $D
@onready var alt_mode = $AltMode
@onready var time_ui = $TimeUI

func _ready() -> void:
	w.hide()
	s.hide()
	a.hide()
	d.hide()
	alt_mode.hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_forward"):
		w.visible = true
	if Input.is_action_just_released("move_forward"):
		w.visible = false
	if Input.is_action_just_pressed("move_back"):
		s.visible = true
	if Input.is_action_just_released("move_back"):
		s.visible = false
	if Input.is_action_just_pressed("move_left"):
		a.visible = true
	if Input.is_action_just_released("move_left"):
		a.visible = false
	if Input.is_action_just_pressed("move_right"):
		d.visible = true
	if Input.is_action_just_released("move_right"):
		d.visible = false

func ToggleMode():
	alt_mode.visible = !alt_mode.visible

func UpdateTime(time: float):
	time_ui.text = str(time)
	
