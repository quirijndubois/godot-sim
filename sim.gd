extends Node2D

var screen_size = get_viewport_rect().size

const G = 10
const center_force = 1
const substeps = 1

const epsilon = .01**2

var zoom = 30
var cam_pos = Vector2(0,0) 

const n = 250
var pos = generateRandomArray(n,-10,10)
var vel = generateRandomArray(n,-10,10)

func generateRandomArray(n,min,max):
	var l = []
	for i in range(n):
		l.append(Vector2(
		randf_range(min, max),
		randf_range(min, max)
		))
	return l

func _draw():
	for x in pos:
		var abs_x = x.x*screen_size[1]/zoom+screen_size[0]/2
		var abs_y = x.y*screen_size[1]/zoom+screen_size[1]/2
		draw_circle(Vector2(abs_x,abs_y),3,Color.WHITE)

func _process(d):
	screen_size = get_viewport_rect().size
	
	var delta = d/substeps
	
	for a in range(substeps):
		for i in range(len(pos)):
			var acc = Vector2(0,0)
			for j in range(len(pos)):

				var diff = pos[i] - pos[j]
				var magSq = diff.x * diff.x + diff.y * diff.y
				var mag = sqrt(magSq)  # This is the magnitude (not squared)
				acc -= G*diff/((magSq+epsilon)**(3/2))

			# acc += -pos[i]*center_force
			vel[i]+= delta*acc
			pos[i]+= delta*vel[i]
	
	queue_redraw()
var dragging = false
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom*=.9
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom*=1.1
