extends Node2D

@export var player: Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$GasNeedle.player = player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
