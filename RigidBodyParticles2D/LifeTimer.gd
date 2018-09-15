extends Timer

var particle

func _ready():
	connect("timeout", self, "_on_timeout")

func _on_timeout():
	particle.queue_free()