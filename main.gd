extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var spectrum
var pitch = 0.000001
var prev_m = Vector2(0,0)

var arm_rotation_start = 0
var arm_rotation_end = 22

var angular_velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    $Music.play()
    $Music.pitch_scale = pitch
    spectrum = AudioServer.get_bus_effect_instance(0,0)

func _input(event):
#    if event.is_action_pressed("left"):
#        $AudioStreamPlayer2D.seek($AudioStreamPlayer2D.get_playback_position()-30)
#    if event.is_action_pressed("right"):
#        $AudioStreamPlayer2D.seek($AudioStreamPlayer2D.get_playback_position()+30)
    pass

func _process(delta):
    var m = get_global_mouse_position()
    
    #var new_pitch = prev_m.distance_to(m)/50
    
    if $RecordPlayer/Player.global_position.distance_to($RecordPlayer/Record.global_position) < 500:
        var rotational_inertia = 100
        var angular_acceleration = $RecordPlayer/Player.torque/rotational_inertia
        angular_velocity += angular_acceleration
        var to_hamster = $RecordPlayer/Player.global_position-$RecordPlayer/Record.global_position
        var forward = to_hamster.rotated(PI/2).normalized()
        $RecordPlayer/Player.move_and_slide(forward*angular_velocity*to_hamster.length())
    angular_velocity -= 0.05*delta*angular_velocity
    
    pitch = angular_velocity
    #pitch = lerp(pitch, new_pitch, 0.005)
    
    #var f = spectrum.get_magnitude_for_frequency_range(0,100,1)
    #var db = linear2db(f.length())*10+600
    $RecordPlayer/Speed/Slider.position.x = $RecordPlayer/Speed/Line.points[0].x + max(0,pitch*0.5*($RecordPlayer/Speed/Line.points[1].x-$RecordPlayer/Speed/Line.points[0].x))
    if golden():
        $RecordPlayer/Speed/Slider.modulate = Color("b9b551")
    else:
        $RecordPlayer/Speed/Slider.modulate = Color("ffffff")  
    
    #var s = max(1,db/50)
    #var s2 = lerp($Re.scale.x, s, 0.05)
    #print($Vis.scale.x)
    #$Vis.scale = Vector2(s2, s2)
    #$Player.speed = pitch*100

    #pitch *= 0.999
    #print(pitch)
    $Music.pitch_scale = pitch
    
    $RecordPlayer/Record.rotation += delta*angular_velocity
    #$RecordPlayer/Player.rotation -= delta*angular_velocity
    
    var progress = $Music.get_playback_position()/$Music.get_stream().get_length()
    $RecordPlayer/Arm.rotation_degrees = arm_rotation_start + (arm_rotation_end-arm_rotation_start)*progress

    prev_m = m


    if randi() % 200 == 0 and golden() and len(get_tree().get_nodes_in_group("cherries")) < 3:
        var c = preload("res://cherry.tscn").instance()
        c.position = Vector2(rand_range(-400, 400), rand_range(-400, 400))
        $RecordPlayer/Record.add_child(c)

func golden():
    return pitch > 0.9 and pitch < 1.1
