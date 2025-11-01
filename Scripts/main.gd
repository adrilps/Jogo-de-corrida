extends Node2D

@onready var camera = $Jogador/Camera2D
@onready var background = $Background

func _ready():
	set_camera_limits()

func set_camera_limits():
	var texture = background.texture
	if not texture:
		return
	
	var dimensions = texture.get_size() * background.scale
	
	camera.limit_left = -dimensions.x / 2.0
	camera.limit_right = dimensions.x / 2.0
	camera.limit_top = -dimensions.y / 2.0
	camera.limit_bottom = dimensions.y / 2.0
	
