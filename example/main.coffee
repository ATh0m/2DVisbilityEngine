# Lista wszystkich odcinków, które mają wpływ na widoczność
# Każdy odcinek składa się z dwóch punktów (a, b) o współrzędnych x, y
segments = [
    # Obwód
        a: x: 0, y: 0
        b: x: 640, y: 0
    ,
        a: x: 640, y: 0
        b: x: 640, y: 360
    ,
        a: x: 640, y: 360
        b: x: 0, y: 360
    ,
        a: x: 0, y: 360
        b: x: 0, y: 0
]

# RYSOWANIE
canvas = document.getElementById 'canvas'
context = canvas.getContext '2d'

# Funkcja rysująca
draw = ->
    # Czyszczenie canvas
    context.clearRect 0, 0, canvas.width, canvas.height

    # Rysowanie odcinków
    context.strokeStyle = '#000'
    for segment in segments
        context.beginPath()
        context.moveTo segment.a.x, segment.a.y
        context.lineTo segment.b.x, segment.b.y
        context.stroke()

# Zmienna, która dba o to, żeby widok aktualizował się tylko gdy jest to potrzebne
updateCanvas = true

# Główna pętla do aktualizacji widoku
drawLoop = ->
    requestAnimationFrame drawLoop
    # Ponowne rysowanie widoku tylko w razie potrzeby
    if updateCanvas
        draw()
        updateCanvas = false

# Odpalenie funkcji rysującej przy załadowaniu okna
window.onload = ->
    drawLoop()
