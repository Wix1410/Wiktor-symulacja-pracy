extends Control

var health = 5 setget set_health
var max_health = 5 setget set_max_health

onready var healthUIValue = $HealthUIValue
onready var label = $Label
onready var initialSize = healthUIValue.rect_size.x

func set_health(value):
	health = clamp(value, 0, max_health)
	if label != null:
		label.text = str(health)
	if healthUIValue != null:
		healthUIValue.rect_size.x = initialSize * health / max_health

func set_max_health(value):
	max_health = max(value, 1)
	
func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_health")
