@tool
extends CanvasLayer
class_name OnscrnOutput

var _messages_on_screen : int
var _last_top_position : int = 0

var _debug_enabled : bool = false
var _show_timestamp : bool
var _font_color : String
var _background_color : String
var _font_size : float
var _anchor : int

var _plugin_config : ConfigFile

var _config_path : String = "res://addons/onscreen_output/plugin.cfg"


@onready var main_control = $Control

@onready var log_label = $Control/RichTextLabel

var start : int = 0

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
	
	if !Engine.is_editor_hint():
		_load_config()
		_setup()
	
	if !Engine.is_editor_hint() and _show_timestamp:
		start = Time.get_ticks_msec()

# THIS FUNC IS ESSENTIAL
# The built-in Control.LayoutPreset options don't work properly
# likely Godot bug
func _set_label_anchor(anchor : Dictionary):
	
	log_label.anchor_left = anchor["anchor_left"]
	log_label.anchor_top = anchor["anchor_top"]
	log_label.anchor_right = anchor["anchor_right"]
	log_label.anchor_bottom = anchor["anchor_bottom"] 
	
	log_label.grow_horizontal = anchor["grow_horizontal"]
	log_label.grow_vertical = anchor["grow_vertical"]


func _setup():
	
	# Configure label visuals
	log_label.add_theme_font_size_override("normal_font_size", _font_size)
	
	match _anchor:
		0: # Top-Left
			_set_label_anchor(ANCHORS["TOP_LEFT"])
		1: # Top-Right
			_set_label_anchor(ANCHORS["TOP_RIGHT"])
		2: # Bottom-Left
			_set_label_anchor(ANCHORS["BOTTOM_LEFT"])
		3: # Bottom-Right
			_set_label_anchor(ANCHORS["BOTTOM_RIGHT"])
	
	# Create a new ColorRect
	var color_rect = $Control/RichTextLabel/ColorRect
	
	# Set the color of the ColorRect using a hex value
	color_rect.color = Color(_background_color)
	color_rect.color.a = 100
	
	# sets visibility to false
	visible = false


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


func print(message : String):
	if not _debug_enabled:
		printerr("Onscreen Output: Tried to print, but debug is disabled.")
		return
	
	if not visible:
		visible = true
	
	log_label.append_text(" > " + message)

	if _show_timestamp:
		log_label.push_indent(1)
		log_label.append_text("[color=yellow]%s[/color]" % _get_timestamp())
		log_label.pop()
	
	log_label.newline()
	
	_messages_on_screen += 1

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
