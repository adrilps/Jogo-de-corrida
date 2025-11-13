extends State

@onready var timer = $Timer as Timer

func enter():
	timer.start()

func process_state(_delta) -> String:
	player.acceleration = Vector2.ZERO
	player.current_friction_mult = 1.0
	player.current_traction = player.traction_slipping
	
	return ""

func _on_timer_timeout() -> void:
	if player.current_state.name == "Slip":
		player.change_state("Idle")
