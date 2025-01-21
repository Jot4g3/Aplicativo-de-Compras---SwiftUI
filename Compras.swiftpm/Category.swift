import UIKit
import SwiftData
import SwiftUICore

struct ColorComponents: Codable {
    let red: Float
    let green: Float
    let blue: Float
    
    var color: Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue))
    }
    
    static func fromColor(_ color:Color) -> ColorComponents{
        let resolved = color.resolve(in: EnvironmentValues())
        return ColorComponents(
            red: resolved.red,
            green: resolved.green,
            blue: resolved.blue
        )
    }
}

@Model
class Category{
    var name: String
    var colorComponent: ColorComponents
    init(name: String, color: Color) {
        self.name = name
        self.colorComponent = ColorComponents.fromColor(color)
    }
}
