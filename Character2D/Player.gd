extends CharacterBody2D



## Speed of the character on the X-axis.
@export var vel := 800

## Jump force of the character.
@export var JumpForce := -900

## Additional time to allow jumps after leaving the ground.
@export var CoyoteTime := 0.1

## Maximum number of consecutive jumps.
@export var Jumps := 2

## Gravity applied to the character.
@export var Gravity := 2.8

## Horizontal acceleration of the character.
@export var ACCELERATION := 130

## Friction applied when stopping.
@export var friction := 25

## Indicates whether the character should flip horizontally.
@export var Flip := false

## Action associated with the left button.
@export var Left := "ui_left"

## Action associated with the right button.
@export var Right := "ui_right"

## Action associated with the jump button.
@export var Jump := "ui_accept"

## Name of the AnimatedSprite2D node.
@export var Anims := "AnimatedSprite2D"

## Names of the character's animations.
@export var AnimationsNames :PackedStringArray


var JumpTemp := 0 # Remaining jumps count
var time := 0 # Time elapsed since the character left the ground

## Gravity obtained from the project settings to sync with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var Animations

func _ready() -> void:
	Animations = get_node("AnimatedSprite2D")
	gravity *= Gravity

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		time += delta
		_Animation(AnimationsNames[2]) # Activate the falling animation
		if JumpTemp == Jumps and time >= CoyoteTime:
			#print(JumpTemp, " No consigui saltar")
			time = 0
			JumpTemp -= 1
	else:
		if Animations.animation == AnimationsNames[2]:
			Animations.play(AnimationsNames[0]) # Play the idle animation
		time = 0
		JumpTemp = Jumps

	if Input.is_action_just_pressed(Jump) and JumpTemp > 0:
		velocity.y = JumpForce
		JumpTemp -= 1

	if Input.is_action_pressed(Right):
		velocity.x = min(velocity.x + ACCELERATION, vel)
		_Animation(AnimationsNames[1]) # Activate the movement animation
		Animations.flip_h = Flip
	elif Input.is_action_pressed(Left):
		velocity.x = max(velocity.x - ACCELERATION, -vel)
		_Animation(AnimationsNames[1]) # Activate the movement animation
		Animations.flip_h = !Flip
	else:
		velocity.x *= 1 / (1 + (delta * friction))
		_Animation(AnimationsNames[0]) # Activate the idle animation
	
	move_and_slide()

func _Animation(Anim: String) -> void:
	if Animations.animation != AnimationsNames[2]:
		Animations.play(Anim)
