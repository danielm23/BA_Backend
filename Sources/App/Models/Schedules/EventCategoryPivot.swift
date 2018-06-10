import FluentPostgreSQL
import Vapor
import Foundation

final class EventCategoryPivot: PostgreSQLUUIDPivot {
    var id: UUID?
    var eventId: Event.ID
    var categoryId: Category.ID
    
    typealias Left = Event
    typealias Right = Category
    
    static let leftIDKey: LeftIDKey = \EventCategoryPivot.eventId
    static let rightIDKey: RightIDKey = \EventCategoryPivot.categoryId

    init(_ eventId: Event.ID, _ categoryId: Category.ID) {
        self.eventId = eventId
        self.categoryId = categoryId
    }
}

extension EventCategoryPivot: Migration { }
