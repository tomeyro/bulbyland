extends Node


onready var target_window_size : Vector2 = Vector2(
    ProjectSettings.get_setting("display/window/size/width"),
    ProjectSettings.get_setting("display/window/size/height"))
onready var target_window_aspect : float = target_window_size.x / target_window_size.y


const MAX_LEVEL = 12
