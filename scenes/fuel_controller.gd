extends Node

@export var fuel_scene: PackedScene = null
@export var fuel_spawn_list = [Vector2(-191, -389),Vector2(824,-118),Vector2(840,459),Vector2(-335,451),Vector2(-750,-155)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if fuel_scene:
		pass
	else:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_timer_timeout() -> void:
	var fuel_instance = fuel_scene.instantiate()
	if fuel_instance:
		add_child(fuel_instance)
		if fuel_spawn_list.size() > 0:
			fuel_instance.global_position = fuel_spawn_list.pick_random()
	pass # Replace with function body.
