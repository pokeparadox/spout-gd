extends Node2D


var is_moving : bool = true
const scroll_speed : float = 100.0

func _physics_process(delta: float) -> void:
	if is_moving:
		if $SpawnTimer.is_stopped():
			$SpawnTimer.start()
		$BlockContainer.position.y += scroll_speed * delta
	else:
		$SpawnTimer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	$BlockContainer.spawn_blocks()
