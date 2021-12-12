extends AnimationPlayer

var transition = false
var delete = false

onready var letter_a = get_node("Letter_A")
onready var letter_v = get_node("Letter_V")
onready var letter_o = get_node("Letter_O")
onready var letter_i = get_node("Letter_I")
onready var letter_d = get_node("Letter_D")
onready var letter_e = get_node("Letter_E")
onready var letter_r = get_node("Letter_R")
onready var letter_o2 = get_node("Letter_O2")
onready var letter_i2 = get_node("Letter_I2")
onready var letter_d2 = get_node("Letter_D2")
onready var letter_s = get_node("Letter_S")

func _on_clear():
	transition = true
	#stop()
	


func modu():
	letter_a.modulate.a = lerp(letter_a.modulate.a, 0, .1)
	letter_v.modulate.a = lerp(letter_v.modulate.a, 0, .1)
	letter_o.modulate.a = lerp(letter_o.modulate.a, 0, .1)
	letter_i.modulate.a = lerp(letter_i.modulate.a, 0, .1)
	letter_d.modulate.a = lerp(letter_d.modulate.a, 0, .1)
	letter_e.modulate.a = lerp(letter_e.modulate.a, 0, .1)
	letter_r.modulate.a = lerp(letter_r.modulate.a, 0, .1)
	letter_o2.modulate.a = lerp(letter_o2.modulate.a, 0, .1)
	letter_i2.modulate.a = lerp(letter_i2.modulate.a, 0, .1)
	letter_d2.modulate.a = lerp(letter_d2.modulate.a, 0, .1)
	letter_s.modulate.a = lerp(letter_s.modulate.a, 0, .1)
	
	if(letter_s.modulate.a <= 0.01):
		delete = true

func _process(_delta):
		if(transition == true):
			modu()
			if(delete):
				queue_free()
		
		
		
	
