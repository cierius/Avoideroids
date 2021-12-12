extends TextureButton

# Button used to pop-out the sounds options on mobile

func _on_button_up():
	if(get_parent().get_node("Settings_Panel").visible == true):
		get_parent().get_node("Settings_Panel").visible = false
	else:
		get_parent().get_node("Settings_Panel").visible = true
