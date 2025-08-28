class_name State_Dash extends State

@onready var idle:State = $"../Idle"
@export var dashSpeed: float = 800.0
@export var dashDuration: float = 0.3

var dashDir:Vector2 = Vector2.DOWN
var left:bool = true

var dashTimer:float  = 0.0

func enter() -> void:
	
	player.setDashAnimation()
	match player.isFacing:
		Player.Dir.DOWN:
			player.velocity = Vector2.DOWN * dashSpeed
		Player.Dir.SIDE:
			if(player.direction.x == -1):
				player.velocity = Vector2.LEFT * dashSpeed
			else:
				player.velocity = Vector2.RIGHT * dashSpeed
		Player.Dir.UP:
			player.velocity = Vector2.UP * dashSpeed
	dashTimer = dashDuration
	player.resetDashTimer()
	pass

func exit() -> void:
	pass

func process(_delta:float) -> State:
	
	return null

func physics(_delta:float) -> State:
	dashTimer -= _delta
	if dashTimer <= 0:
		return idle
	 
	return null

func handleInput(_event:InputEvent) -> State:
	
	return null
