extends Line2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not($anim.is_playing()):
		$vine_collider.constant_linear_velocity = Vector2.ZERO
	elif $anim.is_playing():
		$vine_collider.constant_linear_velocity.x = 400*($end.position.x - $start.position.x)
		$vine_collider.constant_linear_velocity.y = 400*($end.position.y - $start.position.y)
