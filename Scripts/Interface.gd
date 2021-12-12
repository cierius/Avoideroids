extends Node2D

signal a_up

var start_time = 0
var elapsed_time = 0

var score = 0
export (int) var starting_score = 0
export (int) var multiplier = 1
var score_counter = 1
var a_cost = 50 #default 250
var starting_armor = 2

export (float) var m_freq = 7.5 #7.5
var m_time = 0

onready var s = get_node("Score_Text/Score_Number")
onready var m = get_node("Score_Text/Multiplier")
onready var p = get_node("Multiplier_Progress")


# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = OS.get_unix_time()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scoref(delta)
	multiplierf(delta)
	prog_bar()


func scoref(d):
	score += (1 * multiplier) * d 
	elapsed_time = OS.get_unix_time() - start_time
	
	if(score >= a_cost*score_counter):
		emit_signal("a_up")
		print("(Interface): Armor Up Bitches")
		score_counter += 1
	
	s.text = str(round(score))
	

func multiplierf(d):
	m_time += 1 * d
	
	if(m_time >= m_freq && multiplier < 10):
		multiplier += 1
		m.text = str(multiplier) + "x"
		m_time = 0

func prog_bar():
	var e_time = OS.get_unix_time() - start_time
	if(e_time <= m_freq*10):
		p.value = e_time*(100/(m_freq*10))
		
		
# This is the "listener" function
# The signal is defined in the "calling" script
func _on_reset_score():
	print("Interface Reset")
	start_time = OS.get_unix_time()
	score = starting_score
	multiplier = 1
	m_time = 0
	p.value = 0
	get_parent().get_node("Player").armor = starting_armor
	
	

