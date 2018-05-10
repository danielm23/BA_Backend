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
    
    var tags: Children<Schedule, Tag>{
        return children(\.scheduleId)
    }
    
    var venues: Children<Schedule, Venue>{
        return children(\.scheduleId)
    }
}
