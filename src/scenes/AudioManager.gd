extends Node


export var volume: float = 0 setget set_volume
export var volume_sfx: float = 0 setget set_volume_sfx

export var pitch_scale_max: float = 1.2 setget set_pitch_scale_max
export var pitch_scale_min: float = 0.8 setget set_pitch_scale_min


onready var music_tracks = [
    $Music/AudioStreamPlayer1,
    $Music/AudioStreamPlayer2,
    $Music/AudioStreamPlayer3,
    $Music/AudioStreamPlayer4,
    $Music/AudioStreamPlayer5,
    $Music/AudioStreamPlayer6,
]
onready var sfx_light: AudioStreamPlayer = $Sfx/Light
onready var sfx_block: AudioStreamPlayer = $Sfx/Block
onready var sfx_switch: AudioStreamPlayer = $Sfx/Switch


var current_pitch = 0
var current_track setget set_current_track


func _ready() -> void:
    randomize()
    for music_track in music_tracks:
        music_track.connect("finished", self, "on_track_finished")
    self.current_track = music_tracks[0]
    # warning-ignore:return_value_discarded
    LevelSignals.connect("level_started", self, "on_level_started")
    update_volume_sfx()


func on_track_finished() -> void:
    var idx = music_tracks.find(current_track) + 1
    if idx == len(music_tracks):
        idx = 0
    self.current_track = music_tracks[idx]


func set_current_track(new_track) -> void:
    current_track = new_track
    update_volume()
    current_track.play()


func set_volume(new_volume) -> void:
    volume = new_volume
    update_volume()


func update_volume() -> void:
    if not current_track:
        return
    current_track.volume_db = volume


func set_pitch_scale_max(new_pitch) -> void:
    pitch_scale_max = new_pitch


func set_pitch_scale_min(new_pitch) -> void:
    pitch_scale_min = new_pitch


func update_pitch() -> void:
    if not current_track:
        return
    var level_percentage = min(float(current_pitch), float(Globals.MAX_LEVEL)) / float(Globals.MAX_LEVEL)
    var pitch_diff = pitch_scale_max - pitch_scale_min
    current_track.pitch_scale = pitch_scale_min + (pitch_diff * level_percentage)


func on_level_started(level) -> void:
    current_pitch = level.level


func set_volume_sfx(new_volume) -> void:
    volume_sfx = new_volume
    update_volume_sfx()


func update_volume_sfx() -> void:
    if sfx_light:
        sfx_light.volume_db = volume_sfx
    if sfx_block:
        sfx_block.volume_db = volume_sfx
    if sfx_switch:
        sfx_switch.volume_db = volume_sfx


func play_sfx_light() -> void:
    if sfx_light.playing:
        sfx_light.stop()
    sfx_light.play()


func play_sfx_block() -> void:
    if sfx_light.playing:
        sfx_block.play()
    sfx_block.pitch_scale = 0.8
    sfx_block.play()


func play_sfx_short() -> void:
    if sfx_light.playing:
        sfx_block.play()
    sfx_block.pitch_scale = 0.6
    sfx_block.play()


func play_sfx_switch() -> void:
    if sfx_light.playing:
        sfx_switch.play()
    sfx_switch.play()
