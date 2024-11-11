extends Node2D

export var ammo_capacity = 10

func _on_Hurtbox_body_entered(body):
	if PlayerStats.ammo < PlayerStats.max_ammo:
		PlayerStats.ammo += ammo_capacity
		queue_free()
