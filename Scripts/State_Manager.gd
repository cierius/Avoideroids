extends Node
# The purpose of the State Manager is to organize the different menus and 
# their scenes by the enum gs. Also, handles instancing of scenes per state.

enum gs {READY_TO_START, PLAYING, DEATH_MENU}
var current_state
export (gs) var start_at_state

var screen_tex = ImageTexture.new()

# Mobile Menus
var m_menu = preload("res://Scenes/M_Menu.tscn")
var m_interface = preload("res://Scenes/M_Interface.tscn")
var m_pause = preload("res://Scenes/M_Pause.tscn")

# RTS Menu
var menu = preload("res://Scenes/Menu.tscn")
var sgb = preload("res://Scenes/Start_Game_Button.tscn")
var cdb = preload("res://Scenes/Count_Down_Boxes.tscn")
var title = preload("res://Scenes/Title.tscn")
var qb = preload("res://Scenes/Quit_Button.tscn")

# PLAYING
var player = preload("res://Scenes/Player.tscn")
var interface = preload("res://Scenes/Interface.tscn")
var pause = preload("res://Scenes/Pause.tscn")
var asteroid_spawner = preload("res://Scenes/Asteroid_Spawner.tscn")
var diff = {EASY=1.25, MEDIUM=1.0, HARD=0.75}
var curr_diff = diff.MEDIUM

# Pause Menu
onready var bg_blur = get_node("BG/Blurry_BG")

# Ads
#var admob = preload("res://Scenes/AdMob.tscn")
#onready var ad = get_node("AdMob")
var ad_freq = 2 # ads will play every 5 deaths
var curr_deaths = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	#if(OS.get_name() == "Android"):
		#var admob_inst = admob.instance()
		#add_child(admob_inst)
		
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)
	_change_state(start_at_state)


func _notification(what):
	# Whenever the X button is pressed or any quit request really (obviously by the name)
	if(what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		if(current_state == gs.PLAYING):
			if(get_tree().paused == false):
				pause()
			else:
				call_deferred("_change_state", gs.READY_TO_START)
		else:
			get_tree().quit()
	
	# This is what happens when android users press the back button
	if(what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		if(current_state == gs.PLAYING):
			if(get_tree().paused == false):
				pause()
			else:
				call_deferred("_change_state", gs.READY_TO_START)
		else:
			get_tree().quit()


func get_input():
	if(Input.is_action_just_pressed("fullscreen")):
		if(OS.window_fullscreen):
			OS.window_fullscreen = false
		else:
			OS.window_fullscreen = true
			
	if(Input.is_action_just_pressed("pause") and current_state == gs.PLAYING):
		if(get_tree().paused == false):
			pause()
			
		else:
			print("(SM): UNPAUSED")
			unblur()
			
			if(get_node("Pause")):
				get_node("Pause").queue_free()
			get_tree().paused = false

# Creates the blur for the pause screen
func pause():
	print("(SM): PAUSED")
	# Captures a screenshot of what the game looks like, used to
	# create a blurry background via shader
	var screen_cap = get_viewport().get_texture().get_data()
	screen_cap.flip_y()
	screen_tex.create_from_image(screen_cap)
	$BG/Blurry_BG.texture = screen_tex
	$BG/Blurry_BG.visible = true
	
	if(OS.get_name() == "Android" or OS.get_name() == "iOS"):
		var m_pause_inst = m_pause.instance()
		call_deferred("add_child", m_pause_inst)
	else:
		var pause_inst = pause.instance()
		call_deferred("add_child", pause_inst)
		
	get_tree().paused = true

# Unblurs the pause screen
func unblur():
	$BG/Blurry_BG.texture = null
	$BG/Blurry_BG.visible = false

# Listener function
func _change_state(state):
	clear_scene()
	current_state = state
	
	if(current_state == gs.READY_TO_START):
		print("(SM): ---> READY_TO_START")
		
		if(OS.get_name() != "Android" and OS.get_name() != "iOS"):
			var cdb_inst = cdb.instance()
			var title_inst = title.instance()
			var menu_inst = menu.instance()
			
			add_child(cdb_inst)
			add_child(title_inst)
			add_child(menu_inst)
		else:
			# Mobile instances
			var cdb_inst = cdb.instance()
			var title_inst = title.instance()
			var m_menu_inst = m_menu.instance()
			
			add_child(cdb_inst)
			add_child(title_inst)
			add_child(m_menu_inst)
		
	elif(current_state == gs.PLAYING):
		print("(SM): ---> PLAYING")
		
		if(OS.get_name() != "Android" and OS.get_name() != "iOS"):
			var p_inst = player.instance()
			var as_inst = asteroid_spawner.instance()
			as_inst.diff_scaling = curr_diff
			var i_inst = interface.instance()
			
			add_child(i_inst)
			add_child(p_inst)
			add_child(as_inst)
		else:
			# Mobile Instances
			var p_inst = player.instance()
			var as_inst = asteroid_spawner.instance()
			as_inst.diff_scaling = curr_diff
			var m_i_inst = m_interface.instance()
			
			add_child(m_i_inst)
			add_child(p_inst)
			add_child(as_inst)
		
	elif(current_state == gs.DEATH_MENU):
		print("(SM): ---> DEATH_MENU")
		# This was going to be where the ads would be played but I could not 
		# figure out how to get the ads to work and at this point
		# I don't feel like avoideroids even needs ads simply because
		# there wont be enough players to make anything from them.
		
		#if(OS.get_name() == "Android"):
			#if(curr_deaths < ad_freq):
				#curr_deaths += 1
				#_change_state(gs.READY_TO_START)
			#if(curr_deaths < ad_freq - 1):
				#ad.load_interstitial()
				#_change_state(gs.READY_TO_START)
			#else:
				# Play ad
				#if(ad.is_interstitial_loaded()):
					#ad.show_interstitial()
				#curr_deaths = 0
		#else:
		_change_state(gs.READY_TO_START)

# Clears root hierarchy of everything
func clear_scene():
	print("(SM): CLEANING UP SCENE")
	unblur()
	get_tree().paused = false
	for n in get_child_count():
			if(get_child(n).name != "BG" and 
				get_child(n).name != "Barrier" and
				get_child(n).name != "Title" and
				get_child(n).name != "AdMob"):
				#print(get_child(n).name, " DELETED")
				get_child(n).queue_free()

# Listener function that changes the difficulty located in the menu
func _on_diff(arg):
	if(arg == "Diff_Arrow_Left"):
		if(curr_diff == diff.EASY):
			curr_diff = diff.HARD
		elif(curr_diff == diff.MEDIUM):
			curr_diff = diff.EASY
		else:
			curr_diff = diff.MEDIUM
	else:
		if(curr_diff == diff.EASY):
			curr_diff = diff.MEDIUM
		elif(curr_diff == diff.MEDIUM):
			curr_diff = diff.HARD
		else:
			curr_diff = diff.EASY
			
	if(curr_diff == diff.EASY):
		get_node("Menu/Difficulty/Diff_Text").text = "Easy"
	elif(curr_diff == diff.MEDIUM):
		get_node("Menu/Difficulty/Diff_Text").text = "Medium"
	else:
		get_node("Menu/Difficulty/Diff_Text").text = "Hard"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_input()


func _on_interstitial_closed():
	_change_state(gs.READY_TO_START)
