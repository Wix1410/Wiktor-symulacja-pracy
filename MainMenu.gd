extends Control

onready var gameVersionInfo = $GameVersionInfo

var currentVersion = "Current Game Version"

func _ready():
	gameVersionInfo.text = currentVersion

func _on_PlayBtn_pressed():
	get_tree().change_scene("res://main.tscn")

func _on_OptionsBtn_pressed():
	pass # Replace with function body.

func _on_ExitButton_pressed():
	get_tree().quit()
