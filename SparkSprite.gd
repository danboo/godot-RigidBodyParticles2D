extends Node2D

var rigid_body

func _ready():
	rigid_body = get_parent()

func _process(delta):
	var velocity = rigid_body.linear_velocity
	rotation = velocity.angle()
	$Tail.scale = Vector2(1, velocity.length() / 100)
