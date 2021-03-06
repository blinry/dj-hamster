extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    $Life.wait_time = rand_range(5,20)
    $Life.start()

func collect(body):
    $PickupSound.pitch_scale = rand_range(0.9,1.1)
    $PickupSound.play()
    hide()
    set_process(false)
    #$"/root/Main".angular_velocity *= rand_range(0.8,1.2)
    game.state.points += 1
    game.save_state()
    yield($PickupSound, "finished")
    queue_free()

func move(d):
    position += d/75


func die():
    queue_free()
