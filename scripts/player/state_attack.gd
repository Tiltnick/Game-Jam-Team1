class_name State_Attack extends State
var screen_center = Vector2(1920.0/2.0, 1080.0/2.0)  # Bildschirmmitte
@onready var idle:State = $"../Idle"
var attackTimer:float = 0.0

func enter() -> void:
	player.setAttackAnimation()
	attackTimer = 0.3
	player.velocity = Vector2.ZERO
	
	var mousePos = get_viewport().get_mouse_position()
	var mouseWorld = mousePos - screen_center 
	var relative = mouseWorld - player.centerPosition()
	if relative.x >= 0:
		player.sprite.flip_h = false
	else:
		player.sprite.flip_h = true
	player.shoot(relative.normalized())
	print("PlayerPos: " + str(player.position))
	print("mousePos: " + str(mousePos))
	print("relative: " + str(relative))
	pass

func exit() -> void:
	pass

func process(_delta:float) -> State:
	attackTimer -= _delta
	if(attackTimer <= 0.0):
		return idle
	return null

func physics(_delta:float) -> State:
	return null

func handleInput(_event:InputEvent) -> State:
	return null
