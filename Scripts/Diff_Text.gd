extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	var n = get_parent().get_parent().get_parent().curr_diff
	if(n == .75):
		text = "Hard"
	elif(n == 1):
		text = "Medium"
	else:
		text = "Easy"

