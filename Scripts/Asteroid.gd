extends KinematicBody2D

# Script for asteroid AI, basically it just moves in a randomly chosen direction
# and when it gets hit it tries to keep moving that direction.

signal hit

var alive = true

var speed = rand_range(50, 350)
var rot_speed = rand_range(-5, 5)
var velocity = Vector2()
var rot = Vector2()
var aim_var = Vector2(rand_range(-50, 50), rand_range(-50, 50))

var rand_scale = rand_range(0.75, 2.0)

var life_time = 15 # They last 15 seconds and then they are destoyed
var elapsed_time = 0
var start_time = 0

onready var top = Vector2(rand_range(-500,get_viewport_rect().size.x+500),
		rand_range(-50, -500))
onready var bottom = Vector2(rand_range(-500, get_viewport_rect().size.x+500),
		rand_range(get_viewport_rect().size.y+50, get_viewport_rect().size.y+500))
onready var left = Vector2(rand_range(-500, -50),
		rand_range(-500, get_viewport_rect().size.y+500))
onready var right = Vector2(rand_range(get_viewport_rect().size.x+50, get_viewport_rect().size.y+500),
		rand_range(-500, get_viewport_rect().size.y+500))


func _ready():
	if(connect("hit", get_parent().get_node("Player"), "_asteroid_coll") != OK):
		print("(Asteroid): ERROR CONNECTING SIGNAL TO PLAYER")
	var spawn_pos = round(rand_range(0, 3))
	if(spawn_pos == 0):
		position = top
	elif(spawn_pos == 1):
		position = bottom
	elif(spawn_pos == 2):
		position = left
	elif(spawn_pos == 3):
		position = right
	
	scale = Vector2(rand_scale, rand_scale)
	
	var p = get_parent().get_node("Player").position
	p = p + aim_var
		
	look_at(p)
	rot = rotation
	velocity = Vector2(speed, 0).rotated(rot)
	
	start_time = OS.get_unix_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = move_and_slide(velocity)
	velocity += Vector2(speed, 0).rotated(rot) * delta
	velocity = Vector2(clamp(velocity.x, -speed, speed), clamp(velocity.y, -speed, speed))
	
	rotation += rot_speed * delta
	
	elapsed_time = OS.get_unix_time() - start_time
	if(elapsed_time > life_time):
		death()
		

# When the asteroid times out it will explode with particles if it is in the 
# viewport and then it will be deleted once it leaves the viewport. Or if it is
# already out of the viewport then it will just be deleted.
func death():
	if(position.x > 0 and position.x < get_viewport_rect().size.x
			and position.y > 0 and position.y < get_viewport_rect().size.y):
		if(alive):
			$CollisionPolygon2D.queue_free()
			$Area2D.queue_free()
			$Sprite.queue_free()
			$Dark_Gray_Particles.emitting = true
			$Explosion.playing = true
			alive = false
	else:
		queue_free()


func _on_body_entered(body):
	if(body.name == "Player"):
		emit_signal("hit")
		death()
