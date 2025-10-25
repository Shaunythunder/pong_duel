extends Node

var mouse_enabled: bool = true
var difficulty: String = GlobalConstants.INSANE

func disable_mouse():
	mouse_enabled = false

func enable_mouse():
	mouse_enabled = true
