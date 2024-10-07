extends Node2D

var PAUSE : String = "ui_cancel"
@onready var label1 = $Label
@onready var label2 = $Label2
@export var end = false
var can_press_time = 0
var can_press_max_time = 2

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	can_press_time += delta
	if Input.is_action_just_pressed(PAUSE):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if can_press_time >= can_press_max_time:
		if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
			if label1.visible:
				label1.visible = false
				label2.visible = true
			else:
				if !end:
					get_tree().change_scene_to_file("res://scenes/road_trip.tscn")
