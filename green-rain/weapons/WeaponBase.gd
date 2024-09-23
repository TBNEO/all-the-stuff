extends Node3D
class_name Weapon

@export var Damage: int = 1
@export var FireRate: float = 0.5

@export var AltBladeDamage: int = 2
@export var AltBladeCooldown: float = 2.0

@export var Attack_Callable: String = "fire"
@export var AltBlade_Callable: String = "alt_fire"

var attacklock: bool = false
var altbladelock: bool = false

func _unhandled_input(_event):
	if Input.is_action_pressed("click")and has_method(Attack_Callable) and not attacklock:
		call(Attack_Callable)
		firerate_lock()
	elif Input.is_action_just_pressed("altclick")and has_method(AltBlade_Callable) and not altbladelock:
		call(AltBlade_Callable)
		firerate_lock()

func firerate_lock():
	attacklock = true
	await get_tree().create_timer(FireRate).timeout
	attacklock = false

func altblade_lock():
	altbladelock = true
	await get_tree().create_timer(AltBladeCooldown).timeout
	altbladelock = false
