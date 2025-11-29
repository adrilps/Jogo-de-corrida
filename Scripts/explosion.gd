extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
		if body.is_in_group("player"):
			if(body.has_method("take_damage")):
				body.take_damage(25) 
