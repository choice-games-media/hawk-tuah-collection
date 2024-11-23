extends Control


func _on_play_button_pressed() -> void:
	get_window().size = Vector2i(512, 608)
	get_window().move_to_center()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
