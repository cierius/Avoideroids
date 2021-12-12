extends TextureButton


func _on_button_down():
	$Click.playing = true


func _on_button_up():
	get_parent().visible = false
