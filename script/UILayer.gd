extends CanvasLayer

var currentUIBoard: UIBoard # should have BoardName: String
var player: BaseCharacter

signal UI_board_closedS

func set_player(p: BaseCharacter):
	player = p
	
func add_UI_board(board: UIBoard) -> bool:
	if board.get("boardName") == null:
		push_warning("board should have property: boardName!")
		
	if currentUIBoard != null and currentUIBoard.boardName == board.boardName:
		close_UI_board()
		return false
	else:
		add_child(board)
		currentUIBoard = board
		board.board_closeS.connect(_on_UI_board_closed)
		board.set_player(player)
		return true

func close_UI_board():
	currentUIBoard.close_board()
	remove_child(currentUIBoard)
	currentUIBoard = null
	UI_board_closedS.emit()
	
func _on_UI_board_closed(board: UIBoard):
	if board != currentUIBoard:
		push_warning("board != current board")
	else:
		close_UI_board()
	
