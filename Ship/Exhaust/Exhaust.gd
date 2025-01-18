extends Node2D

@export var default_particles : int = 100
@export var max_particles : int = 500
@export var default_spread : float = 2.0
@export var max_spread : float = 45.0

func _ready() -> void:
	$CpEmitter.spread = 8
	$CpEmitter.set_boundary( Vector2(32, 16), Vector2(992, 622))

func set_exhaust(exhaust : bool) -> void:
	$CpEmitter.emitting = exhaust

func set_angle(a_rad : float) -> void:
	$CpEmitter.angle_rad = a_rad
