import FluentPostgreSQL
import Vapor

final class GeoSearchResult: PostgreSQLModel {
    var id: Int?
    var title: String?
   
    init(
        title: String
        ) {
        self.title = title
    }
}

extension GeoSearchResult: Migration { }

extension GeoSearchResult: Content { }

extension GeoSearchResult: Parameter { }
