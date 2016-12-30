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
    ,
    # Skała 1
        a: x: 30, y: 30
        b: x: 150, y: 80
    ,
        a: x: 150, y: 80
        b: x: 80, y: 170
    ,
        a: x: 80, y: 170
        b: x: 30, y: 30
    ,
    # Skała 2
        a: x: 150, y: 200
        b: x: 180, y: 220
    ,
        a: x: 180, y: 220
        b: x: 200, y: 300
    ,
        a: x: 200, y: 300
        b: x: 110, y: 280
    ,
        a: x: 110, y: 280
        b: x: 150, y: 200
    ,
    # Skała 3
        a: x: 500, y: 100
        b: x: 550, y: 150
    ,
        a: x: 550, y: 150
        b: x: 520, y: 260
    ,
        a: x: 520, y: 260
        b: x: 500, y: 100
    ,
    # Domek
        a: x: 250, y: 100
        b: x: 400, y: 100
    ,
        a: x: 400, y: 100
        b: x: 400, y: 150
    ,
        a: x: 400, y: 200
        b: x: 400, y: 250
    ,
        a: x: 400, y: 250
        b: x: 250, y: 250
    ,
        a: x: 250, y: 250
        b: x: 250, y: 225
    ,
        a: x: 250, y: 215
        b: x: 250, y: 200
    ,
        a: x: 250, y: 190
        b: x: 250, y: 175
    ,
        a: x: 250, y: 165
        b: x: 250, y: 150
    ,
        a: x: 250, y: 140
        b: x: 250, y: 100
]

# RYSOWANIE
canvas = document.getElementById 'canvas'
context = canvas.getContext '2d'

# Kursor myszy
mouse =
    x: canvas.width / 2
    y: canvas.height / 2

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

    # Zaznaczenie kursora
    context.fillStyle = '#dd3838'
    context.beginPath()
    context.arc mouse.x, mouse.y, 4, 0, Math.PI*2, false
    context.fill()

# Zmienna, która dba o to, żeby widok aktualizował się tylko gdy jest to potrzebne
updateCanvas = true

# Śledzenie ruchów myszy
canvas.onmousemove = (event) ->
    mouse.x = event.clientX - canvas.getBoundingClientRect().left
    mouse.y = event.clientY - canvas.getBoundingClientRect().top
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
