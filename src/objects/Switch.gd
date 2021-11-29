extends Spatial


onready var anim: AnimationPlayer = $AnimationPlayer


var on: bool = false


func _on_BulbyDetector_area_entered(area: Area) -> void:
    on = !on
    if on:
        anim.play("TurnOn")
    else:
        anim.play("TurnOff")
    for child in get_children():
        if child.is_in_group("block"):
            child.on_bulby(area.get_parent(), true)
    AudioManager.play_sfx_switch()
