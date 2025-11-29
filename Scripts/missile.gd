extends CharacterBody2D

@export var speed: float = 400.0
@export var turn_speed: float = 5.0
@export var life_time: float = 5

@export var target: Node2D = null

@export var explosion_scene: PackedScene = null

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	
	var direction = global_position.direction_to(target.global_position)
	rotation = lerp_angle(rotation, direction.angle(), turn_speed * delta)
	
	velocity = Vector2.RIGHT.rotated(rotation) * speed
	move_and_slide()


func _on_timer_timeout() -> void:
	call_deferred("explode")

func _on_missile_hurtbox_body_entered(_body: Node2D) -> void:
	call_deferred("explode")

func _on_missile_hurtbox_area_entered(_area: Area2D) -> void:
	call_deferred("explode")
	
func explode() -> void: 
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		get_tree().root.add_child(explosion)
		explosion.global_position = global_position
	queue_free()
