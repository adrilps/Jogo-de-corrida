extends CharacterBody2D

@export var friction = -55  # Coeficiente de fricção que afeta negativamente a aceleração do veículo
@export var friction_brake_factor = 2.0 #Multiplicador de fricção do freio
@export var drag = -0.06  # Coeficiente de resistência do ar
@export var slip_speed = 400  # Limiar de velocidade para troca de coeficiente de fricção

@export var steering_angle = 25  # Ângulo máximo das rodas
@export var engine_power = 500  # Força máxima que o motor converte em aceleração
@export var reverse_speed = -450  # Força máxima de frenagem/ré
@export var max_speed_reverse = 250  # Limite superior da velocidade de ré

@export var traction_fast = 2.5  # Fator de tração em alta velocidade
@export var traction_slow = 10  # Fator de tração em baixa velocidade
@export var traction_brake = 0.2 # Fator de tração quando freando
@export var traction_slipping = 0.05 # Fator de tração quando escorregando

var wheel_base = 65  # Distância entre o eixo frontal e traseiro do carro
var acceleration = Vector2.ZERO  # Vetor de acceleração atual
var steer_direction  # Direção atual das rodas 
var is_drifting = false #Indicador de derrapagem
var is_slipping = false #Indicador de deslizamento
var terrain_friction_multiplier = 1
var terrain_traction_multiplier = 1

func _physics_process(delta: float) -> void:
	acceleration = Vector2.ZERO
	get_input()  # Recebe entrada do jogador
	calculate_steering(delta)  # Aplica lógica de direção às entradas do jogador
	
	apply_friction(delta)  # Aplica forças retardantes ao veículo
	velocity += acceleration * delta  # Aplica a aceleração resultante à velocidade do veículo
	move_and_slide()  # Chama o motor de física
	

# Função de tratamento de entrada do usuário
func get_input():
	# Traduz entradas de direção em ângulos
	var turn = Input.get_axis("steer_right", "steer_left")
	steer_direction = turn * deg_to_rad(steering_angle)

	# Aplica a a força total do motor quando movendo para frente
	if Input.is_action_pressed("move_forward"):
		acceleration = transform.x * engine_power

	# Aplica aceleração negativa quando movendo para trás
	if Input.is_action_pressed("move_backward"):
		acceleration = transform.x * reverse_speed
	
	# Ativa o indicador de derrapagem ao frear
	is_drifting = false
	if Input.is_action_pressed("brake"):
		is_drifting = true

# Função para cálculo de forças retardantes
func apply_friction(delta):
	# Arredonda a velocidade a zero para evitar rebotes infinitos 
	if acceleration == Vector2.ZERO and velocity.length() < 30:
		velocity = Vector2.ZERO
	# Calcula fricção e resistência do ar, baseadas na velocidade atual
	var friction_force = velocity * friction * terrain_friction_multiplier * delta
	var drag_force = velocity * velocity.length() * drag * delta
	
	# Multiplica as forças resistivas caso o indicador de derrapagem estiver ativo
	if is_drifting:
		friction_force *= friction_brake_factor
		drag_force *= friction_brake_factor 
	
	# Acrescenta as forças resistivas à aceleração atual
	acceleration += drag_force + friction_force

	
# Função de cálculo de direção
func calculate_steering(delta):
	# Calcula a posição do eixo frontal e traseiro
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	# Altera a posição das rodas, baseada na velocidade atual e rotaciona as rodas frontais
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	# Calcula a direção real do veículo, baseada no vetor entre o eixo traseiro e frontal
	var new_heading = rear_wheel.direction_to(front_wheel)

	# Escolha do cálculo de tração
	var traction = traction_slow
	if is_slipping:
		traction = traction_slipping
	if velocity.length() > slip_speed:
		traction = traction_fast
	if is_drifting and velocity.length() > slip_speed / 2.0:
		traction = traction_brake
		
	traction *= terrain_traction_multiplier

	# Dot product resulta na diferença entre a direção da trajetória do carro e a direção da sua velocidade
	var d = new_heading.dot(velocity.normalized())

	# Caso não esteja freando (d > 0), ajusta gradativamente a direção de sua velocidade rumo à direção da trajetória
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)

	#Caso esteja freando / dando ré (d < 0), inverte a direção e limita a velocidade máxima
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	# Atualiza a rotação do objeto em relação ao novo ângulo de direção
	rotation = new_heading.angle()
	
	# Função que aplica efeito de perda de controle no veículo, chamado externamente
func apply_debuff():
		# Ativa o indicador de deslizamento por 1.5 segundos para cálculo de fricção
		is_slipping = true
		await get_tree().create_timer(1.5).timeout
		is_slipping = false
		
func set_traction(traction_factor):
	terrain_traction_multiplier = traction_factor
	
func set_friction(friction_factor):
	terrain_friction_multiplier = friction_factor

# posição global da roda da frente
func get_front_wheel_gpos() -> Vector2:
	return global_position + transform.x * (wheel_base / 2.0)
	
