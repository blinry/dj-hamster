extends Node2D

var showMe = false

func _ready():
    pass

func _process(delta):
    if showMe and $Paper.position.x > 0:
        $Paper.position.x -= 100*delta
    if not showMe:
        $Paper.position.x += 1000*delta
    #print($Paper.position.x)

func showIt():
    if not showMe:
        $Paper.position.x = 150
        $Tada.play()
    showMe = true
