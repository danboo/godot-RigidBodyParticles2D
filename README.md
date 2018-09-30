# RigidBodyParticles2D

A Godot 3.0 addon that facilitates simple rigid body based particle systems.

**Instructions**

1. Copy the 'addons' directory into your project.
2. Create a new scene that has a 'RigidBody2D' as its root node (Don't forget to setup a 'CollisionShape2D' and the collision layer/mask). You can add whatever you like below this node; for example a Sprite. This scene represents an individual particle, and will be instanced each time a particle is emitted.
3. In another new or existing scene use 'Instance Child Scene' to add 'addons/RigidBodyParticles2D/RigidBodyParticles2D.tscn' as a node. This will be the particle emitter.
4. On the newly instanced emitter node, set the 'Particle Scene' property to the scene you created in step 2.
5. Tune other various properties on the emitter node, play the scene, rinse and repeat to your liking.

**Description**

This addon makes it possible to create simple particle systems that emit `RigidBody2D` based scenes, which Godot's `Particles2d` node cannot. This lets particles interact with the environment like bouncing off other physics bodies, or use collision detection to apply affects like damage.

And because the particles are user created scenes, you have more control over their behaviors. You can attach any other nodes to the parent `RigidBody2D` like a `Light2D` or even a `Particles2D`.

Using custom scripts you can modify particles during over their lifetime, like rotating them so they're oriented along the path they are traveling, stretching their trails in line with their velocity, or changing the lighting intensity as they near end of life.

Note that emitting many `RigidBody2D` instances in rapid succession can have an adverse affect on performance. For this reason, you should keep the scenes small and efficient, and the number of instanced particles relatively low.

**Randomness**

Randomness in `RigidBodyParticles2D` differs from `Particles2D` in that the resultant value can be either higher or lower than the specified base value. The general calculation is:

````
    rand_param_value = param_value + param_value * ( 2 * randf() - 1 ) * param_random
````

For instance if the base `impulse` parameter is set to `100` and `impulse_random` is set to `0.5`, then the resultant randomized value can range from `50` to `150` (i.e., `100 +/- 100 * 0.5 * randf()`).

**Signals**

 * `shot_started` - Emitted each time a "shot" (set of particles) starts.

 * `shot_ended` - Emitted each time a "shot" (set of particles) ends.

**Properties**

 * `emitting` - Enable emitting if `true`. Disable emitting if `false`.

 * `amount` - Number of particles to emit for each "shot".

 * `amount_random` - Randomness parameter for `amount`. The valid range is `[0,1]`. See note about randomness in the description above.

 * `particle_scene` - The `PackedScene` that gets instanced and emitted for each particle.

 * `one_shot` - Emit only one "shot" (set) of particles if `true`. Repeatedly emit particle "shots" if `false`.

 * `explosiveness` - Controls the delay between each particle within a single "shot" of particles.  The valid range is `[0,1]`. An `explosiveness` of `0` means that particles are emitted with even spacing over the `lifetime` of the "shot". An `explosiveness` of `1` means that all particles are emitted at once at the start of the `lifetime` of a "shot".

 * `tracker_name` - This `String` property indicates the name of the `Timer` node that is attached to each instanced particle. The `wait_time` property of the `Timer` is set to the lifetime of the particle, and is useful for setting up `Tween`s that vary over the life of the particle. For example, in a script attached to your particle scene you can access this as:

````
    onready var tracker  = get_node( get_parent().tracker_name )
    onready var lifetime = tracker.wait_time

    function _ready():
		## fade light over duration of particle's existence
    	$Tween.interpolate_property($Light2D, "energy", 0.7, 0.4, lifetime,
    		Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
    	$Tween.start()
````

 * `emission_shape` - Specify a `Shape2D` to be used as the area where particles are emitted. This can be a `CircleShape2D`, `RectangleShape2D`, `CapsuleShape2D` or `SegmentShape2D`. If a shape is not specified it defaults to a point emitter. If an invalid shape is specifed, an error is printed and a point emitter is used.

 * `lifetime` - Specifies the lifetime of a particle and the delay between "shots" in seconds.

 * `lifetime_random` - Randomness parameter for `lifetime`. The valid range is `[0,1]`. See note about randomness in the description above.

 * `impulse` - Specifies the initial `impulse` magnitude (not direction) applied to the `RigidBody2D` particle as it is emitted.

 * `impulse_random` - Randomness parameter for `impulse`. The valid range is `[0,1]`. See note about randomness in the description above.

 * `impulse_angle_degrees` - Specifies the `impulse` angle in degrees.

 * `impulse_spread_degrees` - Controls the spread of the angle of `impulse` for each particle. Each particle's initial angle will range from `[impulse_angle_degrees - impulse_spread_degrees, impulse_angle_degrees + impulse_spread_degrees]`.

 * `force` - Specifies the `applied_force` magnitude (not direction) applied to the `RigidBody2D` particle as it is emitted.

 * `force_random` - Randomness parameter for `force`. The valid range is `[0,1]`. See note about randomness in the description above.

 * `force_angle_degrees` - Specifies the `force` angle in degrees.

 * `force_spread_degrees` - Controls the spread of the angle of `force` for each particle. Each particle's initial angle will range from `[force_angle_degrees - force_spread_degrees, force_angle_degrees + force_spread_degrees]`.

**Examples**

 * `examples\simple` - This simple example shows a very simple scene `RigidBody2D` particles with a `Sprite2D` attached. The particles are emitted and bounce around in the physics simulation.

 * `examples\sparks` - This more complex example uses a particle scene that includes multiple `Sprite2D` nodes, a `Tween` and a `Light2D` node. Additionally it uses a custom script to orient the tail of the spark along the path it is traveling, stretch the tail in line with its velocity, and vary the color of the sprite and light over the lifetime of the particle.

**Acknowledgements:**

 * Spark sprites from Kenney's Particle Pack (https://kenney.nl/assets/particle-pack).

**TODO**

* add example gifs to README or create a demo GIF/video
* fix initial tail of spark so it never goes behind origin
* add support for arrays of particle scenes with multiple selection methods (random, random weighted, round-robin)
