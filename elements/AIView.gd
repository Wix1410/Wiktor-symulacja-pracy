extends Node2D

var player = null

func _ready():
	pass

func _physics_process(delta):
	pass
	
func player_in_view():
	return player != null

func _on_PlayerEscapeZone_body_entered(body):
	pass

func _on_PlayerEscapeZone_body_exited(body):
	player = null

func _on_PlayerTooCloseZone_body_entered(body):
	player = body
