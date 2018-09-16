extends Node2D

## TODO
##  - use a Timer node to handle auto-restarts
##  - change randomness calc to be value +/- value * randf() * randomness
##  - would a Vector2() be more intuitive than "angle"

## ENUMS

## EXPORTED VARIABLES

export (int)         var particles = 8      ## Number of particles emitted for each "shot"
export (PackedScene) var particle_scene     ## Scene instanced and attached to each rigidbody
export (bool)        var autostart = true   ## automatically start particles when add to tree
export (bool)        var oneshot = false
export (float, 1)    var explosiveness = 0


## emit properties
export (float)       var lifetime = 2
export (float, 1)    var lifetime_random = 0

export (float, 360)  var angle = 0
export (float, 1)    var angle_random = 0

export (float)       var impulse = 200
export (float, 1)    var impulse_random = 0

export (Gradient)    var color

## PRIVATE VARIABLES

var life_timer_scene = load("res://RigidBodyParticles2D/LifeTimer.tscn")

func _ready():
	if autostart:
		_start()

func _start():
	randomize()
	var start_time = OS.get_ticks_msec()
	for i in range(particles):
		var particle = particle_scene.instance()
		if particle.get_class() != 'RigidBody2D':
			printerr("Error: Root node of instanced scene must be a 'RigidBody2D', not '"
				+ particle.get_class()) + "'"
		_initialize_particle(particle)
		add_child(particle)
		var emit_delay = ( 1 - explosiveness ) * ( lifetime / float(particles) )
		if abs(emit_delay) > 0.01:
			yield(get_tree().create_timer(emit_delay), "timeout")
	var duration = OS.get_ticks_msec() - start_time
	yield(get_tree().create_timer( lifetime - float(duration) / 1000 ), "timeout")
	if ! oneshot:
		_start()

func _initialize_particle(p):

    ## impulse angle
	var angle_add    = angle * randf() * angle_random
	var angle_inst   = deg2rad(angle + angle_add)
	var angle_vector = Vector2( cos(angle_inst), sin(angle_inst) ).normalized()

	## impulse magnitude
	var impulse_add  = impulse * randf() * impulse_random
	var impulse_inst = impulse + impulse_add

	p.apply_impulse( Vector2(0,0), angle_vector * impulse_inst )

	## set lifetime
	var lifetime_add     = lifetime * randf() * lifetime_random
	var lifetime_inst    = lifetime + lifetime_add
	var life_timer       = life_timer_scene.instance()
	life_timer.wait_time = lifetime_inst
	life_timer.particle  = p
	p.add_child(life_timer)

	## change color over time
	if color:
		p.modulate = color.colors[0]
		for i in range(color.offsets.size() - 1):
			var tween_time = color.offsets[i+1] * lifetime_inst - \
				color.offsets[i] * lifetime_inst
			var tween = Tween.new()
			tween.interpolate_property(p, "modulate", color.colors[i],
				color.colors[i+1], tween_time, Tween.TRANS_LINEAR,
				Tween.EASE_IN, color.offsets[i] * lifetime_inst)
			tween.start()
			p.add_child(tween)
