import Foundation
import Vapor
import FluentPostgreSQL

final class Venue: Codable {
    var id: Int?
    var name: String
    var scheduleId: Schedule.ID
    var geoinformationId: Geoinformation.ID?
    
    var created: Date?
    var updated: Date?
    
    static var createdAtKey: TimestampKey? = \.created
    static var updatedAtKey: TimestampKey? = \.updated
    
    init(name: String, scheduleId: Schedule.ID, geoinformationId: Geoinformation.ID) {
        self.name = name
        self.scheduleId = scheduleId
        self.geoinformationId = geoinformationId
    }
}

extension Venue: PostgreSQLModel { }
extension Venue: Migration { }
extension Venue: Content { }
extension Venue: Parameter { }

extension Venue {
    var events: Children<Venue, Event>{
        return children(\.venueId)
    }
}
