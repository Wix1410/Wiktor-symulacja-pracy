extends "res://Items/Item.gd"


func item_picked_up():
	queue_free()

func _on_Hurtbox_area_entered(area):
	emit_signal("item_picked_up")
