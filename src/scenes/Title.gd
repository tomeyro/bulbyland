extends Control


var colors = ["yellow", "cyan", "pink", "green"]
var current_color = "yellow" setget set_current_color


onready var bulby_images: Array = $UI/Bulby.get_children()
onready var bulbyland_images: Array = $UI/Bulbyland.get_children()
onready var info: Control = $UI/Info


func _ready() -> void:
    set_current_color(current_color)
    generate_buttons()
    info.visible = false


func _on_ExitButton_pressed() -> void:
    get_tree().quit()


func _on_Level_button_pressed(button) -> void:
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://src/levels/" + button.name + ".tscn")


func _on_ImagesTimer_timeout() -> void:
    var next_color: int = colors.find(current_color) + 1
    if next_color == len(colors):
        next_color = 0
    self.current_color = colors[next_color]


func set_current_color(new_color) -> void:
    current_color = new_color
    for bulby_img in bulby_images:
        bulby_img.visible = bulby_img.name == ('Bulby' + current_color.capitalize())
    for bulbyland_img in bulbyland_images:
        bulbyland_img.visible = bulbyland_img.name == ('Bulbyland' + current_color.capitalize())


func generate_buttons() -> void:
    var btns = $UI/Buttons;
    var btn = btns.get_node("BulbyButton")
    btn.state = BulbyButton.STATES.completed if SaveManager.unlocked_level > 1 else BulbyButton.STATES.unlocked
    btn.level = 1

    for idx in range(1, Globals.MAX_LEVEL):
        var other_btn = btn.duplicate()
        # warning-ignore:integer_division
        var y_offset = (idx - (idx % 4)) / 4
        other_btn.rect_position += Vector2(
            btn.btn_size.x * 1.25 * btn.btn_scale.x * (idx % 4),
            btn.btn_size.y * 1.25 * btn.btn_scale.y * y_offset )
        var level = idx + 1
        other_btn.state = BulbyButton.STATES.locked
        if SaveManager.unlocked_level == level:
            other_btn.state = BulbyButton.STATES.unlocked
        if SaveManager.unlocked_level > level:
            other_btn.state = BulbyButton.STATES.completed
        other_btn.level = level

        btns.add_child(other_btn)


func _on_InfoButton_pressed() -> void:
    info.visible = true


func _on_CloseInfoButton_pressed() -> void:
    info.visible = false


func _on_links_clicked(meta) -> void:
    # warning-ignore:return_value_discarded
    OS.shell_open(meta)
