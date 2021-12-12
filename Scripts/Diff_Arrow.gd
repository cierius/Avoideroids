extends TextureButton

signal diff

# Called when the node enters the scene tree for the first time.
func _ready():
	if(connect("diff", get_parent().get_parent().get_parent(), "_on_diff") != OK):
		print("(DIFF_ARROW): COULD NOT CONNECT TO SGB")

func _on_button_down():
	emit_signal("diff", self.name)
	$Click.playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
