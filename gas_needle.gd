extends Sprite2D

@export var player: Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(player):
		var angle_empty = -90
		var angle_full = 90
		rotation_degrees = remap(player.current_fuel , 0, 100, angle_empty, angle_full)
	pass
