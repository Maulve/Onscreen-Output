@tool
class_name OnscreenOutputConfig extends Resource

@export_group("General")
@export var singleton_name := "Output"
@export var debug_enabled := true
@export var save_logs := false
@export var log_path := "user://"
@export var toggle_keybind: InputEventKey = null:
	get:
		if toggle_keybind == null:
			return load("res://addons/onscreen_output/default_keybind.tres")
		return toggle_keybind

@export_group("Output")
@export var show_timestamp := true
@export var font_color := Color("c6cad3ff")
@export var background_color := Color("191c2fff")
@export var font_size: float = 16.0:
	set(value):
		font_size = clampf(value, 1, INF)
@export_enum("Top Left", "Top Right", "Bottom Right", "Bottom Left") var anchor: int = 0
@export var size := Vector2():
	set(value):
		value = get_default(value)
		
		var real_size := get_window_real_size()
		var min_size := Vector2()
		min_size.x = real_size.x / 8
		min_size.y = real_size.y / 4
		
		value.x = clampf(value.x, min_size.x, INF)
		value.y = clampf(value.y, min_size.y, INF)
		size = get_default(value)

func get_default(value: Vector2) -> Vector2:
	var window_size := get_window_real_size()
	if value.x == 0:
		value.x = window_size.y / 4
	if value.y == 0:
		value.y = window_size.y / 2
	return value

func get_window_real_size() -> Vector2:
	var override := Vector2(
		ProjectSettings.get("display/window/size/window_width_override"),
		ProjectSettings.get("display/window/size/window_height_override")
	)
	if override != Vector2():
		return override
	
	var real_size := Vector2(
		ProjectSettings.get("display/window/size/viewport_width"),
		ProjectSettings.get("display/window/size/viewport_height")
	)
	return real_size
