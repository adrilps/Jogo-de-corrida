extends Area2D

@export var refuel_amount: float = 25.0

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		body.refuel(refuel_amount)
		queue_free()
