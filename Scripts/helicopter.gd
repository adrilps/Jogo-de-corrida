extends CharacterBody2D

@export var speed: float = 200.0
@export var turn_speed: float = 4.0

@export var target: Node2D = null

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	
	var direction = global_position.direction_to(target.global_position)
	rotation = lerp_angle(rotation, direction.angle(), turn_speed * delta)
	
	velocity = direction * speed
	move_and_slide()
