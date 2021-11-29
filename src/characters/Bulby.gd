extends KinematicBody
class_name Bulby


export var speed: float = 10
export var rotation_speed: float = 10
export(Tools.COLORS) var color = Tools.COLORS.yellow
export var color_update_speed: float = 2
export var head_material: SpatialMaterial
export var arms_material: SpatialMaterial
export var legs_material: SpatialMaterial


var velocity = Vector3.ZERO
var target: Vector3
var rotator: Spatial
var shader: ShaderMaterial = preload("res://src/characters/BulbyShader.tres")
var dancing: bool = false


onready var animation_player: AnimationPlayer = $Bulby/AnimationPlayer
onready var block_detector: RayCast = $BlockDetector


func _ready() -> void:
    rotator = Spatial.new()
    get_parent().call_deferred("add_child", rotator)

    head_material.next_pass = ShaderMaterial.new()
    head_material.next_pass.set("shader", shader.shader)
    arms_material.next_pass = ShaderMaterial.new()
    arms_material.next_pass.set("shader", shader.shader)
    legs_material.next_pass = ShaderMaterial.new()
    legs_material.next_pass.set("shader", shader.shader)

    emit_new_color()

    # warning-ignore:return_value_discarded
    LevelSignals.connect("level_completed", self, "on_level_completed")
    # warning-ignore:return_value_discarded
    LevelSignals.connect("level_failed", self, "on_level_failed")


func _get_movement() -> Vector3:
    if Input.is_action_just_pressed("move_up"):
        return Vector3(0, 0, 1)
    if Input.is_action_just_pressed("move_down"):
        return Vector3(0, 0, -1)
    if Input.is_action_just_pressed("move_left"):
        return Vector3(1, 0, 0)
    if Input.is_action_just_pressed("move_right"):
        return Vector3(-1, 0, 0)
    return Vector3.ZERO


func _update_color(delta: float) -> void:
    var current_color: Vector3 = Tools.color_to_vector3(head_material.next_pass.get_shader_param("color"))
    var new_color_v3 = current_color.move_toward(Tools.color_to_vector3(Tools.get_color(color)), color_update_speed * delta)
    var new_color = Color(new_color_v3.x, new_color_v3.y, new_color_v3.z, 1)
    head_material.next_pass.set_shader_param("color", new_color)
    arms_material.next_pass.set_shader_param("color", new_color)
    legs_material.next_pass.set_shader_param("color", new_color)


func _process(delta: float) -> void:
    _update_color(delta)

    if target == global_transform.origin and not dancing:
        var movement = _get_movement()
        if movement != Vector3.ZERO:
            var block_detector_y = block_detector.global_transform.origin.y
            block_detector.global_transform.origin = global_transform.origin + (movement * Block.BLOCK_SIZE)
            block_detector.global_transform.origin.y = block_detector_y
            block_detector.force_raycast_update()

            if block_detector.is_colliding():
                var collider = block_detector.get_collider()
                if collider.is_in_group("obstacle"):
                    pass

                else:
                    target = collider.global_transform.origin
                    target.y = global_transform.origin.y

                    rotator.global_transform.origin = global_transform.origin
                    rotator.look_at(target, Vector3.UP)

    if target != global_transform.origin:
        animation_player.play("Walk", -1, 2)

        rotation.y = lerp_angle(rotation.y, rotator.rotation.y, rotation_speed * delta)
        global_transform.origin = global_transform.origin.move_toward(target, speed * delta)

    else:
        if dancing:
            rotation.y = 0
            animation_player.play("Walk", -1, 4)

        else:
            animation_player.play("Idle", -1, 1.2)


func _on_LightDetector_area_entered(area: Area) -> void:
    if color != Tools.COLORS.grey:
        AudioManager.play_sfx_light()
    color = area.get_parent().color
    emit_new_color()


func emit_new_color() -> void:
    BulbySignals.emit_signal("new_color", color)


func on_level_completed(_level) -> void:
    dancing = true


func on_level_failed(_level) -> void:
    dancing = true
