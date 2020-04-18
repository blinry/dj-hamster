extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var spectrum
var pitch = 0
var prev_m = Vector2(0,0)

var arm_rotation_start = 0
var arm_rotation_end = 22

# Called when the node enters the scene tree for the first time.
func _ready():
    $AudioStreamPlayer2D.play()
    #$AudioStreamPlayer2D2.play()
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
    var new_pitch = $RecordPlayer/Record/Player.force
    pitch = lerp(pitch, new_pitch, 0.005)
    
    var f = spectrum.get_magnitude_for_frequency_range(0,100,1)
    var db = linear2db(f.length())*10+600
    $RecordPlayer/Speed/Slider.position.x = $RecordPlayer/Speed/Line.points[0].x + pitch*0.5*($RecordPlayer/Speed/Line.points[1].x-$RecordPlayer/Speed/Line.points[0].x)
    
    var s = max(1,db/50)
    #var s2 = lerp($Re.scale.x, s, 0.05)
    #print($Vis.scale.x)
    #$Vis.scale = Vector2(s2, s2)
    #$Player.speed = pitch*100

    #pitch *= 0.999
    $AudioStreamPlayer2D.pitch_scale = pitch
    
    $RecordPlayer/Record.rotation += delta*pitch
    $RecordPlayer/Record/Player.rotation -= delta*pitch
    
    var progress = $AudioStreamPlayer2D.get_playback_position()/$AudioStreamPlayer2D.get_stream().get_length()
    $RecordPlayer/Arm.rotation_degrees = arm_rotation_start + (arm_rotation_end-arm_rotation_start)*progress

    prev_m = m
