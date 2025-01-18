extends Node2D

const Square := preload("res://Shapes/Square.tscn")
var screen_width : int = 1
var screen_height : int = 1
var pixels : Array[Square]
var zoom : int = 2

func init_screen(w : int, h : int, zm : int = 2, spacing : int = 0) -> void:
	zoom = zm
	screen_width = w
	screen_height = h
	for y in h:
		for x in w:
			var pixel = Square.instantiate()
			pixel.position = Vector2((x * zoom) + spacing, (y * zoom) + spacing) + (Vector2(zoom-spacing, zoom-spacing) * 0.5)
			pixel.length = zoom-spacing
			pixel.colour = Color.BLACK
			pixels.append(pixel)
			add_child(pixel)

func set_pixel(x : int, y : int, colour : Color) -> void:
	var index : int = (y * screen_width) + x
	if pixels[index].colour != colour:
		pixels[index].colour = colour
