extends Spatial


export(Tools.COLORS) var color = Tools.COLORS.yellow


func _ready() -> void:
    var mesh = $MeshInstance.mesh
    var material: SpatialMaterial = mesh.surface_get_material(0)
    material.albedo_color = Tools.get_color(color)
    mesh.surface_set_material(0, material)
