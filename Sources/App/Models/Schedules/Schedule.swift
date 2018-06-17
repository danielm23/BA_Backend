import Foundation
import FluentPostgreSQL
import Vapor

final class Schedule: Codable {
    
    var id: UUID?
    var name: String
    var info: String
    var startDate: Date
    var endDate: Date
    var isPublic: Bool
    var version: Int
    
    var created: Date?
    var updated: Date?
    
    static var createdAtKey: TimestampKey? = \.created
    static var updatedAtKey: TimestampKey? = \.updated
    
    init(name: String,
         info: String,
         startDate: Date,
         endDate: Date,
         isPublic: Bool,
         version: Int) {
        
        self.name = name
        self.info = info
        self.startDate = startDate
        self.endDate = endDate
        self.isPublic = isPublic
        self.version = version
    }
}

extension Schedule: PostgreSQLUUIDModel { }
extension Schedule: Migration { }
extension Schedule: Content { }
extension Schedule: Parameter { }

extension Schedule {
    var events: Children<Schedule, Event>{
        return children(\.scheduleId)
    }
    
    var categories: Children<Schedule, Category>{
        return children(\.scheduleId)
    }
    
    var venues: Children<Schedule, Venue>{
        return children(\.scheduleId)
    }
    
    var messages: Children<Schedule, Message>{
        return children(\.scheduleId)
    }
    
    var tracks: Children<Schedule, Track>{
        return children(\.scheduleId)
    }
}
