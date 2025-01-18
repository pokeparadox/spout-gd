extends Node2D
# The blok will define an area via Rect2 which can be a potential collision
# The area within is destructible and written to the buffer.
# The block is made up of 8x8 sub blocks due to the scaling
# The subblocks are drawn into the gameplay buffer
# The blocks are disabled as needed
# The disabled blocks are cleared from the gameplay buffer trying to reduce updates

var active : bool = false
var rectangle : Rect2
var pixels := {}

func set_dimensions(dims : Vector2) -> void:
	# Reseting the dimensions resets the pixels to be active
	rectangle.size = dims
	$DebugRect.set_dimensions(dims)
	var scale_dims := dims / State.zoom
	for y in range(scale_dims.y):
		for x in range(scale_dims.x):
			pixels[Vector2i(x, y)] = 2

# Hit the scaled LCD pixel
func hit_pixel(other_rect : Rect2) -> void:
	if get_parent().in_play_area(global_position):
		rectangle.position = global_position
		if rectangle.encloses(other_rect):
			# Only do per pixel checks if we pass the rectangle check
			# We need to figure out th scaled position of the other rect
			var hit_pos : Vector2 = other_rect.position - global_position
			var scaled_hit_pos : Vector2 = hit_pos / State.zoom
			# Now we have the scaled hit position we can destroy the pixel in this position
			var key : Vector2i = Vector2i(scaled_hit_pos + Vector2(0.5, 0.5))
			if pixels.has(key):
				pixels.erase(key)

func _process(_delta: float) -> void:
	if get_parent().in_play_area(global_position + rectangle.size):
		#run through the dictionary and draw the pixels
		var half_vec := Vector2(0.5,0.5)
		var scale_dims = (rectangle.size / State.zoom) + half_vec
		var scale_pos = (global_position / State.zoom) + half_vec
		for y in range(scale_dims.y):
			for x in range(scale_dims.x):
				var key : Vector2i = Vector2i(x, y)
				var pos : Vector2i = Vector2i(scale_pos) + key
				if get_parent().in_play_area((scale_pos + half_vec) * State.zoom):
					if pixels.has(key):
						Buffers.set_pixel(pos, 2)

# Deal with block entering and exiting the play area and being destroyed
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	active = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if active:
		active = false
		queue_free()
