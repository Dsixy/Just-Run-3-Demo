extends UIBoard

@onready var imgBoard = $MarginContainer/TextureRect

func _init():
	self.boardName = "sign_board"
	
func set_img(image_texture: Texture2D):
	imgBoard.texture = image_texture

func close_board():
	board_closeS.emit()
	queue_free()
	
func _on_texture_button_pressed():
	close_board()
