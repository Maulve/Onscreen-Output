@tool
extends CanvasLayer
class_name OnscrnOutput

var log_id : int = 1

var _debug_enabled : bool = false
var _show_timestamp : bool
var _font_color : String
var _background_color : String
var _font_size : float
var _anchor : int
var _save_logs : bool = false
var _save_path : String = "user://"

var _plugin_config : ConfigFile

var _config_path : String = "res://addons/onscreen_output/plugin.cfg"

@onready var main_control = $Control

@onready var log_label = $Control/RichTextLabel
@onready var color_rect = $Control/RichTextLabel/ColorRect
@onready var btn_control = $Control/BtnControl
@onready var toggle_btn = $Control/BtnControl/ToggleBtn

var start : int = 0

var _visible : bool = true

var was_in_editor : bool = true

const ANCHORS : Dictionary = {
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
	_load_config()
	_setup()
	
	if !Engine.is_editor_hint() and _show_timestamp:
		start = Time.get_ticks_msec()

func _set_control_anchor(control : Control,anchor : Dictionary):
	# THIS FUNC IS ESSENTIAL
	# The built-in Control.LayoutPreset options don't work properly
	# likely Godot bug
	
	control.anchor_left = anchor["anchor_left"]
	control.anchor_top = anchor["anchor_top"]
	control.anchor_right = anchor["anchor_right"]
	control.anchor_bottom = anchor["anchor_bottom"] 
	
	control.grow_horizontal = anchor["grow_horizontal"]
	control.grow_vertical = anchor["grow_vertical"]

func _set_same_anchor(target : Control, origin : Control):
	target.anchor_left = target.anchor_left
	target.anchor_top = target.anchor_top
	target.anchor_right = target.anchor_right
	target.anchor_bottom = target.anchor_bottom
	
	target.grow_horizontal = target.grow_horizontal
	target.grow_vertical = target.grow_vertical
	
	target.offset_bottom = 0
	target.offset_left = 0
	target.offset_right = 0
	target.offset_top = 0

func _toggle_visible(value : bool):
	
	log_label.visible = value
	
	if not value:
		
		match _anchor:
			0: # Top-Left
				_set_control_anchor(toggle_btn, ANCHORS["TOP_LEFT"])
			1: # Top-Right
				_set_control_anchor(toggle_btn, ANCHORS["TOP_RIGHT"])
			2: # Bottom-Left
				_set_control_anchor(toggle_btn, ANCHORS["BOTTOM_LEFT"])
			3: # Bottom-Right
				_set_control_anchor(toggle_btn, ANCHORS["BOTTOM_RIGHT"])
	
	else:
		
		match _anchor:
			0: # Top-Left
				_set_control_anchor(toggle_btn, ANCHORS["BOTTOM_LEFT"])
				toggle_btn.grow_vertical = 1
			1: # Top-Right
				_set_control_anchor(toggle_btn, ANCHORS["BOTTOM_RIGHT"])
				toggle_btn.grow_vertical = 1
			2: # Bottom-Left
				_set_control_anchor(toggle_btn, ANCHORS["TOP_LEFT"])
				toggle_btn.grow_vertical = 0
			3: # Bottom-Right
				_set_control_anchor(toggle_btn, ANCHORS["TOP_RIGHT"])
				toggle_btn.grow_vertical = 0

func _setup():
	
	#if !was_in_editor:
		
		
		#pass
	
	#was_in_editor = Engine.is_editor_hint()
	
	log_label.add_theme_font_size_override("normal_font_size", _font_size)
	
	toggle_btn.text = "Hide"
	toggle_btn.toggled.connect(func(toggled_on):
		_toggle_visible(!toggled_on)
		if !toggled_on:
			toggle_btn.text = "Hide"
		else:
			toggle_btn.text = "Show"
		)
	
	match _anchor:
		0: # Top-Left
			_set_control_anchor(log_label, ANCHORS["TOP_LEFT"])
			_set_control_anchor(btn_control, ANCHORS["TOP_LEFT"])
			
			_set_control_anchor(toggle_btn, ANCHORS["BOTTOM_LEFT"])
			toggle_btn.grow_vertical = 1
			
		1: # Top-Right
			_set_control_anchor(log_label, ANCHORS["TOP_RIGHT"])
			_set_control_anchor(btn_control, ANCHORS["TOP_RIGHT"])
			
			_set_control_anchor(toggle_btn, ANCHORS["BOTTOM_RIGHT"])
			toggle_btn.grow_vertical = 1
			
		2: # Bottom-Left
			_set_control_anchor(log_label, ANCHORS["BOTTOM_LEFT"])
			_set_control_anchor(btn_control, ANCHORS["BOTTOM_LEFT"])
			
			_set_control_anchor(toggle_btn, ANCHORS["TOP_LEFT"])
			toggle_btn.grow_vertical = 0
			
		3: # Bottom-Right
			_set_control_anchor(log_label, ANCHORS["BOTTOM_RIGHT"])
			_set_control_anchor(btn_control, ANCHORS["BOTTOM_RIGHT"])
			
			_set_control_anchor(toggle_btn, ANCHORS["TOP_RIGHT"])
			toggle_btn.grow_vertical = 0
	
	
	color_rect.color = Color(_background_color)
	
	visible = !Engine.is_editor_hint() and _debug_enabled


func _load_config():
	_plugin_config = ConfigFile.new()
	# Load data from a file.
	var err = _plugin_config.load(_config_path)

	# If the file didn't load, ignore it.
	if err != OK:
		printerr("Screen Output: Failed to load config. %s might be damaged or missing." % _config_path)
		return

	_debug_enabled = bool(_plugin_config.get_value("config", "debug_enabled"))
	_show_timestamp = bool(_plugin_config.get_value("config", "show_timestamp"))
	_font_color = _plugin_config.get_value("config", "font_color")
	_background_color = _plugin_config.get_value("config", "background_color")
	_font_size = float(_plugin_config.get_value("config", "font_size"))
	_anchor = int(_plugin_config.get_value("config", "anchor"))
	_save_logs = bool(_plugin_config.get_value("config", "save_logs"))
	_save_path = str(_plugin_config.get_value("config", "save_path"))
	log_id = int(_plugin_config.get_value("config", "log_id"))

func _save_config():
	_plugin_config.set_value("config", "log_id", log_id)
	
	_plugin_config.save(_config_path)

func print(message : String):
	if not _debug_enabled:
		printerr("Onscreen Output: Tried to print, but debug is disabled.")
		return
	
	
	log_label.append_text(" > " + message)

	if _show_timestamp:
		log_label.push_indent(1)
		log_label.append_text("[color=yellow]%s[/color]" % _get_timestamp())
		log_label.pop()
	
	log_label.newline()

func _get_timestamp() -> String:
	var time_ms : int = Time.get_ticks_msec() - start
	var time_s : int = 0
	var time_min : int = 0
	
	# get s from ms
	time_s = time_ms / 1000
	
	# get min from s
	time_min = time_s / 60
	
	# cap ms and s
	time_ms -= (time_s * 1000)
	time_s -= (time_min * 60)
	
	var timestamp_string : String = "%dmin %ds %dms" % [time_min, time_s, time_ms]
	
	return timestamp_string

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST and _save_logs:
		
		if !_save_path.ends_with("/"):
			_save_path += "/"
		
		if !DirAccess.dir_exists_absolute(_save_path):
			DirAccess.make_dir_absolute(_save_path)
			
		var file = FileAccess.open(_save_path + "OnscrnOutput_LOG%d.txt" % log_id, FileAccess.WRITE)
		file.store_string(log_label.get_parsed_text())
		file.close()
		log_id += 1
		
		_save_config()
