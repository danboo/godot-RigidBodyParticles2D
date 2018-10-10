extends Node2D

## SIGNALS

signal shot_started
signal shot_ended

## ENUMS

## EXPORTED VARIABLES

export (bool)        var emitting = true setget set_emitting, get_emitting
export (int)         var amount = 8
export (float, 1)    var amount_random = 0
export (PackedScene) var particle_scene
export (bool)        var one_shot = false
export (float, 1)    var explosiveness = 0
export (String)      var tracker_name = "ParticleTracker"
export (Shape2D)     var emission_shape

## EMIT PROPERTIES

export (float)    var lifetime = 2
export (float, 1) var lifetime_random = 0

export (float)            var impulse = 200
export (float, 1)         var impulse_random = 0
export (float, -360, 360) var impulse_angle_degrees = 0
export (float, -360, 360) var impulse_spread_degrees = 0

export (float)            var force = 0
export (float, 1)         var force_random = 0
export (float, -360, 360) var force_angle_degrees = 0
export (float, -360, 360) var force_spread_degrees = 0

export (float, -360, 360) var initial_rotation_degrees = 0
export (float, 1)         var initial_rotation_degrees_random  = 0

## SETGET METHODS

func set_emitting(e):
	var call_emit = e and ! emitting
	emitting = e
	if call_emit:
		_shoot()

func get_emitting():
	return emitting

## PRIVATE VARIABLES

var _iteration = 0
var _life_timer_script = _life_timer_script()

## VIRTUAL METHODS

func _ready():
	randomize()
	$Restarter.connect("timeout", self, "_shoot")
	if emitting:
		_shoot()

## PRIVATE METHODS

func _shoot():

	if ! emitting:
		return

	emit_signal("shot_started")

	if ! one_shot:
		$Restarter.wait_time = lifetime
		$Restarter.start()

	var particle_count = _randomize(amount, amount_random)
	var particles_left = particle_count
	var emit_end       = OS.get_ticks_msec() + lifetime * 1000 * (1 - explosiveness)

	var capsule_circle_frac

	if emission_shape and emission_shape.get_class() == 'CapsuleShape2D':
		var circle_area = pow(emission_shape.radius, 2) * PI
		var rect_area   = emission_shape.radius * 2 * emission_shape.height
		var total_area  = circle_area + rect_area
		capsule_circle_frac = circle_area / total_area

	for i in range(particle_count):

		var particle = particle_scene.instance()
		if _iteration == 0 && particle.get_class() != 'RigidBody2D':
			printerr("Error: Root node of 'Particle Scene' must be a 'RigidBody2D', not '"
				+ particle.get_class() + "'")
		_initialize_particle(particle)

		var particle_pos = Vector2(0,0)

		if emission_shape:
			if emission_shape.get_class() == 'CircleShape2D':
				var rand_radius = emission_shape.radius * sqrt(randf())
				var rand_theta  = randf() * 2 * PI
				particle_pos.x  = rand_radius * cos(rand_theta)
				particle_pos.y  = rand_radius * sin(rand_theta)

			elif emission_shape.get_class() == 'RectangleShape2D':
				particle_pos.x = emission_shape.extents.x * ( 2 * randf() - 1 )
				particle_pos.y = emission_shape.extents.y * ( 2 * randf() - 1 )

			elif emission_shape.get_class() == 'SegmentShape2D':
				var rand     = randf()
				particle_pos = ( 1 - rand ) * emission_shape.a + rand * emission_shape.b

			elif emission_shape.get_class() == 'CapsuleShape2D':
				var rand = randf()
				if rand < capsule_circle_frac:
					## in circle parts
					var rand_radius = emission_shape.radius * sqrt(randf())
					var rand_theta  = randf() * 2 * PI
					particle_pos.x  = rand_radius * cos(rand_theta)
					particle_pos.y  = rand_radius * sin(rand_theta)
					if particle_pos.y < 0:
						particle_pos.y -= emission_shape.height / 2
					else:
						particle_pos.y += emission_shape.height / 2
				else:
					## in rectangle part
					particle_pos.x = emission_shape.radius * ( 2 * randf() - 1 )
					particle_pos.y = emission_shape.height / 2 * ( 2 * randf() - 1 )

			else:
				printerr("Error: invalid emit shape (" + emission_shape.get_class() + ")")

		particles_left -= 1
		particle.position = particle_pos
		add_child(particle)

		if explosiveness < 1 and particles_left > 0:
			var slices = particles_left + 1
			var delay  = ( emit_end - OS.get_ticks_msec() ) / slices / 1000
			if delay > 0.001:
				yield(get_tree().create_timer(delay), "timeout")

	_iteration += 1
	emit_signal("shot_ended")

func _randomize(value, randomness):
	if typeof(value) == TYPE_VECTOR2:
		var x_rand_unit = ( 2 * randf() - 1 ) ## ranges from -1,+1
		var x_rand_mult = x_rand_unit * randomness
		var x_rand_add  = value.x * x_rand_mult
		var y_rand_unit = ( 2 * randf() - 1 ) ## ranges from -1,+1
		var y_rand_mult = y_rand_unit * randomness
		var y_rand_add  = value.y * y_rand_mult
		return Vector2( value.x + x_rand_add, value.y + y_rand_add )
	else:
		var rand_unit = ( 2 * randf() - 1 ) ## ranges from -1,+1
		var rand_mult = rand_unit * randomness
		var rand_add  = value * rand_mult
		return value + rand_add

func _initialize_particle(p):

    ## impulse angle
	var impulse_angle_inst   = impulse_angle_degrees + impulse_spread_degrees * ( 2 * randf() -1 )
	var impulse_angle_rad    = deg2rad(impulse_angle_inst + global_rotation_degrees)
	var impulse_angle_vector = Vector2( cos(impulse_angle_rad), sin(impulse_angle_rad) ).normalized()

	## impulse magnitude
	var impulse_inst = _randomize(impulse,  impulse_random)
	p.apply_impulse( Vector2(0,0), impulse_angle_vector * impulse_inst )

	## force angle
	var force_angle_inst   = force_angle_degrees + force_spread_degrees * ( 2 * randf() -1 )
	var force_angle_rad    = deg2rad(force_angle_inst + global_rotation_degrees)
	var force_angle_vector = Vector2( cos(force_angle_rad), sin(force_angle_rad) ).normalized()

	## force magnitude
	var force_inst = _randomize(force, force_random)
	p.add_force( Vector2(0,0), force_angle_vector * force_inst )

	## set lifetime
	var lifetime_inst    = _randomize(lifetime, lifetime_random)
	var life_timer       = Timer.new()
	life_timer.name      = tracker_name
	life_timer.set_script(_life_timer_script)
	life_timer.wait_time = lifetime_inst
	life_timer.autostart = true
	life_timer.one_shot  = true
	life_timer.particle  = p
	p.add_child(life_timer)

	var initial_rotation_degrees_inst = _randomize(initial_rotation_degrees, initial_rotation_degrees_random)
	p.rotation_degrees = initial_rotation_degrees_inst

func _life_timer_script():
	var gdscript = GDScript.new()
	gdscript.set_source_code(_life_timer_script_text())
	gdscript.reload()
	return gdscript

func _life_timer_script_text():
	return """
extends Timer
var particle

func _ready():
	connect("timeout", self, "_on_timeout")

func _on_timeout():
	particle.queue_free()
"""
