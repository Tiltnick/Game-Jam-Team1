# res://scripts/enemies/slime.gd
extends CharacterBody2D

@export var speed: float = 1000.0
@export var retarget_interval: float = 0.2
@export var contact_damage: int = 1
@export var attack_cooldown: float = 0.6

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var retarget_timer: Timer = get_node_or_null("RetargetTimer")
@onready var attack_timer: Timer = get_node_or_null("AttackTimer")

var target: Node2D

func set_target(t: Node2D) -> void:
	target = t
	if is_instance_valid(target):
		nav_agent.target_position = target.global_position

func _ready() -> void:
	add_to_group("enemy")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	nav_agent.radius = 12.0
	nav_agent.path_desired_distance = 10.0
	nav_agent.target_desired_distance = 16.0
	nav_agent.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_CORRIDORFUNNEL
	nav_agent.avoidance_enabled = true
	nav_agent.max_speed = speed
	if not nav_agent.velocity_computed.is_connected(_on_nav_velocity_computed):
		nav_agent.velocity_computed.connect(_on_nav_velocity_computed)

	if retarget_timer == null:
		retarget_timer = Timer.new(); retarget_timer.name = "RetargetTimer"; add_child(retarget_timer)
	retarget_timer.wait_time = retarget_interval
	if not retarget_timer.timeout.is_connected(_on_retarget):
		retarget_timer.timeout.connect(_on_retarget)
	retarget_timer.start()

	if attack_timer == null:
		attack_timer = Timer.new(); attack_timer.name = "AttackTimer"; add_child(attack_timer)
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true

func _physics_process(_d: float) -> void:
	if target == null:
		velocity = Vector2.ZERO; move_and_slide(); return
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO; move_and_slide(); _try_attack(); return
	var next_pos := nav_agent.get_next_path_position()
	var desired := (next_pos - global_position).normalized() * speed
	nav_agent.set_velocity(desired)
	if global_position.distance_to(nav_agent.target_position) <= nav_agent.target_desired_distance + 4.0:
		_try_attack()

func _on_nav_velocity_computed(v: Vector2) -> void:
	velocity = v; move_and_slide()

func _on_retarget() -> void:
	if target: nav_agent.target_position = target.global_position

func _try_attack() -> void:
	if attack_timer.time_left > 0.0: return
	if target and target.has_method("take_damage"):
		target.take_damage(contact_damage)
	attack_timer.start()
