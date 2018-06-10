import Foundation
import Vapor
import FluentPostgreSQL

final class Category: Codable {
    var id: Int?
    var name: String
    var color: Int64
    var scheduleId: Schedule.ID

    init(name: String, color: Int64, scheduleId: Schedule.ID) {
        self.name = name
        self.color = color
        self.scheduleId = scheduleId
    }
}

extension Category: PostgreSQLModel { }
extension Category: Migration { }
extension Category: Content { }
extension Category: Parameter { }

extension Category {
    var events: Siblings<Category, Event, EventCategoryPivot> {
        return siblings()
    }
}
