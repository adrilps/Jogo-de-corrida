extends State

func process_state(_delta: float) -> String:
	if Input.is_action_pressed("move_forward"):
		return "Accelerate"
	if not Input.is_action_pressed("move_backward"):
		return "Idle"
	if Input.is_action_pressed("brake"):
		return "Drift"
	
	if player.current_fuel > 0:
		player.current_fuel = max(0.0, player.current_fuel - player.fuel_rate * _delta)
	
	player.acceleration = player.transform.x * player.reverse_speed
	player.current_friction_mult = 1.0
	player.current_traction = player.traction_slow
	
	return ""
