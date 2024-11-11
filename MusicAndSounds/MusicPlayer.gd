extends Node

onready var audio = $AudioStreamPlayer
var playingChaseMusic = false

signal stop_music

func playChaseMusic():
	if not playingChaseMusic:
		playingChaseMusic = true
		audio.play()
		
func keepPlayingMusic():
	playingChaseMusic = true
		
func stopChaseMusic():
	playingChaseMusic = false
	emit_signal("stop_music")

func _process(delta):
	if not playingChaseMusic:
		audio.stop()
