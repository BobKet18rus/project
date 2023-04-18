extends Node2D
class_name Ring

@onready var player = get_parent().get_player()
@onready var ring_area = player.get_ring_area()
@onready var spr = player.get_sprite()

func _physics_process(delta):
	if $area.overlaps_area(ring_area) and not(Input.is_action_just_pressed("down") or Input.is_action_just_pressed("jump") or $cooldown.time_left > 0):
		player.set_state("IS_ON_RING")
		
		if player.direction_x < 0:
			spr.rotation = lerp_angle(player.rotation, 30, 0.1)
			player.position = lerp(player.position, self.position + Vector2(-10, 115), 0.3)
		elif player.direction_x > 0:
			spr.rotation = lerp_angle(player.rotation, -30, 0.1)
			player.position = lerp(player.position, self.position + Vector2(10, 115), 0.1)
		else:
			player.position = lerp(player.position, self.position + Vector2(0, 120), 0.3)
		player.velocity = Vector2.ZERO
		
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("jump"):
		$cooldown.start(0.2)
		if $cooldown.time_left != 0:
			player.state = "IS_IN_AIR"
		
