class_name Tooltip
extends Node


export var visual_res: PackedScene
export var owner_path: NodePath

var _visuals: Control

onready var owner_node = get_node(owner_path)
onready var sat = owner_node.get_parent()
onready var mesh = owner_node.get_parent().get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	#_visuals = visual_res.instance()
	#add_child(_visuals)
	#_visuals.hide();
	
	owner_node.connect("mouse_entered",self, "_mouse_entered")
	owner_node.connect("mouse_exited",self, "_mouse_exited")
	
	
func _mouse_entered() -> void:
	print("mouse entered")
	#_visuals.show()
	
func _mouse_exited() -> void:
	print("mouse exited")
	#_visuals.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
