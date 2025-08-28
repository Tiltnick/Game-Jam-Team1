class_name Player extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var stateMachine:PlayerStateMachine = $StateMachine
@onready var healthbar = get_parent().get_node("Health")
@export var moveSpeed:float = 150.0
@export var max_health:float = 20.0
@export var health: float = 20.0
@export var attackSpeed:float = 50.0
@export var damage:float = 50.0
@export var max_energy:float = 100.0
@export var energy:float = 100.0
@export var attackCooldown: float = 0.5


var direction: Vector2 = Vector2.ZERO
enum Dir {DOWN, SIDE, UP}
var isFacing = Dir.DOWN


func _ready():
	stateMachine.initialize(self)
	healthbar.update_hp(health, max_health)

func _process(delta):
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	

func _physics_process(delta: float) -> void:
	move_and_slide()


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

func take_damage(amount: int) -> void:
	health = max(health - amount, 0)
	healthbar.update_hp(health, max_health)

func heal(amount: int) -> void:
	health = min(health + amount, max_health)
	healthbar.update_hp(health, max_health)
