extends Node

export(int) var max_health = 1
export(int) var max_ammo = 1
export(int) var start_ammo = 1
onready var health = max_health setget set_health
onready var ammo = clamp(start_ammo, 0, max_ammo) setget set_ammo
onready var gun_status = false setget set_gun_status
var key = false setget set_key
var gameover = load("res://UI/GameOverScreen.tscn")

signal no_health
signal health_changed
signal ammo_changed
signal gun_out
signal gun_in
signal key_picked_up

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_ammo(value):
	ammo = clamp(value, 0, max_ammo)
	emit_signal("ammo_changed", ammo)
	
func set_gun_status(value):
	gun_status = value
	if gun_status:
		emit_signal("gun_out")
	else:
		emit_signal("gun_in")

func set_key(value):
	key = value
	emit_signal("key_picked_up")
