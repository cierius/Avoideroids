extends KinematicBody2D

signal change_state
onready var main = get_parent()

export (float) var speed = 10.0
export (float) var max_speed = 250.0
export (int) var armor = 2
#export (int) var armor_cost = 250 # this isn't used in this script.

var invuln = false
var invuln_time = 0
var invuln_dur = 3

var is_alive = true
var death_time = 0
var death_menu_delay = 3

var velocity = Vector2()
var pressed = false

onready var ar = [get_parent().get_node("Interface/Armor"), get_parent().get_node("Interface/Armor2"),
		get_parent().get_node("Interface/Armor3"), get_parent().get_node("Interface/Armor4"),
		get_parent().get_node("Interface/Armor5")]
		

# Called when the node enters the scene tree for the first time.
func _ready():
	if(get_parent().get_node("Interface").connect("a_up", self,"_armor_up") != OK):
		print("(Player): ERROR CONNECTING SIGNAL TO INTERFACE")
	if(connect("change_state", main, "_change_state") != OK):
		print("(Player): ERROR CONNECTING SIGNAL TO MAIN")
	print("(Player): Ship Spawned!")
	
	is_alive = true
	heart_checker(armor)
	
	# Centers the ship when it is spawned into the scene
	position = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)


func heart_checker(num):
	for c in range(len(ar)):
		ar[c].visible = false
		
	for n in range(num):
		ar[n].visible = true

# listener function
func _armor_up():
	if(armor < 5):
		print("(Player): Armor Up")
		armor += 1
		heart_checker(armor)


func armor_down():
	if(armor > 1): # player dies when the last heart container disappears
		armor -= 1
		print("(Player): Armor Down - ", armor)
	else:
		armor -= 1
		print("(Player): Death")
		deathf()
	heart_checker(armor)


func deathf():
	# play exploding particles
	if(is_alive):
		death_time = OS.get_unix_time()
	is_alive = false
	$Sprite.visible = false


func invulnf():
	if(invuln == false):
		print("(Player): Invulnerable")
		invuln_time = OS.get_unix_time()
		invuln = true
		$Force_Field.visible = true
		set_deferred("$Force_Field/StaticBody2D/CollisionShape2D.disabled", false)
		#$Force_Field/StaticBody2D/CollisionShape2D.disabled = false

func get_input():
	look_at(get_global_mouse_position())
	
	if(Input.is_mouse_button_pressed(BUTTON_LEFT)):
		$Sprite/Thruster_Particles.emitting = true
		movement()
		
		if($Rocket_Audio.playing == false):
			$Rocket_Audio.playing = true
		else:
			$Rocket_Audio.stream_paused = false
	else:
		$Sprite/Thruster_Particles.emitting = false
		$Rocket_Audio.stream_paused = true


func movement():
	velocity += Vector2(speed, 0).rotated(rotation)
	velocity = Vector2(clamp(velocity.x, -max_speed, max_speed), clamp(velocity.y, -max_speed, max_speed))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	get_input()
	if(pressed):
		movement()
	velocity = move_and_slide(velocity)
	
	if(invuln):
		var e_time = OS.get_unix_time() - invuln_time
		if(e_time >= invuln_dur):
			print("(Player): Invulnerable Faded")
			invuln = false
			$Force_Field.visible = false
			$Force_Field/StaticBody2D/CollisionShape2D.disabled = true
	
	if(!is_alive):
		var e_time = OS.get_unix_time() - death_time
		if(e_time >= death_menu_delay):
			emit_signal("change_state", main.gs.DEATH_MENU)

# Listener func that is connected to from asteroids in the scene
func _asteroid_coll():
	if(!invuln):
		armor_down()
		if(is_alive):
			invulnf()
