extends CharacterBody2D

const speed = 200
@export var player: Node = null
@onready var navAgent := $NavigationAgent2D as NavigationAgent2D

func _ready() -> void:
	navAgent.target_position = player.global_position

func _physics_process(_delta: float) -> void:
	if !navAgent.is_target_reached():
		var navPointDirection = to_local(navAgent.get_next_path_position()).normalized()
		velocity = navPointDirection * speed
		move_and_slide()
		
		
func _on_timer_timeout():
	if navAgent.target_position != player.global_position:
		navAgent.target_position = player.global_position
	$Timer.start()
