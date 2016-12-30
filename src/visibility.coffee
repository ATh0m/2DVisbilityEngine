# Moduł visibility odpowiada za znajdowanie wielokąta opisującego widoczny
# obszar dla zbioru odcinków i punktu obserwacji

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

    # Lista przecięć utworzonych prostych z odcinkami
    intersects = []
