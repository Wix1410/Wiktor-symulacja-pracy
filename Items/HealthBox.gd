extends Node2D

export var healing_amount = 5

func _on_Hurtbox_body_entered(body):
	if PlayerStats.health < PlayerStats.max_health:
		PlayerStats.health += healing_amount
		queue_free()
