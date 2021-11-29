tool
extends Control
class_name BulbyButton


enum STATES {
    locked,
    unlocked,
    completed
}


export(STATES) var state: int = STATES.locked setget set_state
export var level: int = 1


onready var locked_btn: TextureButton = $Locked
onready var unlocked_btn: TextureButton = $Unlocked
onready var completed_btn: TextureButton = $Completed

onready var btn_size: Vector2 = locked_btn.rect_size
onready var btn_scale: Vector2 = locked_btn.rect_scale


func _ready() -> void:
    update_btn()


func set_state(new_state) -> void:
    state = new_state
    update_btn()


func update_btn() -> void:
    if locked_btn:
        locked_btn.visible = state == STATES.locked
    if unlocked_btn:
        unlocked_btn.visible = state == STATES.unlocked
    if completed_btn:
        completed_btn.visible = state == STATES.completed


func _on_Btn_pressed() -> void:
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://src/levels/Level" + str(level) + ".tscn")
