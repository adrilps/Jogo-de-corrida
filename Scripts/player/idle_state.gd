extends State

func process_state(_delta: float) -> String:
	if Input.is_action_pressed("move_forward"):
		return "Accelerate"
	if Input.is_action_pressed("move_backward"):
		return "Reverse"
	if Input.is_action_pressed("brake"):
		return "Drift"
	
	player.acceleration = Vector2.ZERO
	player.current_friction_mult = 1.0
	
	if player.velocity.length() > player.slip_speed:
		player.current_traction = player.traction_fast
	else:
		player.current_traction = player.traction_slow
	
	return ""
