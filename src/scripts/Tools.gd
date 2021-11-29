extends Node
class_name Tools


enum COLORS {
    yellow,
    purple,
    pink,
    cyan,
    green,
    black,
    grey,
}


static func get_color(color) -> Color:
    if color == COLORS.yellow:
        return absolute_rgb(255, 210, 63)
    if color == COLORS.purple:
        return absolute_rgb(80, 72, 152)
    if color == COLORS.pink:
        return absolute_rgb(238, 66, 102)
    if color == COLORS.cyan:
        return absolute_rgb(59, 206, 172)
    if color == COLORS.green:
        return absolute_rgb(14, 173, 105)
    if color == COLORS.black:
        return absolute_rgb(30, 30, 30)
    if color == COLORS.grey:
        return absolute_rgb(134, 134, 134)
    return absolute_rgb(255, 255, 255)


static func absolute_rgb(r: float, g: float, b: float) -> Color:
    return Color(r / 255, g / 255, b / 255)


static func color_to_vector3(color: Color) -> Vector3:
    return Vector3(color.r, color.g, color.b)


static func vector3_to_color(vector: Vector3) -> Color:
    return Color(vector.x, vector.y, vector.z, 1)
