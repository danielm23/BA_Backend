import FluentPostgreSQL
import Vapor

final class Geoinformation: PostgreSQLModel {
    var id: Int?
    var title: String
    var shortinformation: String?
    var detailinformation: String?
    var synonyms: String?
    var created: Date?
    var updated: Date?
    var userId: Int?
    var geolocationId: Geolocation.ID?
    var parent: Geoinformation.ID?
    
    static var createdAtKey: TimestampKey? = \.created
    static var updatedAtKey: TimestampKey? = \.updated
    
    init(id: Int? = nil,
         title: String,
         shortinformation: String?,
         detailinformation: String?,
         synonyms: String?,
         userId: Int?,
         geolocationId: Geolocation.ID?,
         parent: Geoinformation.ID?
        ) {
        self.id = id
        self.title = title
        self.shortinformation = shortinformation
        self.detailinformation = detailinformation
        self.synonyms = synonyms
        self.userId = 1
        self.geolocationId = geolocationId
        self.parent = parent
    }
}

extension Geoinformation: Migration { }

extension Geoinformation: Content { }

extension Geoinformation: Parameter { }

extension Geoinformation {

    var geogroups: Siblings<Geoinformation, Geogroup, GroupForGeoinformation> {
        return siblings()
    }
    
    //var parents: Siblings<Geoinformation, Geoinformation, ParentOfGeoinformation> {
    //    return siblings()
    //}
}

