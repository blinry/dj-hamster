extends Node2D

var down = false

func _ready():
    pass
    
func _process(delta):
    if down:
        position.y += delta*1200
    elif position.y > 0:
        position.y -= delta*1200
        
    if position.y < 0:
        position.y = 0
        
func showCover():
    down = false
    position.y = 1000
    $Turn.play()

func hideCover(body):
    down = true
    $Turn.play()
    #() # Replace with function body.
