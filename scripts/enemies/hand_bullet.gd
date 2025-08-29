extends Area2D

@export var speed: float = 360.0
@export var damage: int = 1
@export var lifetime: float = 5
@export var spin_deg_per_sec: float = 0.0

# Für AnimatedSprite2D:
@export var animation_name: StringName = &"default"
@export var random_start_frame: bool = true
@export var play_animation: bool = true

var _vel: Vector2 = Vector2.ZERO

@onready var sprite_node: Node = get_node_or_null("Sprite")  
@onready var lifetime_timer: Timer = $Lifetime
@onready var colshape: CollisionShape2D = $CollisionShape2D

func launch(start_pos: Vector2, dir: Vector2, dmg: int = -1) -> void:
	var d := dir.normalized()

	#Spawn-Offset
	var gap := 16.0
	if colshape and colshape.shape is RectangleShape2D:
		var r := colshape.shape as RectangleShape2D
		gap = max(r.extents.x, r.extents.y) * 0.6

	global_position = start_pos + d * gap
	rotation = d.angle()
	_vel = d * speed
	if dmg >= 0:
		damage = dmg
	set_deferred("monitoring", false)
	await get_tree().process_frame
	monitoring = true

func _ready() -> void:
	z_as_relative = false
	z_index = 200

	
	if sprite_node:
		if sprite_node is AnimatedSprite2D:
			var anim := sprite_node as AnimatedSprite2D
			anim.centered = true
			if animation_name != StringName():
				anim.animation = animation_name
			if random_start_frame and anim.sprite_frames:
				var cnt := anim.sprite_frames.get_frame_count(anim.animation)
				if cnt > 0:
					anim.frame = randi() % cnt
			if play_animation:
				anim.play()
			else:
				anim.stop()
		elif sprite_node is Sprite2D:
			var spr := sprite_node as Sprite2D
			spr.centered = true

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not lifetime_timer.timeout.is_connected(_on_timeout):
		lifetime_timer.timeout.connect(_on_timeout)

	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()

func _physics_process(delta: float) -> void:
	position += _vel * delta
	if spin_deg_per_sec != 0.0:
		rotation_degrees += spin_deg_per_sec * delta

func _on_body_entered(body: Node) -> void:
	# Wichtig: CollisionMask des Projektils im Inspector nur auf "player" setzen!
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()

func _on_timeout() -> void:
	queue_free()
