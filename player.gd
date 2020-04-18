extends KinematicBody2D

export var speed = 400
var dir = 0
var force = 0

func _ready():
    pass

func _process(delta):
    dir = atan2(position.y, position.x) + get_parent().rotation
    var right = Input.get_action_strength("right") - Input.get_action_strength("left")
    var down = Input.get_action_strength("down") - Input.get_action_strength("up")
    move_and_slide(Vector2(right, down).normalized().rotated(dir)*speed)
    force = -down*(500-position.length())/150.0
