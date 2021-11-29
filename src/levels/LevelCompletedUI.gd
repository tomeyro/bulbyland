extends Control


onready var next_level_button: TextureButton = $Buttons/NextLevelButton
onready var retry_button: TextureButton = $Buttons/RetryButton


var next_level: int = 0


func _ready() -> void:
    visible = false
    # warning-ignore:return_value_discarded
    LevelSignals.connect("level_completed", self, "on_level_completed")
    # warning-ignore:return_value_discarded
    LevelSignals.connect("level_failed", self, "on_level_failed")


func on_level_completed(level) -> void:
    next_level = level.level + 1
    next_level_button.visible = next_level <= Globals.MAX_LEVEL
    retry_button.visible = false
    visible = true


func on_level_failed(level) -> void:
    next_level_button.visible = false
    retry_button.visible = true
    next_level = level.level + 1
    visible = true


func _on_TitleScreenButton_pressed() -> void:
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://src/scenes/Title.tscn")


func _on_NextLevelButton_pressed() -> void:
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://src/levels/Level" + str(next_level) + ".tscn")


func _on_RetryButton_pressed() -> void:
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://src/levels/Level" + str(next_level - 1) + ".tscn")
