extends Area2D

var invicible = false setget set_invicible

onready var timer = $Timer

signal invicibility_started
signal invicibility_ended

func set_invicible(value):
	invicible = value
	if invicible == true:
		emit_signal("invicibility_started")
	else:
		emit_signal("invicibility_ended")
		
func start_inviciblity(duration):
	self.invicible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invicible = false

func _on_Hurtbox_invicibility_started():
	set_deferred("monitoring", false)

func _on_Hurtbox_invicibility_ended():
	set_deferred("monitoring", true)
	print("Hurtbox is now monitorable again!")
