extends Node2D

func _on_Hurtbox_body_entered(body):
	PlayerStats.key = true
	queue_free()
