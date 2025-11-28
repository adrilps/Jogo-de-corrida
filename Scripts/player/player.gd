class_name Player extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var initial_state = $StateMachine/Idle

@export var friction: int = -55  # Coeficiente de fricção que afeta negativamente a aceleração do veículo
@export var friction_brake_factor: float = 2.0 #Multiplicador de fricção do freio
@export var drag: float = -0.06  # Coeficiente de resistência do ar
@export var slip_speed: int = 400  # Limiar de velocidade para troca de coeficiente de fricção

@export var steering_angle: float = 25  # angulo máximo das rodas
@export var engine_power: int = 500  # Força máxima que o motor converte em aceleração
@export var reverse_speed: int = -450  # Força máxima de frenagem/ré
@export var max_speed_reverse: int = 250  # Limite superior da velocidade de ré

@export var traction_fast: float = 2.5  # Fator de tração em alta velocidade
@export var traction_slow: float = 10  # Fator de tração em baixa velocidade
@export var traction_brake: float = 0.2 # Fator de tração quando freando
@export var traction_slipping: float = 0.05 # Fator de tração quando escorregando

@export var max_fuel: float = 100.0
@export var fuel_rate: float = 2.0
@export var low_fuel_threshold: float = 15.0
@export var low_fuel_speed_multiplier: float = 0.4

var wheel_base = 65  # Distância entre o eixo frontal e traseiro do carro
var acceleration = Vector2.ZERO  # Vetor de acceleração atual
var steer_direction  # Direção atual das rodas 
var current_traction = traction_slow
var current_friction_mult = 1.0

var terrain_friction_multiplier = 1
var terrain_traction_multiplier = 1

var current_fuel = max_fuel

var current_state: State

func _ready():
	if initial_state == null:
		push_error("Initial state not assigned")
		return
	current_state = initial_state
	if not state_machine.has_node(current_state.get_path()):
		push_error("Initial state '%s' not part of $StateMachine" % current_state.name)
		return
	
	current_state.enter()

func _physics_process(delta: float) -> void:
	var turn = Input.get_axis("steer_right", "steer_left")
	steer_direction = turn * deg_to_rad(steering_angle)
	acceleration = Vector2.ZERO
	
	if current_fuel <= 0:
		change_state("Empty")
	
	var new_state = current_state.process_state(delta)
	if new_state:
		change_state(new_state)
	
	if current_fuel < low_fuel_threshold and current_fuel > 0:
		acceleration *= lerp(low_fuel_speed_multiplier, 1.0, current_fuel / low_fuel_threshold)
	
	apply_control(delta)
	apply_forces(delta)
	
	velocity += acceleration * delta  # Aplica a aceleração resultante à velocidade do veículo
	move_and_slide()  # Chama o motor de física
	print(current_fuel, current_state)

func change_state(new_state: String):
	if current_state.name == "Empty":
		return
	if not state_machine.has_node(new_state):
		push_warning("Estado não encontrado: %s" % new_state)
		return
	if current_state.name == new_state:
		return
	
	current_state.exit()
	current_state = state_machine.get_node(new_state)
	current_state.enter()

func apply_control(delta):
	# Calcula a posição do eixo frontal e traseiro
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	# Altera a posição das rodas, baseada na velocidade atual e rotaciona as rodas frontais
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	# Calcula a direção real do veículo, baseada no vetor entre o eixo traseiro e frontal
	var new_heading = rear_wheel.direction_to(front_wheel)

	var traction = current_traction * terrain_traction_multiplier

	# Dot product resulta na diferença entre a direção da trajetória do carro e a direção da sua velocidade
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		# Caso não esteja freando (d > 0), ajusta gradativamente a direção de sua velocidade rumo à direção da trajetória
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	elif d < 0:
		#Caso esteja freando / dando ré (d < 0), inverte a direção e limita a velocidade máxima
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	# Atualiza a rotação do objeto em relação ao novo ângulo de direção
	rotation = new_heading.angle()

func apply_forces(delta):
	# Arredonda a velocidade a zero para evitar rebotes infinitos 
	if acceleration == Vector2.ZERO and velocity.length() < 30:
		velocity = Vector2.ZERO
	# Calcula fricção e resistência do ar, baseadas na velocidade atual
	var friction_force = velocity * friction * terrain_friction_multiplier * delta
	var drag_force = velocity * velocity.length() * drag * delta
	
	friction_force *= current_friction_mult
	drag_force *= current_friction_mult
	
	# Acrescenta as forças resistivas à aceleração atual
	acceleration += drag_force + friction_force

	# Função que aplica efeito de perda de controle no veículo, chamado externamente
func apply_debuff():
	change_state("Slip")
	
func take_damage(amount: float):
	current_fuel = clamp(current_fuel - amount, 0, max_fuel)
	if current_state.name == "Empty":
		current_state.exit()
		current_state = state_machine.get_node("Idle")
		current_state.enter()

func refuel(amount: float):
	current_fuel = clamp(current_fuel + amount, 0, max_fuel)
	if current_state.name == "Empty":
		current_state.exit()
		current_state = state_machine.get_node("Idle")
		current_state.enter()

func set_traction(traction_factor):
	terrain_traction_multiplier = traction_factor
	
func set_friction(friction_factor):
	terrain_friction_multiplier = friction_factor

# posição global da roda da frente
func get_front_wheel_gpos() -> Vector2:
	return global_position + transform.x * (wheel_base / 2.0)
	
