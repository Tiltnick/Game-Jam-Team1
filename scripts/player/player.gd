class_name Player extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var stateMachine:PlayerStateMachine = $StateMachine
@export var moveSpeed:float = 200.0
@export var max_health:float = 100.0
@export var health: float = 100.0
@export var attackSpeed:float = 50.0
@export var damage:float = 50.0
@export var max_energy:float = 100.0
@export var energy:float = 100.0
@export var attackCooldown: float = 1.0
@onready var healthbar = get_parent().get_node("Health")
@export var dashCooldown: float = 1.0

@export var projectile_speed:float = 700.0

@export var ice: PackedScene = preload("res://scenes/projectiles/ice.tscn")

var dashCooldownTimer: float = 0.0

var attackCooldownTimer: float = 0.0

var direction: Vector2 = Vector2.ZERO
enum Dir {DOWN, SIDE, UP}
var isFacing = Dir.DOWN


func _ready():
	stateMachine.initialize(self)
	healthbar.update_hp(health, max_health)

func _process(_delta):
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if(dashCooldownTimer > 0.0):
		dashCooldownTimer -= _delta
	if(attackCooldownTimer > 0.0):
		attackCooldownTimer -= _delta

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

func setAttackAnimation():
	sprite.play("Attack")

func shoot(dir:Vector2):
	var projectile = ice.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.global_position.y -= 29.0
	projectile.direction = dir
	projectile.speed = projectile_speed
	projectile.rotation = dir.angle()
	resetAttackTimer()
	
func take_damage(amount: int) -> void:
	health = max(health - amount, 0)
	healthbar.update_hp(health, max_health)

func heal(amount: int) -> void:
	health = min(health + amount, max_health)
	healthbar.update_hp(health, max_health)
	
