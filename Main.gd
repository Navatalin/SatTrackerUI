extends Spatial

var is_mouse_mode_captured = false

var sat_tempate = preload("res://Sat.tscn")
var sats = {}
var sats_nodes = []

var zoom = 200

onready var httpRequest = $HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready():
	httpRequest.connect("request_completed",self,"_on_request_completed")
	httpRequest.request("http://127.0.0.1:5000/")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mouse_capture"):
		if !is_mouse_mode_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			is_mouse_mode_captured = true
			
	if Input.is_action_just_released("mouse_capture"):
		if is_mouse_mode_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			is_mouse_mode_captured = false

func _physics_process(_delta):
	pass


func _on_Timer_timeout():
	#httpRequest.request("http://127.0.0.1:5000/")
	pass
	
func _on_request_completed(result, response_code, headers, body):
	var stringBody = body.get_string_from_utf8()
	var data = parse_json(stringBody)
	if sats.size() < 1:
		for sat in data:
			var newSat = sat_tempate.instance()
			newSat.name = sat[0]
			newSat.sat_name = sat[0]
			newSat.velocity_x = sat[4]
			newSat.velocity_y = sat[5]
			newSat.velocity_z = sat[6]
			self.add_child(newSat)
			newSat.global_transform.origin = Vector3(-sat[1]/zoom,sat[3]/zoom, sat[2]/zoom)
			sats[newSat.name] = newSat
	else:
		for sat in data:
			if(sats.has(sat[0])):
				var update_sat = sats[sat[0]]
				update_sat.global_transform.origin = Vector3(-sat[1]/zoom,sat[3]/zoom, sat[2]/zoom)
				update_sat.velocity_x = sat[4]
				update_sat.velocity_y = sat[5]
				update_sat.velocity_z = sat[6]
			else:
				var newSat = sat_tempate.instance()
				newSat.name = sat[0]
				newSat.sat_name = sat[0]
				newSat.velocity_x = sat[4]
				newSat.velocity_y = sat[5]
				newSat.velocity_z = sat[6]
				self.add_child(newSat)
				newSat.global_transform.origin = Vector3(-sat[1]/zoom,sat[3]/zoom, sat[2]/zoom)
				sats[newSat.name] = newSat
	httpRequest.request("http://127.0.0.1:5000/")
	
	
