# res://scripts/enemies/hand_bullet.gd
extends Area2D

@export var speed: float = 360.0
@export var damage: int = 1
@export var lifetime: float = 2.0
@export var frames_in_strip: int = 16   # Kachelanzahl in boss_hand.png
@export var random_frame: bool = true
@export var spin_deg_per_sec: float = 0.0

var _vel := Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite       # Node-Name "Sprite" in der Szene
@onready var lifetime_timer: Timer = $Lifetime

func launch(start_pos: Vector2, dir: Vector2, dmg: int = -1) -> void:
	global_position = start_pos
	_vel = dir.normalized() * speed
	rotation = dir.angle()
	if dmg >= 0: damage = dmg

func _ready() -> void:
	z_index = 100
	if sprite and sprite.texture:
		sprite.hframes = frames_in_strip
		sprite.vframes = 1
		sprite.frame = (randi() % frames_in_strip) if random_frame else 0
		sprite.centered = true

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not lifetime_timer.timeout.is_connected(_on_Lifetime_timeout):
		lifetime_timer.timeout.connect(_on_Lifetime_timeout)

	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()

func _physics_process(delta: float) -> void:
	position += _vel * delta
	if spin_deg_per_sec != 0.0:
		rotation_degrees += spin_deg_per_sec * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()   # nur bei Player-Hit zerstören

func _on_Lifetime_timeout() -> void:
	queue_free()
