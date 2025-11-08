extends Node2D

@onready var camera = $Jogador/Camera2D
@onready var background = $Background
@onready var jogador = $Jogador

var background_image: Image

func _ready():
	set_camera_limits()
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
