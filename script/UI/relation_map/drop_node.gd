extends Control

var _type: bool = false
var type: bool:
	get:
		return _type
	set(value):
		if value:
			region = Rect2(0, 0, 32, 32)
			chosenColor = Color8(255, 220, 255)
			normalColor = Color8(220, 160, 255)
		else:
			region = Rect2(0, 32, 32, 32)
			chosenColor = Color8(255, 255, 50)
			normalColor = Color8(200, 200, 50)
		_type = value
		
var chosenColor: Color = Color8(255, 220, 255)
var normalColor: Color = Color8(220, 160, 255)
var region: Rect2
var _chosen: bool = false
var chosen: bool:
	get:
		return _chosen
	set(value):
		_chosen = value 
		if value:
			self.modulate = chosenColor
			self.scale = Vector2.ONE * 0.8
		else:
			self.modulate = normalColor
			self.scale = Vector2.ONE * 0.5

var id: int = 0

signal be_chosen(node: Node)

func _ready():
	self.modulate = normalColor
	self.texture_normal = self.texture_normal.duplicate()
	self.texture_normal.region = region
		
func _on_mouse_entered():
	if not chosen:
		self.scale = Vector2.ONE * 0.8

func _on_mouse_exited():
	if not chosen:
		self.scale = Vector2.ONE * 0.5

func _on_pressed():
	chosen = not chosen
	emit_signal("be_chosen", self)

func dechoose():
	self.chosen = false
