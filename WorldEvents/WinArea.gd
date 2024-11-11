extends Area2D

var winScreen = load("res://UI/WinScreen.tscn")

func _on_WinArea_body_entered(body):
	var popup = winScreen.instance()
	var world = get_tree().current_scene
	world.add_child(popup)
	get_tree().paused = true
