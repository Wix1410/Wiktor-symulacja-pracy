extends RigidBody2D

enum {
	MOVE,
	MOVE_GUN,
	GUNOUT,
	GUNIN,
	GUNSHOT
}

var input_vector = Vector2.ZERO
var state = MOVE
var inShot = false
var hp = 5
var knockback = Vector2.ZERO
var stats = PlayerStats
var reload = false
var hitParticle = load("res://Player/PlayerHurtParticle.tscn")
var maxStamina = 100
var stamina = maxStamina
var sprintMultipler = 1

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var sprite = $Sprite
onready var bodyShape = $bodyShape
onready var hurtbox = $Hurtbox
onready var timer = $Timer
onready var audio = $HitSoundPlayer
onready var light = $Light2D
onready var sprintBar = $Sprite/SprintBar

func _ready():
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	animationState.start("Idle")
	sprintBar.visible = false
	
func _process(delta):
	light.global_rotation = 0
	apply_central_impulse(knockback)
	knockback = Vector2.ZERO
	sprite.look_at(get_global_mouse_position())
	sprintBar.value = stamina
	match state:
		MOVE:
			move_state(delta)
		MOVE_GUN:
			move_gun_state(delta)
		GUNOUT:
			gun_out_state(delta)
		GUNIN:
			gun_in_state(delta)
		GUNSHOT:
			gun_shot_state(delta)

func move_state(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationState.travel("walking")
		apply_central_impulse(input_vector*90*sprintMultipler)
		if Input.is_key_pressed(KEY_SHIFT) and CanSprint():
			sprintMultipler = 2
			sprintBar.visible = true
			stamina -= 0.5
		elif not Input.is_key_pressed(KEY_SHIFT):
			sprintMultipler = 1
			sprintBar.visible = false
			stamina += 0.5
	else:
		animationState.travel("Idle")
	
	if Input.is_action_just_pressed("ui_gun"):
		state = GUNOUT
		
func move_gun_state(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationState.travel("gunWalk")
		apply_central_impulse(input_vector*70)
	else:
		animationState.travel("gunIdle")
	
	if Input.is_action_just_pressed("ui_gun"):
		state = GUNIN
		
	if Input.is_action_just_pressed("ui_shot") and (reload == false):
		state = GUNSHOT
	
func gun_out_state(delta):
	reload = true
	timer.start(0.5)
	animationState.travel("gunOut")
	stats.gun_status = true
	state = MOVE_GUN

func gun_in_state(delta):
	animationState.travel("gunIn")
	stats.gun_status = false
	state = MOVE
	
func gun_shot_state(delta):
	if stats.ammo <= 0:
		state = MOVE_GUN
		return
		
	reload = true
	timer.start(0.5)
	animationState.travel("gunShot")
	stats.ammo -= 1
	var Bullet = load("res://Bullet/Bullet.tscn")
	var bullet = Bullet.instance()
	var world = get_tree().current_scene
	var bullet_spawn_pos = sprite.get_node("bullet_spawn").global_position
	world.add_child(bullet)
	bullet.global_position = bullet_spawn_pos
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.rotation = bullet.direction.angle()

	state = MOVE_GUN
	
func _on_Timer_timeout():
	reload = false

func _on_Hurtbox_area_entered(area):
	audio.play()
	stats.health -= area.damage
	hurtbox.start_inviciblity(1)
	knockback = Vector2(1000, 0 ).rotated( area.global_rotation )
	var explosion = hitParticle.instance()
	var world = get_tree().current_scene
	world.add_child(explosion)
	explosion.global_position = self.global_position
	explosion.global_rotation = global_rotation
	
func CanSprint():
	if stamina > 0:
		return true
	else:
		return false

