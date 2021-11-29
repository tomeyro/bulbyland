extends MeshInstance
class_name Block


signal block_is_on(block)
signal block_is_off(block)
signal block_shorted(block)


const BLOCK_SIZE: float = 4.0


export var color_update_speed: float = 2.0
export(Tools.COLORS) var color = Tools.COLORS.grey setget set_color
export(Tools.COLORS) var required_color = Tools.COLORS.grey


onready var material: SpatialMaterial = mesh.surface_get_material(0)
onready var target_color: Color = Tools.get_color(color)


var shorted: bool = false


func _ready() -> void:
    if required_color in [Tools.COLORS.grey, Tools.COLORS.black]:
        $RequiredColor.visible = false
    else:
        $RequiredColor.visible = true
        $RequiredColor/MeshInstance.mesh.surface_get_material(0).albedo_color = Tools.get_color(required_color)
        $RequiredColor/MeshInstance2.mesh.surface_get_material(0).albedo_color = Tools.get_color(required_color)


func _process(delta: float) -> void:
    if not material:
        return
    var current_color: Color = material.albedo_color
    if current_color != target_color:
        var current_color_v3: Vector3 = Tools.color_to_vector3(current_color)
        var target_color_v3: Vector3 = Tools.color_to_vector3(target_color)
        var new_color_v3 = current_color_v3.move_toward(target_color_v3, color_update_speed * delta)
        var new_color = Tools.vector3_to_color(new_color_v3)
        material.albedo_color = new_color


func _on_BulbyDetector_area_entered(area: Area) -> void:
    on_bulby(area.get_parent())



func on_bulby(bulby, safe: bool = false) -> void:
    if color == Tools.COLORS.black:
        return
    if is_on():
        self.color = Tools.COLORS.grey if safe else Tools.COLORS.black
    else:
        var invalid_colors = [Tools.COLORS.grey, Tools.COLORS.black]
        var new_color = bulby.color
        if safe and not (required_color in invalid_colors):
            new_color = required_color
        if required_color in invalid_colors or new_color == required_color:
            self.color = new_color


func set_color(new_color):
    if color == Tools.COLORS.black:
        return
    if is_on() and new_color != Tools.COLORS.grey:
        shorted = true
        color = Tools.COLORS.black
        target_color = Tools.get_color(color)
        emit_signal("block_shorted", self)
        return
    color = new_color
    target_color = Tools.get_color(color)
    if is_on():
        emit_signal("block_is_on", self)
    else:
        emit_signal("block_is_off", self)


func is_on():
    return color != Tools.COLORS.grey and not shorted
