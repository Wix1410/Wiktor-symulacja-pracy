extends CanvasLayer

func _on_Restart_pressed():
	PlayerStats.reset_stats()
	get_tree().paused = false
	get_tree().change_scene("res://main.tscn")

func _on_Quit_pressed():
	get_tree().quit()
