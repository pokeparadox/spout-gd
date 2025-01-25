extends Node2D

class_name Particle

signal particle_dead

var min_pos : Vector2 = Vector2.ZERO
var max_pos : Vector2 = Vector2.INF
var direction_vec : Vector2 = Vector2.ZERO
var resistance : float = 1.0
var last_float_pos : Vector2 = Vector2.INF
var last_buff_pos : Vector2i = Vector2.INF
var rectangle : Rect2 = Rect2(Vector2.ZERO, Vector2i(8,8))
@export var colour_byte: int


func _ready() -> void:
	$Animation.play("ParticleFade")

func _physics_process(delta):
	direction_vec *= resistance
	# Storing the previous position let's us calculate the floats but render to nearest integer
	if last_float_pos != Vector2.INF:
		position = last_float_pos

	var z = State.zoom
	position.y += float(State.gravity * float(z) * 0.31)
	position += direction_vec * z * delta

	var max_value = 48 * z
	if direction_vec.x < -max_value:
		direction_vec.x = -max_value
	elif direction_vec.x > max_value:
		direction_vec.x = max_value

	if direction_vec.y < -max_value:
		direction_vec.y = -max_value
	elif direction_vec.y > max_value:
		direction_vec.y = max_value

	#if global_position.y < min_pos.y:
	#	global_position.y = min_pos.y
	#	direction_vec.y = -direction_vec.y
	if global_position.y > max_pos.y:
		global_position.y = max_pos.y
		direction_vec.y = -direction_vec.y
	if global_position.x < min_pos.x:
		global_position.x = min_pos.x
		direction_vec.x = -direction_vec.x
	elif global_position.x > max_pos.x:
		global_position.x = max_pos.x
		direction_vec.x = -direction_vec.x

func _process(delta: float) -> void:
	last_float_pos = position
	position = Vector2i(position/State.zoom + (Vector2(0.5,0.5))) * State.zoom

func hit():
	visible = false
	emit_signal("particle_dead")
	queue_free()


func _on_animation_animation_finished(_anim_name):
	hit()
