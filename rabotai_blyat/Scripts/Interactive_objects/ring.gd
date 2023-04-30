extends Node2D
class_name Ring

@onready var player = get_node("/root/Main_scene/GG")
@onready var player_area = player.get_node("ring_area")
@onready var player_spr = player.get_node("sprite")
var on_ring = false

func _physics_process(_delta):
	if on_ring == true and player.state == sm.RING:
		player.position = lerp(player.position, self.position + Vector2(0, 100), 0.6)
#func _physics_process(delta):
#	if $area.overlaps_area(player_area) and (player.state == sm.JUMP or sm.FALL) and player.ring_timer.is_stopped():
#		player.state = sm.RING
#		player.position = lerp(player.position, self.position + Vector2(0, 100), 0.3)
#		player.velocity = Vector2.ZERO
func _on_area_area_entered(player_area):
	if (player.state == sm.JUMP or sm.FALL) and player.ring_timer.is_stopped():
		on_ring = true
		player.state = sm.RING
		player.velocity = Vector2.ZERO
	
func _on_area_area_exited(player_area):
	on_ring = false
