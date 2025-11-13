extends State

func enter():
	player.current_friction_mult = player.friction_brake_factor
	player.current_traction = player.traction_brake

func process_state(_delta: float) -> String:
	player.acceleration = Vector2.ZERO
	
	if player.velocity.length() > 10:
		player.current_friction_mult = player.friction_brake_factor
		player.current_traction = player.traction_brake
	else:
		player.current_friction_mult = 1.0
		player.current_traction = player.traction_slow
	
	return ""
