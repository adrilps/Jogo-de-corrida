extends State

func enter():
	player.slip_timer.start()

func process_state(_delta) -> String:
	player.acceleration = Vector2.ZERO
	player.current_friction_mult = 1.0
	player.current_traction = player.traction_slipping
	
	return ""
