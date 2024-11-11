extends StaticBody2D

func _ready():
	PlayerStats.connect("key_picked_up", self, "queue_free")
