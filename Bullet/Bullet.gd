extends KinematicBody2D

const speed = 700
var direction = Vector2.ZERO
var explosionParticle = load("res://Bullet/BulletParticle.tscn")

func _ready():
	pass

func _process(delta):
	var collision_result = move_and_collide( direction * speed * delta)
	if collision_result != null:
		var explosion = explosionParticle.instance()
		var world = get_tree().current_scene
		world.add_child(explosion)
		explosion.global_position = collision_result.position
		explosion.rotation = collision_result.normal.angle()
		queue_free()

func _on_Hitbox_area_entered(area):
	var explosion = explosionParticle.instance()
	var world = get_tree().current_scene
	world.add_child(explosion)
	explosion.global_position = global_position
	explosion.global_rotation = global_rotation
	queue_free()
