import FluentPostgreSQL
import Vapor

final class GeoOverview: Codable {
    
    var id: Int?
    var title: String?
    var parentId: Int?
    var parent: String?
    var group: String?
    var longitude: Double?
    var latitude: Double?
    
    init(title: String,
         parentId: Int?,
         parent: String,
         group: String,
         longitude: Double?,
         latitude: Double?) {
        self.title = title
        self.parentId = parentId
        self.parent = parent
        self.group = group
        self.longitude = longitude
        self.latitude = latitude
    }
}

extension GeoOverview: PostgreSQLModel { }

extension GeoOverview: Content { }

extension GeoOverview: Migration { }

extension GeoOverview: Parameter { }

