extends Node2D


onready var bullet_manager = $BulletManager
onready var player = $Player
onready var enemies = $Enemies
onready var camera = $Camera2D
onready var health_bar = $Camera2D/CanvasLayer/HealthBar
onready var robot = $Enemies/Robot


signal won()


func _ready():
    player.set_camera_transform(camera.get_path())
    player.connect("player_fired_bullet", bullet_manager, "handle_bullet_fired")
    player.connect("health_changed", self, "on_health_changed")
    robot.connect("boss_mode_activated", self, "on_boss_mode_activated")
    robot.connect("dead", self, "on_boss_dead")
    for enemy in enemies.get_children():
        enemy.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_fired")
    robot.player = player
    var new_dialog = Dialogic.start('start')
    add_child(new_dialog)


func on_health_changed(health):
    health_bar.value = health


func on_boss_mode_activated():
    var new_dialog = Dialogic.start("robot_turns_evil")
    new_dialog.connect("dialogic_signal", self, "on_boss_dialogue_closed")
    add_child(new_dialog)


func on_boss_dialogue_closed(arg):
    robot.boss_dialogue = false


func on_boss_dead():
    var new_dialog = Dialogic.start("end")
    new_dialog.connect("dialogic_signal", self, "on_end_dialogue_closed")
    add_child(new_dialog)
    

func on_end_dialogue_closed(arg):
    emit_signal("won")
    queue_free()
