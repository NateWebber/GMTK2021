extends MarginContainer

onready var debug_switch = $CheckButton

signal debug_on
signal debug_off

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("debug_on", get_parent(), "set_debug")
	connect("debug_off", get_parent(), "set_debug")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CheckButton_toggled(button_pressed):
	if button_pressed:
		emit_signal("debug_on", true)
	else:
		emit_signal("debug_off", false)
