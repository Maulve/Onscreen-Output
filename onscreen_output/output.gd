extends CanvasLayer

var log_id: int = 1

@onready var main_control: Control = $Control
@onready var log_label: RichTextLabel = $Control/RichTextLabel
@onready var color_rect: ColorRect = $Control/RichTextLabel/ColorRect

var start: int = 0

var config_path: String = "res://addons/onscreen_output/config.tres"
var config := OnscreenOutputConfig.new()

const ANCHORS: Dictionary = {
	"TOP_LEFT" : {
		"anchor_left" : 0,
		"anchor_top" : 0,
		"anchor_right" : 0,
		"anchor_bottom" : 0,
		"grow_horizontal" : 1,
		"grow_vertical": 1
	},
	"TOP_RIGHT" : {
		"anchor_left" : 1,
		"anchor_top" : 0,
		"anchor_right" : 1,
		"anchor_bottom" : 0, 
		"grow_horizontal" : 0,
		"grow_vertical": 1
	},
	"BOTTOM_RIGHT" : {
		"anchor_left" : 1,
		"anchor_top" : 1,
		"anchor_right" : 1,
		"anchor_bottom" : 1,
		"grow_horizontal" : 0,
		"grow_vertical": 0
	},
	"BOTTOM_LEFT" : {
		"anchor_left" : 0,
		"anchor_top" : 1,
		"anchor_right" : 0,
		"anchor_bottom" : 1,
		"grow_horizontal" : 1,
		"grow_vertical": 0
	}
}

func _ready():
	visible = false
	
	_load_config()
	_setup()
	
	if !Engine.is_editor_hint() and config.show_timestamp:
		start = Time.get_ticks_msec()
	
	var event = config.toggle_keybind
	
	if !InputMap.has_action("OnscreenOutput_toggle"):
		InputMap.add_action("OnscreenOutput_toggle")
	InputMap.action_add_event("OnscreenOutput_toggle", event)

func _physics_process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		if Input.is_action_just_pressed("OnscreenOutput_toggle"):
			visible = !visible

func _set_control_anchor(control: Control,anchor: Dictionary):
	# As of 4.1, not tested again in 4.2
	# THIS FUNC IS ESSENTIAL
	# The built-in Control.LayoutPreset options don't work properly
	# likely Godot bug
	
	control.anchor_left = anchor["anchor_left"]
	control.anchor_top = anchor["anchor_top"]
	control.anchor_right = anchor["anchor_right"]
	control.anchor_bottom = anchor["anchor_bottom"] 
	
	control.grow_horizontal = anchor["grow_horizontal"]
	control.grow_vertical = anchor["grow_vertical"]

func _setup():
	log_label.custom_minimum_size.x = DisplayServer.window_get_size().x / 4
	log_label.custom_minimum_size.y = DisplayServer.window_get_size().y / 2
	
	log_label.add_theme_font_size_override("normal_font_size", config.font_size)
	
	match config.anchor:
		0: # Top-Left
			_set_control_anchor(log_label, ANCHORS["TOP_LEFT"])
			
		1: # Top-Right
			_set_control_anchor(log_label, ANCHORS["TOP_RIGHT"])
			
		2: # Bottom-Left
			_set_control_anchor(log_label, ANCHORS["BOTTOM_LEFT"])
			
		3: # Bottom-Right
			_set_control_anchor(log_label, ANCHORS["BOTTOM_RIGHT"])
	
	
	color_rect.color = Color(config.background_color)
	
	visible = !Engine.is_editor_hint() and config.debug_enabled

func print(message: String):
	if not config.debug_enabled:
		printerr("Onscreen Output: Tried to print, but debug is disabled.")
		return
	
	
	log_label.append_text(" > " + message)

	if config.show_timestamp:
		log_label.push_indent(1)
		log_label.append_text("[color=yellow]%s[/color]" % _get_timestamp())
		log_label.pop()
	
	log_label.newline()

func _get_timestamp() -> String:
	var time_ms: int = Time.get_ticks_msec() - start
	var time_s: int = 0
	var time_min: int = 0
	
	# get s from ms
	time_s = time_ms / 1000
	
	# get min from s
	time_min = time_s / 60
	
	# cap ms and s
	time_ms -= (time_s * 1000)
	time_s -= (time_min * 60)
	
	var timestamp_string: String = "%dmin %ds %dms" % [time_min, time_s, time_ms]
	
	return timestamp_string

func _load_config() -> void:
	config = ResourceLoader.load(config_path)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		
		if !config.save_logs:
			return
		
		var save_path := config.log_path.replace("\\", "/")
		
		if !save_path.ends_with("/"):
			save_path += "/"
		
		if !DirAccess.dir_exists_absolute(save_path):
			DirAccess.make_dir_absolute(save_path)
			
		var file := FileAccess.open(save_path + "OnscrnOutput_LOG%d.txt" % log_id, FileAccess.WRITE)
		file.store_string(log_label.get_parsed_text())
		file.close()
		log_id += 1
