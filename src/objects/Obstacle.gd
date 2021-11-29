tool
extends MeshInstance


export(Tools.COLORS) var color = Tools.COLORS.black setget set_color
export var velocity: float = 50


onready var material = $InnerBlock.mesh.surface_get_material(0)
onready var original_position: Vector3 = translation


onready var target_position: Vector3 = original_position


func _ready() -> void:
    # warning-ignore:return_value_discarded
    BulbySignals.connect("new_color", self, "on_bulby_new_color")
    self.color = color


func _process(delta: float) -> void:
    if Engine.is_editor_hint():
        return
    if target_position and translation != target_position:
        translation = translation.move_toward(target_position, velocity * delta)


func on_bulby_new_color(new_color) -> void:
    target_position = original_position if new_color != color else (original_position + Vector3(0, velocity / 2, 0))


func set_color(new_color):
    color = new_color
    if material:
        material.albedo_color = Tools.get_color(color)
