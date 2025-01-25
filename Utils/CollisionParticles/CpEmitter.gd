extends Node2D

@export var emitting : bool = true
@export var max_particles : int = 500
@export var spread : float = 0
@export var angle_rad : float = 0
@export var angle_invert : bool = false
@export var speed : float = 100
@export var delay : float = 0.032
@export var resistance : float = 0.99

const ParticlesGroupName : String = "Particles"

var spawn_position : Vector2 = Vector2.ZERO
var num_particles : int = 0
var cumulative_delta : float = 0
const Particle := preload("res://Utils/CollisionParticles/CpParticle.tscn")

func set_boundary(min_pos: Vector2, max_pos : Vector2) -> void:
	$MinPos.global_position = min_pos
	$MaxPos.global_position = max_pos

func _physics_process(delta):
	cumulative_delta += delta
	if cumulative_delta > delay:
		cumulative_delta = 0
		spawn_particle()

#	for p in get_children():
#		p.set_position_offset(global_position)

func on_particle_dead():
	num_particles -= 1

func spawn_particle():
	if emitting and num_particles < max_particles:
		var p = Particle.instantiate()
		p.global_position = spawn_position
		p.min_pos = $MinPos.global_position
		p.max_pos = $MaxPos.global_position
		p.resistance = resistance
		var jitter : float = angle_rad + randf_range(1 - spread, spread) *0.03
		p.direction_vec = Vector2(-sin(jitter) * speed, cos(jitter ) * speed)
		p.connect("particle_dead", on_particle_dead)
		p.add_to_group(ParticlesGroupName)
		add_child(p)
		num_particles += 1
