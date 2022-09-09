extends Entity

class_name PlayerController

export var speed = 15
export var xSens = -1.0
export var interactionDistance = 2

var pressEUI: Object
var safeTarget: Object
var id = 1
var currentKey: Object = null

func _ready():
	pressEUI = get_node("Label")
	pressEUI.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):         
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(event.relative.x * xSens))
		$Camera.rotate_x(deg2rad(event.relative.y * xSens))
	if Input.is_action_pressed("action") and safeTarget != null and currentKey == null:
		currentKey = safeTarget
		safeTarget.hide()
		pressEUI.hide()
		safeTarget = null

func _physics_process(delta):
	# Controls
	var x = 0
	var y = 0

	if Input.is_action_pressed("move_right"):
		x = 1
	elif Input.is_action_pressed("move_left"):
		x = -1
	if Input.is_action_pressed("move_back"):
		y = 1
	elif Input.is_action_pressed("move_forward"):
		y = -1

	var velocity = (global_transform.basis.y * y + global_transform.basis.x * x).normalized() * speed
	move_and_slide(velocity)
	
	var center = get_viewport().size/2
	var from = $Camera.project_ray_origin(center)
	var to = from + $Camera.project_ray_normal(center) * 100
	var result = get_world().direct_space_state.intersect_ray(from, to)
	if result and result.collider.name == "Safe" and global_transform.origin.distance_to(result.collider.global_transform.origin) < interactionDistance && result.collider.is_visible() and currentKey == null:
		pressEUI.show()
		safeTarget = result.collider
	else:
		pressEUI.hide()
		safeTarget = null
