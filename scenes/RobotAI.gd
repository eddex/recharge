extends Node2D


signal energy_pickup_detected(energy_pickup)
signal evil_mode_entered()

var evil_mode = false

var actor = null
var last_fired = 0

func _process(delta):
    if evil_mode:
        if last_fired > 1:
            actor.shoot()
            last_fired = 0
        else:
            last_fired += delta


func _on_DetectionZone_body_entered(body):
    if body.has_method("pick_up") and !body.picked_up:
        emit_signal("energy_pickup_detected", body)	


func _on_PickupZone_body_entered(body):
    if body.has_method("pick_up"):
        body.pick_up()


func _on_PickupZone_area_entered(area: Area2D):
    if area.name == "RobotEvilArea":
        emit_signal("evil_mode_entered")	
        evil_mode = true
