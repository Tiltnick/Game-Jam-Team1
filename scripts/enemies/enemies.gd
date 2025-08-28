extends CharacterBody2D

const speed = 200
@export var chest: Node2D
@onready var navAgent := $NavigationAgent2D as NavigationAgent2D

func _physics_process(_delta: float) -> void:
	var dir = (chest.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()
