# RigidBodyParticles2D

A Godot 3.0 addon that facilitates simple rigid body based particle systems.

**Instructions**

1. Copy the 'addons' directory into your project.
2. Create a new scene that has a 'RigidBody2D' as its root node (Don't forget to setup a 'CollisionShape2D' and the collision layer/mask). You can add whatever you like below this node; for example a Sprite. This scene represents an individual particle, and will be instanced each time a particle is emitted.
3. In another new or existing scene use 'Instance Child Scene' to add 'addons/RigidBodyParticles2D/RigidBodyParticles2D.tscn' as a node. This will be the particle emitter.
4. On the newly instanced emitter node, set the 'Particle Scene' property to the scene you created in step 2.
5. Tune other various properties on the emitter node, play the scene, rinse and repeat to your liking.

**Description**

Randomness in `RigidBodyParticles2D` differs from `Particles2D` in that the resultant value can be either higher or lower than the specified base value. The general calculation is:

````
    rand_param_value = param_value + param_value * ( 2 * randf() - 1 ) * param_random
````

For instance if the base `impulse` parameter is set to `100` and `impulse_random` is set to `0.5`, then the resultant randomized value can range from `50` to `150` (i.e., `100 +/- 100 * 0.5 * randf()`).

**Signals**

**Properties**

 * `emitting` - TODO

 * `amount` - TODO

 * `amount_random` - TODO

 * `particle_scene` - TODO

 * `one_shot` - TODO

 * `explosiveness` - TODO

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

 * `lifetime` - TODO

 * `lifetime_random` - TODO

 * `impulse` - TODO

 * `impulse_random` - TODO

 * `impulse_angle_degrees` - TODO

 * `impulse_spread_degrees` - TODO

 * `force` - TODO

 * `force_random` - TODO

 * `force_angle_degrees` - TODO

 * `force_spread_degrees` - TODO

**Methods**

**Acknowledgements:**

 * Spark sprites from Kenney's Particle Pack (https://kenney.nl/assets/particle-pack).

**TODO**

* add custom signals (initial start, stop, iteration start, iteration end, all particles removed )
* document interface
* create a prettier example (a cloud, falling rain with wind)
* add example gifs to README or create a demo GIF/video
* see if there is a better way to handle emit delay when particles are very rapid (i.e., remove explosive conversion, more accurate timing)
* fix initial tail of spark so it never goes behind origin
