extends Node2D

## EXPORTED VARIABLES

export (int)         var particles = 8  ## Number of particles emitted for each "shot"
export (PackedScene) var particle_scene ## Scene instanced and attached to each rigidbody

## emit properties
export (float)       var particle_lifetime = 1
export (float, 360)  var emit_angle = 0
export (float, 1)    var emit_angle_random = 0
export (float)       var emit_impulse = 0
export (float, 1)    var emit_impulse_random = 0

## PRIVATE VARIABLES

var life_timer_scene = load("res://RigidBodyParticles2D/LifeTimer.tscn")

func _ready():
	randomize()
	for i in range(particles):
		var particle      = particle_scene.instance()
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
	var life_timer       = life_timer_scene.instance()
	life_timer.wait_time = particle_lifetime
	life_timer.particle  = p
	p.add_child(life_timer)

