extends TextureButton


func _on_button_up():
	var m_pos = get_local_mouse_position()
	if(m_pos[0] >= 0 and m_pos[0] <= get_rect().size.x):
		if(m_pos[1] >= 0 and m_pos[1] <= get_rect().size.y):
			print("QUITTING GAME")
			get_tree().quit()


func _on_button_down():
	$Click.playing = true
