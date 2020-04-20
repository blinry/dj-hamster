extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#var spectrum
var pitch = 0.000001
var prev_m = Vector2(0,0)

var arm_rotation_start = 0
var arm_rotation_end = 22

var angular_velocity = 0

var record_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    #print("ok")
    load_record(0)
    #print("ok")
    #$Music.play()
    #$Music.pitch_scale = pitch
    #spectrum = AudioServer.get_bus_effect_instance(0,0)

func _input(event):
    pass
#    if event.is_action_pressed("left"):
#        $Music.seek($Music.get_playback_position()-30)
#    if event.is_action_pressed("right"):
#        $Music.seek($Music.get_playback_position()+30)
    if event.is_action_pressed("next"):
        next()
    if event.is_action_pressed("prev"):
        prev()
#    if event.is_action_pressed("ui_accept"):
#        angular_velocity = 1

func _process(delta):
    $Points.text = str(game.state.points) + "/" + str((record_id+1)*10)
    if unlocked() > record_id:
        $Unlock.show()
    else:
        $Unlock.hide()
    
    var m = get_global_mouse_position()
    
    #var new_pitch = prev_m.distance_to(m)/50
    
    if $RecordPlayer/Player.global_position.distance_to($RecordPlayer/Record.global_position) < 500:
        var rotational_inertia = 50
        var angular_acceleration = $RecordPlayer/Player.torque/rotational_inertia
        angular_velocity += angular_acceleration
    
    pull_with($RecordPlayer/Player)
    for t in get_tree().get_nodes_in_group("powerup"):
        pull_with(t)
    for t in get_tree().get_nodes_in_group("powerdown"):
        pull_with(t)
    
    # friction
    angular_velocity -= delta*angular_velocity*0.02
    
    
    pitch = angular_velocity
    #pitch = lerp(pitch, new_pitch, 0.005)
    
    #var f = spectrum.get_magnitude_for_frequency_range(0,100,1)
    #var db = linear2db(f.length())*10+600
    $RecordPlayer/Speed/Slider.position.x = $RecordPlayer/Speed/Line.points[0].x + min(($RecordPlayer/Speed/Line.points[1].x-$RecordPlayer/Speed/Line.points[0].x),max(0,pitch*0.5*($RecordPlayer/Speed/Line.points[1].x-$RecordPlayer/Speed/Line.points[0].x)))
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
    
    if golden():
        $Music.pitch_scale = 1
        $Static.pitch_scale = 1
    elif pitch < 1:
        $Music.pitch_scale = pitch/0.9
        $Static.pitch_scale = abs(pitch/0.9)
    elif pitch > 1:
        $Music.pitch_scale = pitch/1.1
        $Static.pitch_scale = abs(pitch/1.1)
        
    
    $RecordPlayer/Record.rotation += delta*angular_velocity
    #$RecordPlayer/Player.rotation -= delta*angular_velocity
    
    var progress = $Music.get_playback_position()/$Music.get_stream().get_length()
    $RecordPlayer/Arm.rotation_degrees = arm_rotation_start + (arm_rotation_end-arm_rotation_start)*progress

    prev_m = m


    var name = records()[record_id]
    if randi() % 200 == 0 and golden() and len(get_tree().get_nodes_in_group("powerup")) < 3:
        var c = preload("res://powerup.tscn").instance()
        c.position = Vector2(rand_range(-400, 400), rand_range(-400, 400))
        c.find_node("Image").texture = load("res://records/"+name+"/good.png")
        c.find_node("PickupSound").set_stream(load("res://records/"+name+"/good.wav"))
        $RecordPlayer.add_child(c)
    if randi() % 200 == 0 and golden() and len(get_tree().get_nodes_in_group("powerdown")) < 3:
        var c = preload("res://powerdown.tscn").instance()
        c.position = Vector2(rand_range(-400, 400), rand_range(-400, 400))
        c.find_node("Image").texture = load("res://records/"+name+"/bad.png")
        c.find_node("PickupSound").set_stream(load("res://records/"+name+"/bad.wav"))
        $RecordPlayer.add_child(c)
    
func pull_with(t):
    if t.global_position.distance_to($RecordPlayer/Record.global_position) < 500:
        var to_hamster = t.global_position-$RecordPlayer/Record.global_position
        var forward = to_hamster.rotated(PI/2).normalized()
        t.move(forward*angular_velocity*to_hamster.length())
    
func golden():
    return pitch > 0.9 and pitch < 1.1

func records():
    return ["20000-pixels", "1room", "bloody", "spring-clean", "splendid-adventures", "writespace", "artisan-artefacts", "capitalist-piggies", "wurst-day-ever"]

func records2():
    #var tscn_regex = RegEx.new()
    #tscn_regex.compile("\\.ogg$")
    var levels = []
    var level_dir = Directory.new()
    level_dir.open("records")
    level_dir.list_dir_begin(true)
    var level = level_dir.get_next()
    while level != "":
        #if tscn_regex.search(level):
        levels.push_back(level)
        level = level_dir.get_next()
    #print(levels)
    return levels

func load_record(n):
    var name = records()[n]
    #print(name)
    $RecordPlayer/Record/Label.texture = load("res://records/"+name+"/label.png")
    $Music.set_stream(load("res://records/"+name+"/music.ogg"))
    $Music.seek(0)
    pitch = 0.00001
    angular_velocity = 0.00001
    $Music.pitch_scale = pitch
    $Music.play()
    $Static.pitch_scale = pitch
    $Static.play()
    
    var fname = "res://records/"+name+"/text.txt"
    var file = File.new()
    if file.file_exists(fname):
        file.open(fname, File.READ)
        $Cover/Label.text = file.get_as_text()
        file.close()
    else:
        $Cover/Label.text = ""
    $Cover.position.y = 1000
    $Cover.down = false
    
    for t in get_tree().get_nodes_in_group("powerup"):
        t.queue_free()
    for t in get_tree().get_nodes_in_group("powerdown"):
        t.queue_free()
    $RecordPlayer/Record.rotation = 0
    angular_velocity = 0.00001
    var p = $RecordPlayer/Player.global_position
    if p.x < 200:
        $RecordPlayer/Player.position.x += 1920 - 500
    elif p.x > 1920-200:
        $RecordPlayer/Player.position.x -= 1920 - 500
func next(body=null):
    if unlocked() > record_id:
        record_id = (record_id+1)%len(records())
        load_record(record_id)

func prev(body=null):
    record_id = (record_id-1)%len(records())
    load_record(record_id)

func unlocked():
    return floor(game.state.points / 10)
