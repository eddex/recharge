extends Area2D


export var speed: int = 30

var direction: Vector2 = Vector2.ZERO


func _ready():
    $KillTimer.start()

func _physics_process(delta):
    if self.direction != Vector2.ZERO:
        var velocity = direction * speed
        global_position += velocity


func set_direction(direction: Vector2):
    self.direction = direction
    rotation += direction.angle()


func _on_KillTimer_timeout():
    queue_free()


func _on_Bullet_body_entered(body: Node):
    if body.has_method("handle_hit"):
        body.handle_hit()
    queue_free()
