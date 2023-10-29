@tool
class_name ScreenOutputPlugin extends EditorPlugin

var install_path: String = self.get_script().get_path().trim_suffix("plugin.gd")

const SCREEN_OUTPUT_PATH: String = "output.tscn"
const MAIN_PANEL_PATH: String = "main_panel.tscn"

var main_panel = load(install_path + MAIN_PANEL_PATH)

var main_panel_instance: ScreenOutputMainPanel

func get_install_path() -> String:
	return install_path

func _enter_tree():
	main_panel_instance = main_panel.instantiate()
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_set_visible(false)
	
	# logic for showing the main scene
	main_screen_changed.connect(func(screen_name):
		if screen_name == "Onscreen Output":
			_set_visible(true)
		else:
			_set_visible(false))

func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()

func _set_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible

func _get_plugin_name():
	return "Onscreen Output"
	
func _has_main_screen():
	return true
	
func _get_plugin_icon():
	return EditorInterface.get_base_control().get_theme_icon("Node", "EditorIcons")

