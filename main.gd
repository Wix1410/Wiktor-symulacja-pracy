extends Node2D

#onready var player = $Player
onready var nav = $Navigation2D

func _on_Timer_timeout():
	var player = get_node_or_null( "Player" )
	if player:
		get_tree().call_group("enemy", 'get_target_path', player.global_position )
