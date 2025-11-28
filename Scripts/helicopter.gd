extends CharacterBody2D

@export var speed: float = 200.0
@export var turn_speed: float = 4.0

@export var target: Node2D = null

@export var missile_scene: PackedScene = null

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	
	var direction = global_position.direction_to(target.global_position)
	rotation = lerp_angle(rotation, direction.angle(), turn_speed * delta)
	
	velocity = direction * speed
	move_and_slide()


func _on_timer_timeout() -> void:
	shoot_missile()
	pass # Replace with function body.
	
func shoot_missile() -> void:
	if missile_scene:
		var missile = missile_scene.instantiate()
		get_tree().root.add_child(missile)
		missile.target = target
		missile.global_position = global_position
		
