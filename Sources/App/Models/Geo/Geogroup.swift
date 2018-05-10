import FluentPostgreSQL
import Vapor

final class Geogroup: PostgreSQLModel {
    var id: Int?
    var title: String?
    var description: String?
    var created: Date?
    var updated: Date?
    var userId: Int?
    
    init(
        title: String,
        description: String,
        created: Date,
        updated: Date
        ) {
        self.title = title
        self.description = description
        self.created = created
        self.updated = updated
    }
}

extension Geogroup: Migration { }

extension Geogroup: Content { }

extension Geogroup: Parameter { }

extension Geogroup {
    var geoinformations: Siblings<Geogroup, Geoinformation, GroupForGeoinformation> {
        return siblings()
    }
    /*
    var children: Siblings<Geogroup, Geogroup, ParentOfGeogroup> {
        return siblings()
    }
    
    var parents: Siblings<Geogroup, Geogroup, ParentOfGeogroup> {
        return siblings()
    }*/
}
