extends InteractableItem

@onready var boardUIScene = preload("res://scene/UI/sign_board.tscn")
@export var signImage: CompressedTexture2D
var signBoardUIScene: PackedScene

func activate(p: BaseCharacter):
	var board = boardUIScene.instantiate()
	UiLayer.add_UI_board(board)
	board.set_img(signImage)
	
