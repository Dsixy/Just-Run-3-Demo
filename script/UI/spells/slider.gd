extends MarginContainer

@onready var label = $VBoxContainer/Label
@onready var slider = $VBoxContainer/HSlider
var _value
var value:
	get:
		return _value
	set(v):
		_value = v
		label.text = "{0}: {1}".format([attrName, _value])
		changeS.emit(attrName, v)

var attrName: String = ""

signal changeS(n: String, v)

func set_properties(n: String, min_val: float, max_val: float, step: float) -> void:
	self.attrName = n
	self.slider.min_value = min_val
	self.slider.max_value = max_val
	self.slider.step = step
	self.value = min_val

func _on_h_slider_drag_ended(value_changed):
	self.value = slider.value
