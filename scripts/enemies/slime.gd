extends CharacterBody2D

@export var speed: float = 200.0
@export var retarget_interval: float = 0.2

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer

var player: Node2D = null   # Ziel (z. B. ChestTarget)

func set_target(t: Node2D) -> void:
	player = t
	if is_instance_valid(player):
		nav_agent.target_position = player.global_position
		# print("Slime target set:", player.name, "@", player.global_position)

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

	# Navigation-Agent Grundsetup
	nav_agent.radius = 12.0
	nav_agent.path_desired_distance = 10.0
	nav_agent.target_desired_distance = 14.0
	nav_agent.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_CORRIDORFUNNEL
	nav_agent.avoidance_enabled = true
	nav_agent.max_speed = speed
	nav_agent.velocity_computed.connect(_on_nav_velocity_computed)

	# Timer verbinden & starten (nur falls vorhanden)
	if timer:
		timer.wait_time = retarget_interval
		timer.timeout.connect(_on_timer_timeout)
		timer.start()

func _process(_dt: float) -> void:
	if is_instance_valid(player):
		nav_agent.target_position = player.global_position

func _physics_process(_dt: float) -> void:
	if player == null:
		return

	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		# TODO: Base-Schaden / Game-Over-Logik hier einbauen
		queue_free()
		return

	var next_pos: Vector2 = nav_agent.get_next_path_position()
	var desired := (next_pos - global_position).normalized() * speed
	nav_agent.set_velocity(desired)

func _on_nav_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func _on_timer_timeout() -> void:
	if is_instance_valid(player):
		if nav_agent.target_position.distance_to(player.global_position) > 2.0:
			nav_agent.target_position = player.global_position
