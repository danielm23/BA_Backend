import FluentPostgreSQL
import Vapor

final class GeoOverview: PostgreSQLModel {
    var id: Int?
    var title: String?
    var latitude: Double?
    var longitude: Double?
    var document: String
    
    init(
        title: String,
        latitude: Double?,
        longitude: Double?,
        document: String
        ) {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.document = document
    }
}

extension GeoOverview: Migration { }

extension GeoOverview: Content { }

extension GeoOverview: Parameter { }
