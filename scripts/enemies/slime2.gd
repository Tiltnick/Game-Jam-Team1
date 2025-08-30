extends CharacterBody2D

@export var speed: float = 130.0
@export var retarget_interval: float = 0.2
@export var contact_damage: int = 1
@export var attack_distance: float = 32.0

@export var potion_scene: PackedScene
@export var potion_datas: Array[PotionPickup] = []

@export var ally_scene: PackedScene
@export var ally_datas: Array[AllyPickup] = []

@export var potion_drop_chance = 0.50
@export var item_drop_chance = .30

@onready var _rng := RandomNumberGenerator.new()

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@export var playerTarget: PackedScene

var player: Node2D = null     # Ziel (ChestTarget)
var _has_attacked: bool = false

func set_target(t: Node2D) -> void:
	player = t
	if is_instance_valid(player) and nav_agent:
		nav_agent.target_position = player.global_position

func _ready() -> void:
	_rng.randomize()
	modulate = Color(0.9, 0.4, 0.4)
	add_to_group("enemy")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

	# Agent-Setup
	nav_agent.radius = 12.0
	nav_agent.path_desired_distance = 10.0
	nav_agent.target_desired_distance = 14.0
	nav_agent.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_CORRIDORFUNNEL
	nav_agent.avoidance_enabled = true
	nav_agent.max_speed = speed
	nav_agent.velocity_computed.connect(_on_nav_velocity_computed)

	# Timer
	if timer:
		timer.wait_time = retarget_interval
		if not timer.timeout.is_connected(_on_timer_timeout):
			timer.timeout.connect(_on_timer_timeout)
		timer.start()

func _process(_dt: float) -> void:
	if is_instance_valid(player):
		nav_agent.target_position = player.global_position
	
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			attack()
	if attackTimer > 0.0:
		attackTimer -= _dt

func _physics_process(_dt: float) -> void:
	if player == null or _has_attacked:
		return

	if not nav_agent.is_navigation_finished():
		var next_pos := nav_agent.get_next_path_position()
		var desired := (next_pos - global_position).normalized() * speed
		nav_agent.set_velocity(desired)
	else:
		_try_attack()

	if is_instance_valid(player):
		var d := global_position.distance_to(player.global_position)
		if d <= attack_distance:
			_try_attack()

func _on_nav_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func _on_timer_timeout() -> void:
	if is_instance_valid(player):
		if nav_agent.target_position.distance_to(player.global_position) > 2.0:
			nav_agent.target_position = player.global_position

func _try_attack() -> void:
	if _has_attacked or player == null:
		return
	_has_attacked = true

	print("[SLIME] try attack -> has take_damage():", player.has_method("take_damage"))
	if player.has_method("take_damage"):
		player.take_damage(contact_damage)
	else:
		print("[SLIME] Ziel hat keine take_damage-Methode!")

	queue_free()

@export var health = 3.0

func takeDamage(amount:float):
	health -= amount
	if health <= 0.0:
		death()

func death():
	if _rng.randf() < potion_drop_chance:
		drop_potion()

	elif _rng.randf() < item_drop_chance:
		drop_ally()
	
	queue_free()
	

func drop_ally():
	if ally_datas == null:
		return
	#_rng.randi_range(0, ally_datas.size()-1)
	var chosen = ally_datas[0]
	
	if chosen == null:
		return
	var pickup = ally_scene.instantiate()
	
	pickup.ally = chosen
	
	pickup.global_position = global_position
	var parent = get_parent()
	
	if parent:
		parent.add_child(pickup)
	else:
		get_tree().current_scene.add_child(pickup)

func drop_potion() -> void:
	if potion_datas == null:
		return
	
	var chosen = potion_datas[_rng.randi_range(0, potion_datas.size()-1)]
	
	if chosen == null:
		return
	
	var pickup = potion_scene.instantiate()
	
	pickup.potion = chosen
	
	pickup.global_position = global_position
	var parent = get_parent()
	
	if parent:
		parent.add_child(pickup)
	else:
		get_tree().current_scene.add_child(pickup)

var attackCooldown:float = 1.0
@onready var area:Area2D = $Area2D
var attackTimer:float = 0.0

func attack():
	if attackTimer <= 0.0:
		player.take_damage(1)
		attackTimer = attackCooldown
