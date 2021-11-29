extends Node


const SAVEFILE = "user://bulby.save"


var unlocked_level: int = 0


func _ready() -> void:
    load_game()


func load_game() -> void:
    var file = File.new()
    if not file.file_exists(SAVEFILE):
        unlock_level(1)
        return
    file.open(SAVEFILE, File.READ)
    unlocked_level = int(file.get_as_text().strip_edges())
    file.close()


func unlock_level(level) -> void:
    level = max(level, 1)
    if level <= unlocked_level:
        return
    unlocked_level = level
    var file = File.new()
    file.open(SAVEFILE, File.WRITE)
    file.store_string(str(unlocked_level))
    file.close()
