extends Field

@onready var particle = $Graphic/GPUParticles2D

func _init():
	self.duration = 0.1

func _ready():
	super._ready()
	explode()
	
func explode():
	particle.emitting = true
