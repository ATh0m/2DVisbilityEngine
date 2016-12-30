# Moduł visibility odpowiada za znajdowanie wielokąta opisującego widoczny
# obszar dla zbioru odcinków i punktu obserwacji

# Znajdowanie przecięć dwóch odcinków
#
# @param [Segment] ray - pierwszy odcinek
# @param [Segment] segment - drugi odcinek
getIntersection = (ray, segment) ->
    undefined

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
            a: x: sightX, y: sightY
            b: x: sightX + dx, y: sightY + dy

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
