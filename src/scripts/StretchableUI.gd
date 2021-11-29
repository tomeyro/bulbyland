extends Control


func _process(_delta: float) -> void:
    var viewport_size : Vector2 = get_viewport().size
    rect_scale = Vector2(
        viewport_size.x / Globals.target_window_size.x,
        viewport_size.y / Globals.target_window_size.y)
