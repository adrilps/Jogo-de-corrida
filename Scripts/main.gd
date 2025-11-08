extends Node2D

@onready var jogador = $Player
@onready var camera = $Player/Camera2D
@onready var background = $Background
@onready var borders = $Borders

var background_image: Image

func _ready():
	set_camera_limits()
	create_borders()
	if background.texture:
		background_image = background.texture.get_image()

func _physics_process(_delta: float) -> void:	
	check_terrain()

func set_camera_limits():
	var texture = background.texture
	if not texture:
		return
	
	var dimensions = texture.get_size() * background.scale
	
	camera.limit_left = -dimensions.x / 2.0
	camera.limit_right = dimensions.x / 2.0
	camera.limit_top = -dimensions.y / 2.0
	camera.limit_bottom = dimensions.y / 2.0

func create_borders():
	var texture = background.texture
	if not texture:
		return
	
	var dimensions = texture.get_size() * background.scale
	var half_width = dimensions.x / 2.0
	var half_height = dimensions.y / 2.0
	var thickness = 10.0
	
	var walls = [
		[Vector2(0, -half_height - (thickness / 2.0)), Vector2(dimensions.x, thickness)],
		[Vector2(0, half_height + (thickness / 2.0)), Vector2(dimensions.x, thickness)],
		[Vector2(-half_width - (thickness / 2.0), 0), Vector2(thickness, dimensions.y)],
		[Vector2(half_width + (thickness / 2.0), 0), Vector2(thickness, dimensions.y)]
	]
	
	for def in walls:
		var wall = StaticBody2D.new()
		wall.position = def[0]
		
		var shape = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = def[1]
		shape.shape = rect
		
		wall.add_child(shape)
		borders.add_child(wall)

func check_terrain():
	if not background_image:
		return
	
	# converte posição global do jogador para coordenadas locais do sprite de fundo
	var local_pos = background.to_local(jogador.get_front_wheel_gpos())
	
	var image_size = Vector2(background_image.get_size()) * background.scale
	var texture_coord = local_pos + (image_size / 2.0) # ajusta o ponto de origem para (0,0)
	var pixel_coord = (texture_coord / background.scale).floor() # coordenada de pixel real
	
	# garante que estamos dentro da imagem
	if pixel_coord.x < 0 or pixel_coord.x >= background_image.get_size().x or \
	   pixel_coord.y < 0 or pixel_coord.y >= background_image.get_size().y:
		# fora do mapa assume grama
		jogador.set_friction(3.0)
		jogador.set_traction(2.0)
		return
	
	var color = background_image.get_pixelv(pixel_coord)
	
	# grama é verde então checamos se G é mais forte q R e B
	if color.g > color.r and color.g > color.b:
		jogador.set_friction(3.0)
		jogador.set_traction(2.0)
	else:
		jogador.set_friction(0.5)
		jogador.set_traction(2.0)
