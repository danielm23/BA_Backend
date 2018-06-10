import Vapor
import FluentPostgreSQL

final class Track: Codable {
    var id: Int?
    var title: String
    var scheduleId: Schedule.ID
    
    init(title: String, scheduleId: Schedule.ID) {
        self.title = title
        self.scheduleId = scheduleId
    }
}

extension Track: PostgreSQLModel { }
extension Track: Migration { }
extension Track: Content { }
extension Track: Parameter { }
