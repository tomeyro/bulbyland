extends Button


signal button_pressed(button)


func _ready() -> void:
    # warning-ignore:return_value_discarded
    connect("pressed", self, "on_button_pressed")


func on_button_pressed() -> void:
    emit_signal("button_pressed", self)
