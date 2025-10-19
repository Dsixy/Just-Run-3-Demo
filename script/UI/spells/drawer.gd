extends Label

var _value
var value:
	get:
		return _value
	set(v):
		_value = v
		if v:
			self.text = "{0}: {1}".format([attrName, v.spellClass.spellName])
		else:
			self.text = "{0}: {1}".format([attrName, ""])
		changeS.emit(attrName, v)

var attrName: String = ""
var filter: Callable
signal changeS(n: String, v)
	
func set_properties(n: String, f: Callable) -> void:
	attrName = n
	self.value = null
	self.filter = f
