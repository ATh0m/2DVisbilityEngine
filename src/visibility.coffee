# Moduł visibility odpowiada za znajdowanie wielokąta opisującego widoczny
# obszar dla zbioru odcinków i punktu obserwacji

# Znajdowanie przecięć dwóch odcinków
#
# @param [Segment] ray - pierwszy odcinek
# @param [Segment] segment - drugi odcinek
#
# Można to zrobić w prosty sposób poprzez wyznaczenie każdemu odcinkowi jego
# prostą i w ten sposób znalezienie punktu przecięcia z uwzględnieniem
# odpowiednich warunków (czy punkt należy do odcinków)
getIntersection = (ray, segment) ->
    r_px = ray.a.x
    r_py = ray.a.y
    r_dx = ray.b.x - ray.a.x
    r_dy = ray.b.y - ray.a.y

    s_px = segment.a.x
    s_py = segment.a.y
    s_dx = segment.b.x - segment.a.x
    s_dy = segment.b.y - segment.a.y

    r_mag = Math.sqrt r_dx * r_dx + r_dy * r_dy
    s_mag = Math.sqrt s_dx * s_dx + s_dy * s_dy

    # Jeśli proste są równoległe to nie istnieje punkt przecięcia
    if r_dx / r_mag is s_dx / s_mag and r_dy / r_mag is s_dy / s_mag
        return null

    T2 = (r_dx * (s_py - r_py) + r_dy * (r_px - s_px)) / (s_dx * r_dy - s_dy * r_dx)
    T1 = (s_px + s_dx * T2 - r_px) / r_dx

    return null if T1 < 0
    return null if T2 < 0 or T2 > 1

    return x: r_px + r_dx * T1, y: r_py + r_dy * T1, param: T1

# Znajduje wielokąt opisujący widziany obszar
#
# @param [Point] sight - punkt obserwacji
# @param [[Segment]] segments - lista odcinków
#
getSightPolygon = (sight, segments) ->

    # Wyciąganie punktów wyznaczających odcinki
    points = do (segments) ->
        a = []
        segments.map (segment) -> a.push segment.a, segment.b
        return a

    # Usuwanie duplikatów
    uniquePoints = do (points) ->
        set = {}
        points.filter (point) ->
            key = "#{point.x},#{point.y}"
            return fasle if key in set
            set[key] = true
            return true

    # Znajdowanie kątów wskazujących na dane punkty
    # Dzięki temu będzie można wyznaczyć dla każdego punktu 2 dodatkowe
    # proste przechądzące obok niego. Jest to potrzebne do lepszego wyznaczenia
    # widzianego obszaru
    uniqueAngles = []
    for uniquePoint in uniquePoints
        angle = Math.atan2 uniquePoint.y - sight.y, uniquePoint.x - sight.x
        uniquePoint.angle = angle
        # Dodatkowe kąty opisują potrzebne proste
        uniqueAngles.push angle - 0.00001, angle, angle + 0.00001

    # Lista przecięć utworzonych prostych z najbliższym odcinkiem
    intersects = []

    # Wyznaczanie prostych na podstawię kąta i znajdowanie ich przecięć
    # z odcinkami. Znalezienie najbliższego przecięcia względem punktu
    # obserwacji
    for angle in uniqueAngles
        dx = Math.cos angle
        dy = Math.sin angle

        # Zdefiniowanie prostej
        ray =
            a: x: sight.x, y: sight.y
            b: x: sight.x + dx, y: sight.y + dy

        # Najbliższe przecięcie
        closestIntersect = undefined

        # Znalezienie wszystkich przecięć ze wszystkimi odcinkami
        for segment in segments
            # Znalezienie przecięcia dla konkretnego odcinka
            intersect = getIntersection ray, segment
            continue unless intersect
            # Znalezienie najbliższego przecięcia
            if not closestIntersect or intersect.param < closestIntersect.param
                closestIntersect = intersect

        continue unless closestIntersect

        # Ustawienie kąta potrzebnego do odpowiedniego posortowania punktów
        closestIntersect.angle = angle

        # Dodanie najbliższego przecięcia
        intersects.push closestIntersect

    # Sortowanie przecięć względem opodwiednim im kątąm w celu poprawnego
    # zdefiniowania wielokąta
    intersects = intersects.sort (a, b) ->
        a.angle - b.angle

    return intersects
