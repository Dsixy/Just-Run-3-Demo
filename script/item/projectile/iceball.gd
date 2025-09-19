extends Projectile

func _init():
	super._init()
	self.duration = 6.0
	
func _ready():
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
