@tool
class_name OnscreenOutputPlugin extends EditorPlugin

const CONFIG_PATH := "config.tres"
const OUTPUT := "output.tscn"

var install_path: String = self.get_script().get_path().trim_suffix("plugin.gd")

func _init() -> void:
	var config: OnscreenOutputConfig = ResourceLoader.load(install_path + CONFIG_PATH)
	add_autoload_singleton(config.singleton_name, install_path + OUTPUT)

func _get_plugin_name():
	return "Onscreen Output"
