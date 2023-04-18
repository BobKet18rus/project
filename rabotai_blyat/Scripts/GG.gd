extends CharacterBody2D
class_name Player

@export var speed:float = 1000
@export var friction = 0.2	#Трение
@export var acceleration = 0.2	#Ускорение
@export var gravity = 100
@export var jump_force = 1000
var new_value

#var vel = Vector2.ZERO

var state = "IS_IDLE"
#states: IS_IN_AIR, IS_IDLE, IS_IN_AIR_MOVING, IS_MOVING, IS_ON_RING


var direction_x = 0
var direction_y = 0
var anim = ""
var death_counter:int = 0
var jump_possibility:bool
var wall_jump:bool

#-----------------------------------------------------------------
func get_sprite():
	return $sprite
	
func get_direction(y_or_x):
	if y_or_x == "x":
		return direction_x
	else:
		return direction_y
		
func get_pos():
	return position
func get_ring_area():
	return $ring_area
	
func get_state():
	return state
func set_state(new_state):
	state = new_state
func get_jump_timer():
	return $jump_timer
	
func state_machine():
	if (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and is_on_floor():
		state = "IS_MOVING"
	else:
		if is_on_floor():
			state = "IS_IDLE"
		else:
			if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				state = "IS_IN_AIR_MOVING"
			else:
				state = "IS_IN_AIR"
#------------------------------------------------------------------
		
func is_on_left_wall(only):
	if only == null:
		if is_on_wall() and $right_ray.is_colliding():
			return true
		else:
			return false
	else:
		if is_on_wall() and $right_ray.is_colliding() and not(is_on_floor()):
			return true
		else:
			return false
		
func is_on_right_wall(only):
	if only == null:
		if is_on_wall() and $left_ray.is_colliding():
			return true
		else:
			return false
	else:
		if is_on_wall() and $left_ray.is_colliding() and not(is_on_floor()):
			return true
		else:
			return false
			
func gravitation(grav):
	if state != "IS_ON_RING" and state != "IS_ON_H_ROPE":
		if is_on_floor():
			velocity.y += 1.5*grav
		else:
			velocity.y += grav
	
	return velocity.y
		
func animate(): #animation
	pass
		
func change(value: int, change_value: int):
	new_value = value + change_value
	value = new_value
	
func label(cur_state):
	$state.text = ":-( "+str(cur_state)+","+state
		
func spit_projectile_spawn():
	var spit_projectile = load("res://Scenes/projectiles/Projectile.tscn")
	var bullet = spit_projectile.instantiate()
	get_parent().add_child(bullet)
	
#---------------------------------------------------------------------------------------------------
func _ready():
	pass
	
func _process(_delta):	#графика
	animate()
	label(death_counter)
	
func _physics_process(delta):	#физика
	state_machine()
	if state == "IS_ON_H_ROPE":
		speed = 500
		acceleration = 0.7
		friction = 0.7
	else:
		speed = 1000
		acceleration = 0.2
		friction = 0.2
		
#movement==========================================================================
	direction_x = Input.get_axis("left", "right")
	direction_y = Input.get_axis("jump", "down")
	
	if not(is_on_floor()):
		if direction_x != 0:
			velocity.x = lerp(velocity.x, direction_x * 1.5 * speed, acceleration/5)
		else:
			velocity.x = lerp(velocity.x, 0.0, friction/5)
	else:
		if direction_x != 0:
			velocity.x = lerp(velocity.x, direction_x * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)
				
	if direction_y < 0:
		if jump_possibility == true:
			velocity.y = -jump_force

	if wall_jump == true and Input.is_action_just_pressed("jump"):
		if $right_ray.is_colliding() and not(is_on_floor()):
			velocity = Vector2(lerp(velocity.x, -speed, 0.8), -jump_force*1.6)
		elif $left_ray.is_colliding() and not(is_on_floor()):
			velocity = Vector2(lerp(velocity.x, speed, 0.8), -jump_force*1.6)
#=======================================================================================
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or state == "IS_ON_H_ROPE" or state == "IS_ON_RING"):
		jump_possibility = true
		$jump_timer.start(0.3)
	elif Input.is_action_just_released("jump") or $jump_timer.time_left == 0 or is_on_ceiling():
		jump_possibility = false
	
	if Input.is_action_just_pressed("t1"):
		get_parent().death()
		
	if $right_ray.is_colliding() or $left_ray.is_colliding():
		wall_jump = true
	else:
		wall_jump = false
	
	gravitation(gravity)
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
		
	if is_on_floor():
		if $left_ray.is_colliding():
			$sprite.rotation = lerp_angle($sprite.rotation, get_floor_angle(), 0.1)
		else:
			$sprite.rotation = lerp_angle($sprite.rotation, -get_floor_angle(), 0.1)
	else:
		$sprite.rotation = lerp_angle($sprite.rotation, 0.0, 0.1)
#-------------------------------------------------------------------------------
