extends KinematicBody2D

export var speed = 100
export var color = Color(255, 255, 255)

enum {
	STAY,
	WANDER,
	CHASE,
	DIE,
}

var state = STAY
var velocity = Vector2.ZERO
var path = []
var threshold = 16
var nav = null
var playerPos = null
var died = false

onready var body = $Body
onready var eye = $Eye
onready var animationPlayer = $AnimationPlayer
onready var playerDetectionZone = $AIView
onready var hurtbox = $Hurtbox
onready var hitbox = $Hitbox
onready var stats = $Stats
onready var light = $Light2D
onready var audio = $AudioStreamPlayer
onready var collisionShape = $CollisionShape2D

var hitParticle = load("res://GhostEnemy/GhostEnemyParticle.tscn")

func _ready():
	body.modulate = color
	light.set_color(color)
	yield(owner, "ready")
	nav = owner.nav
	MusicPlayer.connect("stop_music", self, "check_detection_for_music")
	
func _physics_process(delta):
	if died:
			return
	if not playerDetectionZone.player_in_view() and state == CHASE:
		state = STAY
		MusicPlayer.stopChaseMusic()
	hurtbox.global_rotation = self.global_rotation
	match state:
		STAY:
			seek_player()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				move_enemy()
		
func seek_player():
	if playerDetectionZone.player_in_view():
		MusicPlayer.playChaseMusic()
		state = CHASE 
	
func move_enemy():
	if path.size() > 0:
		animationPlayer.play("walk")
		rotation = velocity.angle()
		eye.look_at(playerPos)
		move_to_target()
	else:
		animationPlayer.play("idle")
		
func check_detection_for_music():
	if playerDetectionZone.player_in_view() and not died:
		MusicPlayer.keepPlayingMusic()
		
func move_to_target():
	if global_position.distance_to(path[0]) < threshold:
		path.remove(0)
	else:
		if not playerDetectionZone.player_in_view():
			state = STAY
			return
		var direction = global_position.direction_to(path[0])
		velocity = direction * speed
		velocity = move_and_slide(velocity)
		
func get_target_path(target_pos):
	playerPos = target_pos
	path = nav.get_simple_path(global_position, target_pos, true)


func _on_Hurtbox_area_entered(area):
	audio.play()
	stats.health -= area.damage
	var explosion = hitParticle.instance()
	var world = get_tree().current_scene
	world.get_node("Enemies").add_child(explosion)
	explosion.modulate = color
	explosion.global_position = area.global_position
	explosion.global_rotation = global_rotation
	if state == STAY:
		playerDetectionZone.player = 1
		state = CHASE


func _on_Stats_no_health():
	died = true
	MusicPlayer.stopChaseMusic()
	hitbox.queue_free()
	hurtbox.queue_free()
	collisionShape.queue_free()
	animationPlayer.play("die")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()
