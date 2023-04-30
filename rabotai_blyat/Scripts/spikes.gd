extends Area2D
class_name Danger

@onready var player = get_node("/root/Main_scene/GG")

	
func _on_body_entered(body):
	player.die()
