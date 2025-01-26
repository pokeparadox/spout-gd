extends Node2D

const FrameRate : int = 50
const MaxGrain : int = 500

var box : Vector2i
var mPos : Vector2i
var mSpeed : Vector2i
var mR : int
var nGrain : int
var timeSpout : int = FrameRate * 60

var dispPos : int
var upperLine : int
var rollCount : int


var gx : Array[int] = [-2, 2, -1, 1, 0]
var gPhase : int = 0

func pceLcdDisplayStart() -> void:
	Fonts.set_buffer(Buffers.display_buff)
	$Screen.init_screen(Buffers.LcdWidth, Buffers.LcdHeight, 8)

func loadHiScore() -> void:
	pass

var pallete : Array[Color] = [
	# Normal colours
	Color.WHITE,
	Color8(168, 168, 168),
	Color8(96, 96, 96),
	Color.BLACK,
	# Spout colours
	Color8(214, 230, 78),
	Color8(240, 18, 18),
	Color8(28, 3, 3),
	Color8(0, 0, 0),
]

func pceLcdTrans() -> void:
	for y in range(Buffers.LcdHeight):
		for x in range(Buffers.LcdWidth):
			$Screen.set_pixel(x, y, pallete[Buffers.display_buff[y * Buffers.LcdWidth + x]])
	# Clear buffer after transfer
	var r := range(2 * Buffers.LcdWidth, Buffers.LcdWidth * Buffers.LcdHeight - (10 * 128))
	for i in r:
		Buffers.display_buff[i] = 0

func pceAppInit() -> void:
	loadHiScore()

func _ready() -> void:
	pceLcdDisplayStart()
	pceAppInit()

func writeHiScores() -> void:
	# TODO Save and load score file
	pass


		# Title Demo
#		mPos.x = 7 * 256
#		mPos.y = 60 * 256
#		mR = 0
#
#		if (rollCount & 7) == 0:
#			if upperLine & 31 == 0:
#				pL.address = (12+((upperLine - 24) & 127) * 128)
#				Buffers.pceLcdSetBuffer(Buffers.vBuff2, ((upperLine - 24) & 127) * 128)
#				Buffers.vBuffer = Buffers.vBuff2
#				Fonts.pceFontSetBkColour(0)
#				match upperLine / 32:
#					0:
#						pL.address = 12+((upperLine - 24) & 127) * 128
#						for i in range(16):
#							for j in range(26 / 2):
#								pL.set_uint(0x91919191)
#								pL.inc(2)
#								j += 1
#							if (i & 7) == 3:
#								pL.inc(7)
#							elif (i & 7) == 7:
#								pL.inc(5)
#							else:
#								pL.inc(6)
#						Fonts.pceFontSetTxColour(0x03)
#						Fonts.pceFontSetType(1)
#						Fonts.pceFontSetPos(64 - 4 * 5, 0)
#						Fonts.pceFontPrintF("spout")
#					2:
#						Fonts.pceFontSetTxColour(0xc3)
#						Fonts.pceFontSetType(2)
#						Fonts.pceFontSetPos(118 - 20 * 4, 0);
#						Fonts.pceFontPrintF("    height: %8d", [State.hiScore[1] % 1000000])
#						Fonts.pceFontSetPos(118 - 20 * 4, 6)
#						Fonts.pceFontPrintF("high-score: %8d", [State.hiScore[0] % 1000000])
#					1:
#						pD.address = ((upperLine - 16) & 127) * 128
#						for i in range(128 / 8 * 10):
#							var t : int = pS.get_inc()
#							for j in range(8):
#								if t & 0x80:
#									pD.set_ubyte(0xc3)
#								pD.inc()
#								t <<= 1
#				Fonts.pceFontSetType(0)
#				Fonts.pceFontSetTxColour(0x03)
#				Fonts.pceFontSetBkColour(0)
#				Buffers.pceLcdSetBuffer(Buffers.vBuff)
#			upperLine = (upperLine - 1) & 127
##			sweep(0x13, 0x00)
#		rollCount += 1
		############
func _process(delta: float) -> void:
	#draw_test()
	#pceAppProc()
	pceLcdTrans()


# Both of these events signify gameover
func _on_ship_died() -> void:
	$Status.pause_timer()
	_on_status_out_of_time()

func _on_status_out_of_time() -> void:
	$Ship.active = false
	State.gameover = true
	Fonts.set_buffer(Buffers.display_buff)
	Fonts.pceFontSetType(2)
	Fonts.pceFontSetPos(64 - 11 * 4 / 2, 33)
	Fonts.pceFontPrintF(" game over ")
	Fonts.pceFontSetPos(64 - 11 * 4 / 2, 43)
	Fonts.pceFontPrintF("PRESS START")
	Fonts.pceFontSetType(0)

func _on_ship_level_up() -> void:
	if State.increase_height():
		$Status.add_bonus_time()
	$Status.update_score()

	# Return is just to avoid a crash that is in the below broken code
	return
#	if State.upper_line == 111 and State.height > 0:
#		pL.data = Buffers.vBuff2
#		pL.address =  128 * 108 + 4
#		while pL.address < ((128 * 109 -4) * 4):
#			pL.set_inc(0)
#		pL.inc(2)
#		while pL.address < (128 * 110 - 4):
#			pL.set_inc(0xd3d3d3d3)
#		pL.inc(2)
#		while pL.address < ((128 * 111 -4) * 4):
#			pL.set_inc(0)
#	box.x = (20 - (State.height + 40) / 64)
#	if box.x < 4:
#		box.x = 4
#	box.y = (20 - (State.height + 40) / 64)
#	if box.y < 4:
#		box.y = 4
#	pC.data = Buffers.vBuffer
#	pC.address = ((upperLine - 20 - (randi() & 7)) & 127) * 128
#	for j1 in range(1):
#		var x : int = 4 + (randi() % box.x)
#		var y : int = 4 + (randi() % box.y)
#		pC.address = (((upperLine - 20 - (randi() & 7)) & 127) * 128)
#		var x1 = 4 + (randi() % (120 -x))
#		var x2 = x
#		var i = y
#		while i > 0:
#			if pC.address < 0:
#				pC.inc(128 * 128)
#			pC.inc(x1)
#			var w = x2
#			while w > 0:
#				pC.set_inc(0)
#				w -= 1
#			pC.dec(x1 + x2 + 128)
#			i -= 1
#	sweep(0x13,0xd2)


func _physics_process(delta: float) -> void:
	$Exhaust/CpEmitter.spawn_position = $Ship.global_position
	$Obstacles.is_moving = $Ship.is_rising

func _on_ship_thrust_angle_change(angle_rad: float) -> void:
	$Exhaust.set_angle(angle_rad)


func _on_ship_thrust_change(thrusting: bool) -> void:
	$Exhaust.set_exhaust(thrusting)
