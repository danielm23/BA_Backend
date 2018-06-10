import Vapor
import FluentPostgreSQL

final class Message: Codable {
    var id: Int?
    var title: String
    var content: String
    var created: Date
    var scheduleId: Schedule.ID
    
    init(title: String, content: String, created: Date, scheduleId: Schedule.ID) {
        self.title = title
        self.content = content
        self.created = created
        self.scheduleId = scheduleId
    }
}

extension Message: PostgreSQLModel { }
extension Message: Migration { }
extension Message: Content { }
extension Message: Parameter { }
