extends Node

var asteroid_01 = preload("res://Scenes/Asteroid_01.tscn")
var asteroid_02 = preload("res://Scenes/Asteroid_02.tscn")
var asteroid_03 = preload("res://Scenes/Asteroid_03.tscn")
var asteroid_04 = preload("res://Scenes/Asteroid_04.tscn")
var ast_type

export (float) var spawn_freq = 4
var spawn_count = 0

var diff_scaling = 1.00 # 1=normal, .75=hard, .5=impossible

var start_time = 0
var elapsed_time = 0
var game_start = 0
var game_length = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = OS.get_unix_time()
	game_start = OS.get_unix_time()
	spawn(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	spawning_timer()


func spawning_timer():
	elapsed_time = (OS.get_unix_time() - start_time)
	game_length = (OS.get_unix_time() - game_start)
	
	if(elapsed_time >= spawn_freq):
		spawn(ceil(game_length/(6*diff_scaling)) + 4)
		elapsed_time = 0
		start_time = OS.get_unix_time()

func spawn(num):
	spawn_count += 1
	print("(AS): Spawn #: ", spawn_count, ": Spawn amount: ", clamp(num, 0, 20))
	for n in num:
		if(n < 20):
			ast_type = rand_range(0, 1)
			if(ast_type >= .25 and ast_type <= .5):
				get_parent().add_child(asteroid_01.instance())
			elif(ast_type >= .51 and ast_type <= .75):
				get_parent().add_child(asteroid_02.instance())
			elif(ast_type >= .76 and ast_type <= 1):
				get_parent().add_child(asteroid_03.instance())
			else:
				get_parent().add_child(asteroid_04.instance())
		else:
			break
