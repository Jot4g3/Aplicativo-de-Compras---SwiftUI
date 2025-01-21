import Foundation

extension Date {
    
    init?(_ value: String) {
        do {
            self = try Date(value, strategy: .dateTime.day().month().year())
        } catch {
            print(error)
            return nil
        }
    }
    
}
