extends Control

var ammo = 10 setget set_ammo
var max_ammo = 10 setget set_max_ammo

onready var bulletUIValue = $BulletValue

func set_ammo(value):
	ammo = clamp(value, 0, max_ammo)
	if bulletUIValue != null:
		bulletUIValue.rect_size.x = 10 * ammo 
		
func show_control():
	bulletUIValue.visible = true
	
func hide_control():
	bulletUIValue.visible = false
	
	
func set_max_ammo(value):
	max_ammo = max(value, 1)
	
func _ready():
	bulletUIValue.visible = false
	self.max_ammo = PlayerStats.max_ammo
	self.ammo = PlayerStats.ammo
	PlayerStats.connect("ammo_changed", self, "set_ammo")
	PlayerStats.connect("gun_in", self, "hide_control")
	PlayerStats.connect("gun_out", self, "show_control")

