@tool
class_name ScreenOutputMainPanel extends VBoxContainer

@onready var install_path: String = self.get_script().get_path().trim_suffix("main_panel.gd")

var _plugin_config : ConfigFile

@onready var _config_path : String = install_path + "plugin.cfg"
@onready var folder_icon = load(install_path + "Ignore/Folder.svg")

@onready var btn: TextureButton = $BasicConfig/SavePath/Button
var file_dialog : FileDialog

@onready var line_edit_x: SpinBox = $Appearance/Size/X/LineEdit
@onready var line_edit_y: SpinBox = $Appearance/Size/Y/LineEdit

## Determines how big the Output should be by default (when size_x is 0).
## Default size is calculated like this: DisplayServer.window_get_size().x / default_divider_x.
## Lower number means bigger size.
@export var default_divider_x: float = 6

## same as default_divider_x, but with y.
## Lower number means bigger size.
@export var default_divider_y: float = 3

func _ready():
	_load_config()
	
	btn.texture_normal = folder_icon
	
	$SaveButton.connect("pressed", _on_save_button_pressed)
	

func _on_save_button_pressed():
	_save_config()

func _load_config():
	_plugin_config = ConfigFile.new()
	
	var err = _plugin_config.load(_config_path)
	
	if err != OK:
		printerr("Screen Output: Failed to load config. %s might be damaged or missing." % _config_path)
		return
	
	$BasicConfig/DebugEnabled/CheckBox.button_pressed = bool(_plugin_config.get_value("config", "debug_enabled"))
	
	$BasicConfig/Timestamp/CheckBox.button_pressed = bool(_plugin_config.get_value("config", "show_timestamp"))
	
	$Appearance/FontColor/ColorPickerButton.color = Color(_plugin_config.get_value("config", "font_color"))
	
	$Appearance/BGColor/ColorPickerButton.color = Color(_plugin_config.get_value("config", "background_color"))
	
	$Appearance/FontSize/LineEdit.value = float(_plugin_config.get_value("config", "font_size"))
	
	$Layout/Anchor/OptionButton.select(int(_plugin_config.get_value("config", "anchor")))
	
	$BasicConfig/Logfile/CheckBox.button_pressed = bool(_plugin_config.get_value("config", "save_logs"))
	
	$BasicConfig/SavePath/TextEdit.text = str(_plugin_config.get_value("config", "save_path"))
	
	# calculate size if 0
	$Appearance/Size/X/LineEdit.value = int(_plugin_config.get_value("config", "size_x"))
	var size_x = $Appearance/Size/X/LineEdit.value
	if size_x == 0:
		size_x = DisplayServer.window_get_size().x / default_divider_x
		$Appearance/Size/X/LineEdit.value = size_x
	
	$Appearance/Size/Y/LineEdit.value = int(_plugin_config.get_value("config", "size_y"))
	var size_y = $Appearance/Size/Y/LineEdit.value
	if size_y == 0:
		size_y = DisplayServer.window_get_size().y / default_divider_y
		$Appearance/Size/Y/LineEdit.value = size_y
	
func _save_config():
	_plugin_config.set_value("config", "debug_enabled", $BasicConfig/DebugEnabled/CheckBox.button_pressed)
	
	_plugin_config.set_value("config", "show_timestamp", $BasicConfig/Timestamp/CheckBox.button_pressed)
	
	_plugin_config.set_value("config", "font_color", $Appearance/FontColor/ColorPickerButton.color.to_html(true))
	
	_plugin_config.set_value("config", "background_color", $Appearance/BGColor/ColorPickerButton.color.to_html(true))
	
	_plugin_config.set_value("config", "font_size", $Appearance/FontSize/LineEdit.value)

	_plugin_config.set_value("config", "anchor", int($Layout/Anchor/OptionButton.selected))
	
	_plugin_config.set_value("config", "save_logs", $BasicConfig/Logfile/CheckBox.button_pressed)
	
	_plugin_config.set_value("config", "save_path", $BasicConfig/SavePath/TextEdit.text)
	
	# calculate size if 0
	var size_x = $Appearance/Size/X/LineEdit.value
	if size_x == 0:
		size_x = DisplayServer.window_get_size().x / default_divider_x
		$Appearance/Size/X/LineEdit.value = size_x
	
	_plugin_config.set_value("config", "size_x", size_x)
	
	var size_y = $Appearance/Size/Y/LineEdit.value
	if size_y == 0:
		size_y = DisplayServer.window_get_size().y / default_divider_y
		$Appearance/Size/Y/LineEdit.value = size_y
	
	_plugin_config.set_value("config", "size_y", size_y)
	
	_plugin_config.save(_config_path)

func _on_button_pressed() -> void:
	file_dialog = btn.get_child(0) as FileDialog
	file_dialog.visible = true
	
	file_dialog.dir_selected.connect(_save_path)
	
func _save_path(dir : String):
	$BasicConfig/SavePath/TextEdit.text = dir
	file_dialog.dir_selected.disconnect(_save_path)
