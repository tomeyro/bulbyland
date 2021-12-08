extends Spatial


export var level: int = 1


var blocks: Array
var blocks_count: int = 0
var blocks_on: int = 0 setget set_blocks_on
var completed: bool = false


onready var retry_btn: TextureButton = $UI/Common/RetryButton
onready var title_btn: TextureButton = $UI/Common/TitleButton
onready var empty_bar: Sprite = $UI/Common/Battery/BatteryEmptyBar


func _ready() -> void:
    blocks = get_tree().get_nodes_in_group("block")
    blocks_count = len(blocks)
    for block in blocks:
        if block.is_on():
            self.blocks_on += 1
        block.connect("block_is_on", self, "on_block_on")
        block.connect("block_is_off", self, "on_block_off")
        block.connect("block_shorted", self, "on_block_shorted")

    self.blocks_on = blocks_on

    # warning-ignore:return_value_discarded
    retry_btn.connect("pressed", self, "on_retry")
    # warning-ignore:return_value_discarded
    title_btn.connect("pressed", self, "on_title")

    LevelSignals.emit_signal("level_started", self)


func on_block_on(_block) -> void:
    self.blocks_on += 1
    AudioManager.play_sfx_block()


func on_block_off(_block) -> void:
    self.blocks_on -= 1


func on_block_shorted(_block) -> void:
    self.blocks_on -= 1
    AudioManager.play_sfx_short()
    LevelSignals.emit_signal("level_failed", self)


func set_blocks_on(_blocks_on) -> void:
    blocks_on = _blocks_on

    if blocks_on == blocks_count:
        var timer = get_tree().create_timer(0.5)
        timer.connect("timeout", self, "check_for_win")


func on_retry() -> void:
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://src/levels/Level" + str(level) + ".tscn")


func on_title() -> void:
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://src/scenes/Title.tscn")


func _process(delta: float) -> void:
    var battery_value = 1.0 - (float(blocks_on) / float(blocks_count))
    if blocks_count == blocks_on:
        battery_value = 0
    empty_bar.scale.x = move_toward(empty_bar.scale.x, -battery_value, delta)
    if is_zero_approx(empty_bar.scale.x):
        empty_bar.visible = false


func check_for_win() -> void:
    if not completed and blocks_on == blocks_count:
        completed = true
        SaveManager.unlock_level(level + 1)
        LevelSignals.emit_signal("level_completed", self)
