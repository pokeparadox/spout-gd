extends Node2D

signal died
signal level_up
signal thrust_change(thrusting)
signal thrust_angle_change(angle_rad)

var active : bool = true
var mPos : Vector2

var mSpeed : Vector2
var heading : float = deg_to_rad(45)
var direction : Vector2
var gPhase : int = 0
var rectangle : Rect2 = Rect2(Vector2i(8,8), Vector2i(8,8))

func reset() -> void:
	var z : int = State.zoom
	mPos.x = 7 * z
	mPos.y = 60 * z
	mSpeed.x = 0
	mSpeed.y = 0
	heading = deg_to_rad(45)
	State.gameover = false

func _ready() -> void:
	reset()

#index = y * width + x
func clear_thrust_vector() -> void:
	# Todo only clear previous position instead of full play field
	#var r := range(2 * Buffers.LcdWidth, Buffers.LcdWidth * Buffers.LcdHeight - (10 * 128))
	#for i in r:
	#	Buffers.display_buff[i] = 0
	pass

var Pad := GamePad.Pad
var Trg := GamePad.Trg
func _physics_process(delta: float) -> void:

	if active:
		var zoom : int = State.zoom

		if Input.is_action_pressed("ui_left"):
			heading -= 3.0 * delta
			emit_signal("thrust_angle_change", heading)
		elif Input.is_action_pressed("ui_right"):
			heading += 3.0 * delta
			emit_signal("thrust_angle_change", heading)
		direction = Vector2(sin(heading), -cos(heading))

		if Input.is_action_pressed("ui_accept"):
			mSpeed += direction * 4 * zoom
			emit_signal("thrust_change", true)
		else:
			mSpeed += direction * zoom * 0.8
			emit_signal("thrust_change", false)

		mSpeed.y += State.gravity * zoom
		mSpeed = mSpeed * delta
		# Limit Velocity
		if mSpeed.x < -64 * zoom:
			mSpeed.x = -64 * zoom
		elif mSpeed.x > 64 * zoom:
			mSpeed.x = 64 * zoom

		if mSpeed.y < -64 * zoom:
			mSpeed.y = -64 * zoom
		elif mSpeed.y > 64 * zoom:
			mSpeed.y = 64 * zoom

		# Apply velocity
		mPos += mSpeed * zoom
		# Check bounding collisions
		if mPos.x >= 125 * zoom:
			mPos.x = 124 * zoom
			State.gameover = true
		elif mPos.x <= 2 * zoom:
			mPos.x = 3 * zoom
			State.gameover = true
		if mPos.y >= 78 * zoom:
			mPos.y = 77 * zoom
			State.gameover = true

		if mPos.y < 40 * zoom:
			mPos.y = 40 * zoom
			emit_signal("level_up")
	#if State.gameover == false and (State.gamePhase == State.States.Game):
	direction = -direction
	var scaledPos := mPos / State.zoom

	# Check Gameover
	#var val : int = Buffers.vBuffer[(scaledPos.y * Buffers.LcdWidth) + scaledPos.x]
	#State.gameover = val != 0 and (val & 4) == 0

	clear_thrust_vector()
	var v : Vector2 = scaledPos + direction * gPhase
	var s : float = 6

	var index : int
	for i in range(3):
		if v.y >= 78:
			break
		index = int(v.x) + int(v.y) * Buffers.LcdWidth
		Buffers.display_buff[index] = 3
		v += direction / s
		if v.y >= 78:
			break
		index = int(v.x) + int(v.y) * Buffers.LcdWidth
		Buffers.display_buff[index] = 3
		v += direction / s
		if v.y >= 78:
			break
		index = int(v.x) + int(v.y) * Buffers.LcdWidth
		Buffers.display_buff[index] = 3
		v += direction * 2 / s
	gPhase = (gPhase + 1) % 9

	if State.gameover:
		emit_signal("died")


func _process(_delta: float) -> void:
	position = Vector2i(mPos/State.zoom + (Vector2(0.5,0.5))) * State.zoom
	#draw_ship() # copy buffer pixel
