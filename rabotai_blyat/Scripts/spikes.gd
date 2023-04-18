extends Area2D
class_name Spikes

func _ready():
	pass
	
func _physics_process(_delta):
	if overlaps_body(get_parent().get_player()):
		get_parent().get_player().velocity = Vector2.ZERO
		get_parent().get_player().death_counter += 1
		get_parent().death()
