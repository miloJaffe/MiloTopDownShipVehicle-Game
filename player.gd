extends CharacterBody2D

@export var bullet : PackedScene
@export var cooldown = 0.25
var can_shoot = true


var health = 5
var wheel_base = 70
var steering_angle = 40
var engine_power = 900
var friction = -55
var drag = -0.06
var braking = -900
var max_speed_reverse = 900
var slip_speed = 500
var traction_fast = 2.5
var traction_slow = 10

var acceleration = Vector2.ZERO
var steer_direction

#var target = $Camera2D.get_global_mouse_position()
func _ready():
	$CoolDown.wait_time = cooldown
	$TankDarkBarrel1/fire.play("load")

func _physics_process(delta):
#	var target_dir = (target.global_position - global_position).normalized()
#	var current_dir = Vector2(1, 0).rotated(self.global_rotation)
#	$TankDarkBarrel1.global_rotation = current_dir.lerp(target_dir, 5 * delta).angle()
	Global.health = health
	acceleration = Vector2.ZERO
	get_input()
	$TankDarkBarrel1.look_at(get_global_mouse_position())
#	$TankDarkBarrel1.look_at(get_global_mouse_position())
	apply_friction(delta)
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()
	print(velocity.x)
	if health <= 0:
		queue_free()
	
	
func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force
	
func get_input():
	var turn = Input.get_axis("steer_left", "steer_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
#		print(rotation)
		acceleration = transform.x * engine_power
# Comment out below if you want to stop but NOT reverse
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
# Uncomment below if you want braking to stop, but NOT reverse
	#if Input.is_action_pressed("brake"):
		#if velocity.x > 0:
			#acceleration = transform.x * braking
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = rear_wheel.direction_to(front_wheel)
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
#	velocity = new_heading * velocity.length()
	rotation = new_heading.angle()


func shoot():
	if not can_shoot:
		return
	can_shoot = false
	$TankDarkBarrel1/fire.play("fireburst")
	$CoolDown.start()
	var CB = bullet.instantiate()
	owner.add_child(CB)


	CB.transform = $TankDarkBarrel1/Marker2D.global_transform
	$CoolDown.start()


func _on_cool_down_timeout():
	can_shoot = true


func _on_fire_animation_finished():
	if $TankDarkBarrel1/fire.animation == "fireburst":
		$TankDarkBarrel1/fire.animation = "load"

func hit():
	health -= 1

func heal():
	health = 5
