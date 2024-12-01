extends Node

const FILE_NAME: String = "user://save"
var night_mode: bool = false
var config: ConfigFile = ConfigFile.new()


func _ready():
	var integrity_warning: AcceptDialog = (
		preload("res://scenes/menu/integrity_warning.tscn").instantiate()
	)

	if not FileAccess.file_exists(FILE_NAME):
		var time: String = str(Time.get_unix_time_from_system())  # This loses precision if kept in float form
		config.set_value("core", "salt", time)
	config.load(FILE_NAME)

	var old_checksum: String = config.get_value("core", "checksum")
	var current_checksum: String = generate_checksum()

	if old_checksum != current_checksum:
		add_child(integrity_warning)
		integrity_warning.set_visible(true)
		integrity_warning.connect("canceled", quit_game)
		integrity_warning.connect("confirmed", quit_game)
	else:
		save_file()


func get_save(key: String, section: String = "game_data") -> Variant:
	return config.get_value(section, key)


func set_save(key: String, value: Variant, section: String = "game_data") -> void:
	config.set_value(section, key, value)
	save_file()


func save_file() -> void:
	config.set_value("core", "checksum", generate_checksum())
	config.save(FILE_NAME)
	print("File saved!")


func generate_checksum() -> String:
	var sum: int = 0
	for section in config.get_sections():
		if section == "game_data":
			for value in config.get_section_keys(section):
				sum += int(config.get_value(section, value))

	var res = (str(sum) + config.get_value("core", "salt")).sha256_text()
	return res


func quit_game():
	get_tree().quit()
