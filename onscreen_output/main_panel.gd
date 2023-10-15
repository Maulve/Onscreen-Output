@tool
extends VBoxContainer

var _plugin_config : ConfigFile

var _config_path : String = "res://addons/onscreen_output/plugin.cfg"

@onready var btn = $BasicConfig/SavePath/Button
var file_dialog : FileDialog


func _ready():
	_load_config()
	print($Appearance/Size/X/LineEdit.value)
	
	btn.texture_normal = EditorInterface.get_base_control().get_theme_icon("Folder", "EditorIcons")
	
	#if !Engine.is_editor_hint():
		#await get_tree().physics_frame
		#print("------------")
		#$Appearance/Size/X/LineEdit.value = scrnOutput._size.x
		#$Appearance/Size/Y/LineEdit.value = scrnOutput._size.y
		#print($Appearance/Size/X/LineEdit.value)
		
	$SaveButton.connect("pressed", _on_save_button_pressed)
	
	scrnOutput.update_size.connect(func(): print("Hey"))
	
	

#func _physics_process(_delta: float) -> void:
	#print("I am here")

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
	$BasicConfig/DebugEnabled/CheckBox.button_pressed = scrnOutput._debug_enabled
	scrnOutput._show_timestamp = bool(_plugin_config.get_value("config", "show_timestamp"))
	$BasicConfig/Timestamp/CheckBox.button_pressed = scrnOutput._show_timestamp
	scrnOutput._font_color = _plugin_config.get_value("config", "font_color")
	$Appearance/FontColor/ColorPickerButton.color = Color(scrnOutput._font_color)
	scrnOutput._background_color = _plugin_config.get_value("config", "background_color")
	$Appearance/BGColor/ColorPickerButton.color = Color(scrnOutput._background_color)
	scrnOutput._font_size = float(_plugin_config.get_value("config", "font_size"))
	$Appearance/FontSize/LineEdit.value = scrnOutput._font_size
	scrnOutput._anchor = int(_plugin_config.get_value("config", "anchor"))
	$Layout/Anchor/OptionButton.select(scrnOutput._anchor)
	scrnOutput._save_logs = bool(_plugin_config.get_value("config", "save_logs"))
	$BasicConfig/Logfile/CheckBox.button_pressed = scrnOutput._save_logs
	scrnOutput._save_path = str(_plugin_config.get_value("config", "save_path"))
	$BasicConfig/SavePath/TextEdit.text = scrnOutput._save_path
	scrnOutput._size.x = int(_plugin_config.get_value("config", "size_x"))
	$Appearance/Size/X/LineEdit.value = scrnOutput._size.x
	scrnOutput._size.y = int(_plugin_config.get_value("config", "size_y"))
	$Appearance/Size/Y/LineEdit.value = scrnOutput._size.y
	
func _save_config():
	scrnOutput._debug_enabled = $BasicConfig/DebugEnabled/CheckBox.button_pressed
	_plugin_config.set_value("config", "debug_enabled", scrnOutput._debug_enabled)
	scrnOutput._show_timestamp = $BasicConfig/Timestamp/CheckBox.button_pressed
	_plugin_config.set_value("config", "show_timestamp", scrnOutput._show_timestamp)
	scrnOutput._font_color = $Appearance/FontColor/ColorPickerButton.color.to_html(true)
	_plugin_config.set_value("config", "font_color", scrnOutput._font_color)
	scrnOutput._background_color = $Appearance/BGColor/ColorPickerButton.color.to_html(true)
	_plugin_config.set_value("config", "background_color", scrnOutput._background_color)
	scrnOutput._font_size = float($Appearance/FontSize/LineEdit.value)
	_plugin_config.set_value("config", "font_size", scrnOutput._font_size)
	scrnOutput._anchor = int($Layout/Anchor/OptionButton.selected)
	_plugin_config.set_value("config", "anchor", scrnOutput._anchor)
	scrnOutput._save_logs = $BasicConfig/Logfile/CheckBox.button_pressed
	_plugin_config.set_value("config", "save_logs", scrnOutput._save_logs)
	scrnOutput._save_path = $BasicConfig/SavePath/TextEdit.text
	_plugin_config.set_value("config", "save_path", scrnOutput._save_path)
	scrnOutput._size.x = $Appearance/Size/X/LineEdit.value
	_plugin_config.set_value("config", "size_x", scrnOutput._size.x)
	scrnOutput._size.y = $Appearance/Size/Y/LineEdit.value
	_plugin_config.set_value("config", "size_y", scrnOutput._size.y)
	
	_plugin_config.save(_config_path)


func _on_button_pressed() -> void:
	file_dialog = btn.get_child(0) as FileDialog
	file_dialog.visible = true
	
	file_dialog.dir_selected.connect(_save_path)
	
func _save_path(dir : String):
	$BasicConfig/SavePath/TextEdit.text = dir
	file_dialog.dir_selected.disconnect(_save_path)
