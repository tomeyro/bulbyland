extends Camera


export var follow_node_path: NodePath
export var camera_speed: float = 7.0


var follow_node: Spatial
var starting_translation: Vector3


func _ready() -> void:
    if follow_node_path:
        follow_node = get_node(follow_node_path)

    starting_translation = translation


func _process(delta: float) -> void:
    if follow_node:
        global_transform.origin = global_transform.origin.move_toward(follow_node.global_transform.origin + starting_translation, camera_speed * delta)
