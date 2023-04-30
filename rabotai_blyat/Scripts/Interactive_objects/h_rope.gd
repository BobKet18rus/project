extends Node2D
class_name H_rope

@onready var player = get_node("/root/Main_scene/GG")
@onready var player_area = player.get_node("ring_area")
@onready var player_spr = player.get_node("sprite")

func _physics_process(delta):
	pass


func _on_area_area_entered(player_area):
	if (player.state == sm.JUMP or sm.FALL) and player.ring_timer.is_stopped():
		player.state = sm.H_ROPE
		player.position.y = self.position.y + 75
		player.velocity.y = 0


func _on_area_area_exited(player_area):
	pass


func _on_borders_area_entered(player_area):
	if player.state == sm.H_ROPE:
		player.state = sm.FALL
