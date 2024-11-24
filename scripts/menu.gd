extends Control

@onready var play_button: Button = $MainMenu/MenuButtons/PlayButton
@onready var exit_button: Button = $MainMenu/MenuButtons/ExitButton


func _set_menu_visibility(mode: bool) -> void:
	play_button.visible = mode
	exit_button.visible = mode

	# https://forum.godotengine.org/t/how-to-get-all-children-from-a-node/18587/2
	var waiting := find_children("GameSelect")
	while not waiting.is_empty():
		var node := waiting.pop_back() as Node
		waiting.append_array(node.get_children())
		node.visible = not mode


func _on_play_button_pressed() -> void:
	_set_menu_visibility(false)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_return_button_pressed() -> void:
	_set_menu_visibility(true)


func _on_hawky_tuah_pressed() -> void:
	get_window().size = Vector2i(512, 608)
	get_window().move_to_center()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
