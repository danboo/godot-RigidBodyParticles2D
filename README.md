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

**Methods**

**Acknowledgements:**

 * Spark sprites from Kenney's Particle Pack (https://kenney.nl/assets/particle-pack).

**TODO**

* document interface
* create a prettier example (falling stones that create sparks)
* rename exported variables for consistency with Particles2D
* provide clear way and instructions on how to access and use particle lifetime for tweening
* add convenience Tweens for RigidBody2D properties (gravity scale, bounce, friction, ...)
* add a start()/play()/emit() method
* add emit shapes in addition to Point (points, circle, ellipse, rectangle)
* add Tween force vector (magnitude, direction and rotation)
* add custom signals (initial start, stop, iteration start, iteration end, all particles removed )
* after instancing a particle from the user scene, attach a single node that is used for attaching other nodes that need to be cleaned
* use setget for properties

