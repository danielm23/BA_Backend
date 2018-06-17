import FluentPostgreSQL
import Vapor

final class Event: Codable {
    var id: Int?
    var name: String
    var info: String?
    var startDate: Date
    var endDate: Date
    var isActive: Bool
    var scheduleId: Schedule.ID
    var venueId: Venue.ID
    var trackId: Track.ID?
    
    var created: Date?
    var updated: Date?
    
    static var createdAtKey: TimestampKey? = \.created
    static var updatedAtKey: TimestampKey? = \.updated

    init(name: String, info: String, startDate: Date, endDate: Date,
         isActive: Bool, scheduleId: Schedule.ID, venueId: Venue.ID, trackId: Track.ID) {
        self.name = name
        self.info = info
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = isActive
        self.scheduleId = scheduleId
        self.venueId = venueId
        self.trackId = trackId
    }
}

extension Event: PostgreSQLModel { }
extension Event: Migration { }
extension Event: Content { }
extension Event: Parameter { }

extension Event {
    var schedule: Parent<Event,Schedule> {
        return parent(\.scheduleId)
    }
    
    var categories: Siblings<Event, Category, EventCategoryPivot> {
        return siblings()
    }
}
