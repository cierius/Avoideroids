extends TextureButton

signal change_state

var main

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent().get_parent()
	if(connect("change_state", main, "_change_state") != OK):
		print("(SGB): ERROR CONNECTING SIGNAL TO MAIN")

func _on_button_up():
	print("BACK-TO-MENU")
	emit_signal("change_state", main.gs.DEATH_MENU)
	
func _on_button_down():
	pass
