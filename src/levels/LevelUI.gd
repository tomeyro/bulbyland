extends Control




func _on_Right_button_down() -> void:
    Input.action_press("move_right")


func _on_Right_button_up() -> void:
    Input.action_release("move_right")


func _on_Down_button_down() -> void:
    Input.action_press("move_down")


func _on_Down_button_up() -> void:
    Input.action_release("move_down")


func _on_Up_button_down() -> void:
    Input.action_press("move_up")


func _on_Up_button_up() -> void:
    Input.action_release("move_up")


func _on_Left_button_down() -> void:
    Input.action_press("move_left")


func _on_Left_button_up() -> void:
    Input.action_release("move_left")
