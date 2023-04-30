extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("t2"):
		$Root.get_node("anim").play("grow")
