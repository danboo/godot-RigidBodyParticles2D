extends Node2D

var particle
var lifetime

## VIRTUAL METHODS

func _ready():
	$Remover.wait_time = lifetime
	$Remover.connect("timeout", self, "_on_remover_timeout")

## PRIVATE METHODS

func _on_remover_timeout():
	particle.queue_free()