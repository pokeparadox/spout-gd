extends Node2D

signal out_of_time

var time_remaining : int = 60

func _ready() -> void:
	Fonts.set_buffer(Buffers.display_buff)
	Fonts.pceFontSetType(2)
	Fonts.pceFontSetPos(0, 82)
	if State.height > 0:
		Fonts.pceFontPrintF("Time:%2d Height:%4d Score:%6d", [time_remaining, State.height % 10000, State.score % 1000000])
	else:
		Fonts.pceFontPrintF("Time:%2d Height:   0 Score:%6d", [time_remaining, State.score % 1000000])
	Fonts.pceFontSetType(0)
	start_timer()

func start_timer() -> void:
	$Timer.start()
	time_remaining = 60

func stop_timer() -> void:
	$Timer.stop()
	time_remaining = 60

func pause_timer() -> void:
	$Timer.paused = true

func unpause_timer() -> void:
	$Timer.paused = false

func add_bonus_time() -> void:
	time_remaining += 60
	if time_remaining > 99:
		time_remaining = 99

func _on_timer_tick() -> void:
	time_remaining -= 1
	Fonts.set_buffer(Buffers.display_buff)
	Fonts.pceFontSetType(2)
	Fonts.pceFontSetPos(4*5, 82)
	Fonts.pceFontPrintF("%2d", [time_remaining])
	Fonts.pceFontSetType(0)
	State.time_remaining = time_remaining
	if time_remaining <= 0:
		stop_timer()
		emit_signal("out_of_time")

func update_score() -> void:
	Fonts.pceFontSetType(2)
	Fonts.pceFontSetPos(4 * 15, 82)
	Fonts.pceFontPrintF("%4d", [ State.height % 10000])
	Fonts.pceFontSetType(0)

	if State.dispScore < State.score:
		State.dispScore += 1
		if State.dispScore < State.score:
			State.dispScore += 1
		Fonts.pceFontSetType(2)
		Fonts.pceFontSetPos(4 * 26, 82)
		Fonts.pceFontPrintF("%6d", [State.dispScore % 1000000])
		Fonts.pceFontSetType(0)
