extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func _ready():
    $Life.wait_time = rand_range(5,20)
    $Life.start()

func collect(body):
    $PickupSound.pitch_scale = rand_range(0.9,1.1)
    $PickupSound.play()
    $Backspin.play()
    hide()
    set_process(false)
    #$"/root/Main".angular_velocity *= 0.9
    var progress = $"/root/Main".record_id/(len($"/root/Main".records())-1)
    var a = 0.5+lerp(0.3, 0, progress)
    var b = 2-lerp(0.8, 0, progress)
    $"/root/Main".set_golden(rand_range(a,b),$"/root/Main".golden_size)
    game.state.points -= 1
    game.save_state()
    #yield($PickupSound, "finished")
    yield($Backspin, "finished")
    
    queue_free()

func move(d):
    position += d/75

func die():
    queue_free()
