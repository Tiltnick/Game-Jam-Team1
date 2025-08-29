class_name PlayerStateMachine extends Node

@onready var hurt:State = $Hurt
@onready var death:State = $Death
var states:Array[State]
var prevState:State
var currentState:State

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta):
	var s = currentState.process(delta)
	changeState(s)
	pass

func _physics_process(delta: float) -> void:
	changeState(currentState.physics(delta))
	pass

func _unhandled_input(event: InputEvent) -> void:
	changeState(currentState.handleInput(event))
	pass

func initialize(_player:Player) -> void:
	states = []
	
	for s in get_children():
		if s is State:
			states.append(s) 
	
	if states.size() != 0:
		states[0].player = _player
		changeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT

func changeState(newState:State) -> void:
	if newState == null || newState == currentState:
		return
	
	if currentState:
		currentState.exit()
	prevState = currentState
	currentState = newState
	currentState.enter()


func _on_player_took_damage() -> void:
	changeState(hurt)


func _on_player_death() -> void:
	changeState(death)
