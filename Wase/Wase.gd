extends RigidBody2D

var WaseEffect = load("res://Wase/WaseEffect.tscn")

func _ready():
	pass


func _on_Hurtbox_area_entered(area):
	var effect = WaseEffect.instance()
	var world = get_tree().current_scene
	var spawn_pos = global_position
	world.get_node("Wases").add_child(effect)
	effect.global_position = spawn_pos
	queue_free()
