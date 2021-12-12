extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_button_down():
	$Click.playing = true


func _on_button_up():
	if(get_parent().get_node("HTP_Panel").visible == true):
		get_parent().get_node("HTP_Panel").visible = false
	else:
		get_parent().get_node("HTP_Panel").visible = true
