extends Node2D

## EXPORTED VARIABLES

export (int)         var particles = 8      ## Number of particles emitted for each "shot"
export (PackedScene) var particle_scene     ## Scene instanced and attached to each rigidbody
export (bool)        var autostart = false  ## automatically start particles when add to tree

## emit properties
export (float)       var lifetime = 1
export (float, 1)    var lifetime_random = 0
export (float, 360)  var emit_angle = 0
export (float, 1)    var emit_angle_random = 0
export (float)       var emit_impulse = 0
export (float, 1)    var emit_impulse_random = 0

## PRIVATE VARIABLES

var life_timer_scene = load("res://RigidBodyParticles2D/LifeTimer.tscn")

func _ready():
	if autostart:
		_start()

func _start():
	randomize()
	for i in range(particles):
		var particle      = particle_scene.instance()
		if particle.get_class() != 'RigidBody2D':
			printerr("Error: Root node of instanced scene must be a 'RigidBody2D', not '"
				+ particle.get_class()) + "'"
		_initialize_particle(particle)
		add_child(particle)

func _initialize_particle(p):

    ## impulse angle
	var angle_rand   = emit_angle * randf() * emit_angle_random
	var angle        = deg2rad(emit_angle + angle_rand)
	var angle_vector = Vector2( cos(angle), sin(angle) ).normalized()

	## impulse magnitude
	var impulse_rand = emit_impulse * randf() * emit_impulse_random
	var impulse      = emit_impulse + impulse_rand

	p.apply_impulse( Vector2(0,0), angle_vector * impulse )

	## set lifetime
	var lifetime_rand    = lifetime * randf() * lifetime_random
	var life_timer       = life_timer_scene.instance()
	life_timer.wait_time = lifetime + lifetime_rand
	life_timer.particle  = p
	p.add_child(life_timer)

	## change scale over time

	## change color over time

	## add delay between particle emits

	## add oneshot
