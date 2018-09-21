# RigidBodyParticles2D

A Godot 3.0 addon that facilitates simple rigid body based particle systems.

**Instructions**

1. Copy the 'addons' directory into your project.
2. Create a new scene that has a 'RigidBody2D' as its root node (Don't forget to setup a 'CollisionShape2D' and the collision layer/mask). You can add whatever you like below this node; for example a Sprite. This scene represents an individual particle, and will be instanced each time a particle is emitted.
3. In another new or existing scene use 'Instance Child Scene' to add 'addons/RigidBodyParticles2D/RigidBodyParticles2D.tscn' as a node. This will be the particle emitter.
4. On the newly instanced emitter node, set the 'Particle Scene' property to the scene you created in step 2.
5. Tune other various properties on the emitter node, play the scene, rinse and repeat to your liking.

**Signals**

**Properties**

 * <code>emission_shape</code> - Specify a <code>Shape2D</code> to be used as the area where particles are emitted. This can be a <code>CircleShape2D</code>, <code>RectangleShape2D</code>, <code>CapsuleShape2D</code> or <code>SegmentShape2D</code>. If a shape is not specified it defaults to a point emitter. If an invalid shape is specifed, an error is printed and a point emitter is used.

 * <code>tracker_name</code> - This <code>String</code> property indicates the name of the <code>Timer</code> node that is attached to each instanced particle. The <code>wait_time</code> property of the <code>Timer</code> is set to the lifetime of the particle, and is useful for setting up <code>Tween</code>s that vary over the life of the particle. For example, in a script attached to your particle scene you can access this as:

    ````
    onready var tracker  = get_node( get_parent().tracker_name )
    onready var lifetime = tracker.wait_time

    function _ready():
		## fade light over duration of particle's existence
    	$Tween.interpolate_property($Light2D, "energy", 0.7, 0.4, lifetime,
    		Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
    	$Tween.start()
    ````

**Methods**

**Acknowledgements:**

 * Spark sprites from Kenney's Particle Pack (https://kenney.nl/assets/particle-pack).

**TODO**

* document interface
* create a prettier example (falling stones that create sparks)
* rename exported variables for consistency with Particles2D
* add convenience Tweens for RigidBody2D properties (gravity scale, bounce, friction, ...)
* add Tween force vector (magnitude, direction and rotation)
* add custom signals (initial start, stop, iteration start, iteration end, all particles removed )
* support world vs local emitting
* fix tail of spart when emitter is rotated
