extends TextureButton

signal reset_score
signal change_state
signal clear_title

# main root node that has the state_manager script
onready var main = get_parent().get_parent()

onready var box_1 = get_parent().get_parent().get_node("Count_Down_Boxes/Box_1")
onready var box_2 = get_parent().get_parent().get_node("Count_Down_Boxes/Box_2")
onready var box_3 = get_parent().get_parent().get_node("Count_Down_Boxes/Box_3")
onready var box_final = get_parent().get_parent().get_node("Count_Down_Boxes/Box_Final")

export (bool) var skip_cd = true

var countdown = false
var start_time = 0
var elapsed_time = 0

func _ready():
	if(OS.get_name() == "Android" or OS.get_name() == "iOS"):
		skip_cd = true
	# Connecting the signal (from self) to the target with the listener function
	if(connect("change_state", main, "_change_state") != OK):
		print("(SGB): ERROR CONNECTING SIGNAL TO MAIN")
	if(connect("clear_title", get_parent().get_parent().get_node("Title"), "_on_clear") != OK):
		print("(SGB): ERROR CONNECTING SIGNAL TO TITLE")

func _process(_delta):
	if(countdown):
		count_down()


# Once the start button has been pressed this will countdown and display
# a countdown on the screen for the player. Then it spawns the ship and 
# the game begins!
func count_down():
	if(!skip_cd):
		elapsed_time = OS.get_unix_time() - start_time
		
		if(elapsed_time > 0):
			box_3.visible = true
		if(elapsed_time > 1):
			box_2.visible = true
		if(elapsed_time > 2):
			box_1.visible = true
		if(elapsed_time > 3):
			box_final.visible = true
			box_3.visible = false
			box_2.visible = false
			box_1.visible = false
			
		if(elapsed_time > 4):
			print("\n\n\n----- THE GAME BEGINS -----\n")
			
			emit_signal("change_state", main.gs.PLAYING)
			emit_signal("reset_score")
			emit_signal("clear_title")
			
			box_3.queue_free()
			box_2.queue_free()
			box_1.queue_free()
			box_final.queue_free()
			queue_free()
			
	else:
		print("\n\n\n----- THE GAME BEGINS -----\n")
			
		emit_signal("change_state", main.gs.PLAYING)
		emit_signal("reset_score")
		emit_signal("clear_title")
			
		box_3.queue_free()
		box_2.queue_free()
		box_1.queue_free()
		box_final.queue_free()
		queue_free()

# Currently don't have a use for this function, probably use it for changing
# texture of button when it's pressed down eventually
func _on_button_down():
	$Click.playing = true


func _on_button_up():
	# this makes sure that you are still hovering over the button on release
	var m_pos = get_local_mouse_position()
	if(m_pos[0] >= 0 and m_pos[0] <= get_rect().size.x):
		if(m_pos[1] >= 0 and m_pos[1] <= get_rect().size.y):
			print("(SGB): Starting Game Count Down")
			get_parent().get_node("Quit_Button").queue_free()
			get_parent().get_node("Credits_Button").queue_free()
			get_parent().get_node("Difficulty").queue_free()
			get_parent().get_node("HTP_Button").queue_free()
			get_parent().get_node("Settings_Panel").queue_free()
			get_parent().get_node("Credits_Panel").queue_free()
			get_parent().get_node("HTP_Panel").queue_free()
			start_countdown()


func start_countdown():
	visible = false
	countdown = true
	start_time = OS.get_unix_time()
