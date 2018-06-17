import Vapor
import FluentPostgreSQL

final class Message: Codable {
    var id: Int?
    var title: String
    var content: String
    var scheduleId: Schedule.ID
    
    var created: Date?
    var updated: Date?
    
    static var createdAtKey: TimestampKey? = \.created
    static var updatedAtKey: TimestampKey? = \.updated
    
    init(title: String, content: String, scheduleId: Schedule.ID) {
        self.title = title
        self.content = content
        self.scheduleId = scheduleId
    }
}

extension Message: PostgreSQLModel { }
extension Message: Migration { }
extension Message: Content { }
extension Message: Parameter { }
