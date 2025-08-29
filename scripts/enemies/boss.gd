# res://scripts/boss.gd
extends CharacterBody2D

@export var projectile_scene: PackedScene         # -> hand_bullet.tscn zuweisen
@export var attack_interval: float = 1.2
@export var burst_count: int = 3
@export var burst_delay: float = 0.12
@export var bullet_damage: int = 1
@export var muzzle_forward_offset: float = 20.0   # NICHT im Boss spawnen

@export var player_path: NodePath                 # optional; sonst Gruppe "player"

@onready var muzzle: Node2D = get_node_or_null("Muzzle")
@onready var atk_timer: Timer = $AttackTimer

var player: Node2D

func _ready() -> void:
	# Player suchen
	if player_path != NodePath():
		player = get_node_or_null(player_path)
	if player == null:
		player = get_tree().get_first_node_in_group("player") as Node2D

	# Timer absichern
	if atk_timer == null:
		atk_timer = Timer.new()
		add_child(atk_timer)
	atk_timer.wait_time = attack_interval
	if not atk_timer.timeout.is_connected(_on_attack):
		atk_timer.timeout.connect(_on_attack)
	atk_timer.start()

func _on_attack() -> void:
	if player == null or projectile_scene == null:
		# Debug hilft: print("Boss: kein Player/Projectile")
		atk_timer.start()
		return
	await _attack_burst_aimed()
	atk_timer.start()

func _attack_burst_aimed() -> void:
	var origin := muzzle.global_position if muzzle and is_instance_valid(muzzle) else global_position
	var dir := (player.global_position - origin).normalized()
	var start_pos := origin + dir * muzzle_forward_offset  # vor den Boss setzen

	for i in burst_count:
		var b = projectile_scene.instantiate()
		get_tree().current_scene.add_child(b)
		if b.has_method("launch"):
			b.launch(start_pos, dir, bullet_damage)
		await get_tree().create_timer(burst_delay).timeout
