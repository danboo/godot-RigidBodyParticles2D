extends Node2D

## TODO
##  - document interface
##  - create a prettier example (falling stones that create sparks)
##  - rename exported variables for consistency with Particles2D
##  - would a Vector2() be more intuitive than "angle"
##  - think about how user can introspect Particle properties. for example
##     - a custom Tween that operates on lifetime
##     - a Sprite that stretches based on speed
##     - a Sprite that rotates based on angle
##  - add Tweens for RigidBody2D properties (gravity scale, bounce, friction, ...)

## ENUMS

## EXPORTED VARIABLES

export (int)         var particles = 8      ## Number of particles emitted for each "shot"
export (PackedScene) var particle_scene     ## Scene instanced and attached to each rigidbody
export (bool)        var autostart = true   ## automatically start particles when add to tree
export (bool)        var oneshot = false
export (float, 1)    var explosiveness = 0

## EMIT PROPERTIES

export (float)       var lifetime = 2
export (float, 1)    var lifetime_random = 0

export (float, -360, 360) var angle = 0
export (float, 1)         var angle_random = 0

export (float)       var impulse = 200
export (float, 1)    var impulse_random = 0

export (Gradient)    var color

## PRIVATE VARIABLES

var life_timer_scene = load("res://RigidBodyParticles2D/LifeTimer.tscn")
var iteration = 0

func _ready():
	randomize()
	if autostart:
		_start()

func _start():

	if ! oneshot:
		$Restarter.wait_time = lifetime
		$Restarter.connect("timeout", self, "_start")
		$Restarter.start()

	var emit_delay = ( 1 - explosiveness ) * ( lifetime / float(particles) )

	for i in range(particles):
		var particle = particle_scene.instance()
		if iteration == 0 && particle.get_class() != 'RigidBody2D':
			printerr("Error: Root node of 'Particle Scene' must be a 'RigidBody2D', not '"
				+ particle.get_class()) + "'"
		_initialize_particle(particle)
		add_child(particle)
		if abs(emit_delay) > 0.01:
			yield(get_tree().create_timer(emit_delay), "timeout")

	iteration += 1

func _randomize(value, randomness):
	var rand_unit = ( 2 * randf() - 1 ) ## ranges from -1,+1
	var rand_mult = rand_unit * randomness
	var rand_add  = value * rand_mult
	return value + rand_add

func _initialize_particle(p):

    ## impulse angle
	var angle_inst   = _randomize(angle, angle_random)
	var angle_rad    = deg2rad(angle_inst)
	var angle_vector = Vector2( cos(angle_rad), sin(angle_rad) ).normalized()

	## impulse magnitude
	var impulse_inst = _randomize(impulse,  impulse_random)
	p.apply_impulse( Vector2(0,0), angle_vector * impulse_inst )

	## set lifetime
	var lifetime_inst    = _randomize(lifetime, lifetime_random)
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
