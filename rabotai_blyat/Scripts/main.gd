extends Node2D

func get_player():
	return $GG
func get_box():
	return $box
func get_cur_cp():
	return $checkpoint.position
func get_obstacles():
	return $obstacles

func death():
	$GG.position = $checkpoint.position

func _ready():
	$GG.position = $checkpoint.position

func _physics_process(_delta):
	pass
		
