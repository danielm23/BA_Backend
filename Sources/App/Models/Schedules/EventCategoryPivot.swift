import FluentPostgreSQL
import Vapor
import Foundation

final class EventCategoryPivot: PostgreSQLUUIDPivot {
    var id: UUID?
    var eventId: Event.ID
    var tagId: Tag.ID
    
    typealias Left = Event
    typealias Right = Tag
    
    static let leftIDKey: LeftIDKey = \EventCategoryPivot.eventId
    static let rightIDKey: RightIDKey = \EventCategoryPivot.tagId
    

    init(_ eventId: Event.ID, _ tagId: Tag.ID) {
        self.eventId = eventId
        self.tagId = tagId
    }
}

extension EventCategoryPivot: Migration { }
