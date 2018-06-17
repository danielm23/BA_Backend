import Vapor
import FluentPostgreSQL

final class Track: Codable {
    var id: Int?
    var title: String
    var scheduleId: Schedule.ID
    
    var created: Date?
    var updated: Date?
    
    static var createdAtKey: TimestampKey? = \.created
    static var updatedAtKey: TimestampKey? = \.updated
    
    init(title: String, scheduleId: Schedule.ID) {
        self.title = title
        self.scheduleId = scheduleId
    }
}

extension Track: PostgreSQLModel { }
extension Track: Migration { }
extension Track: Content { }
extension Track: Parameter { }
