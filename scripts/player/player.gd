class_name Player extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var stateMachine:PlayerStateMachine = $StateMachine
@export var moveSpeed:float = 150.0
@export var max_health:float = 100.0
@export var health: float = 100.0
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

func apply_potion(potion: PotionPickup) -> void:
	print_debug(potion.type)
	print_debug("Entered apply potion function")
	match potion.type:
		"Heal":
			health = clamp(health+potion.amount, 0.0, max_health)
			print_debug("New Health: " + str(health))
		"Energy":
			energy = clamp(energy+potion.amount, 0.0, max_energy)
		"Damage":
			damage += potion.amount
			print_debug("New damage:" + str(damage))
		"Speed":
			moveSpeed += potion.amount
		"AttackSpeed":
			attackSpeed += potion.amount
		#add attackCooldown later
