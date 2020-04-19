extends KinematicBody2D

export var speed = 400
var dir = 0
var torque = 0

func _ready():
    pass
    
func move(d):
    move_and_slide(d)

func _process(delta):
    #dir = atan2(position.y, position.x) + get_parent().rotation
    dir = 0
    var right = Input.get_action_strength("right") - Input.get_action_strength("left")
    var down = Input.get_action_strength("down") - Input.get_action_strength("up")

    if Input.is_action_pressed("guide"):
        dir = global_position.angle_to_point(get_global_mouse_position()) - PI/2# + get_parent().rotation
        down = -1
        speed = 400*min(50, global_position.distance_to(get_global_mouse_position()))/50
        
    var movement = Vector2(right, down).normalized().rotated(dir)*speed
    
    var to_center = (get_parent().find_node("Record").global_position - global_position)
    
#    if to_center.length() < 500:
#        var mass = 10000
#        var centrifugal_force = mass*pow(get_parent().get_parent().angular_velocity, 2)/to_center.length()
#        #print(centrifugal_force)
#        movement -= centrifugal_force*to_center.normalized()
    
    move_and_slide(movement)
    
    #var forward = to_center.rotated(PI/2).normalized()
    #var projected = movement.dot(forward)
    #torque = projected/500#/500*(500-position.length())/150.0
    torque = -Vector3(to_center.x, 0, to_center.y).cross(Vector3(movement.x, 0, movement.y)).y/1000000
   
    if Vector2(right,down) != Vector2.ZERO and speed > 10:
        $Sprite.rotation = 0.1*sin(OS.get_system_time_msecs()/50)
