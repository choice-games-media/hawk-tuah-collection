extends Control

# Scenes are stored in this format: Scene name, UID reference to the scene, window dimensions in Vector2i
var scene_data: Dictionary = {
	"hawky-tuah": ["uid://dob5tqgyakn3v", Vector2i(512, 608)],
	"twenty-forty-tuah": ["uid://csgl14occ1k6y", Vector2i(500, 500)]  # twenty-forty-tuah
}
@onready var play_button: Button = $MainMenu/MenuButtons/PlayButton
@onready var exit_button: Button = $MainMenu/MenuButtons/ExitButton
@onready var tooltip: Label = $MainMenu/Tooltip


func _set_menu_visibility(mode: bool) -> void:
	play_button.set_visible(mode)
	exit_button.set_visible(mode)

	# https://forum.godotengine.org/t/how-to-get-all-children-from-a-node/18587/2
	var waiting := find_children("GameSelect")
	while not waiting.is_empty():
		var node := waiting.pop_back() as Node
		waiting.append_array(node.get_children())
		node.set_visible(not mode)


func _swap_scenes(folder: String) -> void:
	get_window().set_size(scene_data[folder][1])
	get_window().move_to_center()
	get_tree().change_scene_to_file(scene_data[folder][0])


func _on_play_button_pressed() -> void:
	_set_menu_visibility(false)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_return_button_pressed() -> void:
	_set_menu_visibility(true)


func _on_hawky_tuah_pressed() -> void:
	Global.night_mode = false
	_swap_scenes("hawky-tuah")


func _on_hawky_tuah_night_pressed() -> void:
	Global.night_mode = true
	_swap_scenes("hawky-tuah")


func _on_twenty_forty_tuah_pressed() -> void:
	_swap_scenes("twenty-forty-tuah")


func _on_button_mouse_exited() -> void:
	tooltip.set_text("")


func _on_play_button_mouse_entered() -> void:
	tooltip.set_text("That's right, there's multiple of these atrocities now!")


func _on_exit_button_mouse_entered() -> void:
	tooltip.set_text("Closes the game. You could also click the X button, but this lets me add more buttons to the menu.")


func _on_return_button_mouse_entered() -> void:
	tooltip.set_text("Return to the main menu.")


func _on_hawky_tuah_mouse_entered() -> void:
	tooltip.set_text("Flappy Bird clone, the game that (unfortunately) began it all. Fly through columns of pipes with some... new additions.")


func _on_hawky_tuah_night_mouse_entered() -> void:
	tooltip.set_text("Hawky Tuah, but scroll speed passively increases over time - how far can you get?")


func _on_hawksweeper_mouse_entered() -> void:
	tooltip.set_text("Minesweeper clone. Clean the grid while avoiding mines. Every empty tile has a number, telling you how many mines are touching it. (In development)")


func _on_twenty_forty_tuah_mouse_entered() -> void:
	# Now with save states and multiplayer!
	tooltip.set_text("2048 clone. Combine numbered tiles on a grid until you reach the mythical Hawk Tuah tile. (In development)")
