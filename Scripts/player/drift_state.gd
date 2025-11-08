extends State

func process_state(_delta) -> String:
	if Input.is_action_pressed("move_forward"):
		return "Accelerate"
	if Input.is_action_pressed("move_backward"):
		return "Reverse"
	if not Input.is_action_pressed("brake"):
		return "Idle"

	player.acceleration = Vector2.ZERO
	player.current_friction_mult = player.friction_brake_factor
	player.current_traction = player.traction_brake
	
	return ""
