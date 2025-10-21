extends CharacterBody2D


const SPEED = 300.0
const ACCELERATION = 5.0
const FRICTION = 2
const JUMP_VELOCITY = -400.0
var rotational_velocity = 0



func _physics_process(delta: float) -> void:
	
	var absolute_velocity: float = (abs(velocity.x)+abs(velocity.y))
	
	
	if(rotation == 0 ):
		pass
	elif(rotation < 0):
		rotation += FRICTION
	elif(rotation > 0):
		rotation -= FRICTION
	
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta
	if(velocity.x == 0 ):
		pass
	elif(velocity.x < 0):
		velocity.x += FRICTION
	elif(velocity.x > 0):
		velocity.x -= FRICTION
		
	if(velocity.y == 0 ):
		pass
	elif(velocity.y < 0):
		velocity.y += FRICTION
	elif(velocity.y > 0):
		velocity.y -= FRICTION
	

	if Input.is_action_pressed("Forwards"):
		velocity.x += ACCELERATION*cos(rotation)
		velocity.y += ACCELERATION*sin(rotation)
		
	if Input.is_action_pressed("Steer Left"):
		if((abs(velocity.x)+abs(velocity.y))== 0):
			pass
		else :
			rotation += 0.005 * (absolute_velocity/250)
		
	if Input.is_action_pressed("Steer Right"):
		if((abs(velocity.x)+abs(velocity.y))== 0):
			pass
		else :
			rotation -= 0.005* ((abs(velocity.x)+abs(velocity.y))/250)
	
	if Input.is_action_pressed("Brake"):
		velocity.x -= 0.6*ACCELERATION*cos(rotation)
		velocity.y -= 0.6*ACCELERATION*sin(rotation)
		
		
	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	move_and_slide()
