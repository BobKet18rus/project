extends CharacterBody2D

var state:int = sm.FALL

@export var speed:int = 500
@export var gravity:int = 100
@export var jump_force:int = -900
@export var acc:float = 0.2
@export var fr:float = 0.2

@onready var jump_timer = $timers/jump_timer
@onready var ring_timer = $timers/ring_timer

var dir:int = 0
var jump_possibility:bool = false
var current_checkpoint_position:Vector2

var death_counter:int = 0
var fast_fall:bool

func die():
	velocity = Vector2.ZERO
	death_counter += 1
	self.position = current_checkpoint_position
	self.state = sm.FALL

func time(s):#ВЫЗЫВАТЬ AWAIT
	var timer = get_tree().create_timer(s)
	return timer.timeout
	
func state_machine():
	if state != sm.FALL:
		fast_fall = false
	match state:
		sm.IDLE:
			jump_possibility = true
			idle(1)
			if Input.is_action_pressed("left") and Input.is_action_pressed("right"):
				state = sm.IDLE
			elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				state = sm.MOVE
			if not(is_on_floor()):
				state = sm.FALL
			jump(1)
			jump_timer_starting()
		sm.MOVE:
			jump_possibility = true
			move(1,1)
			if not(is_on_floor()):
				state = sm.FALL
			jump(1)
			jump_timer_starting()
		sm.FALL:
			jump_possibility = false
			if Input.is_action_just_pressed("down"):
				fast_fall = true
				
			if fast_fall == true:
				gravitation(2)
				velocity.x = lerpf(velocity.x, 0.0, 0.5)
			else:
				gravitation(1)
				move(1, 0.2)
				
			if is_on_floor():
				state = sm.IDLE
			elif is_on_wall():
				velocity = Vector2.ZERO
				state = sm.WALL
				
		sm.JUMP:
			if jump_timer.is_stopped() or is_on_ceiling() or Input.is_action_just_released("jump"):
				state = sm.FALL
			else:
				jump_possibility = true
				
			if Input.is_action_just_pressed("down"):
				state = sm.FALL
				
			if is_on_wall():
				velocity = Vector2.ZERO
				state = sm.WALL
			move(1, 0.2)
		sm.RING:
			jump_possibility = true
			if Input.is_action_just_pressed("down"):
				state = sm.FALL
				ring_timer.start()
			ring_timer_starting()
			jump(1)
			jump_timer_starting()
		sm.H_ROPE:
			jump_possibility = true
			if Input.is_action_just_pressed("down") or is_on_ceiling():
				state = sm.FALL
				ring_timer.start()
			move(0.8, 1)
			ring_timer_starting()
			jump(1)
			jump_timer_starting()
		sm.D_ROPE:
			pass
		sm.V_ROPE:
			pass
		sm.LEDGE:
			pass
		sm.WALL:
			jump_possibility = true
			if ($left_ray.is_colliding() or $right_ray.is_colliding()) and not(Input.is_action_pressed("down")):
				gravitation(0.1)
			else:
				gravitation(1)
			jump(0.8)
			wall_jump(10)
			jump_timer_starting()
			if is_on_floor():
				state = sm.IDLE
			elif not(is_on_wall()):
				state = sm.FALL
	
func wall_jump(s_mult):
	if is_on_wall():
		if Input.is_action_just_pressed("jump"):
			if $left_ray.is_colliding():
				velocity.x = lerpf(velocity.x, speed*s_mult, 0.1)
			else:
				velocity.x = lerpf(velocity.x, -speed*s_mult, 0.1)
func label():
	$state.text = str(state)+","+str(velocity)
	
func jump_timer_starting():
	if Input.is_action_just_pressed("jump"):
		jump_timer.start(0.3)

func ring_timer_starting():
	if Input.is_action_just_pressed("jump"):
		ring_timer.start()
func jump(force_mult:float):
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_possibility == true):
		jump_timer_starting()
		state = sm.JUMP
		velocity.y += jump_force*force_mult
		
func move(s, a):
	if is_on_floor() and (Input.is_action_pressed("left") and Input.is_action_pressed("right")):
		state = sm.IDLE
	elif Input.is_action_pressed("left") and Input.is_action_pressed("right"):
		idle(1)
	elif state == sm.H_ROPE and not(Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		idle(1)
	elif Input.is_action_pressed('left'):
		velocity.x = lerpf(velocity.x, -speed*s, acc*a)
	elif Input.is_action_pressed("right"):
		velocity.x = lerpf(velocity.x, speed*s, acc*a)
	else:
		if is_on_floor():
			state = sm.IDLE
		
		
func idle(fr_mult):
	velocity.x = lerpf(velocity.x, 0.0, fr*fr_mult)
	
func gravitation(grav_mult:float):
	velocity.y += gravity*grav_mult
	
func _ready():
	pass
	
func _process(_delta):
	label()
	if Input.is_action_just_pressed("t1"):
		die()

	if is_on_floor():
		if $down_ray.is_colliding():
			$sprite.rotation = lerp_angle($sprite.rotation, $down_ray.target_position.angle_to(-$down_ray.get_collision_normal()), 0.5)
		elif $left_ray.is_colliding():
			$sprite.rotation = lerp_angle($sprite.rotation, Vector2(1, 2).angle_to(-$down_ray.get_collision_normal()+Vector2(0, 48)), 0.3)
		elif $right_ray.is_colliding():
			$sprite.rotation = lerp_angle($sprite.rotation, Vector2(-1, 2).angle_to(-$down_ray.get_collision_normal()+Vector2(0, 48)), 0.3)
	else:
		$sprite.rotation = lerp_angle($sprite.rotation, 0.0, 0.1)
	
func _physics_process(_delta):
	state_machine()
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()

	
