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
			newSat.name = sat["name"]
			newSat.sat_name = sat["name"]
			newSat.velocity_x = sat["v_x"]
			newSat.velocity_y = sat["v_y"]
			newSat.velocity_z = sat["v_z"]
			self.add_child(newSat)
			newSat.global_transform.origin = Vector3(-sat["p_x"]/zoom,sat["p_z"]/zoom, sat["p_y"]/zoom)
			sats[newSat.name] = newSat
	else:
		for sat in data:
			if(sats.has(sat["name"])):
				var update_sat = sats[sat["name"]]
				update_sat.global_transform.origin = Vector3(-sat["p_x"]/zoom,sat["p_z"]/zoom, sat["p_y"]/zoom)
				update_sat.velocity_x = sat["v_x"]
				update_sat.velocity_y = sat["v_y"]
				update_sat.velocity_z = sat["v_z"]
			else:
				var newSat = sat_tempate.instance()
				newSat.name = sat["name"]
				newSat.sat_name = sat["name"]
				newSat.velocity_x = sat["v_x"]
				newSat.velocity_y = sat["v_y"]
				newSat.velocity_z = sat["v_z"]
				self.add_child(newSat)
				newSat.global_transform.origin = Vector3(-sat["p_x"]/zoom,sat["p_z"]/zoom, sat["p_y"]/zoom)
				sats[newSat.name] = newSat
	httpRequest.request("http://127.0.0.1:5000/")
	
	
