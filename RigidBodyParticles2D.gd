extends Node2D

## can i export Tween.EaseType and Tween.TransitionType directly?

## ENUMS

enum EaseType {
	EASE_IN     = Tween.EASE_IN,
	EASE_OUT    = Tween.EASE_OUT,
	EASE_IN_OUT = Tween.EASE_IN_OUT,
	EASE_OUT_IN = Tween.EASE_OUT_IN,
	}

enum TransitionType {
	TRANS_LINEAR  = Tween.TRANS_LINEAR,
	TRANS_SINE    = Tween.TRANS_SINE,
	TRANS_QUINT   = Tween.TRANS_QUINT,
	TRANS_QUART   = Tween.TRANS_QUART,
	TRANS_QUAD    = Tween.TRANS_QUAD,
	TRANS_EXPO    = Tween.TRANS_EXPO,
	TRANS_ELASTIC = Tween.TRANS_ELASTIC,
	TRANS_CUBIC   = Tween.TRANS_CUBIC,
	TRANS_CIRC    = Tween.TRANS_CIRC,
	TRANS_BOUNCE  = Tween.TRANS_BOUNCE,
	TRANS_BACK    = Tween.TRANS_BACK,
	}

## EXPORTED VARIABLES

export (int)         var particles = 8      ## Number of particles emitted for each "shot"
export (PackedScene) var particle_scene     ## Scene instanced and attached to each rigidbody
export (bool)        var autostart = false  ## automatically start particles when add to tree

## emit properties
export (float)       var lifetime = 1
export (float, 1)    var lifetime_random = 0

export (float, 360)  var angle = 0
export (float, 1)    var angle_random = 0

export (float)       var impulse = 0
export (float, 1)    var impulse_random = 0

export (Gradient)    var color

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
		for i in range(color.offsets.size() - 1):
			var tween_time = color.offsets[i+1] * lifetime_inst - \
				color.offsets[i] * lifetime_inst
			var tween = Tween.new()
			tween.interpolate_property(p, "modulate", color.colors[i],
				color.colors[i+1], tween_time, Tween.TRANS_LINEAR,
				Tween.EASE_IN, color.offsets[i] * lifetime_inst)
			tween.start()
			p.add_child(tween)

	## add delay between particle emits

	## add oneshot
