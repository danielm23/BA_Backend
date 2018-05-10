import Vapor
import FluentPostgreSQL

final class Tag: Codable {
    var id: Int?
    var name: String
    var color: Int64 //HEX
    var scheduleId: Schedule.ID

    init(name: String, color: Int64, scheduleId: Schedule.ID) {
        self.name = name
        self.color = color
        self.scheduleId = scheduleId
    }
}

extension Tag: PostgreSQLModel { }
extension Tag: Migration { }
extension Tag: Content { }
extension Tag: Parameter { }

extension Tag {
    var events: Siblings<Tag, Event, EventCategoryPivot> {
        return siblings()
    }
}
