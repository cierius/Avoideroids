extends Sprite

# This script manages when the volume sliders change. It changes the values of the 
# text for the percentages. Also, changes the actual volume of the AudioBuses.

var tick_amount
var min_vol = -36

var start_up

onready var m_text = get_node("Music_Percent")
onready var sfx_text = get_node("SFX_Percent")

func _ready():
	start_up = true
	tick_amount = abs(min_vol/10)
	
	var m_val = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	print(m_val)
	var sfx_val = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	print("m_val: ", 10 + (m_val/tick_amount), " | sfx_val: ", 10 + (sfx_val/tick_amount))
	
	if(m_val != 0):
		get_node("Music_Vol_Slider").value = 10 + (m_val/tick_amount)
		#_on_Music_Vol_value_changed(10 + (m_val/tick_amount), true)
	else:
		get_node("Music_Vol_Slider").value = 10
		#_on_Music_Vol_value_changed(10, true)
	
	if(sfx_val != 0):
		get_node("SFX_Vol_Slider").value = 10 + (m_val/tick_amount)
	#	_on_SFX_Vol_value_changed(10 + (sfx_val/tick_amount), true)
	else:
		get_node("SFX_Vol_Slider").value = 10
	#	_on_SFX_Vol_value_changed(10, true)

	m_text.text = str(get_node("Music_Vol_Slider").value * 10) + "%"
	sfx_text.text = str(get_node("SFX_Vol_Slider").value * 10) + "%"
	
	start_up = false

func _on_Music_Vol_value_changed(value):
	if(!start_up):
		get_node("Click").play()
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), min_vol+(value*tick_amount))
	
	if(value == 0): # Sets the audio to mute if the slider is at 0
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	elif(AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
	
	get_node("Music_Vol_Slider").value = value
	m_text.text = str(value*10) + "%"
	print("Music Volume: ", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")), "db")


func _on_SFX_Vol_value_changed(value):
	if(!start_up):
		get_node("Click").play()
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), min_vol+(value*tick_amount))
	
	if(value == 0): # Sets the audio to mute if the slider is at 0
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
	elif(AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX"))):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
	
	get_node("SFX_Vol_Slider").value = value
	sfx_text.text = str(value*10) + "%"
	print("SFX Volume: ", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")), "db")
