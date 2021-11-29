extends Control
class_name ResizableUI


enum HorizontalAlignments {
    Left,
    Right,
    Center
}
enum VerticalAlignments {
    Top,
    Bottom,
    Center
}


export(HorizontalAlignments) var horizontal_alignment = HorizontalAlignments.Left
export(VerticalAlignments) var vertical_alignment = VerticalAlignments.Top


onready var original_position : Vector2 = rect_position


func _process(_delta: float) -> void:
    var viewport_size : Vector2 = get_viewport().size
    var half_viewport_size : Vector2 = viewport_size / 2

    var window_scale : float = min(
        viewport_size.x / Globals.target_window_size.x,
        viewport_size.y / Globals.target_window_size.y)

    rect_scale = Vector2(window_scale, window_scale)

    var new_position : Vector2 = Vector2.ZERO

    var scaled_diff : Vector2 = (Globals.target_window_size - original_position) * window_scale
    var half_diff : Vector2 = ((Globals.target_window_size / 2) - original_position) * window_scale

    if (horizontal_alignment == HorizontalAlignments.Left):
        new_position.x = original_position.x * window_scale
    elif (horizontal_alignment == HorizontalAlignments.Right):
        new_position.x = viewport_size.x - scaled_diff.x
    elif (horizontal_alignment == HorizontalAlignments.Center):
        new_position.x = half_viewport_size.x - half_diff.x

    if (vertical_alignment == VerticalAlignments.Top):
        new_position.y = original_position.y * window_scale
    elif (vertical_alignment == VerticalAlignments.Bottom):
        new_position.y = viewport_size.y - scaled_diff.y
    elif (vertical_alignment == VerticalAlignments.Center):
        new_position.y = half_viewport_size.y - half_diff.y

    rect_position = new_position
