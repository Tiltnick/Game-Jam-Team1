extends CharacterBody2D

const speed = 200
@export var chest: Node2D
@onready var navAgent := $NavigationAgent2D as NavigationAgent2D

func _ready() -> void:
	makePath()

func _physics_process(_delta: float) -> void:
	var dir = to_local(navAgent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()
	
func makePath() -> void:
	navAgent.target_position = chest.global_position
	
func _on_timer_timeout():
	makePath()
