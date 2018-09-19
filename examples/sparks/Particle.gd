extends RigidBody2D

onready var lifetime = get_node(get_parent().tracker_name).wait_time

export (Gradient) var gradient

func _enter_tree():
	## initialize colors as we enter the tree
	modulate       = gradient.colors[0]
	$Light2D.color = gradient.colors[0]

func _ready():

	## setup Light2d intensity tween
	$Modulate.interpolate_property($Light2D, "energy", 0.7, 0.4, lifetime,
		Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)

	for i in range(gradient.offsets.size() - 1):

		## calc time in this step of the gradient
		var tween_time = gradient.offsets[i+1] * lifetime - \
			gradient.offsets[i] * lifetime

		## setup Sprite modulate tween
		$Modulate.interpolate_property(self, "modulate", gradient.colors[i],
			gradient.colors[i+1], tween_time, Tween.TRANS_LINEAR,
			Tween.EASE_IN, gradient.offsets[i] * lifetime)

		## setup Light2D color tween
		$Modulate.interpolate_property($Light2D, "color", gradient.colors[i],
			gradient.colors[i+1], tween_time, Tween.TRANS_LINEAR,
			Tween.EASE_IN, gradient.offsets[i] * lifetime)

	$Modulate.start()

func _process(delta):
	## align the sparks direction with its velocity
	$SparkSprite.rotation   = linear_velocity.angle()

	## scale the tail of the sprite based on its velocity
	$SparkSprite/Tail.scale = Vector2(2, min( 4, linear_velocity.length() / 100 ) )
