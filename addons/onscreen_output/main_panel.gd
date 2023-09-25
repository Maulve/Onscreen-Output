@tool
extends VBoxContainer

var _plugin_config : ConfigFile

var _config_path : String = "res://addons/onscreen_output/plugin.cfg"

@onready var btn = $BasicConfigVBoxContainer/FilePathHBoxContainer/Button
var file_dialog : FileDialog


func _ready():
	_load_config()
	
	btn.texture_normal = EditorInterface.get_base_control().get_theme_icon("Folder", "EditorIcons")
	
	$SaveButton.connect("pressed", _on_save_button_pressed)


func _on_save_button_pressed():
	_save_config()


func _load_config():
	_plugin_config = ConfigFile.new()
	
	# Load data from a file.
	var err = _plugin_config.load(_config_path)

	# If the file didn't load, ignore it.
	if err != OK:
		printerr("Screen Output: Failed to load config. %s might be damaged or missing." % _config_path)
		return

	scrnOutput._debug_enabled = bool(_plugin_config.get_value("config", "debug_enabled"))
	$BasicConfigVBoxContainer/DebugEnabledHBoxContainer/DebugEnabledCheckBox.button_pressed = scrnOutput._debug_enabled
	scrnOutput._show_timestamp = bool(_plugin_config.get_value("config", "show_timestamp"))
	$BasicConfigVBoxContainer/TimestampHBoxContainer/TimestampCheckBox.button_pressed = scrnOutput._show_timestamp
	scrnOutput._font_color = _plugin_config.get_value("config", "font_color")
	$AppearanceVBoxContainer/FontColorHBoxContainer/ColorPickerButton.color = Color(scrnOutput._font_color)
	scrnOutput._background_color = _plugin_config.get_value("config", "background_color")
	$AppearanceVBoxContainer/BackgroundColorHBoxContainer/ColorPickerButton.color = Color(scrnOutput._background_color)
	scrnOutput._font_size = float(_plugin_config.get_value("config", "font_size"))
	$AppearanceVBoxContainer/FontSizeHBoxContainer/FontSizeLineEdit.value = scrnOutput._font_size
	scrnOutput._anchor = int(_plugin_config.get_value("config", "anchor"))
	$LayoutVBoxContainer/AnchorHBoxContainer/AnchorOptionButton.select(scrnOutput._anchor)
	scrnOutput._save_logs = bool(_plugin_config.get_value("config", "save_logs"))
	$BasicConfigVBoxContainer/LogFileHBoxContainer/LogFileCheckBox.button_pressed = scrnOutput._save_logs
	scrnOutput._save_path = str(_plugin_config.get_value("config", "save_path"))
	$BasicConfigVBoxContainer/FilePathHBoxContainer/TextEdit.text = scrnOutput._save_path
	
func _save_config():
	scrnOutput._debug_enabled = $BasicConfigVBoxContainer/DebugEnabledHBoxContainer/DebugEnabledCheckBox.button_pressed
	_plugin_config.set_value("config", "debug_enabled", scrnOutput._debug_enabled)
	scrnOutput._show_timestamp = $BasicConfigVBoxContainer/TimestampHBoxContainer/TimestampCheckBox.button_pressed
	_plugin_config.set_value("config", "show_timestamp", scrnOutput._show_timestamp)
	scrnOutput._font_color = $AppearanceVBoxContainer/FontColorHBoxContainer/ColorPickerButton.color.to_html(true)
	_plugin_config.set_value("config", "font_color", scrnOutput._font_color)
	scrnOutput._background_color = $AppearanceVBoxContainer/BackgroundColorHBoxContainer/ColorPickerButton.color.to_html(true)
	_plugin_config.set_value("config", "background_color", scrnOutput._background_color)
	scrnOutput._font_size = float($AppearanceVBoxContainer/FontSizeHBoxContainer/FontSizeLineEdit.value)
	_plugin_config.set_value("config", "font_size", scrnOutput._font_size)
	scrnOutput._anchor = int($LayoutVBoxContainer/AnchorHBoxContainer/AnchorOptionButton.selected)
	_plugin_config.set_value("config", "anchor", scrnOutput._anchor)
	scrnOutput._save_logs = $BasicConfigVBoxContainer/LogFileHBoxContainer/LogFileCheckBox.button_pressed
	_plugin_config.set_value("config", "save_logs", scrnOutput._save_logs)
	scrnOutput._save_path = $BasicConfigVBoxContainer/FilePathHBoxContainer/TextEdit.text
	_plugin_config.set_value("config", "save_path", scrnOutput._save_path)
	
	
	_plugin_config.save(_config_path)
	
	print_debug("Onscreen Output: Successfully saved config.")


func _on_button_pressed() -> void:
	file_dialog = btn.get_child(0) as FileDialog
	file_dialog.visible = true
	
	file_dialog.dir_selected.connect(_save_path)
	
func _save_path(dir : String):
	$BasicConfigVBoxContainer/FilePathHBoxContainer/TextEdit.text = dir
	file_dialog.dir_selected.disconnect(_save_path)
