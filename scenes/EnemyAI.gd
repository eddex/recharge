extends Node2D

enum State {
    PATROL,
    ENGAGE
 }

onready var detection_zone = $DetectionZone

signal state_changed(state)

var state: int = State.PATROL setget set_state
var player = null
var actor = null
var last_fired = 0

func set_state(new_state: int):
    if state == new_state:
        return
    state = new_state
    emit_signal("state_changed", state)


func initialize(actor):
    self.actor = actor


func _process(delta):
    if state == State.ENGAGE:
        if player != null:
            actor.rotation = actor.global_position.direction_to(player.global_position).angle()
            if last_fired > 1:
                actor.shoot()
                last_fired = 0
            else:
                last_fired += delta

func _on_DetectionZone_body_entered(body: Node):
    if body.is_in_group("player"):
        set_state(State.ENGAGE)
        player = body
        print("player detected")
