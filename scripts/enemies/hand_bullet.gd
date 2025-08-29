# res://scripts/hand_bullet.gd
extends Area2D

@export var speed: float = 360.0
@export var damage: int = 1
@export var lifetime: float = 2.0
@export var spin_deg_per_sec: float = 0.0
var _vel := Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $sprite
@onready var lifetime_timer: Timer = $Lifetime

func _ready() -> void:
	if not body_entered.is_connected(_on_hand_bullet_body_entered):
		body_entered.connect(_on_hand_bullet_body_entered)
	if not lifetime_timer.timeout.is_connected(_on_Lifetime_timeout):
		lifetime_timer.timeout.connect(_on_Lifetime_timeout)

func launch(start_pos: Vector2, dir: Vector2, dmg: int = damage) -> void:
	global_position = start_pos
	damage = dmg
	_vel = dir.normalized() * speed
	rotation = dir.angle()

	# optional: zufälliger Frame aus "hand"-Animation
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("hand"):
		sprite.play("hand")
		sprite.frame = randi() % sprite.sprite_frames.get_frame_count("hand")

	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()

func _physics_process(delta: float) -> void:
	position += _vel * delta
	if spin_deg_per_sec != 0.0:
		rotation_degrees += spin_deg_per_sec * delta

func _on_Lifetime_timeout() -> void:
	queue_free()

func _on_hand_bullet_body_entered(body: Node) -> void:
	if body.is_in_group("boss"):
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
