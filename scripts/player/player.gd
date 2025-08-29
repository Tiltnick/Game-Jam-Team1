class_name Player extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var stateMachine:PlayerStateMachine = $StateMachine

const final_moveSpeed:float = 200.0
const final_max_health:float = 20.0
const final_health: float = 10.0
const final_attackSpeed:float = 50.0
const final_damage:float = 1.0
const final_max_energy:float = 5.0
const final_energy:float = 3.0
const final_attackCooldown: float = 1.0
const final_attackCooldown_ghost:float = 0.2
const final_dashCooldown: float = 1.0
const final_projectile_speed:float = 700.0
const final_ghostMultiplier:float = 1.2

@export var moveSpeed:float = 200.0
@export var max_health:float = 20.0
@export var health: float = 10.0
@export var attackSpeed:float = 50.0
@export var damage:float = 1.0
@export var max_energy:float = 5.0
@export var energy:float = 3.0
@export var attackCooldown: float = 1.0
@export var dashCooldown: float = 1.0
@export var projectile_speed:float = 700.0

@onready var map = get_parent()

@onready var healthbar = get_parent().get_node("Health")
@onready var energybar = get_parent().get_node("Energy")

signal took_damage()
signal death()

@export var ice: PackedScene = preload("res://scenes/projectiles/ice.tscn")

var dashCooldownTimer: float = 0.0

var attackCooldownTimer: float = 0.0

var direction: Vector2 = Vector2.ZERO
enum Dir {DOWN, SIDE, UP}
var isFacing = Dir.DOWN

var energy_active: bool = false
var energy_timer: float = 0.0
@export var energy_duration: float = 4.0




func _ready():
	moveSpeed = final_moveSpeed
	max_health  = final_max_health
	health = final_health
	attackSpeed = final_attackSpeed
	damage = final_damage
	max_energy = final_max_energy
	energy = final_energy
	attackCooldown = final_attackCooldown
	dashCooldown = final_dashCooldown
	projectile_speed = final_projectile_speed
	stateMachine.initialize(self)
	healthbar.update_hp(health, max_health)
	energybar.update_energy(energy, max_energy)
	$AnimatedSprite2D.material.set("shader_parameter/invert_colors", false)
	
func _process(_delta):
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if(health <= 0.0):
		emit_signal("death")
	
	if(dashCooldownTimer > 0.0):
		dashCooldownTimer -= _delta
	if(attackCooldownTimer > 0.0):
		attackCooldownTimer -= _delta
	
	if energy_active:
		energy_timer -= _delta
		if energy_timer <= 0.0:
			energy_active = false
			map.set_ghost_mode(false)
			attackCooldown = final_attackCooldown
			damage /= final_ghostMultiplier
			projectile_speed /= final_ghostMultiplier
			moveSpeed /= final_ghostMultiplier
			dashCooldown *= final_ghostMultiplier
			$AnimatedSprite2D.material.set("shader_parameter/invert_colors", false)

			print("Energy wieder aus")

	# Taste Q drücken
	if Input.is_action_just_pressed("switch_form"):
		activate_energy()

func _physics_process(_delta: float) -> void:
	move_and_slide()

func resetDashTimer():
	dashCooldownTimer = dashCooldown

func resetAttackTimer():
	attackCooldownTimer = attackCooldown

func setMoveAnimation():
	if(direction.x):
		if(direction.x == -1):
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		isFacing = Dir.SIDE
		sprite.play("LeftRigthMovement")
	elif(direction.y):
		if(direction.y == 1):
			isFacing = Dir.DOWN
			sprite.play("DownMovement")
		else:
			isFacing = Dir.UP
			sprite.play("UpMovement")

func setIdleAnimation():
	match isFacing:
		Dir.DOWN:
			sprite.play("DownIdle")
		Dir.SIDE:
			sprite.play("LeftRightIdle")
		Dir.UP:
			sprite.play("UpIdle")

func setDashAnimation():
	match isFacing:
		Dir.DOWN:
			sprite.play("DashDown")
		Dir.SIDE:
			sprite.play("DashSide")
		Dir.UP:
			sprite.play("DashUp")

func apply_potion(potion: PotionPickup) -> void:
	match potion.type:
		"Heal":
			heal(potion.amount)
			print_debug("New Health: " + str(health))
		"Energy":
			energy = clamp(energy+potion.amount, 0.0, max_energy)
			energybar.update_energy(energy, max_energy)
		"Damage":
			damage += potion.amount
			print_debug("New damage:" + str(damage))
		"Speed":
			moveSpeed += potion.amount
		"AttackSpeed":
			attackSpeed += potion.amount
		#add attackCooldown later

var bowNumber = 0

func increment_ally():
	bowNumber+=1
	print_debug("Number of bows in inventory: " + str(bowNumber))

func setAttackAnimation():
	sprite.play("Attack")

func centerPosition() -> Vector2:
	var center = global_position
	center.y -= 29.0
	return center

func shoot(dir:Vector2):
	var projectile = ice.instantiate()
	
	get_parent().add_child(projectile)
	projectile.damage = damage
	projectile.global_position = centerPosition()
	projectile.direction = dir
	projectile.speed = projectile_speed
	projectile.rotation = dir.angle()
	resetAttackTimer()
	
func take_damage(amount: int) -> void:
	health = max(health - amount, 0)
	healthbar.update_hp(health, max_health)
	emit_signal("took_damage")

func heal(amount: int) -> void:
	health = min(health + amount, final_max_health)
	healthbar.update_hp(health, final_max_health)
	

func activate_energy():
	if energy > 0 and not energy_active:
		energy -= 1
		energybar.update_energy(energy, max_energy)
		energy_active = true
		energy_timer = energy_duration
		map.set_ghost_mode(true) 
		attackCooldown = final_attackCooldown_ghost
		damage *= final_ghostMultiplier
		projectile_speed *= final_ghostMultiplier
		moveSpeed *= final_ghostMultiplier
		dashCooldown /= final_ghostMultiplier
		$AnimatedSprite2D.material.set("shader_parameter/invert_colors", true)

		print("Energy aktiviert für ", energy_duration, " Sekunden")

func die() -> void:
	var game_over_ui = get_tree().current_scene.get_node("GameOver")
	print(game_over_ui)
	game_over_ui.game_over()
