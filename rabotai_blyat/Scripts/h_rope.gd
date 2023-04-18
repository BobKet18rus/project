extends Node2D

@onready var player = get_parent().get_player()
@onready var ring_area = player.get_ring_area()
@onready var spr = player.get_sprite()
var new_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $ray.is_colliding() and not(player.is_on_floor() or $cooldown.time_left > 0) and player.state != "IS_ON_H_ROPE":
		player.set_state("IS_ON_H_ROPE")
		new_pos = Vector2($ray.get_collision_point().x, self.position.y) + Vector2(-88, 70)
		player.velocity.y = 0
		player.position = lerp(player.position, new_pos, 1)
	
	if not($ray.is_colliding()):
		player.state = "IS_IN_AIR"
	
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("jump"):
		$cooldown.start(0.1)
		if $cooldown.time_left != 0:
			player.state = "IS_IN_AIR"
			
